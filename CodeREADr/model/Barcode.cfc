<!--- Barcode Model                                                                           --->
<!--- =============                                                                           --->
<!---                                                                                         --->
<!--- Written by Denard Springle (denard.springle@gmail.com) of Virtual Solutions Group, LLC  --->
<!--- http://www.vsgcom.net/. This work is licensed under a Creative Commons                  --->
<!--- Attribution-ShareAlike 3.0 Unported License.                                            --->
<!---                                                                                         --->
<!--- Source code available on GitHub:                                                        --->
<!--- https://github.com/ddspringle/cfCodeREADr                                               --->
<!---                                                                                         --->

<cfcomponent displayname="Barcode" output="false" hint="">
<cfproperty name="barcodeValue" type="string" default="" />
<cfproperty name="barcodeSize" type="string" default="" />
<cfproperty name="valueSize" type="string" default="" />
<cfproperty name="valuePosition" type="string" default="" />
<cfproperty name="isValueHidden" type="string" default="" />
<cfproperty name="customText" type="string" default="" />
<cfproperty name="customTextSize" type="string" default="" />
<cfproperty name="customTextAlignment" type="string" default="" />
<cfproperty name="logo" type="string" default="" />
<cfproperty name="logoPosition" type="string" default="" />
<cfproperty name="fileType" type="string" default="" />
<cfproperty name="errorCorrection" type="string" default="" />
<cfproperty name="databaseId" type="string" default="" />
<cfproperty name="response" type="string" default="" />
<cfproperty name="validity" type="string" default="" />

<!--- pseudo-contructor --->
<cfset variables.instance = {
			barcodeValue = '',
			barcodeSize = '',
			valueSize = '',
			valuePosition = '',
			isValueHidden = '',
			customText = '',
			customTextSize = '',
			customTextAlignment = '',
			logo = '',
			logoPosition = '',
			fileType = '',
			errorCorrection = '',
			databaseId = '',
			response = '',
			validity = ''
	} />
<cffunction name="init" access="public" output="false" returntype="any" hint="">
  <cfargument name="barcodeValue" type="string" required="true" default="" hint="" />
  <cfargument name="barcodeSize" type="string" required="true" default="" hint="" />
  <cfargument name="valueSize" type="string" required="true" default="" hint="" />
  <cfargument name="valuePosition" type="string" required="true" default="" hint="" />
  <cfargument name="isValueHidden" type="string" required="true" default="" hint="" />
  <cfargument name="customText" type="string" required="true" default="" hint="" />
  <cfargument name="customTextSize" type="string" required="true" default="" hint="" />
  <cfargument name="customTextAlignment" type="string" required="true" default="" hint="" />
  <cfargument name="logo" type="string" required="true" default="" hint="" />
  <cfargument name="logoPosition" type="string" required="true" default="" hint="" />
  <cfargument name="fileType" type="string" required="true" default="" hint="" />
  <cfargument name="errorCorrection" type="string" required="true" default="" hint="" />
  <cfargument name="databaseId" type="string" required="true" default="" hint="" />
  <cfargument name="response" type="string" required="true" default="" hint="" />
  <cfargument name="validity" type="string" required="true" default="" hint="" />
  <!--- set the initial values of the bean --->
  <cfscript>
  	setBarcodeValue(ARGUMENTS.barcodeValue);
  	setBarcodeSize(ARGUMENTS.barcodeSize);
  	setValueSize(ARGUMENTS.valueSize);
	setValuePosition(ARGUMENTS.valuePosition);
	setIsValueHidden(ARGUMENTS.isValueHidden);
	setCustomText(ARGUMENTS.customText);
	setCustomTextSize(ARGUMENTS.customTextSize);
  	setCustomTextAlignment(ARGUMENTS.customTextAlignment);
  	setLogo(ARGUMENTS.logo);
  	setLogoPosition(ARGUMENTS.logoPosition);
  	setFileType(ARGUMENTS.fileType);
  	setErrorCorrection(ARGUMENTS.errorCorrection);
	setDatabaseId(ARGUMENTS.databaseId);
	setResponse(ARGUMENTS.response);
	setValidity(ARGUMENTS.validity);
  </cfscript>
  <cfreturn this>
</cffunction>

<!--- setters --->
<cffunction name="setBarcodeValue" access="public" output="false" hint="">
  <cfargument name="barcodeValue" type="string" required="true" default="" hint="" />
  <cfset variables.instance.barcodeValue = ARGUMENTS.barcodeValue />
</cffunction>

<cffunction name="setBarcodeSize" access="public" output="false" hint="">
  <cfargument name="barcodeSize" type="string" required="true" default="" hint="" />
  <cfset variables.instance.barcodeSize = ARGUMENTS.barcodeSize />
</cffunction>

<cffunction name="setValueSize" access="public" output="false" hint="">
  <cfargument name="valueSize" type="string" required="true" default="" hint="" />
  <cfset variables.instance.valueSize = ARGUMENTS.valueSize />
</cffunction>

<cffunction name="setValuePosition" access="public" output="false" hint="">
  <cfargument name="valuePosition" type="string" required="true" default="" hint="" />
  	<cfset variables.instance.valuePosition = ARGUMENTS.valuePosition />
</cffunction>

<cffunction name="setIsValueHidden" access="public" output="false" hint="">
  <cfargument name="isValueHidden" type="string" required="true" default="" hint="" />  
  	<cfset variables.instance.isValueHidden = ARGUMENTS.isValueHidden />
</cffunction>

<cffunction name="setCustomText" access="public" output="false" hint="">
  <cfargument name="customText" type="string" required="true" default="" hint="" />
  	<cfset variables.instance.customText = ARGUMENTS.customText />
</cffunction>

<cffunction name="setCustomTextSize" access="public" output="false" hint="">
  <cfargument name="customTextSize" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.customTextSize = ARGUMENTS.customTextSize />
</cffunction>

<cffunction name="setCustomTextAlignment" access="public" output="false" hint="">
  <cfargument name="customTextAlignment" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.customTextAlignment = ARGUMENTS.customTextAlignment />
</cffunction>

<cffunction name="setLogo" access="public" output="false" hint="">
  <cfargument name="logo" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.logo = ARGUMENTS.logo />
</cffunction>

<cffunction name="setLogoPosition" access="public" output="false" hint="">
  <cfargument name="logoPosition" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.logoPosition = ARGUMENTS.logoPosition />
</cffunction>

<cffunction name="setFileType" access="public" output="false" hint="">
  <cfargument name="fileType" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.fileType = ARGUMENTS.fileType />
</cffunction>

<cffunction name="setErrorCorrection" access="public" output="false" hint="">
  <cfargument name="errorCorrection" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.errorCorrection = ARGUMENTS.errorCorrection />
</cffunction>

<cffunction name="setDatabaseId" access="public" output="false" hint="">
  <cfargument name="databaseId" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.databaseId = ARGUMENTS.databaseId />
</cffunction>

<cffunction name="setResponse" access="public" output="false" hint="">
  <cfargument name="response" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.response = ARGUMENTS.response />
</cffunction>

<cffunction name="setValidity" access="public" output="false" hint="">
  <cfargument name="validity" type="string" required="true" default="" hint="" />
 	<cfset variables.instance.validity = ARGUMENTS.validity />
</cffunction>

<!--- getters --->
<cffunction name="getBarcodeValue" access="public" output="false" hint="">
  <cfreturn variables.instance.barcodeValue />
</cffunction>

<cffunction name="getBarcodeSize" access="public" output="false" hint="">
  <cfreturn variables.instance.barcodeSize />
</cffunction>

<cffunction name="getValueSize" access="public" output="false" hint="">
  <cfreturn variables.instance.valueSize />
</cffunction>

<cffunction name="getValuePosition" access="public" output="false" hint="">
  	<cfreturn variables.instance.valuePosition />
</cffunction>

<cffunction name="getIsValueHidden" access="public" output="false" hint="">
    <cfreturn variables.instance.isValueHidden />
</cffunction>

<cffunction name="getCustomText" access="public" output="false" hint="">
    <cfreturn variables.instance.customText />
</cffunction>

<cffunction name="getCustomTextSize" access="public" output="false" hint="">
  <cfreturn variables.instance.customTextSize />
</cffunction>

<cffunction name="getCustomTextAlignment" access="public" output="false" hint="">
 	<cfreturn variables.instance.customTextAlignment />
</cffunction>

<cffunction name="getLogo" access="public" output="false" hint="">
 	<cfreturn variables.instance.logo />
</cffunction>

<cffunction name="getLogoPosition" access="public" output="false" hint="">
 	<cfreturn variables.instance.logoPosition />
</cffunction>

<cffunction name="getFileType" access="public" output="false" hint="">
 	<cfreturn variables.instance.fileType />
</cffunction>

<cffunction name="getErrorCorrection" access="public" output="false" hint="">
 	<cfreturn variables.instance.errorCorrection />
</cffunction>

<cffunction name="getDatabaseId" access="public" output="false" hint="">
 	<cfreturn variables.instance.databaseId />
</cffunction>

<cffunction name="getResponse" access="public" output="false" hint="">
 	<cfreturn variables.instance.response />
</cffunction>

<cffunction name="getValidity" access="public" output="false" hint="">
 	<cfreturn variables.instance.validity />
</cffunction>

<!--- utility methods --->
<cffunction name="getMemento" access="public" output="false" hint="">
   <cfreturn variables.instance />
</cffunction>

</cfcomponent>