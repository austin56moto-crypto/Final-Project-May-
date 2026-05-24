from shared import bad_request, created


def handler(event, context):
    body = event.get("body") or {}
    if isinstance(body, str):
        return bad_request("Request body must be JSON-decoded by API Gateway.")

    proof_url = body.get("proofUrl")
    if not proof_url:
        return bad_request("proofUrl is required")

    return created({"message": "Proof submitted", "proofUrl": proof_url})

