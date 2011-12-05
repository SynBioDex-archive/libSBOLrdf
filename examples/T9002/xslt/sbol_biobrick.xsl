<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
xmlns:s="http://sbols.org/rdf#"
xmlns:pr="http://partsregistry.org/"
xmlns:prt="http://partsregistry.org/type/"
xmlns:prd="http://partsregistry.org/data/"
xmlns:prf="http://partsregistry.org/data/feature"
>
<xsl:param name="prd" select="'http://partsregistry.org/data/'"/>
<xsl:param name="prt" select="'http://partsregistry.org/type/'"/>
<!-- prt is the Partsregistry type
     prd is the Partsregistry data

prt and prd could potentially be resolvable at these urls
xmlns:prt="http://partsregistry.org/cgi/partsdb/pgroup.cgi?pgroup="
xmlns:prd="http://partsregistry.org/cgi/xml/part.cgi?part="
-->

<xsl:strip-space elements="*"/>
<xsl:output indent="yes"/>
<xsl:variable name="lc">abcdefghijklmnopqrstuvwxyz</xsl:variable>
<xsl:variable name="uc">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
<xsl:key name="parts" match="subpart" use="part_name"/>

<xsl:template match="/">
<rdf:RDF>

  <xsl:for-each select="rsbpml/part_list/part">
    <s:DnaComponent rdf:about="{concat($prd,part_name)}">
      <s:displayId><xsl:value-of select="part_name"/></s:displayId>
        <xsl:choose>
          <xsl:when test="normalize-space(part_nickname)">
            <s:name><xsl:value-of select="part_nickname"/></s:name>
          </xsl:when>
          <xsl:otherwise>
            <s:name><xsl:value-of select="part_short_name"/></s:name>
          </xsl:otherwise>
        </xsl:choose>
      <s:description>
        <xsl:value-of select="normalize-space(part_short_desc)"/>
          </s:description>
          <pr:type rdf:resource="{concat($prt,translate(part_type,$uc,$lc))}"/>
          <!-- 
          <xsl:value-of select="part_status"/>
          <xsl:value-of select="part_results"/>
          <xsl:value-of select="part_nickname"/>
          <xsl:value-of select="part_rating"/>
          <xsl:value-of select="part_entered"/>
          <xsl:value-of select="part_author"/>
          <xsl:value-of select="best_quality"/>
          <xsl:value-of select="categories/category"/>
          <xsl:for-each select="twins/twin">
            <xsl:value-of select="."/>
          -->
      <s:dnaSequence>
        <s:DnaSequence rdf:about="{concat($prd,generate-id())}">
          <s:nucleotides>
            <xsl:value-of select="translate(sequences/seq_data, 
                        '&#x20;&#x9;&#xD;&#xA;', ' ')"/>
          </s:nucleotides>
        </s:DnaSequence>
      </s:dnaSequence>

         <xsl:for-each select="deep_subparts/subpart">
         <s:annotations>
          <s:SequenceAnnotation rdf:about="{concat($prd,generate-id())}">
            <xsl:if test="preceding-sibling::*">
            <s:precedes rdf:resource="{concat($prd,generate-id(preceding-sibling::*))}"/>
            </xsl:if>
            <s:subComponent>
              <s:DnaComponent rdf:about="{concat($prd,part_name)}"> 
                <s:displayId><xsl:value-of select="part_name"/></s:displayId>
                <xsl:choose>
                  <xsl:when test="normalize-space(part_nickname)">
                     <s:name><xsl:value-of select="part_nickname"/></s:name>
                  </xsl:when>
                  <xsl:otherwise>
                     <s:name><xsl:value-of select="part_name"/></s:name>
                  </xsl:otherwise>
                </xsl:choose>
                <s:description><xsl:value-of select="normalize-space(part_short_desc)"/></s:description>
                <pr:type rdf:resource="{concat($prt,translate(part_type,$uc,$lc))}"/>
         </s:DnaComponent> 
            </s:subComponent>
          </s:SequenceAnnotation>
          </s:annotations>
          </xsl:for-each>

          <xsl:for-each select="specified_subparts/subpart">
          <s:annotations>

          <s:SequenceAnnotation rdf:about="{concat($prd,generate-id())}">
            <xsl:if test="preceding-sibling::*">
            <s:precedes rdf:resource="{concat($prd,generate-id(preceding-sibling::*))}"/>
            </xsl:if>
            <s:subComponent>

              <s:DnaComponent rdf:about="{concat($prd,part_name)}"> 
                <s:displayId><xsl:value-of select="part_name"/></s:displayId>
                <xsl:choose>
                  <xsl:when test="normalize-space(part_nickname)">
                  <s:name><xsl:value-of select="part_nickname"/></s:name>
                  </xsl:when>
                  <xsl:otherwise>
                  <s:name><xsl:value-of select="part_name"/></s:name>
                  </xsl:otherwise>
                </xsl:choose>
                <s:description><xsl:value-of select="normalize-space(part_short_desc)"/></s:description>
                <pr:type rdf:resource="{concat($prt,translate(part_type,$uc,$lc))}"/>
              </s:DnaComponent> 
            </s:subComponent>
          </s:SequenceAnnotation>
          </s:annotations>
          </xsl:for-each>

          <xsl:for-each select="specified_subscars/subpart">
          <s:annotations>

          <s:SequenceAnnotation rdf:about="{concat($prd,generate-id())}">
            <xsl:if test="preceding-sibling::*">
            <s:precedes rdf:resource="{concat($prd,generate-id(preceding-sibling::*))}"/>
            </xsl:if>
            <s:subComponent>

              <s:DnaComponent rdf:about="{concat($prd,part_name)}"> 
                <s:displayId><xsl:value-of select="part_name"/></s:displayId>
                <xsl:choose>
                  <xsl:when test="normalize-space(part_nickname)">
                  <s:name><xsl:value-of select="part_nickname"/></s:name>
                  </xsl:when>
                  <xsl:otherwise>
                  <s:name><xsl:value-of select="part_name"/></s:name>
                  </xsl:otherwise>
                </xsl:choose>
                <s:description><xsl:value-of select="normalize-space(part_short_desc)"/></s:description>
                <pr:type rdf:resource="{concat($prt,translate(part_type,$uc,$lc))}"/>
         </s:DnaComponent> 
            </s:subComponent>
          </s:SequenceAnnotation>
          </s:annotations>
          </xsl:for-each>

          <xsl:for-each select="specified_subscars/scar">
          <s:annotations>
          <s:SequenceAnnotation rdf:about="{concat($prd,generate-id())}">
            <xsl:if test="preceding-sibling::*">
            <s:precedes rdf:resource="{concat($prd,generate-id(preceding-sibling::*))}"/>
            </xsl:if>
            <s:subComponent>
              <s:DnaComponent rdf:about="{concat($prd,concat('RFC_',scar_standard))}"> 
                <s:displayId><xsl:value-of select="concat('RFC_',scar_standard)"/></s:displayId>
                <xsl:choose>
                  <xsl:when test="normalize-space(scar_nickname)">
                  <s:name><xsl:value-of select="scar_nickname"/></s:name>
                  </xsl:when>
                  <xsl:otherwise>
                  <s:name><xsl:value-of select="scar_name"/></s:name>
                  </xsl:otherwise>
                </xsl:choose>
                <s:description><xsl:value-of select="normalize-space(scar_comments)"/></s:description>
                <pr:type rdf:resource="{concat($prt,translate(scar_type,$uc,$lc))}"/>
                <s:dnaSequence>
                <s:DnaSequence rdf:about="{concat($prd,generate-id(scar_sequence))}">
                  <s:nucleotides>
                    <xsl:value-of select="translate(scar_sequence, 
                      '&#x20;&#x9;&#xD;&#xA;', ' ')"/>
                    </s:nucleotides>
                  </s:DnaSequence>
           </s:dnaSequence>
              </s:DnaComponent> 
            </s:subComponent>
          </s:SequenceAnnotation>
          </s:annotations>
          </xsl:for-each>
    
        <xsl:for-each select="features/feature">
          <s:annotations>
          <s:SequenceAnnotation rdf:about="{concat($prd,generate-id())}">
<!--
            <xsl:if test="preceding-sibling::*">
            <s:precedes rdf:resource="{concat($prd,generate-id(preceding-sibling::*))}"/>
            </xsl:if>
-->
            <s:bioStart><xsl:value-of select="startpos"/></s:bioStart>
            <s:bioEnd><xsl:value-of select="endpos"/></s:bioEnd>
            <xsl:choose>
              <xsl:when test="starts-with(direction,'forward')">
                <s:strand>+</s:strand>
              </xsl:when>
              <xsl:when test="starts-with(direction,'reverse')">
                <s:strand>-</s:strand>
              </xsl:when>
            </xsl:choose>
            <s:subComponent>
                <xsl:choose>
                  <!-- There is a subpart with the same BBa_ as this feature -->
                  <xsl:when test="starts-with(title,'BBa_') and key('parts',title)">
                    <s:DnaComponent rdf:about="{concat($prd,title)}">
                      <pr:type rdf:resource="{concat($prt,translate(type,$uc,$lc))}"/>
                    </s:DnaComponent>
                  </xsl:when>
                  <!-- This BBa_ feature is a part, not listed as subpart -->
                  <xsl:when test="starts-with(title,'BBa_') and not(key('parts',title))">
                    <s:DnaComponent rdf:about="{concat($prd,title)}">
                      <s:displayId><xsl:value-of select="title" /></s:displayId>
                      <pr:type rdf:resource="{concat($prt,type)}"/>
                    </s:DnaComponent>
                  </xsl:when>
                  <!-- This feature is not a part -->
                  <xsl:otherwise>
                    <s:DnaComponent rdf:about="{concat(concat($prd,'feature/'),id)}">
                      <s:displayId><xsl:value-of select="id" /></s:displayId>
                      <xsl:choose>
                       <xsl:when test="normalize-space(title)">
                         <s:name><xsl:value-of select="title"/></s:name>
                       </xsl:when>
                       <xsl:otherwise>
                         <s:name><xsl:value-of select="type"/></s:name>
                       </xsl:otherwise>
                     </xsl:choose>
                      <pr:type rdf:resource="{concat($prt,type)}"/>
                    </s:DnaComponent>
                  </xsl:otherwise>
                </xsl:choose>
            </s:subComponent>
          </s:SequenceAnnotation>
          </s:annotations>

        </xsl:for-each>
 

  </s:DnaComponent>
  </xsl:for-each>

</rdf:RDF>
</xsl:template>

</xsl:stylesheet>

