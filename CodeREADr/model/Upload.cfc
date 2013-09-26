<!--- Upload Model                                                                            --->
<!--- ============                                                                            --->
<!---                                                                                         --->
<!--- Written by Denard Springle (denard.springle@gmail.com) of Virtual Solutions Group, LLC  --->
<!--- http://www.vsgcom.net/. This work is licensed under a Creative Commons                  --->
<!--- Attribution-ShareAlike 3.0 Unported License.                                            --->
<!---                                                                                         --->
<!--- Source code available on GitHub:                                                        --->
<!--- https://github.com/ddspringle/cfCodeREADr                                               --->
<!---                                                                                         --->

<cfcomponent displayname="Upload" output="false" hint="http://help.codereadr.com/help/kb/developer-api/api-uploads">
<cfproperty name="uploadId" type="string" default="" />
<cfproperty name="serviceId" type="string" default="" />
<cfproperty name="deviceId" type="string" default="" />
<cfproperty name="userId" type="string" default="" />
<cfproperty name="status" type="string" default="" />
<cfproperty name="limit" type="string" default="" />
<cfproperty name="offset" type="string" default="" />
<cfproperty name="count" type="string" default="" />
<cfproperty name="timestamp" type="string" default="" />

<!--- pseudo-contructor --->
<cfset variables.instance = {
			uploadId = '',
			serviceId = '',
			deviceId = '',
			userId = '',
			status = '',
			limit = '',
			offset = '',
			count = '',
			timestamp = ''
	} />
    
<cffunction name="init" access="public" output="false" returntype="any" hint="">
  <cfargument name="uploadId" type="string" required="true" default="" hint="" />
  <cfargument name="serviceId" type="string" required="true" default="" hint="" />
  <cfargument name="deviceId" type="string" required="true" default="" hint="" />
  <cfargument name="userId" type="string" required="true" default="" hint="" />
  <cfargument name="status" type="string" required="true" default="" hint="" />
  <cfargument name="limit" type="string" required="true" default="" hint="" />
  <cfargument name="offset" type="string" required="true" default="" hint="" />
  <cfargument name="count" type="string" required="true" default="" hint="" />
  <cfargument name="timestamp" type="string" required="true" default="" hint="" />
  
  <!--- set the initial values of the bean --->
  <cfscript>
  	setUploadId(ARGUMENTS.uploadId);
  	setServiceId(ARGUMENTS.serviceId);
	setDeviceId(ARGUMENTS.deviceId);
	setUserId(ARGUMENTS.userId);
	setStatus(ARGUMENTS.status);
	setLimit(ARGUMENTS.limit);
	setOffset(ARGUMENTS.offset);
	setCount(ARGUMENTS.count);
	setTimestamp(ARGUMENTS.timestamp);
  </cfscript>
  <cfreturn this>
</cffunction>

<!--- setters --->
<cffunction name="setUploadId" access="public" output="false" hint="">
  <cfargument name="uploadId" type="string" required="true" default="" hint="" />
  <cfset variables.instance.uploadId = ARGUMENTS.uploadId />
</cffunction>

<cffunction name="setServiceId" access="public" output="false" hint="">
  <cfargument name="serviceId" type="string" required="true" default="" hint="" />
  <cfset variables.instance.serviceId = ARGUMENTS.serviceId />
</cffunction>

<cffunction name="setDeviceId" access="public" output="false" hint="">
  <cfargument name="deviceId" type="string" required="true" default="" hint="" />
  	<cfset variables.instance.deviceId = ARGUMENTS.deviceId />
</cffunction>

<cffunction name="setUserId" access="public" output="false" hint="">
  <cfargument name="userId" type="string" required="true" default="" hint="" />  
  	<cfset variables.instance.userId = ARGUMENTS.userId />
</cffunction>

<cffunction name="setStatus" access="public" output="false" hint="">
  <cfargument name="status" type="string" required="true" default="" hint="" />
  	<cfset variables.instance.status = ARGUMENTS.status />
</cffunction>

<cffunction name="setLimit" access="public" output="false" hint="">
  <cfargument name="limit" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.limit = ARGUMENTS.limit />
</cffunction>

<cffunction name="setOffset" access="public" output="false" hint="">
  <cfargument name="offset" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.offset = ARGUMENTS.offset />
</cffunction>

<cffunction name="setCount" access="public" output="false" hint="">
  <cfargument name="count" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.count = ARGUMENTS.count />
</cffunction>

<cffunction name="setTimestamp" access="public" output="false" hint="">
  <cfargument name="timestamp" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.timestamp = ARGUMENTS.timestamp />
</cffunction>

<!--- getters --->
<cffunction name="getUploadId" access="public" output="false" hint="">
  <cfreturn variables.instance.uploadId />
</cffunction>

<cffunction name="getServiceId" access="public" output="false" hint="">
  <cfreturn variables.instance.serviceId />
</cffunction>

<cffunction name="getDeviceId" access="public" output="false" hint="">
  	<cfreturn variables.instance.deviceId />
</cffunction>

<cffunction name="getUserId" access="public" output="false" hint="">
    <cfreturn variables.instance.userId />
</cffunction>

<cffunction name="getStatus" access="public" output="false" hint="">
    <cfreturn variables.instance.status />
</cffunction>

<cffunction name="getLimit" access="public" output="false" hint="">
 	<cfreturn variables.instance.limit />
</cffunction>

<cffunction name="getOffset" access="public" output="false" hint="">
 	<cfreturn variables.instance.offset />
</cffunction>

<cffunction name="getCount" access="public" output="false" hint="">
 	<cfreturn variables.instance.count />
</cffunction>

<cffunction name="getTimestamp" access="public" output="false" hint="">
 	<cfreturn variables.instance.timestamp />
</cffunction>

<!--- utility methods --->
<cffunction name="getMemento" access="public" output="false" hint="">
   <cfreturn variables.instance />
</cffunction>

</cfcomponent>