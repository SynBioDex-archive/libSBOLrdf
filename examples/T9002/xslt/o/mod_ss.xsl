<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:it="http://xmlns.rdfinference.org/ril/issue-tracker"
  xmlns:rit="http://rdfs.rdfinference.org/ril/issue-tracker#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dc="http://purl.org/metadata/dublin_core#"
  version="1.0"
>
  <xsl:strip-space elements="*"/>
  <xsl:output indent="yes"/>
  <xsl:param name="it-base" select="'http://meta.rdfinference.org/ril/issue-tracker/'"/>
  <xsl:param name="it-schema" select="'http://rdfs.rdfinference.org/ril/issue-tracker#'"/>
  <xsl:param name="it-users" select="'http://users.rdfinference.org/ril/issue-tracker#'"/>
  <xsl:template match="/">
    <rdf:RDF>
      <xsl:apply-templates/>
    </rdf:RDF>
  </xsl:template>
  <xsl:template match="it:issue">
    <xsl:call-template name="handle-issue"/>
  </xsl:template>
  <xsl:template name="handle-issue">
    <xsl:apply-templates select="it:reference" mode="resolve-ref"/>
    <rdf:description about="{@id}">
      <xsl:apply-templates/>
    </rdf:description>
  </xsl:template>
  <xsl:template match="it:reference" mode="resolve-ref">
    <xsl:choose>
      <xsl:when test="it:spec">
        <rdf:description about="{concat($it-base,it:spec/@id)}">
          <rit:issue rdf:resource="#{../@id}"/>
        </rdf:description>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="it:reference"/>
  <xsl:template match="it:main"/>
  <xsl:template match="it:body"/>
  <xsl:template match="it:description"/>
</xsl:stylesheet>
