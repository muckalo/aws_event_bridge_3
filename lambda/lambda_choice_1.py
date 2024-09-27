"""
Lambda Choice 1
"""

import json


def lambda_handler(event, context):
    """
    Lambda Handler - Test Choice 1

    :param event:
    :param context:
    :return:
    """

    # Log the received event
    print("Lambda choice 1 received event:", json.dumps(event))

    # Process the event
    result = {
        "status": "success",
        "message": "Processed by Lambda 1",
        "input": event
    }

    return result
