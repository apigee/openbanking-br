<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="@*|node()" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="AssignVariable/Template">
    <xsl:variable name="obbrMetricsMock">{
"data": {
    "requestTime": "{requestTime}",
    "availability": {
        "uptime" : {
            "generalUptimeRate" : "1",
            "endpoints" : [
                {
                    "url" : "https://{request.header.host}/open-banking-br/admin/v1",
                    "uptimeRate" : "1"
                },
                {
                    "url" : "https://{request.header.host}/open-banking-br/discovery/v1",
                    "uptimeRate" : "1"
                },
                {
                    "url" : "https://{organization.name}-{environment.name}.apigee.net/open-banking/channels/v1",
                    "uptimeRate" : "1"
                },
                {
                    "url" : "https://{request.header.host}/open-banking-br/products-services/v1",
                    "uptimeRate" : "1"
                }
            ]
        },
        "downtime" : {
            "generalDowntime" : 0,
            "scheduledOutage" : 0,
            "endpoints" : [
                 {
                    "url" : "https://{request.header.host}/open-banking-br/admin/v1",
                    "partialDowntime" : 0
                },
                {
                    "url" : https://{request.header.host}/open-banking-br/discovery/v1",
                    "partialDowntime" : 0
                },
                {
                    "url" : "https://{request.header.host}/open-banking-br/channels/v1",
                    "partialDowntime" : 0
                },
                {
                    "url" : "https://{request.header.host}/open-banking-br/products-services/v1",
                    "partialDowntime" : 0
                }
            ]
        }
    },
    "invocations": {
        "unauthenticated": {
            "currentDay": 20,
            "previousDays": [
                20, 20, 20, 20, 20, 20, 20
            ]
        },
        "highPriority": {
            "currentDay": 10,
            "previousDays": [
                10, 10, 10, 10, 10, 10, 10
            ]
        },
        "mediumPriority": {
            "currentDay": 5,
            "previousDays": [
                5, 5, 5, 5, 5, 5, 5
            ]
        },
        "unattended": {
            "currentDay": 3,
            "previousDays": [
                3, 3, 3, 3, 3, 3, 3
            ]
        }
    },
    "averageResponse": {
        "unauthenticated": {
            "currentDay": 0.055,
            "previousDays": [
                0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055
            ]
        },
        "highPriority": {
            "currentDay": 0.055,
            "previousDays": [
                0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055
            ]
        },
        "mediumPriority": {
            "currentDay": 0.055,
            "previousDays": [
                0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055
            ]
        },
        "unattended": {
            "currentDay": 0.055,
            "previousDays": [
                0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055
            ]
        }
    },
    "averageTps": {
        "currentDay": 1.0,
        "previousDays": [
            1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0
        ]
    },
    "peakTps": {
        "currentDay": 1.0,
        "previousDays": [
            12.0, 12.0, 12.0, 12.0, 12.0, 12.0, 12.0
        ]
    },
    "errors": {
        "currentDay": 0,
        "previousDays": [
            0, 0, 0, 0, 0, 0, 0
        ]
    },
    "rejections": {
        "currentDay": 0,
        "previousDays": [
            0, 0, 0, 0, 0, 0, 0
        ]
    }
}
}</xsl:variable>
    <xsl:value-of select="$obbrMetricsMock"/>
  </xsl:template>
</xsl:stylesheet>
