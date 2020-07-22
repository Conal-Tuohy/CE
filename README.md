# CE
A "Collection Explorer" website for browsing the collection of the National Museum of Australia, based on their Collection API

## Installation
* Install Apache Tomcat.
* Clone this repository to a local folder, e.g. `/etc/xproc-z/CE`
* Install XProc-Z by downloading the latest release of `xproc-z.war` file from https://github.com/Conal-Tuohy/XProc-Z/releases e.g. to `/etc/xproc-z/xproc-z.war`, and configure it by creating a Tomcat "context" file e.g. in `/var/lib/tomcat8/conf/Catalina/localhost/ce.xml`:

```xml
<Context path="/ce"
    docBase="/etc/xproc-z/xproc-z.war"
    preemptiveAuthentication="true"
    antiResourceLocking="false">
  <Valve className="org.apache.catalina.authenticator.BasicAuthenticator" />
  <Parameter name="xproc-z.main" value="/etc/xproc-z/CE/xproc/xproc-z.xpl" override="false"/>
  <!-- to avoid performance being throttled by the API, request an API key from the NMA website, and specify the key here -->
  <Parameter name="apikey" value="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" override="false"/>
  <!-- specify the base URI of the Collection API, e.g. "https://data.nma.gov.au/" -->
  <Parameter name="api-base-uri" value="http://localhost/" override="false"/>
</Context>
```

The CE website will then be available at the base URI "/ce"
