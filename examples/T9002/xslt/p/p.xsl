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

<xsl:key name="ppp" match="subpart" use="part_name"/>
<xsl:template match="/">
<rdf:RDF>

  <xsl:for-each select="rsbpml/part_list/part">
         <xsl:for-each select="features/feature">
              <xsl:variable name="feat_id">
                <xsl:choose>
                  <xsl:when test="starts-with(title,'BBa_')">
                    <xsl:if test="key('ppp',title)">
                    <xsl:value-of select="title"/>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="id"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <s:DnaComponent rdf:about="{concat($prd,$feat_id)}">
                <s:displayId><xsl:copy-of select="$feat_id" /></s:displayId>
                    <s:f><xsl:value-of select="id"/></s:f>
              </s:DnaComponent>

        </xsl:for-each>
   <s:DnaComponent rdf:about="{concat($prd,part_name)}">
      <s:displayId><xsl:value-of select="part_name"/></s:displayId>
         <xsl:for-each select="deep_subparts/subpart">
              <s:DnaComponent rdf:about="{concat($prd,part_name)}"> 
                <s:displayId><xsl:value-of select="part_name"/></s:displayId>
         </s:DnaComponent> 
          </xsl:for-each>

 

  </s:DnaComponent>
  </xsl:for-each>

</rdf:RDF>
</xsl:template>


<!--
        <tr>
          <td>&#160;</td>
     </table>
    </td></tr>
    </xsl:for-each>
  </table>
  </body>
  </html>
</xsl:template>

  -->
</xsl:stylesheet>

