import requests
import json
from datetime import datetime
import os

accountID = os.environ.get("account_id")
orgID = os.environ.get("org_id")
projectID = os.environ.get("project_id")
notifyID = os.environ.get("notify_id")
xApiKey = os.environ.get("x_api_key")

# Define your GraphQL query
query = """
query getExperimentRun($identifiers: IdentifiersRequest!, $experimentRunID: String, $notifyID: String) {
        getExperimentRun(identifiers: $identifiers, experimentRunID: $experimentRunID, notifyID: $notifyID) {
          workflowRunID
          runSequence
          notifyID
          workflowID
          updatedAt
          infra {
            environmentID
            infraID
            name
            infraType
          }
          workflowName
          workflowDescription
          workflowTags
          workflowType
          isCronEnabled
          workflowManifest
          phase
          resiliencyScore
          updatedBy {
            username
          }
          weightages {
            experimentName
            weightage
          }
          executionData
          errorResponse
          securityGovernance {
            name
            type
            startedAt
            finishedAt
            message
            phase
            securityGovernanceNodeData {
              passedRules {
                ruleId
                ruleName
                message
                description
                userGroupIds
                conditions {
                  conditionId
                  conditionName
                  message
                  phase
                }
                timeWindow {
                  duration
                  endTime
                  recurrence {
                    spec {
                      until
                      value
                    }
                    type
                  }
                  startTime
                  timeZone
                }
              }
              failedRules {
                ruleId
                ruleName
                message
                description
                userGroupIds
                conditions {
                  conditionId
                  conditionName
                  message
                  phase
                }
                timeWindow {
                  duration
                  endTime
                  recurrence {
                    spec {
                      until
                      value
                    }
                    type
                  }
                  startTime
                  timeZone
                }
              }
              skippedRules {
                ruleId
                ruleName
                message
                description
                userGroupIds
                conditions {
                  conditionId
                  conditionName
                  message
                  phase
                }
                timeWindow {
                  duration
                  endTime
                  recurrence {
                    spec {
                      until
                      value
                    }
                    type
                  }
                  startTime
                  timeZone
                }
              }
            }
          }
        }
      }
"""

# Define the GraphQL endpoint URL
graphql_url = 'https://app.harness.io/gateway/chaos/manager/api/query'

# Define the request headers
headers = {
    'Content-Type': 'application/json',
    'X-API-KEY': xApiKey
}

# Define your variables
variables = {
    "identifiers":
    {
        "projectIdentifier": projectID,
        "orgIdentifier": orgID,
        "accountIdentifier": accountID
    },
    "notifyID": notifyID
}

# Define the request payload with your query and variables
payload = {
    'query': query,
    'variables': variables
}

# Send a POST request to the GraphQL endpoint
response = requests.post(graphql_url, headers=headers, json=payload)

# Check if the request was successful
if response.status_code == 200:
    # Extract the JSON string from the response
    json_string = response.text

    # Parse the JSON string
    parsed_data = json.loads(json_string)

    execution_data = parsed_data["data"]["getExperimentRun"]["executionData"]

    execution_data_json = json.loads(execution_data)
else:
    print("Error:", response.status_code)

with open('filename.txt', 'w') as file:

    experimentName = parsed_data["data"]["getExperimentRun"]["workflowName"]
    resilienceScore = parsed_data["data"]["getExperimentRun"]["resiliencyScore"]
    experimentStatus = execution_data_json["phase"]
    infrastructureID = parsed_data["data"]["getExperimentRun"]["infra"]["infraID"]
    # Convert milliseconds since epoch to seconds since epoch
    timestamp_seconds = int(
        execution_data_json["creationTimestamp"]) / 1000

    # Convert seconds since epoch to a datetime object
    dt_object = datetime.fromtimestamp(timestamp_seconds)

    # Format the datetime object as a human-readable string
    human_readable_date = dt_object.strftime("%Y-%m-%d %H:%M:%S")
    print("AccountID: ", accountID)
    print("Org ID:", orgID)
    print("Project ID:", projectID)
    print("Experiment Name:", experimentName)
    print("Experiment Status:", experimentStatus)
    print("Resilience Score:", resilienceScore)
    print("Executed on:", human_readable_date)
    print("Infrastructure ID:", infrastructureID)
    print("----------")

    for node_key, node_data in execution_data_json['nodes'].items():
        if 'chaosData' in node_data:
            faultName = node_data["name"]
            faultPhase = node_data["phase"]
            probeSuccessPerc = node_data["chaosData"]["probeSuccessPercentage"]
            startedAt = int(node_data["startedAt"])
            finishedAt = int(node_data["finishedAt"])
            duration_ms = finishedAt - startedAt
            duration_sec = duration_ms / 1000

            # Print the duration in seconds
            print("Fault Name:", faultName)
            print("Fault Phase:", faultPhase)
            print("Probe Success Percentage:", probeSuccessPerc)
            print("Fault Duration:", duration_sec, "seconds")

            probe_statuses = node_data['chaosData']["chaosResult"]['status']['probeStatuses']
            print("Probe Details:")
            for probe_status in probe_statuses:
                probe_info = {
                    'node_name': node_key,
                    'probe_name': probe_status['name'],
                    'status': probe_status['status']['verdict'],
                    'description': probe_status['status']['description'],
                    'type': probe_status['type']
                }
                print("  Probe Name:", probe_info['probe_name'])
                print("  Status:", probe_info['status'])
                print("  Description:", probe_info["description"])
                print("  Type:", probe_info['type'])
            print("----------")
