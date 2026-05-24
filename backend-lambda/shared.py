import json


def response(status_code, body):
    return {
        "statusCode": status_code,
        "headers": {
            "Content-Type": "application/json",
        },
        "body": json.dumps(body),
    }


def ok(body):
    return response(200, body)


def created(body):
    return response(201, body)


def bad_request(message):
    return response(400, {"message": message})

