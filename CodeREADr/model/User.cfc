<!--- User Model                                                                              --->
<!--- ==========                                                                              --->
<!---                                                                                         --->
<!--- Written by Denard Springle (denard.springle@gmail.com) of Virtual Solutions Group, LLC  --->
<!--- http://www.vsgcom.net/. This work is licensed under a Creative Commons                  --->
<!--- Attribution-ShareAlike 3.0 Unported License.                                            --->
<!---                                                                                         --->
<!--- Source code available on GitHub:                                                        --->
<!--- https://github.com/ddspringle/cfCodeREADr                                               --->
<!---                                                                                         --->

<cfcomponent displayname="User" output="false" hint="">
<cfproperty name="userId" type="string" default="" />
<cfproperty name="username" type="string" default="" />
<cfproperty name="password" type="string" default="" />
<cfproperty name="limit" type="string" default="" />
<cfproperty name="serviceIdList" type="string" default="" />
<cfproperty name="createdOn" type="string" default="" />

<!--- pseudo-contructor --->
<cfset variables.instance = {
			userId = '',
			username = '',
			password = '',
			limit = '',
			serviceIdList = '',
			createdOn = ''
	} />
<cffunction name="init" access="public" output="false" returntype="any" hint="">
  <cfargument name="userId" type="string" required="true" default="" hint="" />
  <cfargument name="username" type="string" required="true" default="" hint="" />
  <cfargument name="password" type="string" required="true" default="" hint="" />
  <cfargument name="limit" type="string" required="true" default="" hint="" />
  <cfargument name="serviceIdList" type="string" required="true" default="" hint="" />
  <cfargument name="createdOn" type="string" required="true" default="" hint="" />
  
  <!--- set the initial values of the bean --->
  <cfscript>
  	setUserId(ARGUMENTS.userId);
  	setUsername(ARGUMENTS.username);
  	setPassword(ARGUMENTS.password);
	setLimit(ARGUMENTS.limit);
	setServiceIdList(ARGUMENTS.serviceIdList);
	setCreatedOn(ARGUMENTS.createdOn);
  </cfscript>
  <cfreturn this>
</cffunction>

<!--- setters --->
<cffunction name="setUserId" access="public" output="false" hint="">
  <cfargument name="userId" type="string" required="true" default="" hint="" />
  <cfset variables.instance.userId = ARGUMENTS.userId />
</cffunction>

<cffunction name="setUsername" access="public" output="false" hint="">
  <cfargument name="username" type="string" required="true" default="" hint="" />
  <cfset variables.instance.username = ARGUMENTS.username />
</cffunction>

<cffunction name="setPassword" access="public" output="false" hint="">
  <cfargument name="password" type="string" required="true" default="" hint="" />
  <cfset variables.instance.password = ARGUMENTS.password />
</cffunction>

<cffunction name="setLimit" access="public" output="false" hint="">
  <cfargument name="limit" type="string" required="true" default="" hint="" />
  	<cfset variables.instance.limit = ARGUMENTS.limit />
</cffunction>

<cffunction name="setServiceIdList" access="public" output="false" hint="">
  <cfargument name="serviceIdList" type="string" required="true" default="" hint="" />  
  	<cfset variables.instance.serviceIdList = ARGUMENTS.serviceIdList />
</cffunction>

<cffunction name="setCreatedOn" access="public" output="false" hint="">
  <cfargument name="createdOn" type="string" required="true" default="" hint="" />
  	<cfset variables.instance.createdOn = ARGUMENTS.createdOn />
</cffunction>

<!--- getters --->
<cffunction name="getUserId" access="public" output="false" hint="">
  <cfreturn variables.instance.userId />
</cffunction>

<cffunction name="getUsername" access="public" output="false" hint="">
  <cfreturn variables.instance.username />
</cffunction>

<cffunction name="getPassword" access="public" output="false" hint="">
  <cfreturn variables.instance.password />
</cffunction>

<cffunction name="getLimit" access="public" output="false" hint="">
  	<cfreturn variables.instance.limit />
</cffunction>

<cffunction name="getServiceIdList" access="public" output="false" hint="">
    <cfreturn variables.instance.serviceIdList />
</cffunction>

<cffunction name="getCreatedOn" access="public" output="false" hint="">
    <cfreturn variables.instance.createdOn />
</cffunction>

<!--- utility methods --->
<cffunction name="getMemento" access="public" output="false" hint="">
   <cfreturn variables.instance />
</cffunction>

</cfcomponent>