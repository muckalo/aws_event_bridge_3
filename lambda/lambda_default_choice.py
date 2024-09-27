"""
Lambda Default Choice
"""

import json


def lambda_handler(event, context):
    """
    Lambda Handler - Test Default Choice

    :param event:
    :param context:
    :return:
    """

    # Log the received event
    print("Lambda default choice received event:", json.dumps(event))

    # Process the event
    result = {
        "status": "success",
        "message": "Processed by Lambda Default Choice",
        "input": event
    }

    return result
