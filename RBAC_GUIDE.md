# Role-Based Access Control (RBAC) Implementation Guide

## Overview

This document describes the complete RBAC implementation for the Kingdom Call Circle Flutter app, based on Keycloak SSO integration with role taxonomy, token claims, and cross-system role mapping.

## Architecture

### System Integration

```
┌─────────────┐
│   Keycloak  │ (Authoritative SSO - Realm: KingdomStage)
│   Realm     │ realm_access.roles = canonical roles
└──────┬──────┘
       │ OIDC ID Token (JWT)
       │
       ├───────────────┬───────────────┬──────────────┐
       │               │               │              │
   ┌───▼────┐    ┌────▼────┐    ┌────▼───┐    ┌────▼────┐
   │ Flutter│    │  React  │    │Laravel │    │WordPress│
   │  App   │    │ Portal  │    │  API   │    │  + WP   │
   └────────┘    └─────────┘    └────────┘    └─────────┘
```

### Identity Source

- **Keycloak**: Authoritative for roles and authentication
- **Magento**: Source-of-truth for profile attributes (magentoId in token)

## Role Taxonomy

### Canonical Roles (issued by Keycloak)

| Role | Description | WordPress Mapping | Laravel API Scopes |
|------|-------------|-------------------|-------------------|
| **learner** | Default participant; consumes courses; joins Call Circles | `subscriber` | `read:self`, `join:circle` |
| **facilitator** | Leads a Circle; manages roster, attendance, nudges | `group_leader` (LearnDash/UO) | `circle:manage`, `attendance:write`, `message:broadcast` + learner scopes |
| **instructor** | Creates/manages courses; reviews analytics | `instructor` (plugin role) | `course:manage`, `agenda:template` + learner scopes |
| **admin** | Platform governance, moderation, configuration | `administrator` (restricted) | `admin:*`, `moderate:*`, `export:*` + all scopes |

### Multi-Role Support

- Users can have **multiple roles simultaneously**
- Effective permissions are the **union** of all mapped capabilities
- Sensitive actions require server-side validation (client-side is for UX only)
- Some admin actions require **dual-control** (not just role check)

## Token Structure

### Example Keycloak ID Token

```json
{
  "sub": "d7b3...e91",
  "email": "alice@example.org",
  "name": "Alice Smith",
  "realm_access": {
    "roles": ["learner", "facilitator"]
  },
  "resource_access": {
    "app-callcircle": {
      "roles": ["mobile", "push-receive"]
    },
    "portal-callcircle": {
      "roles": ["facilitator-ui"]
    }
  },
  "groups": ["/communities/ChurchTech", "/campaigns/Fall2025"],
  "kc.locale": "en",
  "magentoId": "M-0012345"
}
```

### Token Claims

- **`realm_access.roles`**: Canonical roles (learner, facilitator, instructor, admin)
- **`resource_access`**: Client-specific scopes (app-callcircle, portal-callcircle)
- **`groups`**: Community/campaign membership for scoping feeds and access
- **`magentoId`**: Link to identity source-of-truth

## Implementation

### 1. Role Enum (`lib/core/auth/models/user_role.dart`)

```dart
enum UserRole {
  learner,
  facilitator,
  instructor,
  admin,
}
```

Each role includes:
- Display name and description
- WordPress role mapping
- Laravel API scopes

### 2. Token Models

```dart
@freezed
class KeycloakToken {
  String sub;          // User ID
  String email;
  String name;
  RealmAccess realmAccess;
  Map<String, ResourceAccess>? resourceAccess;
  List<String>? groups;
  String? magentoId;
}
```

### 3. Token Parser (`lib/core/auth/token_parser.dart`)

Extracts and parses JWT claims:

```dart
UserPermissions permissions = TokenParser.parseToken(idToken);
```

Features:
- Parses realm_access for canonical roles
- Extracts resource_access for client-specific roles
- Computes API scopes (union of all role permissions)
- Validates token expiration
- Extracts user info

### 4. User Permissions Model

```dart
@freezed
class UserPermissions {
  List<UserRole> roles;           // Canonical roles
  List<String> mobileRoles;       // app-callcircle roles
  List<String> portalRoles;       // portal-callcircle roles
  List<String> apiScopes;         // Computed from roles
  List<String> groups;            // Community/campaign groups
  String? magentoId;
}
```

Helper methods:
- `hasRole(UserRole role)`: Check specific role
- `hasAnyRole(List<UserRole>)`: Check any of multiple roles
- `hasScope(String scope)`: Check API scope
- `isLearner`, `isFacilitator`, `isInstructor`, `isAdmin`: Quick checks
- `canManageCircles`, `canManageCourses`, etc.: Capability checks

### 5. Permission Guard (`lib/core/auth/permission_guard.dart`)

UI capability flags for client-side UX optimization:

```dart
final guard = PermissionGuard(permissions);

// Feature access
if (guard.canAccess('manage_circle')) {
  // Show circle management UI
}

// Action validation
if (guard.canPerform('mark_attendance')) {
  // Allow attendance marking
}

// Navigation items
List<NavigationItem> navItems = guard.getNavigationItems();
```

**Important**: These are UI-only checks. Server must always validate permissions.

### 6. Auth Repository Integration

Updated `AuthRepository` to include RBAC:

```dart
@riverpod
class AuthRepository {
  Future<AuthState> build() async {
    // On authentication
    final permissions = TokenParser.parseToken(idToken);
    
    return AuthState.authenticated(
      accessToken: accessToken,
      idToken: idToken,
      permissions: permissions,
      userInfo: userInfo,
    );
  }
}
```

Access permissions anywhere:

```dart
final permissions = ref.watch(userPermissionsProvider);

if (permissions?.isFacilitator ?? false) {
  // Show facilitator UI
}
```

## Cross-System Role Mapping

### WordPress Integration

WordPress plugin maps Keycloak claims to WP roles:

| Keycloak Role | WordPress Role | Capabilities |
|---------------|----------------|--------------|
| learner | subscriber | Basic access, view content |
| facilitator | group_leader | LearnDash group management, UO capabilities |
| instructor | instructor | Course creation, analytics |
| admin | administrator | Full admin access (restricted set) |

### Laravel API Integration

Resource server validates JWT and derives scopes:

| Keycloak Role | API Scopes | Endpoints |
|---------------|------------|-----------|
| learner | `read:self`, `join:circle` | GET /me, POST /circles/join |
| facilitator | + `circle:manage`, `attendance:write`, `message:broadcast` | Circle CRUD, attendance, messaging |
| instructor | + `course:manage`, `agenda:template` | Course management, templates |
| admin | + `admin:*`, `moderate:*`, `export:*` | All admin endpoints |

### React Portal

Similar to Flutter app, computes UI capabilities from claims.

## Usage Examples

### Check Role in UI

```dart
final permissions = ref.watch(userPermissionsProvider);

Widget build(BuildContext context) {
  if (permissions?.isFacilitator ?? false) {
    return FacilitatorDashboard();
  }
  return LearnerDashboard();
}
```

### Conditional Navigation

```dart
final guard = PermissionGuard(permissions);
final navItems = guard.getNavigationItems();

// Automatically includes/excludes items based on roles
```

### API Call with Scopes

```dart
// API service automatically includes JWT with scopes
final circles = await ref.read(callServiceRepositoryProvider).getCircles();

// Server validates: user has 'circle:manage' or 'read:self' scope
```

### Multi-Role Example

User with roles: `["learner", "facilitator"]`

Computed scopes (union):
```dart
[
  "read:self",        // from learner
  "join:circle",      // from learner
  "circle:manage",    // from facilitator
  "attendance:write", // from facilitator
  "message:broadcast" // from facilitator
]
```

## Security Considerations

### Client-Side (Flutter App)

1. **UI Optimization Only**: Role checks are for UX, not security
2. **Never Trust Client**: Server is always source of truth
3. **Token Storage**: Secure storage with encryption
4. **Token Refresh**: Automatic before expiry (5 min threshold)

### Server-Side (Laravel/WordPress)

1. **JWT Validation**: Always validate signature and expiration
2. **Scope Enforcement**: Check required scopes for each endpoint
3. **Dual Control**: Sensitive admin actions need additional validation
4. **Audit Logging**: Log all privileged operations

### Token Handling

1. **PKCE Required**: Mobile apps must use PKCE (S256)
2. **Short-Lived Tokens**: Access tokens expire in 5-15 minutes
3. **Refresh Tokens**: Use refresh_token for seamless renewal
4. **Revocation**: Logout revokes tokens on server

## Testing

### Unit Tests

```dart
test('UserPermissions computes scopes correctly', () {
  final permissions = UserPermissions(
    roles: [UserRole.learner, UserRole.facilitator],
    apiScopes: ['read:self', 'join:circle', 'circle:manage'],
  );
  
  expect(permissions.isLearner, true);
  expect(permissions.isFacilitator, true);
  expect(permissions.canManageCircles, true);
});
```

### Integration Tests

1. Mock Keycloak tokens with different roles
2. Verify UI elements shown/hidden correctly
3. Test API calls with different scopes
4. Verify navigation items match role

## Keycloak Configuration

### Realm Settings (KingdomStage)

1. **Client: MobileApp**
   - Client Protocol: openid-connect
   - Access Type: public
   - Standard Flow Enabled: Yes
   - Valid Redirect URIs: `myapp://com.kingdominc.learning/callback`
   - PKCE: Required (S256)

2. **Realm Roles**
   - Create: learner, facilitator, instructor, admin
   - Set default role: learner

3. **Client Scopes**
   - Create custom scopes for app-callcircle
   - Map to roles via protocol mappers

4. **Mappers**
   - Add realm roles to realm_access
   - Add client roles to resource_access
   - Add groups claim
   - Add magentoId custom attribute

### Role Assignment

1. Users get roles assigned in Keycloak admin UI
2. Roles can be assigned individually or via groups
3. Multiple roles allowed (union of permissions)
4. Default role: learner (auto-assigned)

## Migration Path

### Existing Users

1. **Profile Sync**: Magento → Keycloak (magentoId preserved)
2. **Role Migration**: Existing roles mapped to canonical roles
3. **Token Refresh**: Users re-authenticate to get new token structure

### Phased Rollout

1. **Phase 1**: Enable RBAC in Flutter app (read-only mode)
2. **Phase 2**: WordPress plugin for role mapping
3. **Phase 3**: Laravel API scope enforcement
4. **Phase 4**: React portal integration
5. **Phase 5**: Retire old auth system

## Troubleshooting

### Token Missing Roles

**Issue**: `realm_access.roles` is empty

**Solution**:
1. Check realm role assignment in Keycloak
2. Verify client scope includes realm roles
3. Check protocol mapper configuration

### Permission Denied

**Issue**: User has role but can't access feature

**Solution**:
1. Check if server validates same scope
2. Verify API scope mapping in code
3. Check token expiration and refresh
4. Confirm multi-role union is computed

### Token Parsing Fails

**Issue**: `TokenParseException` thrown

**Solution**:
1. Verify JWT format (should have 3 parts)
2. Check token signature validity
3. Ensure realm_access is in token
4. Check for required claims (sub, email, name)

## References

- Keycloak Documentation: https://www.keycloak.org/docs/latest/
- OAuth 2.0 PKCE: https://oauth.net/2/pkce/
- JWT Specification: https://jwt.io/
- Flutter AppAuth: https://pub.dev/packages/flutter_appauth

## Support

For issues or questions:
1. Check token structure in jwt.io
2. Review Keycloak admin logs
3. Test with Postman/curl
4. Contact platform team
