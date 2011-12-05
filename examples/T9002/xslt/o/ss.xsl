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
  <xsl:template match="it:author">
    <xsl:element name="rit:author" namespace="{$it-schema}">
      <xsl:choose>
        <xsl:when test="@userid='yes'">
          <xsl:attribute name="rdf:resource">
            <xsl:value-of select="concat($it-users, @tag)"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@tag"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  <xsl:template match="it:action">
    <rit:action>
      <rdf:description>
        <xsl:apply-templates/>
      </rdf:description>
    </rit:action>
  </xsl:template>
  <xsl:template match="it:comment">
    <rit:comment>
      <rdf:description>
        <xsl:apply-templates/>
        <it:body><xsl:value-of select="it:body"/></it:body>
      </rdf:description>
    </rit:comment>
  </xsl:template>
  <xsl:template match="it:comment/concur">
    <rit:body>I agree</rit:body>
  </xsl:template>
  <xsl:template match="it:action/it:assign">
    <rit:assigned-to rdf:resource="{concat($it-users, @to)}"/>
  </xsl:template>
  <xsl:template match="it:action/it:description">
    <rit:body><xsl:apply-templates/></rit:body>
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
