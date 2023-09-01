# Skylz API Documentation

## Overview

This document describes the API endpoints available in Skylz for managing skills and activities.
All requests and responses are in JSON format.

## Base URL

```
https://skylz.herokuapp.com/api/v1
http://127.0.0.1:3000/api/v1
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
    "notes": "The technique employs your legs to encircle the opponent's neck and one of their arms, creating a stranglehold. ...",
    "media": null,
    "tags": "guard, triangle, choke, submission",
    "category": null,
    "skillset_id": 1
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

`skill_id` is required. The rest are optional but recommended.
The `date` field should be a string in the format `Fri, 1 Sep 2023`
The owner of the token must also own the skill whose `skill_id` is being referred to.

```json
{
  "skill_id": 1,
  "description": "Posting a new activity from the API. Love that Leg Triangle!!",
  "rating": 4,
  "reps": 101,
  "date": "Fri, 1 Sep 2023",
  "activity_type": "Solo Drills"
}
```

**Response**

```json
{
  "status": 200
}
```

### Get skillsets

- **URL**: `/skillsets`
- **Method**: `GET`

** Response Body **

```
[
    {
        "id": 1,
        "name": "BJJ",
        "is_current": true
    },
    {
        "id": 2,
        "name": "Paramedicine",
        "is_current": false
    },
    {
        "id": 3,
        "name": "Motorcycling 🏍",
        "is_current": false
    }
 ]
```

### Refresh Token

- **URL**: `/refresh_token`
- **Method**: `POST`

This will return a new token that you can use to authenticate future requests. The old token will be invalidated.

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

This is a basic API documentation outline.

V1 is very unstable and will change often. I will try to keep this document
up to date with the latest changes.

- [ ] Add rate limiting and logging
- [ ] Add more details to the endpoints
- [ ] Add more endpoints
- [ ] Add more error handling
- [ ] Add more tests
- [ ] Add more documentation

---
