from shared import bad_request, created


def handler(event, context):
    body = event.get("body") or {}
    if isinstance(body, str):
        return bad_request("Request body must be JSON-decoded by API Gateway.")

    intern_level = body.get("internLevel")
    topic = body.get("topic")
    duration = body.get("duration")

    if not intern_level or not topic or not duration:
        return bad_request("internLevel, topic, and duration are required")

    return created(
        {
            "title": f"Configure {topic}",
            "description": f"Complete a {duration} task focused on {topic} for a {intern_level} intern.",
            "successCriteria": [
                "Task reviewed",
                "Proof submitted",
            ],
        }
    )
