<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:z="https://github.com/Conal-Tuohy/XProc-Z"
	xmlns:cx="http://xmlcalabash.com/ns/extensions"
	xmlns:config="tag:conaltuohy.com,2015:webapp-init-parameters"
version="1.0" name="main" xmlns:ce="tag:conaltuohy.com,2020:nma-ce">


	<p:input port='source' primary='true'/>
	<!-- e.g.
		<request xmlns="http://www.w3.org/ns/xproc-step"
		  method = NCName
		  href? = anyURI
		  detailed? = boolean
		  status-only? = boolean
		  username? = string
		  password? = string
		  auth-method? = string
		  send-authorization? = boolean
		  override-content-type? = string>
			 (c:header*,
			  (c:multipart |
				c:body)?)
		</request>
	-->
	
	<p:input port='parameters' kind='parameter' primary='true'/>
	<p:output port="result" primary="true" sequence="true"/>
	<p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>
	<p:import href="xproc-z-library.xpl"/>
		
	<p:variable name="relative-uri" select="substring-after(/c:request/@href, '/ce/')"/>
	<!-- HTTP Header names are case-insensitive -->
	<p:variable name="accept" select="/c:request/c:header[lower-case(@name)='accept']/@value"/>
	<cx:message>
		<p:with-option name="message" select="$relative-uri"/>
	</cx:message>
	<p:choose>
		<p:when test="starts-with($relative-uri, 'object/')">
			<ce:object/>
		</p:when>
		<p:otherwise>
			<z:not-found/>
		</p:otherwise>
	</p:choose>
			
	<p:declare-step name="object" type="ce:object">
		<p:input port="source"/>
		<p:input port="parameters" kind="parameter" primary="true"/>
		<p:output port="result"/>
		<p:option name="apikey"/>
		<p:option name="api-base-uri"/>
		<p:template name="formulate-api-request">
			<p:input port="template">
				<p:inline>
					<c:request detailed="true" method="get" href="{$config:api-base-uri}/object/{substring-after(/c:request/@href, '/object/')}" override-content-type="text/plain">
						<c:header name="accept" value="application/ld+json"/>
						<c:header name="apikey" value="{$config:apikey}"/>
					</c:request>
				</p:inline>
			</p:input>
		</p:template>
		<p:http-request name="make-api-call"/>
		<p:xslt>
			<p:input port="parameters"><p:empty/></p:input>
			<p:input port="stylesheet">
				<p:document href="../xslt/object.xsl"/>
			</p:input>
		</p:xslt>
		<z:make-http-response/>
	</p:declare-step>
	
</p:declare-step>
