<!--- Device Model                                                                            --->
<!--- ============                                                                            --->
<!---                                                                                         --->
<!--- Written by Denard Springle (denard.springle@gmail.com) of Virtual Solutions Group, LLC  --->
<!--- http://www.vsgcom.net/. This work is licensed under a Creative Commons                  --->
<!--- Attribution-ShareAlike 3.0 Unported License.                                            --->
<!---                                                                                         --->
<!--- Source code available on GitHub:                                                        --->
<!--- https://github.com/ddspringle/cfCodeREADr                                               --->
<!---                                                                                         --->

<cfcomponent displayname="Device" output="false" hint="">
<cfproperty name="deviceId" type="string" default="" />
<cfproperty name="uniqueDeviceId" type="string" default="" />
<cfproperty name="deviceName" type="string" default="" />
<cfproperty name="createdOn" type="string" default="" />

<!--- pseudo-contructor --->
<cfset variables.instance = {
			deviceId = '',
			uniqueDeviceId = '',
			deviceName = '',
			createdOn = ''
	} />
<cffunction name="init" access="public" output="false" returntype="any" hint="">
  <cfargument name="deviceId" type="string" required="true" default="" hint="" />
  <cfargument name="uniqueDeviceId" type="string" required="true" default="" hint="" />
  <cfargument name="deviceName" type="string" required="true" default="" hint="" />
  <cfargument name="createdOn" type="string" required="true" default="" hint="" />
  
  <!--- set the initial values of the bean --->
  <cfscript>
  	setDeviceId(ARGUMENTS.deviceId);
  	setUniqueDeviceId(ARGUMENTS.uniqueDeviceId);
  	setDeviceName(ARGUMENTS.deviceName);
	setCreatedOn(ARGUMENTS.createOn);
  </cfscript>
  <cfreturn this>
</cffunction>

<!--- setters --->
<cffunction name="setDeviceId" access="public" output="false" hint="">
  <cfargument name="deviceId" type="string" required="true" default="" hint="" />
  <cfset variables.instance.deviceId = ARGUMENTS.deviceId />
</cffunction>

<cffunction name="setUniqueDeviceId" access="public" output="false" hint="">
  <cfargument name="uniqueDeviceId" type="string" required="true" default="" hint="" />
  <cfset variables.instance.uniqueDeviceId = ARGUMENTS.uniqueDeviceId />
</cffunction>

<cffunction name="setDeviceName" access="public" output="false" hint="">
  <cfargument name="deviceName" type="string" required="true" default="" hint="" />
  <cfset variables.instance.deviceName = ARGUMENTS.deviceName />
</cffunction>

<cffunction name="setCreatedOn" access="public" output="false" hint="">
  <cfargument name="createdOn" type="string" required="true" default="" hint="" />
  	<cfset variables.instance.createdOn = ARGUMENTS.createdOn />
</cffunction>

<!--- getters --->
<cffunction name="getDeviceId" access="public" output="false" hint="">
  <cfreturn variables.instance.deviceId />
</cffunction>

<cffunction name="getUniqueDeviceId" access="public" output="false" hint="">
  <cfreturn variables.instance.uniqueDeviceId />
</cffunction>

<cffunction name="getDeviceName" access="public" output="false" hint="">
  <cfreturn variables.instance.deviceName />
</cffunction>

<cffunction name="getCreatedOn" access="public" output="false" hint="">
    <cfreturn variables.instance.createdOn />
</cffunction>

<!--- utility methods --->
<cffunction name="getMemento" access="public" output="false" hint="">
   <cfreturn variables.instance />
</cffunction>

</cfcomponent>