# API Draft

## Routes

- `POST /tasks`
- `POST /tasks/generate-ai`
- `GET /tasks`
- `GET /tasks/{id}`
- `PUT /tasks/{id}/status`
- `POST /tasks/{id}/submit-proof`
- `GET /submissions`
- `POST /notifications/send`
- `GET /users/me`

## Request Shape Notes

- Use JSON for all request and response payloads.
- Pass the Cognito access token in the `Authorization` header.
- Return consistent error objects with a message and status code.

