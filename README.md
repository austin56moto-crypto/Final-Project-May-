# InternTask AI Cloud

InternTask AI Cloud is a Flutter-based internship task management platform designed around a modern AWS serverless architecture. It supports role-based access for `Admin`, `Instructor`, and `Student`, and gives the admin side a clean workflow for creating tasks that students can then view, complete, and submit with file attachments.

The project is structured as a full-stack cloud assignment with:

- Flutter mobile/web UI
- AWS Cognito authentication and role gating
- API Gateway and Lambda backend routes
- DynamoDB for application data
- Amazon S3 for proof uploads and reports
- SNS for notifications
- Amazon Bedrock for AI task generation
- Terraform infrastructure as code

## What The App Does

- Shows a role selection screen at startup
- Opens only the selected workspace after login
- Lets admins create student tasks from the UI
- Lets students attach a file and submit work as complete
- Keeps instructor, admin, and student views separated
- Presents a polished dashboard that still feels clean and school-friendly

## Current Implementation

This repo currently includes a working local prototype of the student/admin workflow:

- Task creation is handled in-memory in Flutter for the UI demo
- Student submissions support file picking and attachment metadata
- Role-specific dashboards are gated at the app entry point
- The AWS backend and Terraform structure are scaffolded for the next phase

## Repository Layout

```txt
interntask-ai-cloud/
├── mobile-flutter/
├── backend-lambda/
├── terraform/
├── docs/
└── README.md
```

## Flutter App

The Flutter app lives in `mobile-flutter/` and includes:

- Role selection and workspace gating
- Admin task composer
- Student submission sheet with file attachment support
- Dashboard cards and status sections
- Web build support for local preview

### Key Flow

1. Open the app.
2. Select `Admin`, `Instructor`, or `Student`.
3. Admin creates tasks.
4. Students see assigned tasks in their workspace.
5. Students attach a file and submit the task as complete.

## Backend And AWS Structure

The repository already includes scaffolding for the backend and infrastructure layer:

- `backend-lambda/` for Lambda handlers
- `terraform/` for AWS infrastructure
- `docs/architecture.md` for the high-level system design
- `docs/api.md` for the route design

### Planned AWS Services

- Cognito for authentication and role groups
- API Gateway for secured REST endpoints
- Lambda for business logic
- DynamoDB for tasks, users, submissions, and notifications
- S3 for uploaded proof files and reports
- SNS for assignment and reminder notifications
- Bedrock for AI-generated task drafts

## Running Locally

### Flutter

```bash
cd mobile-flutter
flutter pub get
flutter run -d chrome
```

### Web Preview

If you already built the web app, you can also serve the output locally:

```bash
cd mobile-flutter/build/web
python3 -m http.server 8097
```

Then open:

- `http://127.0.0.1:8097`

## Verification

The current Flutter app has been checked with:

- `flutter analyze`
- `flutter test`
- `flutter build web`

## Notes

- The UI task flow is functional, but the task data is still local/in-memory for now.
- To make it production-ready, the next step is wiring task creation and student submissions to the AWS backend and S3.
- The current UI is intentionally professional and restrained so it looks appropriate for a school assignment and not overly decorative.

## Next Improvements

- Persist tasks and submissions in DynamoDB
- Upload student attachments to S3
- Connect the Flutter app to Cognito and API Gateway
- Add authorization checks in Lambda
- Send task and submission notifications through SNS
- Integrate Amazon Bedrock for AI task generation

