<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
xmlns:s="http://sbols.org/rdf#"
xmlns:pr="http://partsregistry.org/"
xmlns:prt="http://partsregistry.org/type/"
xmlns:prd="http://partsregistry.org/data/"
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

<xsl:template match="/">
<rdf:RDF>

  <xsl:for-each select="rsbpml/part_list/part">
    <xsl:variable name="part_id">
      <xsl:value-of select="part_name"/>
      <!-- 
      <xsl:value-of select="part_url"/>
      -->
    </xsl:variable>
    <s:DnaComponent rdf:about="{concat($prd,$part_id)}">
      <s:uri rdf:resource="{concat($prd,$part_id)}"/>
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
          <pr:type rdf:resource="{concat($prt,part_type)}"/>
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
          <xsl:variable name="seq_id">
            <xsl:value-of select="generate-id()"/>
          </xsl:variable>
        <s:DnaSequence rdf:about="{concat($prd,$seq_id)}">
          <s:uri rdf:resource="{concat($prd,$seq_id)}"/>
          <s:nucleotides>
            <xsl:value-of select="translate(sequences/seq_data, 
                        '&#x20;&#x9;&#xD;&#xA;', ' ')"/>
          </s:nucleotides>
        </s:DnaSequence>
      </s:dnaSequence>

         <xsl:for-each select="deep_subparts/subpart">
         <s:annotations>
          <xsl:variable name="anot_id">
            <xsl:value-of select="generate-id()"/>
          </xsl:variable>
          <s:SequenceAnnotation rdf:about="{concat($prd,$anot_id)}">
            <s:uri rdf:resource="{concat($prd,$anot_id)}"/>
            <xsl:if test="preceding-sibling::*">
            <s:precedes rdf:resource="{concat($prd,generate-id(preceding-sibling::*))}"/>
            </xsl:if>
            <s:subComponent>
            <xsl:variable name="subpart_id">
              <xsl:value-of select="part_name"/>
            </xsl:variable>
              <s:DnaComponent rdf:about="{concat($prd,$subpart_id)}"> 
                <s:uri rdf:resource="{concat($prd,$subpart_id)}"/>
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
                <pr:type rdf:resource="{concat($prt,part_type)}"/>
         </s:DnaComponent> 
            </s:subComponent>
          </s:SequenceAnnotation>
          </s:annotations>
          </xsl:for-each>

          <xsl:for-each select="specified_subparts/subpart">
          <s:annotations>

          <xsl:variable name="anot_id">
            <xsl:value-of select="generate-id()"/>
          </xsl:variable>
          <s:SequenceAnnotation rdf:about="{concat($prd,$anot_id)}">
            <s:uri rdf:resource="{concat($prd,$anot_id)}"/>
            <xsl:if test="preceding-sibling::*">
            <s:precedes rdf:resource="{concat($prd,generate-id(preceding-sibling::*))}"/>
            </xsl:if>
            <s:subComponent>

          <xsl:variable name="subpart_id">
            <xsl:value-of select="part_name"/>
          </xsl:variable>
              <s:DnaComponent rdf:about="{concat($prd,$subpart_id)}"> 
                <s:uri rdf:resource="{concat($prd,$subpart_id)}"/>
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
                <pr:type rdf:resource="{concat($prt,part_type)}"/>
              </s:DnaComponent> 
            </s:subComponent>
          </s:SequenceAnnotation>
          </s:annotations>
          </xsl:for-each>

          <xsl:for-each select="specified_subscars/subpart">
          <s:annotations>

          <xsl:variable name="anot_id">
            <xsl:value-of select="generate-id()"/>
          </xsl:variable>
          <s:SequenceAnnotation rdf:about="{concat($prd,$anot_id)}">
            <s:uri rdf:resource="{concat($prd,$anot_id)}"/>
            <xsl:if test="preceding-sibling::*">
            <s:precedes rdf:resource="{concat($prd,generate-id(preceding-sibling::*))}"/>
            </xsl:if>
            <s:subComponent>

            <xsl:variable name="subpart_id">
              <xsl:value-of select="part_name"/>
            </xsl:variable>
              <s:DnaComponent rdf:about="{concat($prd,$subpart_id)}"> 
                <s:uri rdf:resource="{concat($prd,$subpart_id)}"/>
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
                <pr:type rdf:resource="{concat($prt,part_type)}"/>
         </s:DnaComponent> 
            </s:subComponent>
          </s:SequenceAnnotation>
          </s:annotations>
          </xsl:for-each>

          <xsl:for-each select="specified_subscars/scar">
          <s:annotations>
          <xsl:variable name="anot_id">
            <xsl:value-of select="generate-id()"/>
          </xsl:variable>
          <s:SequenceAnnotation rdf:about="{concat($prd,$anot_id)}">
            <s:uri rdf:resource="{concat($prd,$anot_id)}"/>
            <xsl:if test="preceding-sibling::*">
            <s:precedes rdf:resource="{concat($prd,generate-id(preceding-sibling::*))}"/>
            </xsl:if>
            <s:subComponent>
              <xsl:variable name="scar_id">
                <xsl:value-of select="concat('RFC_',scar_standard)"/>
              </xsl:variable>

              <s:DnaComponent rdf:about="{concat($prd,$scar_id)}"> 
                <s:uri rdf:resource="{concat($prd,$scar_id)}"/>
                <s:displayId><xsl:value-of select="scar_name"/></s:displayId>
                <xsl:choose>
                  <xsl:when test="normalize-space(scar_nickname)">
                  <s:name><xsl:value-of select="scar_nickname"/></s:name>
                  </xsl:when>
                  <xsl:otherwise>
                  <s:name><xsl:value-of select="scar_name"/></s:name>
                  </xsl:otherwise>
                </xsl:choose>
                <s:description><xsl:value-of select="normalize-space(scar_comments)"/></s:description>
                <pr:type rdf:resource="{concat($prt,scar_type)}"/>
                <s:dnaSequence>
                <xsl:variable name="seq_id">
                  <xsl:value-of select="generate-id(scar_sequence)"/>
                </xsl:variable>
                <s:DnaSequence rdf:about="{concat($prd,$seq_id)}">
                  <s:uri rdf:resource="{concat($prd,$seq_id)}"/>
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
          <xsl:variable name="anot_id">
            <xsl:value-of select="generate-id()"/>
          </xsl:variable>
          <s:SequenceAnnotation rdf:about="{concat($prd,$anot_id)}">
            <s:uri rdf:resource="{concat($prd,$anot_id)}"/>
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

              <xsl:variable name="feat_id">
                <xsl:choose>
                  <xsl:when test="starts-with(title,'BBa_')">
                    <xsl:value-of select="title"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="id"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <s:DnaComponent rdf:about="{concat($prd,$feat_id)}">
                <s:uri rdf:resource="{concat($prd,$feat_id)}"/>
                <s:displayId><xsl:copy-of select="$feat_id" /></s:displayId>
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
            </s:subComponent>
          </s:SequenceAnnotation>
          </s:annotations>

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

