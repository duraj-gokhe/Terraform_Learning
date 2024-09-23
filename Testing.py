import json

def lambda_function(event, context):
    return{
        "status" : 200,
        "body" : {
            "msg" : "Hello Terraform",
            "event" : event
        }
    }