<?xml version="1.1"?>
<xsl:stylesheet version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:f="http://www.w3.org/2005/xpath-functions"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:map="http://www.w3.org/2005/xpath-functions/map"
	xmlns:array="http://www.w3.org/2005/xpath-functions/array"
	xmlns:json="json-utility-functions"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="f map xs"
	expand-text="yes">
	
	<xsl:template name="debug">
		<xsl:param name="json"/>
		<pre>{
		serialize(
			$json, 
			map{'method':'json', 'indent':true()}
		)
		}</pre>
	</xsl:template>
	
	<xsl:function name="json:path">
		<xsl:param name="maps" as="map(*)*"/>
		<xsl:param name="property-path" as="xs:string*"/>
		<xsl:variable name="property" select="head($property-path)"/>
		<xsl:variable name="remaining-properties" select="tail($property-path)"/>
		<xsl:variable name="property-values" select="for $map in $maps return array:flatten($map($property))"/>
		<xsl:sequence select="if ($remaining-properties) then json:path($property-values, $remaining-properties) else $property-values"/>
	</xsl:function>
		
	<xsl:template match="/">
		<xsl:variable name="json" select="parse-json(.)"/>
		<html>
			<head>
				<title>{$json?label}</title>
				<link rel="shortcut icon" href="http://www.nma.gov.au/__data/assets/file/0010/591499/favicon2.ico?v=0.1.1" type="image/x-icon" />
				<xsl:call-template name="css"/>
			</head>
			<body>
				<h1>{$json?label}</h1>
				<p>{json:path($json, 'subject_of') [json:path(., ('classified_as', 'label' )) = 'physical description'] ? value}</p>
				<xsl:for-each select="json:path($json, 'representation')">
					<p><a href="{json:path(., 'representation')[ json:path(., ('classified_as', 'label')) = 'large image'] ?id}"><img src="{json:path(., 'representation')[ json:path(., ('classified_as', 'label')) = 'thumbnail image'] ?id}"/></a></p>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template name="css" expand-text="no">
		<style type="text/css">
			body {
				font-family: Calibri, Helvetica, Arial, sans-serif;
				font-size: 10pt;
			}
			h1 {
				font-size: 13pt;
			}
			h2 {
				font-size: 11pt;
			}
			h3 {
				font-size: 10pt;
			}
			img {
				border: none;
			}
		</style>
	</xsl:template>

</xsl:stylesheet>