from shared import bad_request, created


def handler(event, context):
    body = event.get("body") or {}
    if isinstance(body, str):
        return bad_request("Request body must be JSON-decoded by API Gateway.")

    message = body.get("message")
    if not message:
        return bad_request("message is required")

    return created({"message": "Notification queued", "content": message})

