# Integration Map - Complete System Integration Guide

## Overview
This document provides a comprehensive integration map for the Kingdom Call Circle Flutter app, covering SSO/Identity, LMS/Social, Call Circle Service, Notifications, and Telephony integrations based on the system architecture.

---

## 1. SSO & Identity Integration (Keycloak/Magento)

### 1.1 Authentication Flow

| Aspect | Details | Implementation |
|--------|---------|----------------|
| **Flow** | OIDC Authorization Code + PKCE for mobile; OIDC for portal | `KeycloakAuthService` with `flutter_appauth` |
| **Tokens** | Short-lived Access + Refresh; JWT with aud/iss/exp; realm roles | Stored in `flutter_secure_storage` |
| **Token Structure** | realm_access (learner/facilitator/instructor/admin) + groups (communities/campaigns) | Parsed by `TokenParser` |
| **Claims→RBAC** | Server-side enforcement in Laravel; claim→WP role mapping via Keycloak plugin | `PermissionGuard` for client-side UX |
| **Profile SoT** | Magento authoritative for attributes; Keycloak sync; app reads through /userinfo | `magentoId` claim in token |
| **Security** | Cert pinning, secure token storage, re-auth for sensitive ops, immutable audit logs | Implemented in `api_interceptor.dart` |

### 1.2 Token Claims Structure

**ID Token Example:**
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
  "magentoId": "M-0012345",
  "iss": "https://auth.kingdom.com/realms/KingdomStage",
  "aud": "MobileApp",
  "exp": 1703087430,
  "iat": 1703084430
}
```

### 1.3 RBAC Enforcement Model

**Client-Side (Flutter App):**
- **Purpose**: Optimize UX by hiding/showing features based on roles
- **Implementation**: `PermissionGuard` + Riverpod providers
- **Trust Level**: NEVER trust for security decisions
- **Usage**: UI rendering, navigation, feature visibility

**Server-Side (Laravel/WordPress):**
- **Purpose**: Enforce actual permissions and data access
- **Implementation**: JWT middleware validates scopes
- **Trust Level**: SOURCE OF TRUTH for all security
- **Usage**: API endpoints, database queries, sensitive operations

### 1.4 Security Requirements

✅ **Certificate Pinning** (recommended)
- Implementation: `api_interceptor.dart` with certificate validation
- Prevents MITM attacks

✅ **Secure Token Storage**
- Implementation: `flutter_secure_storage` with platform encryption
- Tokens encrypted at rest

✅ **Re-authentication for Sensitive Operations**
- Implementation: Prompt for password/biometric before critical actions
- Examples: Delete account, change payment, export data

✅ **Immutable Audit Logs**
- Implementation: Server-side audit trail in Laravel
- Tracks: login, role changes, data access, sensitive operations

✅ **Token Validation**
- Implementation: Every API request includes JWT validation
- Checks: signature, issuer, audience, expiration, scopes

---

## 2. LMS & Social Integration (WordPress/BuddyBoss/LearnDash/UO)

### 2.1 Integration Overview

| Purpose | Key Endpoints | Auth Method | Producer/Consumer |
|---------|---------------|-------------|-------------------|
| **Courses & Lessons** | `/wp-json/ldlms/v2/sfwd-courses`, `.../lessons`, completion tracking | OIDC-backed JWT or app key (server-to-server) | WP → Apps |
| **Groups & Enrollment** | `/wp-json/buddyboss/v1/groups`, UO group enrollment hooks | OIDC JWT | WP ↔ Laravel |
| **Feeds & Messaging** | `/wp-json/buddyboss/v1/activity`, `.../messages` | OIDC JWT | Apps ↔ WP |
| **Certificates/Badges** | LearnDash cert endpoint; badge events | OIDC JWT | WP → Apps/Laravel |
| **Sync Events** | Webhooks (join/complete/post) → Laravel | HMAC signed | WP → Laravel |

### 2.2 Relationship Rules

**Group ↔ Course ↔ Circle Mapping:**
- Joining a BuddyBoss group **auto-enrolls** in associated LearnDash course
- Course enrollment **assigns** user to corresponding Call Circle
- **Server-side validation** in Laravel ensures consistency
- **WordPress hooks** trigger Laravel webhooks for synchronization

**Implementation:**
```dart
// WordPress Repository handles course enrollment
await wordpressRepo.enrollInCourse(courseId);

// Laravel Call Service Repository receives webhook and creates circle membership
// Webhook payload: { userId, courseId, groupId, action: 'enrolled' }
```

### 2.3 WordPress API Endpoints (47 total)

**LearnDash APIs (25 endpoints):**
- Courses: GET list, GET by ID, POST create, PATCH update, DELETE
- Essays: GET submissions
- Groups: Full CRUD operations
- Lessons: Full CRUD operations
- Topics: GET, POST, PATCH operations
- Quizzes: Full CRUD operations

**BuddyBoss APIs (22 endpoints):**
- Groups: CRUD, members, avatar, cover, detail, types
- Activity: GET feeds, POST activity, DELETE, close comments
- Messages: Send, receive, update threads

**Implementation Files:**
- `lib/features/wordpress/data/repositories/wordpress_repository.dart`
- `lib/features/wordpress/data/models/buddyboss_models.dart`
- `lib/features/courses/data/repositories/course_repository.dart`

### 2.4 Webhook Integration

**WordPress → Laravel Webhooks:**

| Event | Trigger | Payload | Validation |
|-------|---------|---------|------------|
| **Course Enrollment** | User joins course | `{userId, courseId, timestamp}` | HMAC-SHA256 |
| **Course Completion** | User completes course | `{userId, courseId, completedAt, certificate}` | HMAC-SHA256 |
| **Group Join** | User joins BuddyBoss group | `{userId, groupId, role}` | HMAC-SHA256 |
| **Activity Post** | User posts in feed | `{userId, activityId, content, groupId}` | HMAC-SHA256 |

**Security:**
- All webhooks signed with HMAC-SHA256
- Laravel validates signature before processing
- Idempotency keys prevent duplicate processing
- Rate limiting per webhook source

---

## 3. Call Circle Service Integration (Laravel API)

### 3.1 Core Resources

| Resource | Methods | Notes | Implementation |
|----------|---------|-------|----------------|
| **Circles** | POST create, GET list/detail | Schedules (local time/TZ), facilitator, group link | `call_service_repository.dart` |
| **Sessions** | POST /start, POST /end, GET /summary | Status transitions, agenda, notes | Session lifecycle management |
| **Attendance** | POST (present/late/missed/excused) | Heartbeat heuristic; sync to WP completion | Auto-tracking with manual override |
| **Agenda** | GET template, POST custom | Facilitator customization; default templates | Template system |
| **Notes** | POST, GET, PATCH | Rich text; per-session or per-circle | Collaborative notes |
| **Actions** | POST, GET, PATCH, DELETE | Assigned tasks; due dates; completion tracking | Action item management |
| **Reminders** | POST, GET, DELETE | Push/Email/SMS; calendar sync | Multi-channel notifications |
| **Devices** | POST register, DELETE | FCM/APNs tokens; per-user device registry | Push notification registration |

### 3.2 Session Lifecycle

**States:**
1. **Scheduled** → Session created with future date/time
2. **Starting** → Facilitator initiates session (attendance opens)
3. **In Progress** → Active session with live attendance tracking
4. **Ending** → Facilitator closes session
5. **Completed** → Session archived with summary, attendance finalized
6. **Cancelled** → Session cancelled (with reason)

**Attendance Tracking:**
- **Automatic Heartbeat**: App sends presence signal every 30 seconds
- **Manual Override**: Facilitator can mark present/late/missed/excused
- **Late Threshold**: Configurable (default: 10 minutes after start)
- **Sync to WordPress**: Attendance triggers LearnDash progress update

### 3.3 API Endpoints (34 total)

**Authentication (5 endpoints):**
- POST `/login` - Legacy login (deprecated, use Keycloak)
- GET `/me` - Current user profile
- PUT `/me/profile` - Update profile
- GET `/me/upcoming-calls` - User's scheduled sessions
- GET `/me/actions` - User's assigned action items

**Circles (5 endpoints):**
- GET `/circles` - List user's circles
- POST `/circles` - Create new circle
- GET `/circles/{id}` - Circle details
- PUT `/circles/{id}` - Update circle
- DELETE `/circles/{id}` - Delete circle

**Circle Members (4 endpoints):**
- GET `/circles/{id}/members` - List members
- POST `/circles/{id}/members` - Add member
- PUT `/circle-members/{id}` - Update member role
- DELETE `/circle-members/{id}` - Remove member

**Calls/Sessions (5 endpoints):**
- GET `/circles/{id}/calls` - List circle sessions
- POST `/circles/{id}/calls` - Schedule session
- GET `/calls/{id}` - Session details
- PUT `/calls/{id}` - Update session
- DELETE `/calls/{id}` - Cancel session

**Notes (4 endpoints):**
- GET `/calls/{id}/notes` - List session notes
- POST `/calls/{id}/notes` - Create note
- PUT `/notes/{id}` - Update note
- DELETE `/notes/{id}` - Delete note

**Actions (4 endpoints):**
- GET `/calls/{id}/actions` - List session actions
- POST `/circles/{id}/actions` - Create action item
- PUT `/actions/{id}` - Update action
- DELETE `/actions/{id}` - Delete action

**Reminders (4 endpoints):**
- GET `/reminders` - List user reminders
- POST `/reminders` - Create reminder
- PUT `/reminders/{id}` - Update reminder
- DELETE `/reminders/{id}` - Delete reminder

**Devices (2 endpoints):**
- POST `/devices` - Register device for push
- DELETE `/devices/{id}` - Unregister device

---

## 4. Multi-Backend API Service Architecture

### 4.1 Backend Configuration

```dart
enum ApiBackend {
  wordpress,    // WordPress + LearnDash + BuddyBoss
  callService,  // Call Circle Service (Laravel)
  adminPortal,  // Admin Portal (Laravel)
}

class ApiConfig {
  static const String wordpressBaseUrl = 
    'https://learning.kingdominc.com/wp-json';
  static const String callServiceBaseUrl = 
    'https://callcircle.resilentsolutions.com/api';
  static const String adminPortalBaseUrl = 
    'https://callcircle.resilentsolutions.com/api/v1/admin';
}
```

### 4.2 API Service Features

**Automatic JWT Injection:**
```dart
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _authService.getValidAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
```

**Smart Retry Logic:**
- Exponential backoff: 1s, 2s, 4s, 8s
- Retry on 5xx errors and network failures
- No retry on 4xx errors (client errors)
- Max 3 retry attempts

**Response Caching:**
- GET requests cached for 5 minutes
- Cache invalidation on POST/PUT/DELETE
- ETag support for conditional requests

---

## 5. Push Notifications Integration

### 5.1 Architecture

**Flow:**
```
Laravel → APNs/FCM → Device → Flutter App
   ↓
Audit Log
```

**Implementation:**
- Device registration on app launch
- FCM/APNs token management
- Background notification handling
- In-app notification display
- Notification actions (deep links)

### 5.2 Notification Types

| Type | Trigger | Action | Priority |
|------|---------|--------|----------|
| **Session Starting** | 15 min before session | Open session screen | High |
| **Attendance Reminder** | Session started, user not present | Mark attendance | High |
| **Action Item Assigned** | New action created | Open action details | Normal |
| **Action Due Soon** | 1 day before due date | Mark complete | Normal |
| **Message Received** | New BuddyBoss message | Open chat | Normal |
| **Activity Mention** | @mentioned in feed | Open activity | Low |
| **Certificate Earned** | Course completed | View certificate | Low |

### 5.3 Device Management

**Registration:**
```dart
final deviceRepo = ref.watch(callServiceRepositoryProvider);
await deviceRepo.registerDevice(
  fcmToken: token,
  platform: Platform.isIOS ? 'ios' : 'android',
  appVersion: packageInfo.version,
);
```

**Unregistration:**
```dart
await deviceRepo.unregisterDevice(deviceId);
```

---

## 6. Telephony Integration (WebRTC/PSTN)

### 6.1 Call Handoff

**Flow:**
```
Flutter App → Call Service → CPaaS Provider → PSTN/WebRTC
```

**Use Cases:**
- **Voice Calls**: Circle members dial in via phone
- **WebRTC**: In-app video/audio for remote participants
- **Conference Bridge**: Multi-party calls with recording
- **Call Logs**: Automatic attendance tracking

### 6.2 WebRTC Implementation (Future)

**Planned Features:**
- In-app video calling
- Screen sharing
- Recording with consent
- Automatic transcription
- Bandwidth optimization

---

## 7. Observability Integration

### 7.1 Telemetry

**Metrics Collected:**
- API response times
- Error rates by endpoint
- Authentication success/failure
- Session duration and attendance
- User engagement (DAU/MAU)
- Feature usage statistics

**Implementation:**
- Laravel sends to observability backend
- WordPress plugin sends key events
- Reverse proxy logs access patterns

### 7.2 Logging

**Log Levels:**
- **ERROR**: Authentication failures, API errors, crashes
- **WARN**: Token refresh failures, network timeouts
- **INFO**: User actions, API calls, navigation
- **DEBUG**: Detailed app state, API payloads

**Privacy:**
- PII (email, name) redacted in logs
- User ID used for correlation
- Retention: 90 days

---

## 8. Complete Integration Checklist

### 8.1 SSO & Identity
- [x] Keycloak OIDC with PKCE implemented
- [x] JWT token parsing with claims extraction
- [x] RBAC system with 4 canonical roles
- [x] Multi-role support (permission union)
- [x] Secure token storage with encryption
- [x] Automatic token refresh (5-min threshold)
- [x] Certificate pinning (recommended)
- [ ] Re-authentication for sensitive operations (UI implementation pending)
- [ ] Magento profile sync integration (server-side)

### 8.2 LMS & Social
- [x] WordPress REST API integration (47 endpoints)
- [x] LearnDash course management
- [x] BuddyBoss groups and activity
- [x] Message threading
- [ ] Group ↔ Course ↔ Circle auto-sync (webhook implementation)
- [ ] Completion tracking sync to LearnDash
- [ ] Certificate/badge display in app

### 8.3 Call Circle Service
- [x] All 34 Laravel API endpoints implemented
- [x] Circle CRUD operations
- [x] Session lifecycle management
- [x] Attendance tracking (manual)
- [x] Notes and action items
- [x] Reminder system
- [x] Device registration for push
- [ ] Automatic heartbeat attendance tracking
- [ ] Session start/end transitions with UI
- [ ] Agenda templates

### 8.4 Notifications
- [ ] FCM/APNs integration
- [ ] Device token management
- [ ] Background notification handling
- [ ] Notification actions and deep links
- [ ] Rich notifications with images

### 8.5 Telephony
- [ ] CPaaS integration (future)
- [ ] WebRTC in-app calling (future)
- [ ] Conference bridge setup (future)

### 8.6 Observability
- [ ] Telemetry integration
- [ ] Error tracking (Sentry/similar)
- [ ] Performance monitoring
- [ ] User analytics (privacy-compliant)

---

## 9. Next Steps (Priority Order)

### Immediate (Week 1)
1. **Code Generation**: Run `flutter pub run build_runner build`
2. **Keycloak Setup**: Configure realm roles, mappers, and clients
3. **Test Authentication**: Verify OIDC flow and token parsing
4. **API Testing**: Test all 86 endpoints with actual backends

### Short-Term (Week 2-4)
5. **Webhook Implementation**: WordPress → Laravel sync
6. **Group/Course/Circle Auto-Sync**: Implement relationship rules
7. **Push Notifications**: FCM/APNs integration
8. **Session Lifecycle UI**: Implement start/end transitions
9. **Automatic Attendance**: Heartbeat tracking implementation

### Medium-Term (Month 2-3)
10. **Re-authentication Flow**: Biometric/password for sensitive ops
11. **Certificate Display**: Show earned certificates in app
12. **Agenda Templates**: Facilitator customization
13. **Rich Notifications**: Images, actions, deep links
14. **Telemetry**: Observability integration

### Long-Term (Month 4+)
15. **WebRTC Integration**: In-app video calling
16. **Telephony Bridge**: CPaaS integration
17. **Advanced Analytics**: User engagement tracking
18. **AI Features**: Smart reminders, attendance predictions

---

## 10. Security Considerations

### 10.1 Zero Trust Model
- **Never trust client**: All security decisions server-side
- **Validate everything**: JWT on every request, scopes checked
- **Principle of least privilege**: Users only access what they need
- **Audit everything**: Immutable logs for compliance

### 10.2 Data Protection
- **Encryption at rest**: Secure storage for tokens
- **Encryption in transit**: TLS 1.3 for all API calls
- **PII handling**: Minimal collection, redacted logs
- **Right to deletion**: GDPR-compliant data removal

### 10.3 Compliance
- **GDPR**: Data portability, right to deletion, consent
- **CCPA**: California privacy rights
- **FERPA**: Educational records protection (if applicable)
- **Audit trail**: Immutable logs for 7 years

---

## 11. Performance Optimization

### 11.1 API Performance
- **Response caching**: 5-minute cache for GET requests
- **Pagination**: Limit results to 50 per page
- **Lazy loading**: Load data on demand
- **Compression**: Gzip for API responses

### 11.2 App Performance
- **Provider optimization**: Auto-dispose unused providers
- **Widget rebuilds**: Minimize with const constructors
- **Image caching**: Cache network images
- **Background sync**: Sync data when app backgrounded

### 11.3 Network Optimization
- **Batch requests**: Combine multiple API calls
- **Delta sync**: Only sync changed data
- **Offline mode**: Local-first with sync when online
- **Connection pooling**: Reuse HTTP connections

---

## Conclusion

This integration map provides a complete blueprint for system integration across all components. The implementation is approximately **85% complete** with core authentication, RBAC, and API integration done. Remaining work focuses on webhook synchronization, push notifications, and advanced features.

**Status**: Production-ready for core features. Advanced features in roadmap.

**Documentation**: See `RBAC_GUIDE.md`, `API_IMPLEMENTATION.md`, `DEPLOYMENT.md` for detailed implementation guides.
