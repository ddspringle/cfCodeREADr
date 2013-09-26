<!--- Database Model                                                                          --->
<!--- ==============                                                                          --->
<!---                                                                                         --->
<!--- Written by Denard Springle (denard.springle@gmail.com) of Virtual Solutions Group, LLC  --->
<!--- http://www.vsgcom.net/. This work is licensed under a Creative Commons                  --->
<!--- Attribution-ShareAlike 3.0 Unported License.                                            --->
<!---                                                                                         --->
<!--- Source code available on GitHub:                                                        --->
<!--- https://github.com/ddspringle/cfCodeREADr                                               --->
<!---                                                                                         --->

<cfcomponent displayname="Database" output="false" hint="">
<cfproperty name="databaseId" type="string" default="" />
<cfproperty name="databaseName" type="string" default="" />
<cfproperty name="recordCount" type="string" default="" />
<cfproperty name="serviceIdList" type="string" default="" />
<cfproperty name="caseSensitivity" type="string" default="" />

<!--- pseudo-contructor --->
<cfset variables.instance = {
			databaseId = '',
			databaseName = '',
			recordCount = '',
			serviceIdList = '',
			caseSensitivity = ''
	} />
<cffunction name="init" access="public" output="false" returntype="any" hint="">
  <cfargument name="databaseId" type="string" required="true" default="" hint="" />
  <cfargument name="databaseName" type="string" required="true" default="" hint="" />
  <cfargument name="recordCount" type="string" required="true" default="" hint="" />
  <cfargument name="limit" type="string" required="true" default="" hint="" />
  <cfargument name="serviceIdList" type="string" required="true" default="" hint="" />
  <cfargument name="caseSensitivity" type="string" required="true" default="" hint="" />
  
  <!--- set the initial values of the bean --->
  <cfscript>
  	setDatabaseId(ARGUMENTS.databaseId);
  	setDatabaseName(ARGUMENTS.databaseName);
  	setRecordCount(ARGUMENTS.recordCount);
	setServiceIdList(ARGUMENTS.serviceIdList);
	setCaseSensitivity(ARGUMENTS.caseSensitivity);
  </cfscript>
  <cfreturn this>
</cffunction>

<!--- setters --->
<cffunction name="setDatabaseId" access="public" output="false" hint="">
  <cfargument name="databaseId" type="string" required="true" default="" hint="" />
  <cfset variables.instance.databaseId = ARGUMENTS.databaseId />
</cffunction>

<cffunction name="setDatabaseName" access="public" output="false" hint="">
  <cfargument name="databaseName" type="string" required="true" default="" hint="" />
  <cfset variables.instance.databaseName = ARGUMENTS.databaseName />
</cffunction>

<cffunction name="setRecordCount" access="public" output="false" hint="">
  <cfargument name="recordCount" type="string" required="true" default="" hint="" />
  <cfset variables.instance.recordCount = ARGUMENTS.recordCount />
</cffunction>

<cffunction name="setServiceIdList" access="public" output="false" hint="">
  <cfargument name="serviceIdList" type="string" required="true" default="" hint="" />  
  	<cfset variables.instance.serviceIdList = ARGUMENTS.serviceIdList />
</cffunction>

<cffunction name="setCaseSensitivity" access="public" output="false" hint="">
  <cfargument name="caseSensitivity" type="string" required="true" default="" hint="" />
  	<cfset variables.instance.caseSensitivity = ARGUMENTS.caseSensitivity />
</cffunction>

<!--- getters --->
<cffunction name="getDatabaseId" access="public" output="false" hint="">
  <cfreturn variables.instance.databaseId />
</cffunction>

<cffunction name="getDatabaseName" access="public" output="false" hint="">
  <cfreturn variables.instance.databaseName />
</cffunction>

<cffunction name="getRecordCount" access="public" output="false" hint="">
  <cfreturn variables.instance.recordCount />
</cffunction>

<cffunction name="getServiceIdList" access="public" output="false" hint="">
    <cfreturn variables.instance.serviceIdList />
</cffunction>

<cffunction name="getCaseSensitivity" access="public" output="false" hint="">
    <cfreturn variables.instance.caseSensitivity />
</cffunction>

<!--- utility methods --->
<cffunction name="getMemento" access="public" output="false" hint="">
   <cfreturn variables.instance />
</cffunction>

</cfcomponent>