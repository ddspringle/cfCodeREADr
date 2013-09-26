<!--- Service Model                                                                           --->
<!--- =============                                                                           --->
<!---                                                                                         --->
<!--- Written by Denard Springle (denard.springle@gmail.com) of Virtual Solutions Group, LLC  --->
<!--- http://www.vsgcom.net/. This work is licensed under a Creative Commons                  --->
<!--- Attribution-ShareAlike 3.0 Unported License.                                            --->
<!---                                                                                         --->
<!--- Source code available on GitHub:                                                        --->
<!--- https://github.com/ddspringle/cfCodeREADr                                               --->
<!---                                                                                         --->

<cfcomponent displayname="Service" output="false" hint="http://help.codereadr.com/help/kb/developer-api/api-services">
<cfproperty name="serviceId" type="string" default="" />
<cfproperty name="validationMethod" type="string" default="" />
<cfproperty name="databaseId" type="string" default="" />
<cfproperty name="postbackURL" type="string" default="" />
<cfproperty name="serviceName" type="string" default="" />
<cfproperty name="description" type="string" default="" />
<cfproperty name="duplicateScanValue" type="string" default="" />
<cfproperty name="periodStartDate" type="string" default="" />
<cfproperty name="periodStartTime" type="string" default="" />
<cfproperty name="periodEndDate" type="string" default="" />
<cfproperty name="periodEndTime" type="string" default="" />
<cfproperty name="uploadEmail" type="string" default="" />
<cfproperty name="viewOtherScans" type="string" default="" />
<cfproperty name="userIdList" type="string" default="" />
<cfproperty name="questionIdList" type="string" default="" />

<!--- pseudo-contructor --->
<cfset variables.instance = {
			serviceId = '',
			validationMethod = '',
			databaseId = '',
			postbackURL = '',
			serviceName = '',
			description = '',
			duplicateScanValue = '',
			periodStartDate = '',
			periodStartTime = '',
			periodEndDate = '',
			periodEndTime = '',
			uploadEmail = '',
			viewOtherScans = '',
			userIdList = '',
			questionIdList = ''
	} />
<cffunction name="init" access="public" output="false" returntype="any" hint="">
  <cfargument name="serviceId" type="string" required="true" default="" hint="" />
  <cfargument name="validationMethod" type="string" required="true" default="" hint="" />
  <cfargument name="databaseId" type="string" required="true" default="" hint="" />
  <cfargument name="postbackURL" type="string" required="true" default="" hint="" />
  <cfargument name="serviceName" type="string" required="true" default="" hint="" />
  <cfargument name="description" type="string" required="true" default="" hint="" />
  <cfargument name="duplicateScanValue" type="string" required="true" default="" hint="" />
  <cfargument name="periodStartDate" type="string" required="true" default="" hint="" />
  <cfargument name="periodStartTime" type="string" required="true" default="" hint="" />
  <cfargument name="periodEndDate" type="string" required="true" default="" hint="" />
  <cfargument name="periodEndTime" type="string" required="true" default="" hint="" />
  <cfargument name="uploadEmail" type="string" required="true" default="" hint="" />
  <cfargument name="viewOtherScans" type="string" required="true" default="" hint="" />
  <cfargument name="userIdList" type="string" required="true" default="" hint="" />
  <cfargument name="questionIdList" type="string" required="true" default="" hint="" />
  
  <!--- set the initial values of the bean --->
  <cfscript>
  	setServiceId(ARGUMENTS.serviceId);
  	setValidationMethod(ARGUMENTS.validationMethod);
  	setDatabaseId(ARGUMENTS.databaseId);
	setPostbackURL(ARGUMENTS.postbackURL);
	setServiceName(ARGUMENTS.serviceName);
	setDescription(ARGUMENTS.description);
	setDuplicateScanValue(ARGUMENTS.duplicateScanValue);
  	setPeriodStartDate(ARGUMENTS.periodStartDate);
  	setPeriodStartTime(ARGUMENTS.periodStartTime);
  	setPeriodEndDate(ARGUMENTS.periodEndDate);
  	setPeriodEndTime(ARGUMENTS.periodEndTime);
  	setUploadEmail(ARGUMENTS.uploadEmail);
	setViewOtherScans(ARGUMENTS.viewOtherScans);
	setUserIdList(ARGUMENTS.userIdList);
	setQuestionIdList(ARGUMENTS.questionIdList);
  </cfscript>
  <cfreturn this>
</cffunction>

<!--- setters --->
<cffunction name="setServiceId" access="public" output="false" hint="">
  <cfargument name="serviceId" type="string" required="true" default="" hint="" />
  <cfset variables.instance.serviceId = ARGUMENTS.serviceId />
</cffunction>

<cffunction name="setValidationMethod" access="public" output="false" hint="">
  <cfargument name="validationMethod" type="string" required="true" default="" hint="" />
  <cfset variables.instance.validationMethod = ARGUMENTS.validationMethod />
</cffunction>

<cffunction name="setDatabaseId" access="public" output="false" hint="">
  <cfargument name="databaseId" type="string" required="true" default="" hint="" />
  <cfset variables.instance.databaseId = ARGUMENTS.databaseId />
</cffunction>

<cffunction name="setPostbackURL" access="public" output="false" hint="">
  <cfargument name="postbackURL" type="string" required="true" default="" hint="" />
  	<cfset variables.instance.postbackURL = ARGUMENTS.postbackURL />
</cffunction>

<cffunction name="setServiceName" access="public" output="false" hint="">
  <cfargument name="serviceName" type="string" required="true" default="" hint="" />  
  	<cfset variables.instance.serviceName = ARGUMENTS.serviceName />
</cffunction>

<cffunction name="setDescription" access="public" output="false" hint="">
  <cfargument name="description" type="string" required="true" default="" hint="" />
  	<cfset variables.instance.description = ARGUMENTS.description />
</cffunction>

<cffunction name="setDuplicateScanValue" access="public" output="false" hint="">
  <cfargument name="duplicateScanValue" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.duplicateScanValue = ARGUMENTS.duplicateScanValue />
</cffunction>

<cffunction name="setPeriodStartDate" access="public" output="false" hint="">
  <cfargument name="periodStartDate" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.periodStartDate = ARGUMENTS.periodStartDate />
</cffunction>

<cffunction name="setPeriodStartTime" access="public" output="false" hint="">
  <cfargument name="periodStartTime" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.periodStartTime = ARGUMENTS.periodStartTime />
</cffunction>

<cffunction name="setPeriodEndDate" access="public" output="false" hint="">
  <cfargument name="periodEndDate" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.periodEndDate = ARGUMENTS.periodEndDate />
</cffunction>

<cffunction name="setPeriodEndTime" access="public" output="false" hint="">
  <cfargument name="periodEndTime" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.periodEndTime = ARGUMENTS.periodEndTime />
</cffunction>

<cffunction name="setUploadEmail" access="public" output="false" hint="">
  <cfargument name="uploadEmail" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.uploadEmail = ARGUMENTS.uploadEmail />
</cffunction>

<cffunction name="setViewOtherScans" access="public" output="false" hint="">
  <cfargument name="viewOtherScans" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.viewOtherScans = ARGUMENTS.viewOtherScans />
</cffunction>

<cffunction name="setUserIdList" access="public" output="false" hint="">
  <cfargument name="userIdList" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.userIdList = ARGUMENTS.userIdList />
</cffunction>

<cffunction name="setQuestionIdList" access="public" output="false" hint="">
  <cfargument name="questionIdList" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.questionIdList = ARGUMENTS.questionIdList />
</cffunction>

<!--- getters --->
<cffunction name="getServiceId" access="public" output="false" hint="">
  <cfreturn variables.instance.serviceId />
</cffunction>

<cffunction name="getValidationMethod" access="public" output="false" hint="">
  <cfreturn variables.instance.validationMethod />
</cffunction>

<cffunction name="getDatabaseId" access="public" output="false" hint="">
  <cfreturn variables.instance.databaseId />
</cffunction>

<cffunction name="getPostbackURL" access="public" output="false" hint="">
  	<cfreturn variables.instance.postbackURL />
</cffunction>

<cffunction name="getServiceName" access="public" output="false" hint="">
    <cfreturn variables.instance.serviceName />
</cffunction>

<cffunction name="getDescription" access="public" output="false" hint="">
    <cfreturn variables.instance.description />
</cffunction>

<cffunction name="getDuplicateScanValue" access="public" output="false" hint="">
  <cfreturn variables.instance.duplicateScanValue />
</cffunction>

<cffunction name="getPeriodStartDate" access="public" output="false" hint="">
 	<cfreturn variables.instance.periodStartDate />
</cffunction>

<cffunction name="getPeriodStartTime" access="public" output="false" hint="">
 	<cfreturn variables.instance.periodStartTime />
</cffunction>

<cffunction name="getPeriodEndDate" access="public" output="false" hint="">
 	<cfreturn variables.instance.periodEndDate />
</cffunction>

<cffunction name="getPeriodEndTime" access="public" output="false" hint="">
 	<cfreturn variables.instance.periodEndTime />
</cffunction>

<cffunction name="getUploadEmail" access="public" output="false" hint="">
 	<cfreturn variables.instance.uploadEmail />
</cffunction>

<cffunction name="getViewOtherScans" access="public" output="false" hint="">
 	<cfreturn variables.instance.viewOtherScans />
</cffunction>

<cffunction name="getUserIdList" access="public" output="false" hint="">
 	<cfreturn variables.instance.userIdList />
</cffunction>

<cffunction name="getQuestionIdList" access="public" output="false" hint="">
 	<cfreturn variables.instance.questionIdList />
</cffunction>

<!--- utility methods --->
<cffunction name="getMemento" access="public" output="false" hint="">
   <cfreturn variables.instance />
</cffunction>

</cfcomponent>