# Skylz API Documentation

## Overview

This document describes the API endpoints available in YourApp for managing skills and activities. All requests and
responses are in JSON format.

## Base URL

```
https://skylz.herokuapp.com/api/v1
http://127.0.0.1:3000/api/v1/
```

## Authentication

This API uses token-based authentication. Include your authentication token in the header like this:
You can access this token on your account page

```http
Authorization: Bearer YOUR_TOKEN_HERE
```

---

## Endpoints

### Get Skills

- **URL**: `/skills`
- **Method**: `GET`

**Response**

```json
[
  {
    "id": 1,
    "name": "Triangle from Closed Guard",
    "icon": null,
    "notes": "The technique employs your legs to encircle the opponent's neck and one of their arms, creating a stranglehold. ",
    "reason": "(opportunity) They have their arms away from their chest or can force their arms up",
    "steps": "Start in Closed Guard: Begin by having your opponent in your closed guard, with your legs wrapped around their waist.\nControl the Arms: Use your hands to control your opponent's arms. This is typically done by gripping the wrists or sleeves.\nCreate an Opening: Open your guard momentarily to create space and place one foot on the opponent's hip.",
    "media": null,
    "tags": "guard, triangle, choke, submission",
    "category": null,
    "user_id": 1,
    "skillset_id": 1,
    "created_at": "2023-08-23T05:39:41.680Z",
    "updated_at": "2023-08-28T02:02:55.091Z"
  }
]
```

### Get Activities

- **URL**: `/activities`
- **Method**: `GET`

**Response**

```json
[
  {
    "id": 2,
    "description": "Managed to pull this off in rolls with the new white belt.",
    "user_id": 1,
    "skill_id": 1,
    "activity_type": "Rolls",
    "date": "2023-08-22",
    "rating": 2,
    "reps": 0,
    "tags": "success",
    "created_at": "2023-08-23T05:39:41.789Z",
    "updated_at": "2023-08-23T05:39:41.789Z"
  }
]
```

### Create Activity

- **URL**: `/activities`
- **Method**: `POST`

**Request Body**

```json
{
  "description": "Did some drills",
  "activity_type": "Solo Drills"
  // more fields
}
```

**Response**

```json
{
  "id": 1
  // other fields
}
```

### Refresh Token

- **URL**: `/refresh_token`
- **Method**: `POST`

**Response**

```json
{
  "new_token": "YOUR_NEW_TOKEN"
}
```

---

## Errors

All error responses will contain an `error` field describing the issue.

```json
{
  "error": "Description of what went wrong"
}
```

## Notes

This is a basic API documentation outline. For more complex applications, you may want to include details like rate
limiting, data types, and more.

---
