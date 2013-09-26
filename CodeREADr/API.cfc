<!--- CodeREADrAPI                                                                            --->
<!--- ============                                                                            --->
<!---                                                                                         --->
<!--- This API is designed to be used with the mobile QR/barcode scanning application and web --->
<!--- service available at http://www.codereadr.com/. This CFC wraps the API calls in an easy --->
<!--- to use API layer that allows easier integration with ColdFusion applications. Please be --->
<!--- sure to view the example.cfm page to see an example implementation of this API.         --->
<!---                                                                                         --->
<!--- Written by Denard Springle (denard.springle@gmail.com) of Virtual Solutions Group, LLC  --->
<!--- http://www.vsgcom.net/. This work is licensed under a Creative Commons                  --->
<!--- Attribution-ShareAlike 3.0 Unported License.                                            --->
<!---                                                                                         --->
<!--- Source code available on GitHub:                                                        --->
<!--- https://github.com/ddspringle/cfCodeREADr                                               --->
<!---                                                                                         --->

<cfcomponent displayname="CodeREADrAPI" name="CodeREADrAPI" hint="I am the codeREADr API wrapper.">

	<!--- INITIALIZE --->
	<cffunction name="init" access="public" output="false" returntype="any" description="I am the constructor for the codeREADr API wrapper.">
    	<cfargument name="apiKey" type="string" required="false" default="<your api key>" hint="I am the API key for the codeREADr API." />
        <cfargument name="apiUrl" type="string" required="false" default="http://www.codereadr.com/api" hint="I am the URL to use for the codeREADr API calls." />
    
		<cfset var variables.instance.APIKey = ARGUMENTS.apiKey />
        <cfset var variables.instance.APIURL = ARGUMENTS.apiUrl />
    
    	<cfreturn this />
    
    </cffunction>
    
    <!---                  --->
    <!--- PUBLIC FUNCTIONS --->
    <!---                  --->
    
    <!---                                                              --->
    <!--- SERVICES SECTION                                             --->
	<!--- http://help.codereadr.com/help/kb/developer-api/api-services --->
    <!---                                                              --->
    
	<!--- GET SERVICE LIST --->
	<cffunction name="GetServiceList" access="public" returntype="any" description="I return either a single service object or an array of service objects depending on how many records are returned.">
		<cfargument name="serviceIdList" type="string" required="false" default="" hint="I am one or more service ID's to get service information for. Default is 'all' to return all services.">
	
    	<!--- set up an array to hold results --->
		<cfset var ServicesArray = ArrayNew(1) />
        <!--- set up a counter to put objects in the array --->
        <cfset var ServicesCount = 0 />	
        <!--- var scope the elemets needed --->
        <cfset var OuterXmlElement = '' />
        <cfset var InnerXmlElement = '' />
        <cfset var serviceObj = '' />
        <!--- Get the XML returned from a call to codeREADr to get service information --->
		<cfset var resultXML = DoAPIPost('services','retrieve',{service_id = ARGUMENTS.serviceIdList}) />

        <!--- loop through the children of the root XML element returned from codeREADr --->
        <cfloop array="#resultXML.XmlChildren#" index="OuterXmlElement">
        
        	<!--- check if this element is a 'service' element --->
			<cfif OuterXmlElement.XmlName EQ 'service'>
                <!--- it is, increase the services counter by 1 --->
                <cfset ServicesCount = ServicesCount + 1 />
                <!--- create a service object, passing in the service id --->
                <cfset serviceObj = CreateObject('cfcs.CodeREADr.model.Service').init(serviceId = OuterXmlElement.XmlAttributes.id) />
                <!--- loop through the children of the OuterXmlElement (service) --->                
                <cfloop array="#OuterXmlElement.XmlChildren#" index="InnerXmlElement">
                	<!--- switch on the name of the element, and add to the appropriate object value --->
                    <cfswitch expression="#InnerXmlElement.XmlName#">
                    
                        <cfcase value="name">
                            <cfset serviceObj.setServiceName(InnerXmlElement.XmlText) />
                        </cfcase>
                    
                        <cfcase value="validationmethod">		
                            <cfset serviceObj.setValidationMethod(InnerXmlElement.XmlText) />
                        </cfcase>
                    
                        <cfcase value="database">
                            <cfset serviceObj.setDatabaseId(InnerXmlElement.XmlText) />
                        </cfcase>
                        
                        <cfcase value="postback">
                            <cfset serviceObj.setPostbackURL(InnerXmlElement.XmlText) />
                        </cfcase>
                        
                        <cfcase value="duplicateScanValue">		
                            <cfset serviceObj.setDuplicateScanValue(InnerXmlElement.XmlText) />
                        </cfcase>
                        
                        <cfcase value="user">
                            <cfset serviceObj.setUserIdList(ListAppend(serviceObj.getUserIdList(),InnerXmlElement.XmlAttributes.id)) />
                        </cfcase>
                    
                        <cfcase value="question">
                            <cfset serviceObj.setQuestionIdList(ListAppend(serviceObj.getQuestionIdList(),InnerXmlElement.XmlAttributes.id)) />
                        </cfcase>     
                            
                    </cfswitch>
                    
                <!--- end looping through children of the OuterXmlElement (service) --->
                </cfloop>
                <!--- add this service object to the services array --->
                <cfset ServicesArray[ServicesCount] = serviceObj />
            <!--- end checking if this is a service --->
            </cfif>
        <!--- end looping through the children of the root XML returned from codeREADr --->
        </cfloop>
        
		<!--- return the array of services objects --->
		<cfreturn ServicesArray />
                
	</cffunction>

	<!--- CREATE SERVICE --->
	<cffunction name="CreateService" access="public" output="false" returntype="any" description="I create a new service based on the data in the passed in service object.">
    	<cfargument name="serviceObj" type="any" required="true" hint="I am the service object to create a new service for." />
        
        <cfset var resultXML = DoAPIPost('services','create',{
			validation_method 	= ARGUMENTS.serviceObj.getValidationMethod(),
			database_id 		= ARGUMENTS.serviceObj.getDatabaseId(),
			postback_url 		= ARGUMENTS.serviceObj.getPostbackURL(),
			service_name		= ARGUMENTS.serviceObj.getServiceName(),
			description			= ARGUMENTS.serviceObj.getDescription(),
    		duplicate_value		= ARGUMENTS.serviceObj.getDuplicateScanValue(),
			period_start_date	= ARGUMENTS.serviceObj.getPeriodStartDate(),
			period_start_time	= ARGUMENTS.serviceObj.getPeriodStartTime(),
			period_end_date		= ARGUMENTS.serviceObj.getPeriodEndDate(),
			period_end_time		= ARGUMENTS.serviceObj.getPeriodEndTime(),
			upload_email		= ARGUMENTS.serviceObj.getUploadEmail(),
			viewOtherScans		= ARGUMENTS.serviceObj.getViewOtherScans()
		}) />

		<!--- check that we received a valid response --->        
        <cfif resultXML.status.XmlText EQ 1>
        	<!--- we did, return the id provided by codeREADr --->
            <cfreturn resultXML.id.XmlText />
        <!--- otherwise --->
        <cfelse>
        	<!--- we didn't, log the error --->
            <cfset logError(resultXML,getFunctionCalledName()) />
            <!--- and return zero (0) --->
            <cfreturn 0 />
        <!--- end checking if we received a valid response --->
        </cfif>
        
    </cffunction>
    
	<!--- UPDATE SERVICE --->
	<cffunction name="UpdateService" access="public" output="false" returntype="boolean" description="I update a service based on the data in the passed in service object.">
    	<cfargument name="serviceObj" type="any" required="true" hint="I am the service object used to update the service. I must include the service id to update." />
        
        <cfset var resultXML = DoAPIPost('services','update',{
			service_id			= ARGUMENTS.serviceObj.getServiceId(),
			validation_method 	= ARGUMENTS.serviceObj.getValidationMethod(),
			database_id 		= ARGUMENTS.serviceObj.getDatabaseId(),
			postback_url 		= ARGUMENTS.serviceObj.getPostbackURL(),
			service_name		= ARGUMENTS.serviceObj.getServiceName(),
			description			= ARGUMENTS.serviceObj.getDescription(),
    		duplicate_value		= ARGUMENTS.serviceObj.getDuplicateScanValue(),
			period_start_date	= ARGUMENTS.serviceObj.getPeriodStartDate(),
			period_start_time	= ARGUMENTS.serviceObj.getPeriodStartTime(),
			period_end_date		= ARGUMENTS.serviceObj.getPeriodEndDate(),
			period_end_time		= ARGUMENTS.serviceObj.getPeriodEndTime(),
			upload_email		= ARGUMENTS.serviceObj.getUploadEmail(),
			viewOtherScans		= ARGUMENTS.serviceObj.getViewOtherScans()
		}) />
        
		<!--- check that we received a valid response --->        
        <cfif resultXML.status.XmlText EQ 1>
        	<!--- we did, return true --->
            <cfreturn true />
        <!--- otherwise --->
        <cfelse>
        	<!--- we didn't, log the error --->
            <cfset logError(resultXML,getFunctionCalledName()) />
            <!--- and return false --->
            <cfreturn false />
        <!--- end checking if we received a valid response --->
        </cfif>
        
    </cffunction>

	<!--- DELETE SERVICE --->
	<cffunction name="DeleteService" access="public" output="false" returntype="boolean" description="I delete a service based on it's ID.">
    	<cfargument name="serviceId" type="numeric" required="true" hint="I am the service id to delete." />
        
        <cfset var resultXML = DoAPIPost('services','delete',{service_id = ARGUMENTS.serviceId}) />
        
		<!--- check that we received a valid response --->        
        <cfif resultXML.status.XmlText EQ 1>
        	<!--- we did, return true --->
            <cfreturn true />
        <!--- otherwise --->
        <cfelse>
        	<!--- we didn't, log the error --->
<cfset logError(resultXML,getFunctionCalledName()) />
            
            <!--- and return false --->
            <cfreturn false />
        <!--- end checking if we received a valid response --->
        </cfif>
        
    </cffunction>

	<!--- ADD SERVICE USER --->
	<cffunction name="AddServiceUser" access="public" output="false" returntype="boolean" description="I authorize users for a service.">
    	<cfargument name="serviceId" type="numeric" required="true" hint="I am the service id to authorize a user for." />
    	<cfargument name="userIdList" type="numeric" required="true" hint="I am the comma-separated list of user id's to authorize for the service." />
        
        <cfset var resultXML = DoAPIPost('services','adduserpermission',{service_id = ARGUMENTS.serviceId, user_id = ARGUMENTS.userIdList}) />
        
		<!--- check that we received a valid response --->        
        <cfif resultXML.status.XmlText EQ 1>
        	<!--- we did, return true --->
            <cfreturn true />
        <!--- otherwise --->
        <cfelse>
        	<!--- we didn't, log the error --->
            <cfset logError(resultXML,getFunctionCalledName()) />
            <!--- and return false --->
            <cfreturn false />
        <!--- end checking if we received a valid response --->
        </cfif>
        
    </cffunction>

	<!--- REMOVE SERVICE USER --->
	<cffunction name="RemoveServiceUser" access="public" output="false" returntype="boolean" description="I de-authorize users for a service.">
    	<cfargument name="serviceId" type="numeric" required="true" hint="I am the service id to de-authorize a user for." />
    	<cfargument name="userIdList" type="numeric" required="true" hint="I am the comma-separated list of user id's to de-authorize for the service." />
        
        <cfset var resultXML = DoAPIPost('services','revokeuserpermission',{service_id = ARGUMENTS.serviceId, user_id = ARGUMENTS.userIdList}) />
        
		<!--- check that we received a valid response --->        
        <cfif resultXML.status.XmlText EQ 1>
        	<!--- we did, return true --->
            <cfreturn true />
        <!--- otherwise --->
        <cfelse>
        	<!--- we didn't, log the error --->
            <cfset logError(resultXML,getFunctionCalledName()) />
            <!--- and return false --->
            <cfreturn false />
        <!--- end checking if we received a valid response --->
        </cfif>
        
    </cffunction>

	<!--- ADD SERVICE QUESTION --->
	<cffunction name="AddServiceQuestion" access="public" output="false" returntype="boolean" description="I add questions for a service.">
    	<cfargument name="serviceId" type="numeric" required="true" hint="I am the service id to add a question for." />
    	<cfargument name="questionIdList" type="numeric" required="true" hint="I am the comma-separated list of question id's to add to the service." />
        <cfargument name="condition" type="string" required="false" default="" hint="I specify the condition on which the question will display. One of: pre_submit, post_submit, valid_scan, invalid_scan." />
        
        <cfset var resultXML = DoAPIPost('services','addquestion',{service_id = ARGUMENTS.serviceId, question_id = ARGUMENTS.questionIdList, condition = ARGUMENTS.condition}) />
        
		<!--- check that we received a valid response --->        
        <cfif resultXML.status.XmlText EQ 1>
        	<!--- we did, return true --->
            <cfreturn true />
        <!--- otherwise --->
        <cfelse>
        	<!--- we didn't, log the error --->
            <cfset logError(resultXML,getFunctionCalledName()) />
            <!--- and return false --->
            <cfreturn false />
        <!--- end checking if we received a valid response --->
        </cfif>
        
    </cffunction>

	<!--- REMOVE SERVICE QUESTION --->
	<cffunction name="RemoveServiceQuestion" access="public" output="false" returntype="boolean" description="I remove questions from a service.">
    	<cfargument name="serviceId" type="numeric" required="true" hint="I am the service id to remove a question for." />
    	<cfargument name="questionIdList" type="numeric" required="true" hint="I am the comma-separated list of question id's to remove from the service." />
        
        <cfset var resultXML = DoAPIPost('services','removequestion',{service_id = ARGUMENTS.serviceId, question_id = ARGUMENTS.questionIdList}) />
        
		<!--- check that we received a valid response --->        
        <cfif resultXML.status.XmlText EQ 1>
        	<!--- we did, return true --->
            <cfreturn true />
        <!--- otherwise --->
        <cfelse>
        	<!--- we didn't, log the error --->
            <cfset logError(resultXML,getFunctionCalledName()) />
            <!--- and return false --->
            <cfreturn false />
        <!--- end checking if we received a valid response --->
        </cfif>
        
    </cffunction>

	<!---                                                           --->
	<!--- USERS SECTION                                             --->
    <!--- http://help.codereadr.com/help/kb/developer-api/api-users --->
	<!---                                                           --->

	<!--- GET USER LIST --->
	<cffunction name="GetUserList" access="public" returntype="any" description="I return either a single user object or an array of user objects depending on how many records are returned.">
		<cfargument name="userIdList" type="string" required="false" default="" hint="I am one or more user ID's to get user information for. Default is 'all' to return all users.">
	
    	<!--- set up an array to hold results --->
		<cfset var UsersArray = ArrayNew(1) />
        <!--- set up a counter to put objects in the array --->
        <cfset var UsersCount = 0 />	
        <!--- var scope the elemets needed --->
        <cfset var OuterXmlElement = '' />
        <cfset var InnerXmlElement = '' />
        <cfset var userObj = '' />
        <!--- Get the XML returned from a call to codeREADr to get user information --->
		<cfset var resultXML = DoAPIPost('users','retrieve',{user_id = ARGUMENTS.userIdList}) />

        <!--- loop through the children of the root XML element returned from codeREADr --->
        <cfloop array="#resultXML.XmlChildren#" index="OuterXmlElement">
        
        	<!--- check if this element is a 'user' element --->
			<cfif OuterXmlElement.XmlName EQ 'user'>
                <!--- it is, increase the users counter by 1 --->
                <cfset UsersCount = UsersCount + 1 />
                <!--- create a user object, passing in the user id --->
                <cfset userObj = CreateObject('cfcs.CodeREADr.model.User').init(userId = OuterXmlElement.XmlAttributes.id) />
                <!--- loop through the children of the OuterXmlElement (user) --->                
                <cfloop array="#OuterXmlElement.XmlChildren#" index="InnerXmlElement">
                	<!--- switch on the name of the element, and add to the appropriate object value --->
                    <cfswitch expression="#InnerXmlElement.XmlName#">
                    
                        <cfcase value="username">
                            <cfset userObj.setUsername(InnerXmlElement.XmlText) />
                        </cfcase>
                    
						<cfcase value="created">		
							<cfset userObj.setCreatedOn(InnerXmlElement.XmlText) />
                        </cfcase>
                        
                        <cfcase value="service">
                            <cfset userObj.setServiceIdList(ListAppend(userObj.getServiceIdList(),InnerXmlElement.XmlAttributes.id)) />
                        </cfcase>       
                            
                    </cfswitch>
                    
                <!--- end looping through children of the OuterXmlElement (user) --->
                </cfloop>
                <!--- add this user object to the users array --->
                <cfset UsersArray[UsersCount] = userObj />
            <!--- end checking if this is a user --->
            </cfif>
        <!--- end looping through the children of the root XML returned from codeREADr --->
        </cfloop>
        
		<!--- return the array of user objects --->
		<cfreturn UsersArray />
                
	</cffunction>

	<!--- CREATE USER --->
	<cffunction name="CreateUser" access="public" output="false" returntype="any" description="I create a new user based on the data in the passed in user object.">
    	<cfargument name="userObj" type="any" required="true" hint="I am the user object to create a new user for." />
        
        <cfset var resultXML = DoAPIPost('users','create',{
			username 	= ARGUMENTS.userObj.getUsername(),
			password	= ARGUMENTS.userObj.getPassword(),
			limit 		= ARGUMENTS.userObj.getLimit()
		}) />

		<!--- check that we received a valid response --->        
        <cfif resultXML.status.XmlText EQ 1>
        	<!--- we did, return the id provided by codeREADr --->
            <cfreturn resultXML.id.XmlText />
        <!--- otherwise --->
        <cfelse>
        	<!--- we didn't, log the error --->
            <cfset logError(resultXML,getFunctionCalledName()) />
            <!--- and return zero (0) --->
            <cfreturn 0 />
        <!--- end checking if we received a valid response --->
        </cfif>
        
    </cffunction>
    
	<!--- UPDATE USER --->
	<cffunction name="UpdateUser" access="public" output="false" returntype="boolean" description="I update a user based on the data in the passed in user object.">
    	<cfargument name="userObj" type="any" required="true" hint="I am the user object used to update the user. I must include the user id to update." />
        
        <cfset var resultXML = DoAPIPost('users','update',{
			user_id		= ARGUMENTS.userObj.getUserId(),
			username 	= ARGUMENTS.userObj.getUsername(),
			password	= ARGUMENTS.userObj.getPassword(),
			limit 		= ARGUMENTS.userObj.getLimit()
		}) />
        
		<!--- check that we received a valid response --->        
        <cfif resultXML.status.XmlText EQ 1>
        	<!--- we did, return true --->
            <cfreturn true />
        <!--- otherwise --->
        <cfelse>
        	<!--- we didn't, log the error --->
            <cfset logError(resultXML,getFunctionCalledName()) />
            <!--- and return false --->
            <cfreturn false />
        <!--- end checking if we received a valid response --->
        </cfif>
        
    </cffunction>

	<!--- DELETE USER --->
	<cffunction name="DeleteUser" access="public" output="false" returntype="boolean" description="I delete a user based on it's ID.">
    	<cfargument name="userId" type="numeric" required="true" hint="I am the user id to delete." />
        
        <cfset var resultXML = DoAPIPost('users','delete',{user_id = ARGUMENTS.userId}) />
        
		<!--- check that we received a valid response --->        
        <cfif resultXML.status.XmlText EQ 1>
        	<!--- we did, return true --->
            <cfreturn true />
        <!--- otherwise --->
        <cfelse>
        	<!--- we didn't, log the error --->
            <cfset logError(resultXML,getFunctionCalledName()) />
            <!--- and return false --->
            <cfreturn false />
        <!--- end checking if we received a valid response --->
        </cfif>
        
    </cffunction>


	<!---                                                             --->
	<!--- DEVICES SECTION                                             --->
    <!--- http://help.codereadr.com/help/kb/developer-api/api-devices --->
	<!---                                                             --->    

	<!--- GET DEVICE LIST --->
	<cffunction name="GetDeviceList" access="public" returntype="any" description="I return either a single device object or an array of device objects depending on how many records are returned.">
		<cfargument name="deviceIdList" type="string" required="false" default="" hint="I am one or more device ID's to get device information for. Default is 'all' to return all devices.">
	
    	<!--- set up an array to hold results --->
		<cfset var DevicesArray = ArrayNew(1) />
        <!--- set up a counter to put objects in the array --->
        <cfset var DevicesCount = 0 />	
        <!--- var scope the elemets needed --->
        <cfset var OuterXmlElement = '' />
        <cfset var InnerXmlElement = '' />
        <cfset var deviceObj = '' />
        <!--- Get the XML returned from a call to codeREADr to get device information --->
		<cfset var resultXML = DoAPIPost('devices','retrieve',{device_id = ARGUMENTS.deviceIdList}) />

        <!--- loop through the children of the root XML element returned from codeREADr --->
        <cfloop array="#resultXML.XmlChildren#" index="OuterXmlElement">
        
        	<!--- check if this element is a 'device' element --->
			<cfif OuterXmlElement.XmlName EQ 'device'>
                <!--- it is, increase the devices counter by 1 --->
                <cfset DevicesCount = DevicesCount + 1 />
                <!--- create a device object, passing in the device id --->
                <cfset deviceObj = CreateObject('cfcs.CodeREADr.model.Device').init(deviceId = OuterXmlElement.XmlAttributes.id) />
                <!--- loop through the children of the OuterXmlElement (device) --->                
                <cfloop array="#OuterXmlElement.XmlChildren#" index="InnerXmlElement">
                	<!--- switch on the name of the element, and add to the appropriate object value --->
                    <cfswitch expression="#InnerXmlElement.XmlName#">
 
                        <cfcase value="udid">
                            <cfset deviceObj.setUniqueDeviceId(InnerXmlElement.XmlText) />
                        </cfcase>
                                           
                        <cfcase value="devicename">
                            <cfset deviceObj.setDeviceName(InnerXmlElement.XmlText) />
                        </cfcase>
                    
						<cfcase value="created">		
							<cfset deviceObj.setCreatedOn(InnerXmlElement.XmlText) />
                        </cfcase>    
                            
                    </cfswitch>
                    
                <!--- end looping through children of the OuterXmlElement (device) --->
                </cfloop>
                <!--- add this device object to the devices array --->
                <cfset DevicesArray[DevicesCount] = deviceObj />
            <!--- end checking if this is a device --->
            </cfif>
        <!--- end looping through the children of the root XML returned from codeREADr --->
        </cfloop>
        
		<!--- return the array of device objects --->
		<cfreturn DevicesArray />
      
	</cffunction>

	<!--- UPDATE DEVICE --->
	<cffunction name="UpdateDevice" access="public" output="false" returntype="boolean" description="I update a device based on the data in the passed in device object.">
    	<cfargument name="deviceObj" type="any" required="true" hint="I am the device object used to update the device. I must include the device id to update and name of the device." />
        
        <cfset var resultXML = DoAPIPost('devices','update',{
			device_id		= ARGUMENTS.deviceObj.getDeviceId(),
			device_name 	= ARGUMENTS.deviceObj.getDevicename()
		}) />
        
		<!--- check that we received a valid response --->        
        <cfif resultXML.status.XmlText EQ 1>
        	<!--- we did, return true --->
            <cfreturn true />
        <!--- otherwise --->
        <cfelse>
        	<!--- we didn't, log the error --->
            <cfset logError(resultXML,getFunctionCalledName()) />
            <!--- and return false --->
            <cfreturn false />
        <!--- end checking if we received a valid response --->
        </cfif>
        
    </cffunction>
    

    <!---                                                                                     --->
    <!--- QUESTIONS SECTION                                                                   --->
	<!--- http://help.codereadr.com/help/kb/developer-api/api-questions-and-location-tracking --->
    <!---                                                                                     --->
    
	<!--- GET QUESTION LIST --->
	<cffunction name="GetQuestionList" access="public" returntype="any" description="I return either a single question object or an array of question objects depending on how many records are returned.">
		<cfargument name="questionIdList" type="string" required="false" default="" hint="I am one or more question ID's to get question information for. Default is 'all' to return all questions.">
	
    	<!--- set up an array to hold results --->
		<cfset var QuestionsArray = ArrayNew(1) />
        <!--- set up a counter to put objects in the array --->
        <cfset var QuestionsCount = 0 />	
        <!--- var scope the elemets needed --->
        <cfset var OuterXmlElement = '' />
        <cfset var InnerXmlElement = '' />
        <cfset var questionObj = '' />
        <!--- Get the XML returned from a call to codeREADr to get question information --->
		<cfset var resultXML = DoAPIPost('questions','retrieve',{question_id = ARGUMENTS.questionIdList}) />

        <!--- loop through the children of the root XML element returned from codeREADr --->
        <cfloop array="#resultXML.XmlChildren#" index="OuterXmlElement">
        
        	<!--- check if this element is a 'question' element --->
			<cfif OuterXmlElement.XmlName EQ 'question'>
                <!--- it is, increase the questions counter by 1 --->
                <cfset QuestionsCount = QuestionsCount + 1 />
                <!--- create a question object, passing in the question id --->
                <cfset questionObj = CreateObject('cfcs.CodeREADr.model.Question').init(questionId = OuterXmlElement.XmlAttributes.id) />
                <!--- loop through the children of the OuterXmlElement (question) --->                
                <cfloop array="#OuterXmlElement.XmlChildren#" index="InnerXmlElement">
                	<!--- switch on the name of the element, and add to the appropriate object value --->
                    <cfswitch expression="#InnerXmlElement.XmlName#">
                    
                       	<cfcase value="text">
							<cfset questionObj.setText(InnerXmlElement.XmlText) />
                        </cfcase>
                        
                        <cfcase value="type">
                            <cfset questionObj.setType(InnerXmlElement.XmlText) />
                        </cfcase>
                    
                        <cfcase value="answer">
                            <cfset questionObj.setAnswerIdList(ListAppend(questionObj.getAnswerIdList(),InnerXmlElement.XmlAttributes.id)) />
                            <cfset questionObj.setAnswerTextList(ListAppend(questionObj.getAnswerTextList(),InnerXmlElement.XmlText)) />
                        </cfcase>  
                            
                    </cfswitch>
                    
                <!--- end looping through children of the OuterXmlElement (question) --->
                </cfloop>
                <!--- add this question object to the questions array --->
                <cfset QuestionsArray[QuestionsCount] = questionObj />
            <!--- end checking if this is a question --->
            </cfif>
        <!--- end looping through the children of the root XML returned from codeREADr --->
        </cfloop>
        
		<!--- return the array of question objects --->
		<cfreturn QuestionsArray />
        
	</cffunction>

	<!--- CREATE QUESTION --->
	<cffunction name="CreateQuestion" access="public" output="false" returntype="any" description="I create a new question based on the data in the passed in question object.">
    	<cfargument name="questionObj" type="any" required="true" hint="I am the question object to create a new question for." />
        
        <cfset var resultXML = DoAPIPost('questions','create',{
			question_text 	= ARGUMENTS.questionObj.getText(),
			question_type	= ARGUMENTS.questionObj.getType()
		}) />

		<!--- check that we received a valid response --->        
        <cfif resultXML.status.XmlText EQ 1>
        	<!--- we did, return the id provided by codeREADr --->
            <cfreturn resultXML.id.XmlText />
        <!--- otherwise --->
        <cfelse>
        	<!--- we didn't, log the error --->
            <cfset logError(resultXML,getFunctionCalledName()) />
            <!--- and return zero (0) --->
            <cfreturn 0 />
        <!--- end checking if we received a valid response --->
        </cfif>
        
    </cffunction>

	<!--- DELETE QUESTION --->
	<cffunction name="DeleteQuestion" access="public" output="false" returntype="boolean" description="I delete a question based on it's ID.">
    	<cfargument name="questionId" type="numeric" required="true" hint="I am the question id to delete." />
        
        <cfset var resultXML = DoAPIPost('questions','delete',{question_id = ARGUMENTS.questionId}) />
        
		<!--- check that we received a valid response --->        
        <cfif resultXML.status.XmlText EQ 1>
        	<!--- we did, return true --->
            <cfreturn true />
        <!--- otherwise --->
        <cfelse>
        	<!--- we didn't, log the error --->
            <cfset logError(resultXML,getFunctionCalledName()) />
            <!--- and return false --->
            <cfreturn false />
        <!--- end checking if we received a valid response --->
        </cfif>
        
    </cffunction>

	<!--- ADD ANSWER OPTION --->
	<cffunction name="AddAnswerOption" access="public" output="false" returntype="numeric" description="I add answers to a question and return an answer id.">
    	<cfargument name="questionId" type="numeric" required="true" hint="I am the question id to add an answer for for." />
    	<cfargument name="answerIdList" type="numeric" required="false" default="" hint="I am the comma-separated list of answer id's to add to the question." />
        <cfargument name="answerText" type="string" required="false" default="" hint="I am the string text to use for the answer option. Useed to create a new answer id." />
        
        <!--- var scope --->
        <cfset var resultXML = '' />
        
        <!--- check if we've passed in a list of numeric Id's --->
        <cfif answerIdList NEQ "">
        	<!--- we have, send the answer id's to add to this question --->        
			<cfset resultXML = DoAPIPost('questions','addanswer',{answer_text = ARGUMENTS.answerIdList}) />
        <!--- otherwise --->
		<cfelse>
        	<!--- we haven't, use the answerText variable instead to send text to create a new answer --->
			<cfset resultXML = DoAPIPost('questions','addanswer',{answer_text = ARGUMENTS.answerText}) />
        </cfif>
        
		<!--- check that we received a valid response --->        
        <cfif resultXML.status.XmlText EQ 1>
        	<!--- we did, return the id provided by codeREADr --->
            <cfreturn resultXML.id.XmlText />
        <!--- otherwise --->
        <cfelse>
        	<!--- we didn't, log the error --->
            <cfset logError(resultXML,getFunctionCalledName()) />
            <!--- and return zero (0) --->
            <cfreturn 0 />
        <!--- end checking if we received a valid response --->
        </cfif>
        
    </cffunction>

	<!--- REMOVE ANSWER OPTION --->
	<cffunction name="RemoveAnswerOption" access="public" output="false" returntype="boolean" description="I de-authorize questions for a question.">
    	<cfargument name="answerIdList" type="numeric" required="true" hint="I am the comma-separated list of question id's to de-authorize for the question." />
        
        <cfset var resultXML = DoAPIPost('questions','removeanswer',{answer_id = ARGUMENTS.answerIdList}) />
        
		<!--- check that we received a valid response --->        
        <cfif resultXML.status.XmlText EQ 1>
        	<!--- we did, return true --->
            <cfreturn true />
        <!--- otherwise --->
        <cfelse>
        	<!--- we didn't, log the error --->
            <cfset logError(resultXML,getFunctionCalledName()) />
            <!--- and return false --->
            <cfreturn false />
        <!--- end checking if we received a valid response --->
        </cfif>
        
    </cffunction>

    <!---                                                                       --->
    <!--- BARCODE GENERATOR SECTION                                             --->
	<!--- http://help.codereadr.com/help/kb/developer-api/api-barcode-generator --->
    <!---                                                                       --->

	<!--- GENERATE BARCODE --->
	<cffunction name="GenerateBarcode" access="public" output="false" returntype="any" description="I accept a barcode object and return a binary image object if successful, or false otherwise.">
    	<cfargument name="barcodeObj" type="any" required="true" hint="I am the barcode object to create a new barcode image from." />
        
        <cfset var resultBinary = DoAPIPost('barcode','generate',{
			value 			= ARGUMENTS.barcodeObj.getBarcodeValue(),
			size 			= ARGUMENTS.barcodeObj.getBarcodeSize(),
			valuesize 		= ARGUMENTS.barcodeObj.getValueSize(),
			valueposition 	= ARGUMENTS.barcodeObj.getValuePosition(),
			hidevalue 		= ARGUMENTS.barcodeObj.getIsValueHidden(),
			text 			= ARGUMENTS.barcodeObj.getCustomText(),
			textsize 		= ARGUMENTS.barcodeObj.getCustomTextSize(),
			textalignment 	= ARGUMENTS.barcodeObj.getCustomTextAlignment(),
			logo 			= ARGUMENTS.barcodeObj.getLogo(),
			logoposition 	= ARGUMENTS.barcodeObj.getLogoPosition(),
			filetype		= ARGUMENTS.barcodeObj.getFileType(),
			errorcorrection = ARGUMENTS.barcodeObj.getErrorCorrection()	
		}) />
        
		<!--- check that we received a valid response --->        
        <cfif IsBinary(resultBinary)>
        	<!--- we did, return the binary image --->
            <cfreturn resultBinary />
        <!--- otherwise --->
        <cfelse>
        	<!--- we didn't, log the error --->
            <cfset logError(resultXML,getFunctionCalledName()) />
            <!--- and return false --->
            <cfreturn false />
        <!--- end checking if we received a valid response --->
        </cfif>
        
    </cffunction>


	<!---                                                               --->
	<!--- DATABASES SECTION                                             --->
    <!--- http://help.codereadr.com/help/kb/developer-api/api-databases --->
	<!---                                                               --->

	<!--- GET DATABASE LIST --->
	<cffunction name="GetDatabaseList" access="public" returntype="any" description="I return either a single database object or an array of database objects depending on how many records are returned.">
		<cfargument name="databaseIdList" type="string" required="false" default="" hint="I am one or more database ID's to get database information for. Default is 'all' to return all databases.">
	
    	<!--- set up an array to hold results --->
		<cfset var DatabasesArray = ArrayNew(1) />
        <!--- set up a counter to put objects in the array --->
        <cfset var DatabasesCount = 0 />	
        <!--- var scope the elemets needed --->
        <cfset var OuterXmlElement = '' />
        <cfset var InnerXmlElement = '' />
        <cfset var databaseObj = '' />
        <!--- Get the XML returned from a call to codeREADr to get database information --->
		<cfset var resultXML = DoAPIPost('databases','retrieve',{database_id = ARGUMENTS.databaseIdList}) />

        <!--- loop through the children of the root XML element returned from codeREADr --->
        <cfloop array="#resultXML.XmlChildren#" index="OuterXmlElement">
        
        	<!--- check if this element is a 'database' element --->
			<cfif OuterXmlElement.XmlName EQ 'database'>
                <!--- it is, increase the databases counter by 1 --->
                <cfset DatabasesCount = DatabasesCount + 1 />
                <!--- create a database object, passing in the database id --->
                <cfset databaseObj = CreateObject('cfcs.CodeREADr.model.Database').init(databaseId = OuterXmlElement.XmlAttributes.id) />
                <!--- loop through the children of the OuterXmlElement (database) --->                
                <cfloop array="#OuterXmlElement.XmlChildren#" index="InnerXmlElement">
                	<!--- switch on the name of the element, and add to the appropriate object value --->
                    <cfswitch expression="#InnerXmlElement.XmlName#">
                    
                        <cfcase value="name">
                            <cfset databaseObj.setDatabaseName(InnerXmlElement.XmlText) />
                        </cfcase>
                    
						<cfcase value="count">		
							<cfset databaseObj.setRecordCount(InnerXmlElement.XmlText) />
                        </cfcase>
                        
                        <cfcase value="service">
                            <cfset databaseObj.setServiceIdList(ListAppend(databaseObj.getServiceIdList(),InnerXmlElement.XmlAttributes.id)) />
                        </cfcase>       
                            
                    </cfswitch>
                    
                <!--- end looping through children of the OuterXmlElement (database) --->
                </cfloop>
                <!--- add this database object to the databases array --->
                <cfset DatabasesArray[DatabasesCount] = databaseObj />
            <!--- end checking if this is a database --->
            </cfif>
        <!--- end looping through the children of the root XML returned from codeREADr --->
        </cfloop>
        
		<!--- return the array of databases objects --->
		<cfreturn DatabasesArray />

                
	</cffunction>

	<!--- CREATE DATABASE --->
	<cffunction name="CreateDatabase" access="public" output="false" returntype="any" description="I create a new database based on the data in the passed in database object.">
    	<cfargument name="databaseObj" type="any" required="true" hint="I am the database object to create a new database for." />
        
        <cfset var resultXML = DoAPIPost('databases','create',{
			database_name 		= ARGUMENTS.databaseObj.getDatabasename(),
			case_sensitivity	= ARGUMENTS.databaseObj.getCaseSensitivity()
		}) />

		<!--- check that we received a valid response --->        
        <cfif resultXML.status.XmlText EQ 1>
        	<!--- we did, return the id provided by codeREADr --->
            <cfreturn resultXML.id.XmlText />
        <!--- otherwise --->
        <cfelse>
        	<!--- we didn't, log the error --->
            <cfset logError(resultXML,getFunctionCalledName()) />
            <!--- and return zero (0) --->
            <cfreturn 0 />
        <!--- end checking if we received a valid response --->
        </cfif>
        
    </cffunction>
    
	<!--- UPDATE DATABASE --->
	<cffunction name="UpdateDatabase" access="public" output="false" returntype="boolean" description="I update a database based on the data in the passed in database object.">
    	<cfargument name="databaseObj" type="any" required="true" hint="I am the database object used to update the database. I must include the database id to update." />
        
        <cfset var resultXML = DoAPIPost('databases','update',{
			database_id		= ARGUMENTS.databaseObj.getDatabaseId(),
			database_name 	= ARGUMENTS.databaseObj.getDatabasename()
		}) />
        
		<!--- check that we received a valid response --->        
        <cfif resultXML.status.XmlText EQ 1>
        	<!--- we did, return true --->
            <cfreturn true />
        <!--- otherwise --->
        <cfelse>
        	<!--- we didn't, log the error --->
            <cfset logError(resultXML,getFunctionCalledName()) />
            <!--- and return false --->
            <cfreturn false />
        <!--- end checking if we received a valid response --->
        </cfif>
        
    </cffunction>

	<!--- DELETE DATABASE --->
	<cffunction name="DeleteDatabase" access="public" output="false" returntype="boolean" description="I delete a database based on it's ID.">
    	<cfargument name="databaseId" type="numeric" required="true" hint="I am the database id to delete." />
        
        <cfset var resultXML = DoAPIPost('databases','delete',{database_id = ARGUMENTS.databaseId}) />
        
		<!--- check that we received a valid response --->        
        <cfif resultXML.status.XmlText EQ 1>
        	<!--- we did, return true --->
            <cfreturn true />
        <!--- otherwise --->
        <cfelse>
        	<!--- we didn't, log the error --->
            <cfset logError(resultXML,getFunctionCalledName()) />
            <!--- and return false --->
            <cfreturn false />
        <!--- end checking if we received a valid response --->
        </cfif>
        
    </cffunction>

	<!--- CLEAR DATABASE --->
	<cffunction name="ClearDatabase" access="public" output="false" returntype="boolean" description="I clear all the data in a database based on it's ID.">
    	<cfargument name="databaseId" type="numeric" required="true" hint="I am the database id to clear." />
        
        <cfset var resultXML = DoAPIPost('databases','clear',{database_id = ARGUMENTS.databaseId}) />
        
		<!--- check that we received a valid response --->        
        <cfif resultXML.status.XmlText EQ 1>
        	<!--- we did, return true --->
            <cfreturn true />
        <!--- otherwise --->
        <cfelse>
        	<!--- we didn't, log the error --->
            <cfset logError(resultXML,getFunctionCalledName()) />
            <!--- and return false --->
            <cfreturn false />
        <!--- end checking if we received a valid response --->
        </cfif>
        
    </cffunction>

	<!--- ADD BARCODE VALUE (TO DATABASE) --->
	<cffunction name="AddBarcodeValue" access="public" output="false" returntype="any" description="I add a new barcode to the database based on the data in the passed in barcode object.">
    	<cfargument name="barcodeObj" type="any" required="true" hint="I am the barcode object to add a new barcode for." />
        
        <cfset var resultXML = DoAPIPost('databases','addvalue',{
			database_id = ARGUMENTS.barcodeObj.getDatabaseId(),
			value		= ARGUMENTS.barcodeObj.getBarcodeValue(),
			response	= ARGUMENTS.barcodeObj.getResponse(),
			validity	= ARGUMENTS.barcodeObj.getValidity()
		}) />

		<!--- check that we received a valid response --->        
        <cfif resultXML.status.XmlText EQ 1>
        	<!--- we did, return the id provided by codeREADr --->
            <cfreturn resultXML.id.XmlText />
        <!--- otherwise --->
        <cfelse>
        	<!--- we didn't, log the error --->
            <cfset logError(resultXML,getFunctionCalledName()) />
            <!--- and return zero (0) --->
            <cfreturn 0 />
        <!--- end checking if we received a valid response --->
        </cfif>
        
    </cffunction>
    
	<!--- EDIT BARCODE RESPONSE (IN DATABASE) --->
	<cffunction name="EditBarcodeResponse" access="public" output="false" returntype="boolean" description="I update a barcode reponse and results based on the data in the passed in barcode object.">
    	<cfargument name="barcodeObj" type="any" required="true" hint="I am the barcode object used to update the barcode response and results. I must include the barcode value to update." />
        
        <cfset var resultXML = DoAPIPost('databases','editvalue',{
			database_id = ARGUMENTS.barcodeObj.getDatabaseId(),
			value		= ARGUMENTS.barcodeObj.getBarcodeValue(),
			response	= ARGUMENTS.barcodeObj.getResponse(),
			validity	= ARGUMENTS.barcodeObj.getValidity()
		}) />
        
		<!--- check that we received a valid response --->        
        <cfif resultXML.status.XmlText EQ 1>
        	<!--- we did, return true --->
            <cfreturn true />
        <!--- otherwise --->
        <cfelse>
        	<!--- we didn't, log the error --->
            <cfset logError(resultXML,getFunctionCalledName()) />
            <!--- and return false --->
            <cfreturn false />
        <!--- end checking if we received a valid response --->
        </cfif>
        
    </cffunction>

	<!--- REMOVE BARCODE VALUE (FROM DATABASE) --->
	<cffunction name="RemoveBarcodeValue" access="public" output="false" returntype="boolean" description="I remove a barcode value from the database based on it's value.">
    	<cfargument name="barcodeObj" type="any" required="true" hint="I am the barcode object used to remove the barcode. I must include the barcode value to remove." />
        
        <cfset var resultXML = DoAPIPost('databases','deletevalue',{
			database_id = ARGUMENTS.barcodeObj.getDatabaseId(),
			value 		= ARGUMENTS.barcodeObj.getBarcodeValue()
		}) />
        
		<!--- check that we received a valid response --->        
        <cfif resultXML.status.XmlText EQ 1>
        	<!--- we did, return true --->
            <cfreturn true />
        <!--- otherwise --->
        <cfelse>
        	<!--- we didn't, log the error --->
            <cfset logError(resultXML,getFunctionCalledName()) />
            <!--- and return false --->
            <cfreturn false />
        <!--- end checking if we received a valid response --->
        </cfif>
        
    </cffunction>

	<!--- UPLOAD CSV (TO DATABASE) --->
	<cffunction name="UploadCSV" access="public" output="false" returntype="boolean" description="I upload a CSV file for a database.">
    	<cfargument name="databaseId" type="numeric" required="true" hint="I am the database ID to upload this CSV file into." />
        <cfargument name="csvFile" type="any" required="true" hint="I am the path to the CSV file to upload into the database." />
        
        <cfset var resultXML = DoAPIPost('databases','upload',{
			database_id = ARGUMENTS.databaseId,
			csvfile 	= ARGUMENTS.csvFile
		}) />
        
		<!--- check that we received a valid response --->        
        <cfif resultXML.status.XmlText EQ 1>
        	<!--- we did, return true --->
            <cfreturn true />
        <!--- otherwise --->
        <cfelse>
        	<!--- we didn't, log the error --->
            <cfset logError(resultXML,getFunctionCalledName()) />
            <!--- and return false --->
            <cfreturn false />
        <!--- end checking if we received a valid response --->
        </cfif>
        
    </cffunction>

	<!---                                                               --->
	<!--- SCANS SECTION                                             --->
    <!--- http://help.codereadr.com/help/kb/developer-api/api-scans --->
	<!---                                                               --->

	<!--- GET SCAN LIST --->
	<cffunction name="GetScanList" access="public" returntype="any" description="I return either a single scan object or an array of scan objects depending on how many records are returned.">
		<cfargument name="scanSearchObj" type="string" required="true" hint="I am the scan object containing the data to get scan information for.">
	
    	<!--- set up an array to hold results --->
		<cfset var ScansArray = ArrayNew(1) />
        <!--- set up a counter to put objects in the array --->
        <cfset var ScansCount = 0 />	
        <!--- var scope the elemets needed --->
        <cfset var OuterXmlElement = '' />
        <cfset var InnerXmlElement = '' />
        <cfset var scanObj = '' />
        <!--- Get the XML returned from a call to codeREADr to get scan information --->
		<cfset var resultXML = DoAPIPost('scans','retrieve',{
			keyword = ARGUMENTS.scanSearchObj.getKeyword(),
			service_id = ARGUMENTS.scanSearchObj.getServiceId(),
			device_id = ARGUMENTS.scanSearchObj.getDeviceId(),
			user_id = ARGUMENTS.scanSearchObj.getUserId(),
			status = ARGUMENTS.scanSearchObj.getStatus(),
			start_date = ARGUMENTS.scanSearchObj.getStartDate(),
			start_time = ARGUMENTS.scanSearchObj.getStartTime(),
			end_date = ARGUMENTS.scanSearchObj.getEndDate(),
			end_time = ARGUMENTS.scanSearchObj.getEndTime(),
			upload_id = ARGUMENTS.scanSearchObj.getUploadId(),
			order_by = ARGUMENTS.scanSearchObj.getOrderBy(),
			order_desc = ARGUMENTS.scanSearchObj.getIsDescOrder(),
			limit = ARGUMENTS.scanSearchObj.getLimit(),
			offset = ARGUMENTS.scanSearchObj.getOffset()
			}
		) />

        <!--- loop through the children of the root XML element returned from codeREADr --->
        <cfloop array="#resultXML.XmlChildren#" index="OuterXmlElement">
        
        	<!--- check if this element is a 'scan' element --->
			<cfif OuterXmlElement.XmlName EQ 'scan'>
                <!--- it is, increase the scans counter by 1 --->
                <cfset ScansCount = ScansCount + 1 />
                <!--- create a scan object, passing in the scan id --->
                <cfset scanObj = CreateObject('cfcs.CodeREADr.model.Scan').init(scanId = OuterXmlElement.XmlAttributes.id) />
                <!--- loop through the children of the OuterXmlElement (scan) --->                
                <cfloop array="#OuterXmlElement.XmlChildren#" index="InnerXmlElement">
                	<!--- switch on the name of the element, and add to the appropriate object value --->
                    <cfswitch expression="#InnerXmlElement.XmlName#">
                    
                        <cfcase value="device">
                            <cfset scanObj.setDeviceId(InnerXmlElement.XmlAttributes.id) />
                        </cfcase>

                        <cfcase value="service">
                            <cfset scanObj.setServiceId(InnerXmlElement.XmlAttributes.id) />
                        </cfcase>

                        <cfcase value="user">
                            <cfset scanObj.setUserId(InnerXmlElement.XmlAttributes.id) />
                        </cfcase>
                                          
                        <cfcase value="tid">
                            <cfset scanObj.setBarcode(InnerXmlElement.XmlText) />
                        </cfcase>
                                          
                        <cfcase value="result">
                            <cfset scanObj.setResult(InnerXmlElement.XmlText) />
                        </cfcase>
                                          
                        <cfcase value="timestamp">
                            <cfset scanObj.setTimestamp(InnerXmlElement.XmlText) />
                        </cfcase>
                        
                        <cfcase value="answer">
                            <cfset scanObj.setAnswerQidList(ListAppend(scanObj.getAnswerQidList(),InnerXmlElement.XmlAttributes.qid)) />
                            <cfset scanObj.setAnswerList(ListAppend(scanObj.getAnswerList(),InnerXmlElement.XmlText)) />
                        </cfcase>       
                            
                    </cfswitch>
                    
                <!--- end looping through children of the OuterXmlElement (scan) --->
                </cfloop>
                <!--- add this scan object to the scans array --->
                <cfset ScansArray[ScansCount] = scanObj />
            <!--- end checking if this is a scan --->
            </cfif>
        <!--- end looping through the children of the root XML returned from codeREADr --->
        </cfloop>

		<!--- return the array of scans objects --->
		<cfreturn ScansArray />
                
	</cffunction>

	<!--- DELETE SCAN --->
	<cffunction name="DeleteScan" access="public" output="false" returntype="boolean" description="I delete a scan based on it's ID.">
    	<cfargument name="scanId" type="numeric" required="true" hint="I am the scan id to delete." />
        
        <cfset var resultXML = DoAPIPost('scans','delete',{scan_id = ARGUMENTS.scanId}) />
        
		<!--- check that we received a valid response --->        
        <cfif resultXML.status.XmlText EQ 1>
        	<!--- we did, return true --->
            <cfreturn true />
        <!--- otherwise --->
        <cfelse>
        	<!--- we didn't, log the error --->
            <cfset logError(resultXML,getFunctionCalledName()) />
            <!--- and return false --->
            <cfreturn false />
        <!--- end checking if we received a valid response --->
        </cfif>
        
    </cffunction>

	<!---                                                               --->
	<!--- UPLOADS SECTION                                             --->
    <!--- http://help.codereadr.com/help/kb/developer-api/api-uploads --->
	<!---                                                               --->

	<!--- GET UPLOAD LIST --->
	<cffunction name="GetUploadList" access="public" returntype="any" description="I return either a single upload object or an array of upload objects depending on how many records are returned.">
		<cfargument name="uploadSearchObj" type="string" required="true" hint="I am the upload object containing the data to get upload information for.">
	
    	<!--- set up an array to hold results --->
		<cfset var UploadsArray = ArrayNew(1) />
        <!--- set up a counter to put objects in the array --->
        <cfset var UploadsCount = 0 />	
        <!--- var scope the elemets needed --->
        <cfset var OuterXmlElement = '' />
        <cfset var InnerXmlElement = '' />
        <cfset var uploadObj = '' />
        <!--- Get the XML returned from a call to codeREADr to get upload information --->
		<cfset var resultXML = DoAPIPost('uploads','retrieve',{
			service_id = ARGUMENTS.uploadSearchObj.getServiceId(),
			device_id = ARGUMENTS.uploadSearchObj.getDeviceId(),
			user_id = ARGUMENTS.uploadSearchObj.getUserId(),
			limit = ARGUMENTS.uploadSearchObj.getLimit(),
			offset = ARGUMENTS.uploadSearchObj.getOffset()
			}
		) />

        <!--- loop through the children of the root XML element returned from codeREADr --->
        <cfloop array="#resultXML.XmlChildren#" index="OuterXmlElement">
        
        	<!--- check if this element is a 'upload' element --->
			<cfif OuterXmlElement.XmlName EQ 'upload'>
                <!--- it is, increase the uploads counter by 1 --->
                <cfset UploadsCount = UploadsCount + 1 />
                <!--- create a upload object, passing in the upload id --->
                <cfset uploadObj = CreateObject('cfcs.CodeREADr.model.Upload').init(
					uploadId 	= OuterXmlElement.XmlAttributes.id,
					deviceId	= OuterXmlElement.XmlAttributes.device_id,
					serviceId	= OuterXmlElement.XmlAttributes.service_id,
					userId		= OuterXmlElement.XmlAttributes.user_id,
					status		= OuterXmlElement.XmlAttributes.status,
					count		= OuterXmlElement.XmlAttributes.count,
					timestamp	= OuterXmlElement.XmlAttributes.timestamp
					) />
                
                <!--- add this upload object to the uploads array --->
                <cfset UploadsArray[UploadsCount] = uploadObj />
            <!--- end checking if this is a upload --->
            </cfif>
        <!--- end looping through the children of the root XML returned from codeREADr --->
        </cfloop>
        
		<!--- return the array of uploads objects --->
		<cfreturn UploadsArray />
                
	</cffunction>


<!--- UTILITY FUNCTIONS --->

	<!--- SEARCH FOR SERVICE --->
	<cffunction name="SearchForService" access="public" output="false" returntype="numeric" description="I search through service records to find the id of a passed in serviceName.">
		<cfargument name="serviceName" type="string" required="true" hint="I am the serviceName of the service id to retrieve."/>
		
        <!--- get the service list array from the API --->
		<cfset var serviceArray = GetServiceList() />
        <!--- var scope additional variables used --->
        <cfset var iX = '' />
		<cfset var thisServiceID = 0 />
        
        <!--- loop through the services in the service list array --->
		<cfloop from="1" to="#ArrayLen(serviceArray)#" index="iX">
			<!--- check if this object is the object of the service we're searching for --->
			<cfif serviceArray[iX].getServiceName() EQ ARGUMENTS.serviceName>
				<!--- it is, set the service id to this objects service id value --->
				<cfset thisServiceId = serviceArray[iX].getServiceId() />
			<!--- end checking if this object is the object of the service we're searching for --->   
			</cfif>
		<!--- end looping through the services in the service list array --->	
		</cfloop>
        
        <!--- return the service id, if found, or zero, if not found --->
		<cfreturn thisServiceId />
        
	</cffunction>

	<!--- SEARCH FOR USER --->
	<cffunction name="SearchForUser" access="public" output="false" returntype="numeric" description="I search through user records to find the id of a passed in username.">
		<cfargument name="username" type="string" required="true" hint="I am the username of the user id to retrieve."/>
		
        <!--- get the user list array from the API --->
		<cfset var userArray = GetUserList() />
        <!--- var scope additional variables used --->
        <cfset var iX = '' />
		<cfset var thisUserID = 0 />
                
        <!--- loop through the users in the user list array --->
		<cfloop from="1" to="#ArrayLen(userArray)#" index="iX">
        	<!--- check if this object is the object of the user we're searching for --->
			<cfif userArray[iX].getUsername() EQ ARGUMENTS.username>
				<!--- it is, set the user id to this objects user id value --->
				<cfset thisUserId = userArray[iX].getUserId() />
			<!--- end checking if this object is the object of the user we're searching for --->   
			</cfif>
		<!--- end looping through the users in the user list array --->	
		</cfloop>
        
        <!--- return the user id, if found, or zero, if not found --->
		<cfreturn thisUserId />
        
	</cffunction>

	<!--- SEARCH FOR DATABASE --->
	<cffunction name="SearchForDatabase" access="public" output="false" returntype="numeric" description="I search through database records to find the id of a passed in databaseName.">
		<cfargument name="databaseName" type="string" required="true" hint="I am the databaseName of the database id to retrieve."/>
		
        <!--- get the database list array from the API --->
		<cfset var databaseArray = GetDatabaseList() />
        <!--- var scope additional variables used --->
        <cfset var iX = '' />
		<cfset var thisDatabaseID = 0 />
        
        <!--- loop through the databases in the database list array --->
		<cfloop from="1" to="#ArrayLen(databaseArray)#" index="iX">
			<!--- check if this object is the object of the database we're searching for --->
			<cfif databaseArray[iX].getDatabaseName() EQ ARGUMENTS.databaseName>
				<!--- it is, set the database id to this objects database id value --->
				<cfset thisDatabaseId = databaseArray[iX].getDatabaseId() />
			<!--- end checking if this object is the object of the database we're searching for --->   
			</cfif>
		<!--- end looping through the databases in the database list array --->	
		</cfloop>
        
        <!--- return the database id, if found, or zero, if not found --->
		<cfreturn thisDatabaseId />
        
	</cffunction>

<!--- PRIVATE FUNCTIONS --->

<!--- DO API POST --->
<cffunction name="DoAPIPost" access="private" output="false" returntype="any" description="I handle all HTTP POST calls to the codeREADr API.">
	<cfargument name="section" type="string" required="true" hint="I am the section of the API being called." />
	<cfargument name="action" type="string" required="true" hint="I am the action to be taken on the section of the API being called." />
	<cfargument name="params" type="any" required="false" default="#StructNew()#" hint="I am the required and optional parameters of this call to the API." />

	<!--- var scope --->
	<cfset var httpResult = "">
	<cfset var param = "">

	<!--- Make the HTTP POST call to the codeREADr API --->
	<cfhttp url="#variables.instance.APIURL#" method="post" result="httpResult" resolveurl="true" timeout="9999">
		<cfhttpparam type="formfield" name="api_key" value="#variables.instance.APIKey#">
		<cfhttpparam type="formfield" name="section" value="#ARGUMENTS.section#">
		<cfhttpparam type="formfield" name="action" value="#ARGUMENTS.action#">
        <!--- loop through the required and optional parameters, if any --->
		<cfloop collection="#ARGUMENTS.params#" item="param">
        	<!--- check if this parameter is a CSV file --->
			<cfif param eq "csvfile">
            	<!--- it is, set the file httpparam type and pass in the file path --->
				<cfhttpparam type="file" file="#ARGUMENTS.params[param]#" name="#LCase(param)#">
			<!--- otherwise --->
			<cfelse>
            	<!--- check that this parameter is not blank --->
                <cfif params[param] NEQ "">
                	<!--- it ism't, set the formfield httpparam type and pass in the name/value --->
					<cfhttpparam type="formfield" name="#LCase(param)#" value="#ARGUMENTS.params[param]#">
                 <!--- end checking if this parameter is blank --->
                </cfif>
            <!--- end checking if this parameter is a CSV file --->    
			</cfif>
        <!--- end looping through the required and optional parameters, if any --->
		</cfloop>
	</cfhttp>

	<!--- try to parse the returned data --->
	<cftry>
	<!--- check if we're generating a barcode (by checking if we've sent a 'barcode' section --->
	<cfif ARGUMENTS.section NEQ 'barcode'>
    	<!--- we haven't, parse and return the root node of the XML returned from codeREADr --->
		<cfreturn XmlParse(Trim(httpResult.FileContent)).XmlRoot>
    <!--- otherwise --->
	<cfelse>
    	<!--- we have a barcode, return the byte array (binary) version of the barcode --->
		<cfreturn httpResult.FileContent.toByteArray() />
    <!--- end checking if we're generating a barcode --->
	</cfif>
    <!--- catch any errors - the codeREADr API regularly returns 301 http status codes when accessing the API for the first time --->
    <cfcatch type="any">
    	<!--- and return the results from a secondary try to post the data --->
    	<cfreturn DoSecondaryAPIPost(ARGUMENTS.section,ARGUMENTS.action,ARGUMENTS.params,cfcatch.Message) />
    </cfcatch>
    </cftry>
    
</cffunction>

<!--- DO SECONDARY API POST --->
<cffunction name="DoSecondaryAPIPost" access="private" output="false" returntype="any" description="I handle all HTTP POST calls to the codeREADr API.">
	<cfargument name="section" type="string" required="true" hint="I am the section of the API being called." />
	<cfargument name="action" type="string" required="true" hint="I am the action to be taken on the section of the API being called." />
	<cfargument name="params" type="any" required="false" default="#StructNew()#" hint="I am the required and optional parameters of this call to the API." />
    <cfargument name="origError" type="string" required="false" default="unknown" hint="I am the original error from the first pass." />

	<!--- var scope --->
	<cfset var httpResult = "">
	<cfset var param = "">

	<!--- Make the HTTP POST call to the codeREADr API --->
	<cfhttp url="#variables.instance.APIURL#" method="post" result="httpResult" resolveurl="true" timeout="9999">
		<cfhttpparam type="formfield" name="api_key" value="#variables.instance.APIKey#">
		<cfhttpparam type="formfield" name="section" value="#ARGUMENTS.section#">
		<cfhttpparam type="formfield" name="action" value="#ARGUMENTS.action#">
        <!--- loop through the required and optional parameters, if any --->
		<cfloop collection="#ARGUMENTS.params#" item="param">
        	<!--- check if this parameter is a CSV file --->
			<cfif param eq "csvfile">
            	<!--- it is, set the file httpparam type and pass in the file path --->
				<cfhttpparam type="file" file="#ARGUMENTS.params[param]#" name="#LCase(param)#">
			<!--- otherwise --->
			<cfelse>
            	<!--- check that this parameter is not blank --->
                <cfif params[param] NEQ "">
                	<!--- it ism't, set the formfield httpparam type and pass in the name/value --->
					<cfhttpparam type="formfield" name="#LCase(param)#" value="#ARGUMENTS.params[param]#">
                 <!--- end checking if this parameter is blank --->
                </cfif>
            <!--- end checking if this parameter is a CSV file --->    
			</cfif>
        <!--- end looping through the required and optional parameters, if any --->
		</cfloop>
	</cfhttp>

	<!--- try to parse the returned data --->
	<cftry>
	<!--- check if we're generating a barcode (by checking if we've sent a 'barcode' section --->
	<cfif ARGUMENTS.section NEQ 'barcode'>
    	<!--- we haven't, parse and return the root node of the XML returned from codeREADr --->
		<cfreturn XmlParse(Trim(httpResult.FileContent)).XmlRoot>
    <!--- otherwise --->
	<cfelse>
    	<!--- we have a barcode, return the byte array (binary) version of the barcode --->
		<cfreturn httpResult.FileContent.toByteArray() />
    <!--- end checking if we're generating a barcode --->
	</cfif>
    <!--- catch any errors --->
    <cfcatch type="any">
    	<!--- create the error xml --->
        <cfsavecontent variable="resultXML">
            <?xml version="1.0" encoding="UTF-8" ?>
            <xml>
              <status>0</status>
              <error code="911">Failed secondary API post to codeREADr API. This error: #cfcatch.Message#. Root error: #ARGUMENTS.origError#</error>
            </xml>
        </cfsavecontent>
    	<!--- log the error --->
        <cfset logError(resultXML,getFunctionCalledName()) />
        <!--- and throw an error --->
    	<cfthrow message="Failed secondary API post to codeREADr API. This error: #cfcatch.Message#. Root error: #ARGUMENTS.origError#" type="exception" errorcode="911" />
    </cfcatch>
    </cftry>
    
</cffunction>

<!--- LOG ERROR --->
<cffunction name="logError" access="private" output="false" returntype="void" description="I log any errors that occur in the API to a log named 'codeREADr'.">
	<cfargument name="resultXML" type="xml" required="true" hint="I am the XML with the error to parse." />
    <cfargument name="functionName" type="string" required="false" default="" hint="I am the name of the function the threw this error." />
    
    <!--- try --->
    <cftry>
    	<!--- log the error number and message returned by the codeREADr API --->
        <cflog text="[#ARGUMENTS.resultXML.error.XmlAttributes.code#] - #ARGUMENTS.resultXML.error.XmlText# - #ARGUMENTS.functionName#" type="Error" file="codeREADr" thread="yes" date="yes" time="yes" application="yes" />
  	<!--- catch any unhandled exceptions (e.g. the code or message isn't present) --->
    <cfcatch type="any">
    	<!--- and log the unhandled exception instead --->
        <cflog text="[911] - An unhandled exception occurred in the codeREADr API: #cfcatch.Message#" type="Error" file="codeREADr" thread="yes" date="yes" time="yes" application="yes" />
    </cfcatch>
    </cftry>
    
</cffunction>

</cfcomponent>