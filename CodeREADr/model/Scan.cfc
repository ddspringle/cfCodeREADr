<!--- Scan Model                                                                              --->
<!--- ==========                                                                              --->
<!---                                                                                         --->
<!--- Written by Denard Springle (denard.springle@gmail.com) of Virtual Solutions Group, LLC  --->
<!--- http://www.vsgcom.net/. This work is licensed under a Creative Commons                  --->
<!--- Attribution-ShareAlike 3.0 Unported License.                                            --->
<!---                                                                                         --->
<!--- Source code available on GitHub:                                                        --->
<!--- https://github.com/ddspringle/cfCodeREADr                                               --->
<!---                                                                                         --->

<cfcomponent displayname="Scan" output="false" hint="http://help.codereadr.com/help/kb/developer-api/api-scans">
<cfproperty name="scanId" type="string" default="" />
<cfproperty name="keyword" type="string" default="" />
<cfproperty name="serviceId" type="string" default="" />
<cfproperty name="deviceId" type="string" default="" />
<cfproperty name="userId" type="string" default="" />
<cfproperty name="status" type="string" default="" />
<cfproperty name="startDate" type="string" default="" />
<cfproperty name="startTime" type="string" default="" />
<cfproperty name="endDate" type="string" default="" />
<cfproperty name="endTime" type="string" default="" />
<cfproperty name="uploadId" type="string" default="" />
<cfproperty name="orderBy" type="string" default="" />
<cfproperty name="isDescOrder" type="string" default="" />
<cfproperty name="limit" type="string" default="" />
<cfproperty name="offset" type="string" default="" />
<cfproperty name="barcode" type="string" default="" />
<cfproperty name="result" type="string" default="" />
<cfproperty name="timestamp" type="string" default="" />
<cfproperty name="answerQidList" type="string" default="" />
<cfproperty name="answerList" type="string" default="" />

<!--- pseudo-contructor --->
<cfset variables.instance = {
			scanId = '',
			keyword = '',
			serviceId = '',
			deviceId = '',
			userId = '',
			status = '',
			startDate = '',
			startTime = '',
			endDate = '',
			endTime = '',
			uploadId = '',
			orderBy = '',
			isDescOrder = '',
			limit = '',
			offset = '',
			barcode = '',
			result = '',
			timestamp = '',
			answerQidList = '',
			answerList = ''
	} />
<cffunction name="init" access="public" output="false" returntype="any" hint="">
  <cfargument name="scanId" type="string" required="true" default="" hint="" />
  <cfargument name="keyword" type="string" required="true" default="" hint="" />
  <cfargument name="serviceId" type="string" required="true" default="" hint="" />
  <cfargument name="deviceId" type="string" required="true" default="" hint="" />
  <cfargument name="userId" type="string" required="true" default="" hint="" />
  <cfargument name="status" type="string" required="true" default="" hint="" />
  <cfargument name="StartDate" type="string" required="true" default="" hint="" />
  <cfargument name="StartTime" type="string" required="true" default="" hint="" />
  <cfargument name="EndDate" type="string" required="true" default="" hint="" />
  <cfargument name="EndTime" type="string" required="true" default="" hint="" />
  <cfargument name="uploadId" type="string" required="true" default="" hint="" />
  <cfargument name="orderBy" type="string" required="true" default="" hint="" />
  <cfargument name="isDescOrder" type="string" required="true" default="" hint="" />
  <cfargument name="limit" type="string" required="true" default="" hint="" />
  <cfargument name="offset" type="string" required="true" default="" hint="" />
  <cfargument name="barcode" type="string" required="true" default="" hint="" />
  <cfargument name="result" type="string" required="true" default="" hint="" />
  <cfargument name="timestamp" type="string" required="true" default="" hint="" />
  <cfargument name="answerQidList" type="string" required="true" default="" hint="" />
  <cfargument name="answerList" type="string" required="true" default="" hint="" />
  
  <!--- set the initial values of the bean --->
  <cfscript>
  	setScanId(ARGUMENTS.scanId);
  	setKeyword(ARGUMENTS.keyword);
  	setServiceId(ARGUMENTS.serviceId);
	setDeviceId(ARGUMENTS.deviceId);
	setUserId(ARGUMENTS.userId);
	setStatus(ARGUMENTS.status);
  	setStartDate(ARGUMENTS.startDate);
  	setStartTime(ARGUMENTS.startTime);
  	setEndDate(ARGUMENTS.endDate);
  	setEndTime(ARGUMENTS.endTime);
	setUploadId(ARGUMENTS.uploadId);
  	setOrderBy(ARGUMENTS.orderBy);
	setIsDescOrder(ARGUMENTS.isDescOrder);
	setLimit(ARGUMENTS.limit);
	setOffset(ARGUMENTS.offset);
	setBarcode(ARGUMENTS.barcode);
	setResult(ARGUMENTS.result);
	setTimestamp(ARGUMENTS.timestamp);
	setAnswerQidList(ARGUMENTS.answerQidList);
	setAnswerList(ARGUMENTS.answerList);
  </cfscript>
  <cfreturn this>
</cffunction>

<!--- setters --->
<cffunction name="setScanId" access="public" output="false" hint="">
  <cfargument name="scanId" type="string" required="true" default="" hint="" />
  <cfset variables.instance.scanId = ARGUMENTS.scanId />
</cffunction>

<cffunction name="setKeyword" access="public" output="false" hint="">
  <cfargument name="keyword" type="string" required="true" default="" hint="" />
  <cfset variables.instance.keyword = ARGUMENTS.keyword />
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

<cffunction name="setStartDate" access="public" output="false" hint="">
  <cfargument name="startDate" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.startDate = ARGUMENTS.startDate />
</cffunction>

<cffunction name="setStartTime" access="public" output="false" hint="">
  <cfargument name="startTime" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.startTime = ARGUMENTS.startTime />
</cffunction>

<cffunction name="setEndDate" access="public" output="false" hint="">
  <cfargument name="endDate" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.endDate = ARGUMENTS.endDate />
</cffunction>

<cffunction name="setEndTime" access="public" output="false" hint="">
  <cfargument name="endTime" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.endTime = ARGUMENTS.endTime />
</cffunction>

<cffunction name="setUploadId" access="public" output="false" hint="">
  <cfargument name="uploadId" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.uploadId = ARGUMENTS.uploadId />
</cffunction>

<cffunction name="setOrderBy" access="public" output="false" hint="">
  <cfargument name="orderBy" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.orderBy = ARGUMENTS.orderBy />
</cffunction>

<cffunction name="setIsDescOrder" access="public" output="false" hint="">
  <cfargument name="isDescOrder" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.isDescOrder = ARGUMENTS.isDescOrder />
</cffunction>

<cffunction name="setLimit" access="public" output="false" hint="">
  <cfargument name="limit" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.limit = ARGUMENTS.limit />
</cffunction>

<cffunction name="setOffset" access="public" output="false" hint="">
  <cfargument name="offset" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.offset = ARGUMENTS.offset />
</cffunction>

<cffunction name="setBarcode" access="public" output="false" hint="">
  <cfargument name="barcode" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.barcode = ARGUMENTS.barcode />
</cffunction>

<cffunction name="setResult" access="public" output="false" hint="">
  <cfargument name="result" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.result = ARGUMENTS.result />
</cffunction>

<cffunction name="setTimestamp" access="public" output="false" hint="">
  <cfargument name="timestamp" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.timestamp = ARGUMENTS.timestamp />
</cffunction>

<cffunction name="setAnswerQidList" access="public" output="false" hint="">
  <cfargument name="answerQidList" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.answerQidList = ARGUMENTS.answerQidList />
</cffunction>

<cffunction name="setAnswerList" access="public" output="false" hint="">
  <cfargument name="answerList" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.answerList = ARGUMENTS.answerList />
</cffunction>

<!--- getters --->
<cffunction name="getScanId" access="public" output="false" hint="">
  <cfreturn variables.instance.scanId />
</cffunction>

<cffunction name="getKeyword" access="public" output="false" hint="">
  <cfreturn variables.instance.keyword />
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

<cffunction name="getStartDate" access="public" output="false" hint="">
 	<cfreturn variables.instance.atartDate />
</cffunction>

<cffunction name="getStartTime" access="public" output="false" hint="">
 	<cfreturn variables.instance.atartTime />
</cffunction>

<cffunction name="getEndDate" access="public" output="false" hint="">
 	<cfreturn variables.instance.endDate />
</cffunction>

<cffunction name="getEndTime" access="public" output="false" hint="">
 	<cfreturn variables.instance.endTime />
</cffunction>

<cffunction name="getUploadId" access="public" output="false" hint="">
  <cfreturn variables.instance.uploadId />
</cffunction>

<cffunction name="getOrderBy" access="public" output="false" hint="">
 	<cfreturn variables.instance.orderBy />
</cffunction>

<cffunction name="getIsDescOrder" access="public" output="false" hint="">
 	<cfreturn variables.instance.isDescOrder />
</cffunction>

<cffunction name="getLimit" access="public" output="false" hint="">
 	<cfreturn variables.instance.limit />
</cffunction>

<cffunction name="getOffset" access="public" output="false" hint="">
 	<cfreturn variables.instance.offset />
</cffunction>

<cffunction name="getBarcode" access="public" output="false" hint="">
 	<cfreturn variables.instance.barcode />
</cffunction>

<cffunction name="getResult" access="public" output="false" hint="">
 	<cfreturn variables.instance.result />
</cffunction>

<cffunction name="getTimestamp" access="public" output="false" hint="">
 	<cfreturn variables.instance.timestamp />
</cffunction>

<cffunction name="getAnswerQidList" access="public" output="false" hint="">
 	<cfreturn variables.instance.answerQidList />
</cffunction>

<cffunction name="getAnswerList" access="public" output="false" hint="">
 	<cfreturn variables.instance.answerList />
</cffunction>

<!--- utility methods --->
<cffunction name="getMemento" access="public" output="false" hint="">
   <cfreturn variables.instance />
</cffunction>

</cfcomponent>