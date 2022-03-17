<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="@*|node()" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="Parameter[@customerId]"/>
  <xsl:template match="Parameter[@clientId]"/>
  <xsl:template match="Parameter[@sessionId]"/>
</xsl:stylesheet>
