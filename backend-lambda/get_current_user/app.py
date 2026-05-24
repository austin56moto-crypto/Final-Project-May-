from shared import ok


def handler(event, context):
    claims = (
        event.get("requestContext", {})
        .get("authorizer", {})
        .get("claims", {})
    )

    return ok(
        {
            "userId": claims.get("sub"),
            "email": claims.get("email"),
            "groups": claims.get("cognito:groups", []),
        }
    )

