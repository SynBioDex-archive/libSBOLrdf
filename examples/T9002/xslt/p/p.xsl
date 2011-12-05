<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
xmlns:s="http://sbols.org/rdf#"
xmlns:pr="http://pr/"
xmlns:prt="http://pr/t/"
xmlns:prd="http://pr/d/"
>
<xsl:param name="prd" select="'http://pr/d/'"/>
<xsl:param name="prt" select="'http://pr/t/'"/>
<!-- prt is the Partsregistry type
     prd is the Partsregistry data

prt and prd could potentially be resolvable at these urls
xmlns:prt="http://partsregistry.org/cgi/partsdb/pgroup.cgi?pgroup="
xmlns:prd="http://partsregistry.org/cgi/xml/part.cgi?part="
-->

<xsl:strip-space elements="*"/>
<xsl:output indent="yes"/>

<xsl:key name="parts" match="subpart" use="part_name"/>
<xsl:template match="/">
<rdf:RDF>

  <xsl:for-each select="rsbpml/part_list/part">
    <s:DnaComponent rdf:about="{concat($prd,part_name)}">
      <s:displayId><xsl:value-of select="part_name"/></s:displayId>
         <xsl:for-each select="deep_subparts/subpart">
              <s:DnaComponent rdf:about="{concat($prd,part_name)}"> 
                <s:displayId><xsl:value-of select="part_name"/></s:displayId>
         </s:DnaComponent> 
          </xsl:for-each>
        <xsl:for-each select="features/feature">
               <xsl:choose>
                 <!-- There is a subpart with this BBa_  -->
                 <xsl:when test="starts-with(title,'BBa_') and key('parts',title)">
                   <s:DnaComponent rdf:about="{concat($prd,title)}">
                     <!-- type -->
                   </s:DnaComponent>
                 </xsl:when>
                 <!-- This BBa_ is a part, not listed as subpart -->
                 <xsl:when test="starts-with(title,'BBa_') and not(key('parts',title))">
                   <s:DnaComponent rdf:about="{concat($prd,title)}">
                     <s:displayId><xsl:copy-of select="title" /></s:displayId>
                     <!-- type -->
                   </s:DnaComponent>
                 </xsl:when>
                 <!-- This feature is not a part -->
                 <xsl:otherwise>
                   <s:DnaComponent rdf:about="{concat($prd,id)}">
                     <s:displayId><xsl:copy-of select="title" /></s:displayId>
                     <s:f><xsl:value-of select="id"/></s:f>
                     <!-- type -->
                   </s:DnaComponent>
                 </xsl:otherwise>
               </xsl:choose>
         </xsl:for-each>
    </s:DnaComponent>
  </xsl:for-each>

</rdf:RDF>
</xsl:template>
</xsl:stylesheet>

