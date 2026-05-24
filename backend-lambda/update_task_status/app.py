from shared import bad_request, ok


def handler(event, context):
    body = event.get("body") or {}
    if isinstance(body, str):
        return bad_request("Request body must be JSON-decoded by API Gateway.")

    status = body.get("status")
    if not status:
        return bad_request("status is required")

    return ok({"message": "Task status updated", "status": status})

