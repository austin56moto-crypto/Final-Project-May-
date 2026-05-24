from shared import bad_request, created


def handler(event, context):
    body = event.get("body") or {}
    if isinstance(body, str):
        return bad_request("Request body must be JSON-decoded by API Gateway.")

    title = body.get("title")
    if not title:
        return bad_request("title is required")

    return created(
        {
            "message": "Task created",
            "task": body,
        }
    )

