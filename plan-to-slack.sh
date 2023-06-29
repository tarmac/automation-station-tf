#!/bin/bash
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
   curl -H "Content-Type: application/json" -d "${JSON}" "${WEBHOOK_URL}"
fi
