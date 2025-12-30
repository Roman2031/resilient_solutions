# API Integration Documentation

Complete documentation of all API integrations in the Kingdom Call Circles Flutter application.

## Table of Contents

1. [Overview](#overview)
2. [Authentication](#authentication)
3. [Laravel Call Service API](#laravel-call-service-api)
4. [WordPress/LearnDash API](#wordpresslearndash-api)
5. [BuddyBoss API](#buddyboss-api)
6. [Admin Portal API](#admin-portal-api)
7. [Error Handling](#error-handling)
8. [Rate Limiting](#rate-limiting)
9. [Testing](#testing)

---

## Overview

The app integrates with multiple backend services:

| Service | Purpose | Base URL (Production) |
|---------|---------|----------------------|
| Keycloak | Authentication | `https://auth.kingdom.com` |
| Laravel Call Service | Circles & Calls | `https://callcircle.resilentsolutions.com/api` |
| WordPress/LearnDash | Courses & LMS | `https://learning.kingdominc.com/wp-json` |
| BuddyBoss | Social & Messaging | `https://learning.kingdominc.com/wp-json/buddyboss/v1` |
| Admin Portal | Admin Functions | `https://callcircle.resilentsolutions.com/api/v1/admin` |

### Total Endpoints Integrated: 86+

---

## Authentication

### Keycloak OIDC

**Implementation**: `lib/core/auth/keycloak_auth_service.dart`

#### Configuration

```dart
// Environment variables
KEYCLOAK_BASE_URL=https://auth.kingdom.com
KEYCLOAK_REALM=KingdomStage
KEYCLOAK_CLIENT_ID=MobileApp
KEYCLOAK_REDIRECT_URI=com.kingdominc.callcircles://oauth-callback
```

#### Endpoints

##### 1. Authorization
```
GET /realms/{realm}/protocol/openid-connect/auth
```
**Query Parameters:**
- `client_id`: Application client ID
- `redirect_uri`: OAuth callback URL
- `response_type`: code
- `scope`: openid profile email

**Response:** Authorization code via redirect

##### 2. Token Exchange
```
POST /realms/{realm}/protocol/openid-connect/token
```
**Body Parameters:**
- `grant_type`: authorization_code
- `code`: Authorization code
- `client_id`: Application client ID
- `redirect_uri`: OAuth callback URL

**Response:**
```json
{
  "access_token": "eyJhbGc...",
  "refresh_token": "eyJhbGc...",
  "expires_in": 300,
  "refresh_expires_in": 1800,
  "token_type": "Bearer"
}
```

##### 3. Token Refresh
```
POST /realms/{realm}/protocol/openid-connect/token
```
**Body Parameters:**
- `grant_type`: refresh_token
- `refresh_token`: Current refresh token
- `client_id`: Application client ID

**Response:** New access and refresh tokens

##### 4. User Info
```
GET /realms/{realm}/protocol/openid-connect/userinfo
```
**Headers:**
- `Authorization`: Bearer {access_token}

**Response:**
```json
{
  "sub": "user-id",
  "email": "user@example.com",
  "name": "User Name",
  "preferred_username": "username",
  "given_name": "User",
  "family_name": "Name"
}
```

##### 5. Logout
```
POST /realms/{realm}/protocol/openid-connect/logout
```
**Body Parameters:**
- `client_id`: Application client ID
- `refresh_token`: Current refresh token

**Response:** 204 No Content

---

## Laravel Call Service API

**Base URL**: `https://callcircle.resilentsolutions.com/api`

**Implementation**: `lib/core/network/api_service.dart`

**Authentication**: Bearer token in Authorization header

### Circles

#### 1. List User Circles
```
GET /circles
```
**Query Parameters:**
- `page`: Page number (optional)
- `per_page`: Items per page (optional)
- `status`: active/archived (optional)

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Prayer Circle",
      "description": "Weekly prayer meetings",
      "facilitator_id": 123,
      "facilitator_name": "John Doe",
      "member_count": 12,
      "status": "active",
      "created_at": "2024-01-01T00:00:00Z",
      "next_call": {
        "id": 45,
        "scheduled_at": "2024-01-15T10:00:00Z"
      }
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 3,
    "per_page": 20,
    "total": 48
  }
}
```

#### 2. Get Circle Details
```
GET /circles/{id}
```
**Response:**
```json
{
  "id": 1,
  "name": "Prayer Circle",
  "description": "Weekly prayer meetings",
  "facilitator": {
    "id": 123,
    "name": "John Doe",
    "email": "john@example.com",
    "avatar_url": "https://..."
  },
  "members": [
    {
      "id": 124,
      "name": "Jane Smith",
      "role": "member",
      "joined_at": "2024-01-01T00:00:00Z"
    }
  ],
  "calls": [...],
  "status": "active",
  "created_at": "2024-01-01T00:00:00Z"
}
```

#### 3. Create Circle
```
POST /circles
```
**Body:**
```json
{
  "name": "New Circle",
  "description": "Circle description",
  "type": "prayer",
  "schedule": {
    "frequency": "weekly",
    "day": "monday",
    "time": "10:00"
  }
}
```

**Response:** Created circle object (201 Created)

#### 4. Update Circle
```
PUT /circles/{id}
```
**Body:** Same as create (partial updates supported)

**Response:** Updated circle object

#### 5. Delete Circle
```
DELETE /circles/{id}
```
**Response:** 204 No Content

#### 6. Join Circle
```
POST /circles/{id}/join
```
**Response:** Membership object (201 Created)

#### 7. Leave Circle
```
POST /circles/{id}/leave
```
**Response:** 204 No Content

#### 8. Invite Members
```
POST /circles/{id}/invitations
```
**Body:**
```json
{
  "emails": ["user1@example.com", "user2@example.com"],
  "message": "Join our circle!"
}
```

**Response:** Invitation objects

### Calls

#### 1. List Calls
```
GET /calls
```
**Query Parameters:**
- `circle_id`: Filter by circle (optional)
- `status`: upcoming/completed/cancelled
- `date_from`: Start date filter
- `date_to`: End date filter

**Response:**
```json
{
  "data": [
    {
      "id": 45,
      "circle_id": 1,
      "circle_name": "Prayer Circle",
      "title": "Weekly Prayer Call",
      "scheduled_at": "2024-01-15T10:00:00Z",
      "duration_minutes": 60,
      "status": "upcoming",
      "participants_count": 8,
      "notes_count": 3,
      "action_items_count": 5
    }
  ]
}
```

#### 2. Get Call Details
```
GET /calls/{id}
```
**Response:**
```json
{
  "id": 45,
  "circle": {...},
  "title": "Weekly Prayer Call",
  "scheduled_at": "2024-01-15T10:00:00Z",
  "duration_minutes": 60,
  "agenda": "1. Opening prayer\n2. Testimonies\n3. Prayer requests",
  "participants": [...],
  "notes": [...],
  "action_items": [...],
  "status": "upcoming"
}
```

#### 3. Create Call
```
POST /calls
```
**Body:**
```json
{
  "circle_id": 1,
  "title": "Weekly Prayer Call",
  "scheduled_at": "2024-01-15T10:00:00Z",
  "duration_minutes": 60,
  "agenda": "Meeting agenda",
  "send_reminders": true
}
```

**Response:** Created call object

#### 4. Update Call
```
PUT /calls/{id}
```
**Body:** Same as create

**Response:** Updated call object

#### 5. Cancel Call
```
POST /calls/{id}/cancel
```
**Body:**
```json
{
  "reason": "Facilitator unavailable"
}
```

**Response:** Updated call object

### Notes

#### 1. List Notes
```
GET /notes
```
**Query Parameters:**
- `call_id`: Filter by call
- `circle_id`: Filter by circle
- `author_id`: Filter by author

**Response:** Array of note objects

#### 2. Create Note
```
POST /notes
```
**Body:**
```json
{
  "call_id": 45,
  "content": "Note content",
  "type": "insight",
  "is_private": false
}
```

**Response:** Created note object

#### 3. Update Note
```
PUT /notes/{id}
```

#### 4. Delete Note
```
DELETE /notes/{id}
```

### Action Items

#### 1. List Action Items
```
GET /action-items
```
**Query Parameters:**
- `call_id`: Filter by call
- `circle_id`: Filter by circle
- `assignee_id`: Filter by assignee
- `status`: pending/completed/cancelled

**Response:** Array of action item objects

#### 2. Create Action Item
```
POST /action-items
```
**Body:**
```json
{
  "call_id": 45,
  "title": "Prepare presentation",
  "description": "Detailed description",
  "assignee_id": 124,
  "due_date": "2024-01-20T00:00:00Z",
  "priority": "high"
}
```

**Response:** Created action item object

#### 3. Update Action Item Status
```
PATCH /action-items/{id}/status
```
**Body:**
```json
{
  "status": "completed",
  "notes": "Completion notes"
}
```

**Response:** Updated action item object

---

## WordPress/LearnDash API

**Base URL**: `https://learning.kingdominc.com/wp-json`

**Implementation**: `lib/features/courses/data/wordpress_api_client.dart`

### Courses

#### 1. List Courses
```
GET /ldlms/v2/sfwd-courses
```
**Query Parameters:**
- `page`: Page number
- `per_page`: Items per page
- `orderby`: title/date/popular
- `order`: asc/desc
- `category`: Filter by category ID

**Response:**
```json
[
  {
    "id": 123,
    "title": {
      "rendered": "Introduction to Faith"
    },
    "content": {
      "rendered": "Course description..."
    },
    "featured_media": 456,
    "featured_media_url": "https://...",
    "categories": [1, 2],
    "meta": {
      "duration": "4 weeks",
      "lessons": 12,
      "level": "beginner"
    }
  }
]
```

#### 2. Get Course Details
```
GET /ldlms/v2/sfwd-courses/{id}
```
**Response:** Full course object with lessons

#### 3. Enroll in Course
```
POST /learndash/v2/users/{user_id}/course-progress/{course_id}
```
**Response:** Enrollment confirmation

#### 4. Get User Courses
```
GET /ldlms/v2/users/{user_id}/courses
```
**Query Parameters:**
- `status`: enrolled/completed/in-progress

**Response:** Array of user's courses with progress

### Lessons

#### 1. List Lessons
```
GET /ldlms/v2/sfwd-lessons
```
**Query Parameters:**
- `course`: Filter by course ID
- `page`: Page number

**Response:** Array of lesson objects

#### 2. Get Lesson Details
```
GET /ldlms/v2/sfwd-lessons/{id}
```
**Response:**
```json
{
  "id": 789,
  "title": {
    "rendered": "Lesson 1: Introduction"
  },
  "content": {
    "rendered": "Lesson content..."
  },
  "course": 123,
  "order": 1,
  "video_url": "https://...",
  "duration": "15:30",
  "materials": [...]
}
```

#### 3. Mark Lesson Complete
```
POST /learndash/v2/users/{user_id}/course-progress/{course_id}/lessons/{lesson_id}
```
**Body:**
```json
{
  "completed": true
}
```

**Response:** Updated progress

### Quizzes

#### 1. Get Quiz
```
GET /ldlms/v2/sfwd-quiz/{id}
```
**Response:**
```json
{
  "id": 101,
  "title": {
    "rendered": "Quiz 1"
  },
  "lesson": 789,
  "course": 123,
  "questions": [
    {
      "id": 201,
      "question": "What is faith?",
      "type": "multiple_choice",
      "answers": [
        {"id": 1, "text": "Answer 1", "correct": false},
        {"id": 2, "text": "Answer 2", "correct": true}
      ]
    }
  ],
  "passing_score": 70,
  "time_limit": 30
}
```

#### 2. Submit Quiz
```
POST /learndash/v2/users/{user_id}/quiz-attempts
```
**Body:**
```json
{
  "quiz_id": 101,
  "answers": {
    "201": 2,
    "202": 1
  }
}
```

**Response:**
```json
{
  "score": 85,
  "passed": true,
  "correct_answers": 17,
  "total_questions": 20,
  "certificate_id": 301
}
```

### Certificates

#### 1. Get User Certificates
```
GET /learndash/v2/users/{user_id}/certificates
```
**Response:** Array of certificate objects

#### 2. Download Certificate
```
GET /learndash/v2/certificates/{id}/download
```
**Response:** PDF file

---

## BuddyBoss API

**Base URL**: `https://learning.kingdominc.com/wp-json/buddyboss/v1`

**Implementation**: `lib/features/messages/data/buddyboss_api_client.dart`

### Messages

#### 1. Get Messages
```
GET /messages
```
**Query Parameters:**
- `box`: inbox/sentbox/unread
- `page`: Page number
- `per_page`: Items per page

**Response:**
```json
[
  {
    "id": 123,
    "subject": "Meeting tomorrow",
    "message": "Don't forget our meeting...",
    "sender_id": 456,
    "sender_name": "John Doe",
    "sender_avatar": "https://...",
    "recipients": [...],
    "date": "2024-01-15T10:00:00Z",
    "unread": false
  }
]
```

#### 2. Get Thread
```
GET /messages/{thread_id}
```
**Response:**
```json
{
  "thread_id": 123,
  "subject": "Meeting tomorrow",
  "messages": [
    {
      "id": 456,
      "sender_id": 789,
      "sender_name": "Jane Smith",
      "message": "Message content",
      "date": "2024-01-15T10:00:00Z"
    }
  ],
  "recipients": [...]
}
```

#### 3. Send Message
```
POST /messages
```
**Body:**
```json
{
  "subject": "Message subject",
  "message": "Message content",
  "recipients": [456, 789]
}
```

**Response:** Created message object

#### 4. Reply to Thread
```
POST /messages/{thread_id}/reply
```
**Body:**
```json
{
  "message": "Reply content"
}
```

**Response:** Created reply object

#### 5. Mark as Read
```
PUT /messages/{thread_id}/read
```
**Response:** 204 No Content

### Activity Feed

#### 1. Get Activity
```
GET /activity
```
**Query Parameters:**
- `type`: activity_update/new_member/friendship_created
- `page`: Page number
- `scope`: all/friends/groups/personal

**Response:** Array of activity objects

#### 2. Post Activity
```
POST /activity
```
**Body:**
```json
{
  "content": "Activity update text",
  "type": "activity_update"
}
```

**Response:** Created activity object

---

## Admin Portal API

**Base URL**: `https://callcircle.resilentsolutions.com/api/v1/admin`

**Implementation**: `lib/features/admin/data/admin_api_client.dart`

**Authorization**: Requires SuperAdmin or Admin role

### Analytics

#### 1. Dashboard Stats
```
GET /analytics/dashboard
```
**Response:**
```json
{
  "users": {
    "total": 1250,
    "active_today": 320,
    "new_this_week": 45
  },
  "circles": {
    "total": 85,
    "active": 72,
    "archived": 13
  },
  "calls": {
    "total": 450,
    "this_month": 67,
    "upcoming": 23
  },
  "courses": {
    "enrollments": 2340,
    "completions": 890,
    "in_progress": 1450
  }
}
```

#### 2. User Activity
```
GET /analytics/users/activity
```
**Query Parameters:**
- `period`: day/week/month/year
- `user_id`: Specific user (optional)

**Response:** Time-series activity data

### User Management

#### 1. List Users
```
GET /users
```
**Query Parameters:**
- `page`: Page number
- `per_page`: Items per page
- `role`: Filter by role
- `status`: active/inactive/suspended
- `search`: Search query

**Response:** Paginated user list

#### 2. Get User Details
```
GET /users/{id}
```
**Response:** Complete user profile

#### 3. Update User
```
PUT /users/{id}
```
**Body:**
```json
{
  "role": "facilitator",
  "status": "active",
  "permissions": ["circles.create", "calls.manage"]
}
```

**Response:** Updated user object

#### 4. Suspend User
```
POST /users/{id}/suspend
```
**Body:**
```json
{
  "reason": "Violation of terms",
  "duration_days": 30
}
```

**Response:** Updated user object

### System Management

#### 1. System Health
```
GET /system/health
```
**Response:**
```json
{
  "status": "healthy",
  "database": "connected",
  "cache": "operational",
  "storage": {
    "used": "45GB",
    "available": "155GB"
  },
  "services": {
    "api": "up",
    "auth": "up",
    "mail": "up"
  }
}
```

#### 2. Logs
```
GET /system/logs
```
**Query Parameters:**
- `level`: error/warning/info/debug
- `from_date`: Start date
- `to_date`: End date

**Response:** Array of log entries

---

## Error Handling

All APIs return consistent error responses:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": {
      "email": ["Email is required"]
    }
  }
}
```

### HTTP Status Codes

| Code | Meaning | Action |
|------|---------|--------|
| 200 | Success | Process response |
| 201 | Created | Resource created successfully |
| 204 | No Content | Action succeeded, no response body |
| 400 | Bad Request | Check request parameters |
| 401 | Unauthorized | Refresh token or re-authenticate |
| 403 | Forbidden | User lacks permission |
| 404 | Not Found | Resource doesn't exist |
| 422 | Validation Error | Fix validation errors |
| 429 | Too Many Requests | Implement backoff |
| 500 | Server Error | Retry with exponential backoff |
| 503 | Service Unavailable | Service temporarily down |

### Error Codes

```dart
enum ApiErrorCode {
  VALIDATION_ERROR,
  AUTHENTICATION_REQUIRED,
  PERMISSION_DENIED,
  RESOURCE_NOT_FOUND,
  RESOURCE_CONFLICT,
  RATE_LIMIT_EXCEEDED,
  SERVER_ERROR,
  SERVICE_UNAVAILABLE,
}
```

---

## Rate Limiting

### Limits

| Endpoint Type | Limit | Window |
|---------------|-------|--------|
| Authentication | 10 requests | 1 minute |
| Read Operations | 100 requests | 1 minute |
| Write Operations | 30 requests | 1 minute |
| File Uploads | 10 uploads | 1 minute |

### Rate Limit Headers

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 87
X-RateLimit-Reset: 1642089600
```

### Handling Rate Limits

```dart
if (response.statusCode == 429) {
  final resetTime = response.headers['X-RateLimit-Reset'];
  final waitSeconds = int.parse(resetTime!) - DateTime.now().millisecondsSinceEpoch ~/ 1000;
  await Future.delayed(Duration(seconds: waitSeconds));
  // Retry request
}
```

---

## Testing

### Test Credentials

**Development Environment:**
```
Username: test@example.com
Password: Test123!
```

**Roles Available:**
- SuperAdmin
- Admin  
- Facilitator
- Member

### Postman Collection

Available at: `/docs/postman/Kingdom_Call_Circles.postman_collection.json`

### Testing Endpoints

```bash
# Test authentication
curl -X POST https://auth.kingdom.com/realms/KingdomStage/protocol/openid-connect/token \
  -d "grant_type=password" \
  -d "client_id=MobileApp" \
  -d "username=test@example.com" \
  -d "password=Test123!"

# Test API with token
curl -H "Authorization: Bearer {token}" \
  https://callcircle.resilentsolutions.com/api/circles
```

---

## Support

For API questions or issues:
- **Technical Support**: api-support@resilentsolutions.com
- **Documentation**: https://docs.kingdominc.com
- **Status Page**: https://status.kingdominc.com
