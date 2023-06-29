#!/bin/bash
terraform plan -detailed-exitcode
export planresult=$?
if [[ "${planresult}" == "2" ]]
then
   TEXT="*Terraform Plan Changed* - Please check Codebuild logs for the plan and approve or reject the deploy"
   TITLE="Changes in Terraform Plan"
   WEBHOOK_URL="#!/bin/bash
terraform plan -detailed-exitcode
export planresult=$?
if [[ "${planresult}" == "2" ]]
then
   TEXT="*Terraform Plan Changed* - Please check Codebuild logs for the plan and approve or reject the deploy"
   TITLE="Changes in Terraform Plan"
   WEBHOOK_URL="https://hooks.slack.com/services/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"
   COLOR="RED"
   MESSAGE=$( echo ${TEXT} | sed 's/"/\"/g' | sed "s/'/\'/g" )
   JSON="{\"title\": \"${TITLE}\", \"themeColor\": \"${COLOR}\", \"text\": \"${MESSAGE}\" }"
   # Post to Slack.
   curl -H "Content-Type: application/json" -d "${JSON}" "${WEBHOOK_URL}""
   COLOR="RED"
   MESSAGE=$( echo ${TEXT} | sed 's/"/\"/g' | sed "s/'/\'/g" )
   JSON="{\"title\": \"${TITLE}\", \"themeColor\": \"${COLOR}\", \"text\": \"${MESSAGE}\" }"
   # Post to Slack.
   curl -H "Content-Type: application/json" -d "${JSON}" "${WEBHOOK_URL}"
