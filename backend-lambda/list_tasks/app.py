from shared import ok


def handler(event, context):
    return ok(
        {
            "items": [],
            "message": "List tasks endpoint is ready",
        }
    )

