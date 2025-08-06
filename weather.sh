#!/bin/bash
set -e
source ~/.config/bashscripts/email.sh

date_input=$(date +"%d-%M-%Y-%H-%m")
weather_period_json=$(curl -X GET https://api-open.data.gov.sg/v2/real-time/api/twenty-four-hr-forecast | tee >(jq '.' > ~/logs/weather/"$date_input".json))
report=$(echo "$weather_period_json" | jq -r '
  "<h2>Daily weather report</h2>",
  .data.records[0] as $records |
  ($records.periods[] |
    "<section>",
    "<h3>&nbsp;&nbsp;\(.timePeriod.text)</h3>",
    (.regions | to_entries[] | "<p>&nbsp;&nbsp;&nbsp;&nbsp;\(.key): \(.value.text)</p>"),
    "</section>"),
    "\($records.timestamp)"
' | sed -e 's|Midnight|12 am|' -e 's|Midday|12 pm|' -e 's|to|-|') || {
    echo "Report generation failed, exiting" >> ~/logs/weather/"$date_input".json
    exit 1
}

msmtp $EMAIL <<EOF
From: Botto <$EMAIL_FROM>
To: $EMAIL
Subject: Daily Report $(date)
Content-Type: text/html; charset=UTF-8:
MIME-Version: 1.0


<html>
    <body>
        $report
    </body>
</html>
EOF
