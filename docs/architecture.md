# Architecture Overview

## Core Flow

1. The Flutter app authenticates users with AWS Cognito.
2. Cognito issues JWTs that are sent to API Gateway.
3. API Gateway forwards requests to Lambda handlers.
4. Lambdas read and write DynamoDB, upload to S3, and publish to SNS.
5. The AI task generation endpoint calls Amazon Bedrock to produce draft tasks.

## Roles

- Admin: manage users and system data
- Instructor: create and assign tasks, review submissions
- Intern: view tasks, submit proof, track progress

## Security Notes

- Keep Cognito as the front door for authentication.
- Enforce authorization again inside Lambda, not only in the UI.
- Store proof uploads in a private S3 bucket.
- Restrict Bedrock and SNS access to the minimum required permissions.

