<?php
header('Content-Type: text/xml'); 
?>
<?php 
//to trigger download use the following line:
//header('Content-Disposition: attachment; filename="example.xml"'); 
/** 
 * @param  $xml 
 * @param  $xsl 
 * @return string xml 
 */ 
function transform($xml, $xsl) { 
   $xsl_doc = new DomDocument;
   $xsl_doc->load($xsl); 
   $xml_doc = new DomDocument;
   $xml_doc->load($xml); 

   $xslt = new XSLTProcessor(); 
   $xslt->importStylesheet($xsl_doc); 
   
   if ($out = $xslt->transformToXML($xml_doc)) {
      return $out;
  } else {
      trigger_error('XSL transformation failed.', E_USER_ERROR);
  } // if 
} 
function clean($elem) 
{ 
    if(!is_array($elem)) 
        $elem = htmlentities($elem,ENT_QUOTES,"UTF-8"); 
    else 
        foreach ($elem as $key => $value)
            $elem[$key] = clean($value); 
    return $elem; 
} 
function ifget()
{
    if(empty($_GET)) {
        echo "<html>No GET variables\n"; 
        echo "</html>\n"; 
    } else {
        $get = clean($_GET);
        $part = $get["part"];
        //$x = transform($part.".xml","sbol_biobrick.xsl");
        $x = transform("http://partsregistry.org/xml/part.".$part,"sbol_biobrick.xsl");
        print $x;
    }
}

ifget();


?>
