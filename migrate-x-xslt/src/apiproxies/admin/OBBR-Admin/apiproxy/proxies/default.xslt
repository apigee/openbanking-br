<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="@*|node()" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="VirtualHost"/>
  <xsl:template match="BasePath/text()[. = '/open-banking/admin/v1']">
    <xsl:variable name="obbrAdminBasePath">/open-banking-br/admin/v1</xsl:variable>
    <xsl:value-of select="$obbrAdminBasePath"/>
  </xsl:template>
</xsl:stylesheet>
