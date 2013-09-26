<!--- Example Usage                                                                           --->
<!--- =============                                                                           --->
<!---                                                                                         --->
<!--- This code gives an example implementation of using CodeREADr for scanning tickets or    --->
<!--- RFID devices based on ticket holders in a database. The code searches for a single      --->
<!--- eventId passed in on the URL, and processes that event, or scans a table of events for  --->
<!--- all events that will open within an hour and processes event data for each event.       --->
<!--- The event is processed with multiple device and service users, multiple services and    --->
<!--- databases per service (events) and multiple ticket holders per database. Code to check  --->
<!--- for the existence of each item in both CodeREADr and the database is included for a     --->
<!--- well rounded example of the processes involved with using the CodeREADr API with the    --->
<!--- CodeREADr service.                                                                      --->
<!---                                                                                         --->
<!--- NOTE: This is sample code only and will not execute without proper development of the   --->
<!--- database and applicable Application.cfc code. This code is not meant to execute, but to --->
<!--- serve only as one example of how to implement the CodeREADr API in ColdFusion. You will --->
<!--- want to modify this code, or replicate it's functionality, for your own purposes.       --->
<!---                                                                                         --->
<!--- Written by Denard Springle (denard.springle@gmail.com) of Virtual Solutions Group, LLC  --->
<!--- http://www.vsgcom.net/. This work is licensed under a Creative Commons                  --->
<!--- Attribution-ShareAlike 3.0 Unported License.                                            --->
<!---                                                                                         --->
<!--- Source code available on GitHub:                                                        --->
<!--- https://github.com/ddspringle/cfCodeREADr                                               --->
<!---                                                                                         --->

<cfparam name="URL.eventId" default="">

<!--- get any left-over csv files --->
<cfdirectory action="list" directory="#ExpandPath('.')#" name="thisDir" filter="*.csv" type="file">
<!--- loop through the csv files --->
<cfloop query="thisDir">
	<!--- remove the csv files --->
    <cffile action="delete" file="#ExpandPath(thisDir.name)#">
<!--- end looping through left-over csv files --->
</cfloop>

<!--- check if a specific event id has been passed in --->
<cfif IsNumeric(URL.eventId)>

	<!--- process the codereadr database upload for this specific event --->
	<cfset DoCodeREADr(eventId = URL.eventId)>    
	
<!--- otherwise --->
<cfelse>

	<!--- get all the venue users --->
    <cfquery name="qGetUsers" datasource="#APPLICATION.DSN#">
        SELECT userName, userId
        FROM Users
        WHERE useCR = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
        ORDER BY userName
    </cfquery>
        
    <cfset addedStruct = StructNew() />
    <cfset clearedStruct = StructNew() />
    
    <!--- loop through the venue users --->
    <cfloop query="qGetUsers">
   
		<!--- query events whose doors open within the next hour --->
        <cfquery name="qGetCurrentEvents" datasource="#APPLICATION.DSN#">
            SELECT eventId, eventName, customInfo
            FROM Events
            WHERE userId = <cfqueryparam value="#qGetUsers.userId#" cfsqltype="cf_sql_integer" />
            AND eventStart >= <cfqueryparam value="#DateFormat(Now(),'yyyy-mm-dd')# 00:00:00.000" cfsqltype="cf_sql_timestamp" />
            AND eventStart <= <cfqueryparam value="#DateFormat(Now(),'yyyy-mm-dd')# 23:59:59.000" cfsqltype="cf_sql_timestamp" />
        </cfquery>

		<!--- loop through the current shows for this user --->        
		<cfloop query="qGetCurrentEvents">
            
			<!--- set up a comparison time based on the current date plus a time translation from the customInfo field value --->
			<cfset timeToCompare = "#DateFormat(Now(),'yyyy-mm-dd')# #TimeFormat(qGetCurrentEvents.customInfo,'HH:mm:ss')#" />
                
			<!--- check if the minutes remaining before the doors open for this event is less than X --->
			<cfif DateDiff('n',Now(),timeToCompare) LTE (REQUEST.minutesBeforeCodereadrPush+5) AND DateDiff('n',Now(),timeToCompare) GTE (REQUEST.minutesBeforeCodereadrPush-5)>
				
				<!--- process the codereadr database upload for this specific event --->
				<cfset DoCodeREADr(qGetCurrentEvents.eventId)>
                <cfset addedStruct[qGetCurrentEvents.eventId] = qGetCurrentEvents.eventName />
            
            <!--- end checking if the minutes remaining before the doors open for this event is less than X --->        
			</cfif>
        
        <!--- end looping through the current shows for this user --->         
		</cfloop>
    
    	<!--- query events whose doors opened 24 hours ago --->
        <cfquery name="qGetExpiredEvents" datasource="#APPLICATION.DSN#">
            SELECT eventId, eventName, customInfo
            FROM Events 
            WHERE userId = <cfqueryparam value="#qGetUsers.userId#" cfsqltype="cf_sql_integer" />
            AND eventStart >= <cfqueryparam value="#DateFormat(DateAdd('d',-1,Now()),'yyyy-mm-dd')# 00:00:00.000" cfsqltype="cf_sql_timestamp" />
            AND eventStart <= <cfqueryparam value="#DateFormat(DateAdd('d',-1,Now()),'yyyy-mm-dd')# 23:59:59.000" cfsqltype="cf_sql_timestamp" />
        </cfquery>
		<!--- loop through the expired shows for this user --->        
		<cfloop query="qGetExpiredEvents">
            
			<!--- set up a comparison time based on the current date plus a time translation from the customInfo field value --->
			<cfset timeToCompare = "#DateFormat(Now(),'yyyy-mm-dd')# #TimeFormat(qGetExpiredEvents.customInfo,'HH:mm:ss')#" />
                
			<!--- check if the minutes remaining before the doors open for this event is less than X --->
			<cfif DateDiff('n',Now(),timeToCompare) LTE (REQUEST.minutesBeforeCodereadrPush+5) AND DateDiff('n',Now(),timeToCompare) GTE (REQUEST.minutesBeforeCodereadrPush-5)>
				
				<!--- process the codereadr database upload for this specific event --->
				<cfset ClearCodeREADrService(qGetExpiredEvents.eventId)>
                <cfset clearedStruct[qGetExpiredEvents.eventId] = qGetExpiredEvents.eventName />
            
            <!--- end checking if the minutes remaining before the doors open for this event is less than X --->        
			</cfif>
        
        <!--- end looping through the expied shows for this user --->         
		</cfloop>
    
    <!--- end looping through the venue users --->        
    </cfloop>

<!--- check if anything was added or removed --->
<cfif NOT StructIsEmpty(addedStruct) OR NOT StructIsEmpty(clearedStruct)>
	<!--- it was, email me and todd with the details --->
    <cfmail to="denard.springle@gmail.com" cc="to" from="codereadr@codereadr.com" subject="CodeREADr Results #DateFormat(Now(),'mm.dd.yyyy')# #TimeFormat(Now(),'hh:mm tt')#" priority="3" charset="utf-8" type="html">
    <cfif NOT StructIsEmpty(addedStruct)>
    	<h3>Events added to CodeREADr</h3>
        <cfdump var="#addedStruct#" label="Added to CodeREADr">
    </cfif>
    <cfif NOT StructIsEmpty(clearedStruct)>
    	<h3>Events removed from CodeREADr</h3>
        <cfdump var="#clearedStruct#" label="Cleared from CodeREADr">
    </cfif>
    </cfmail>
</cfif>


<!--- end checking if a specific event id has been passed in --->
</cfif>
	
    
<!--- PRIVATE FUNCTIONS --->

<!--- DO CODEREADR --->
<cffunction name="DoCodeREADr" access="private" output="false" returntype="void" description="I run the processes for each event to populate and upload the database to the CodeREADr API.">
	<cfargument name="eventId" type="numeric" required="true" hint="I am the event ID to use for populating a service and database for this user." />
    
    <cfset var codeREADrService = CreateObject('CodeREADr.API').init() />
    <cfset var qGetEvent = '' />
    <cfset var qUpdEvent = '' />
    <cfset var qGetUser = '' />
    <cfset var qUpdUser = '' />
    <cfset var qGetOrders = '' />
    <cfset var thisUserId = 0 />
    <cfset var userObj = '' />    
    <cfset var thisDatabaseId = 0 />
    <cfset var databaseObj = '' />
	<cfset var thisServiceId = 0 />
    <cfset var serviceObj = '' />
    <cfset var thisEventDetail = '' />
    <cfset var thisCSVFile = '' />
    <cfset var iX = 0 />
    <cfset var suffix = Left(Encrypt(Hash(ARGUMENTS.eventId,'SHA-512'),'rA81n0perOsB23tszdXeXQ==','BLOWFISH','HEX'),8) />
	<cfset var memId = 0 />
    
	<!--- get the information for this event --->
    <cfquery name="qGetEvent" datasource="#APPLICATION.DSN#">
        SELECT eventName, userId, crDatabaseId, crServiceId, eventStart
        FROM Events
        WHERE eventId = <cfqueryparam value="#ARGUMENTS.eventId#" cfsqltype="cf_sql_integer" />
	</cfquery>
    
    <!--- get the CodeREADr user id for this event --->
    <cfquery name="qGetUser" datasource="#APPLICATION.DSN#">
        SELECT userName, userId, crUserId
        FROM Users
        WHERE userId = <cfqueryparam value="#qGetEvent.userId#" cfsqltype="cf_sql_integer" />
	</cfquery>
    
    <!--- check if we have a valid CodeREADr user id stored (legacy code did not) --->
    <cfif NOT IsNumeric(qGetUser.crUserId) OR qGetUser.crUserId EQ 0>
    
    	<!--- no valid CodeREADr user id exists yet, generate the userName --->
        <cfset thisUser = "prepend." & CleanForCodeREADr(qGetUser.userName) />
    
    	<!--- search for this user's id with the CodeREADr API --->
        <cfset thisUserId = codeREADrService.SearchForUser(userName = thisUser) />
        
        <!--- check if a user id was found --->
        <cfif thisUserId EQ 0>
        
        	<!--- it wasn't, we'll have to create the user object --->
            <cfset userObj = CreateObject('component','CodeREADr.model.User').init(
				userName	= thisUser,
				password	= Left(Hash(qGetUser.userName),6)
			) />
            
            <!--- and then create the user --->
            <cfset thisUserId = codeREADrService.CreateUser(userObj) />
        
        <!--- end checking if a user id was found --->    
        </cfif>
        
        <!--- check if a user id was returned --->
        <cfif thisUserId NEQ 0>
        
			<!--- it was, update the account database with the user id so we don't have to do all this in the future :) --->
            <cfquery name="qUpdUser" datasource="#APPLICATION.DSN#">
                UPDATE Account
                SET crUserId = <cfqueryparam value="#thisUserId#" cfsqltype="cf_sql_integer" />
                WHERE userId = <cfqueryparam value="#qGetUser.userId#" cfsqltype="cf_sql_integer" />
            </cfquery>
    	
        <!--- otherwise --->
    	<cfelse>
        	
            <!--- throw an error --->
            <cfthrow message="User ID could not be retrieved from the CodeREADr API." type="exception" errorcode="911" />
        
        <!--- end checking if a user id was returned --->
        </cfif>
    
    <!--- otherwise --->
    <cfelse>
    
    	<!--- we do have a valid CodeREADr user id stored, so use it --->
        <cfset thisUserId = qGetUser.crUserId />
    
    <!--- end checking if we have a valid CodeREADr user id stored (legacy code did not) --->
    </cfif>


    <!--- check if we have a valid CodeREADr database id stored (legacy code did not) --->
    <cfif NOT IsNumeric(qGetEvent.crDatabaseId) OR qGetEvent.crDatabaseId EQ 0>
    
    	<!--- no valid CodeREADr database id exists yet, generate the databaseeventName --->
        <cfset thisDatabase = CleanForCodeREADr(qGetEvent.eventName & '___' & suffix) />
    
    	<!--- search for this database's id with the CodeREADr API --->
        <cfset thisDatabaseId = codeREADrService.SearchForDatabase(databaseeventName = thisDatabase) />
        
        <!--- check if a database id was found --->
        <cfif thisDatabaseId EQ 0>
        
        	<!--- it wasn't, we'll have to create the database object --->
            <cfset databaseObj = CreateObject('component','CodeREADr.model.Database').init(databaseeventName = thisDatabase) />
            
            <!--- and then create the database --->
            <cfset thisDatabaseId = codeREADrService.CreateDatabase(databaseObj) />
        
        <!--- end checking if a database id was found --->    
        </cfif>
        
        <!--- check if a database id was returned --->
        <cfif thisDatabaseId NEQ 0>
        
			<!--- it was, update the account database with the database id so we don't have to do all this in the future :) --->
            <cfquery name="qUpdEvent" datasource="#APPLICATION.DSN#">
                UPDATE Events
                SET crDatabaseId = <cfqueryparam value="#thisDatabaseId#" cfsqltype="cf_sql_integer" />
                WHERE eventId = <cfqueryparam value="#ARGUMENTS.eventId#" cfsqltype="cf_sql_integer" />
            </cfquery>
    	
        <!--- otherwise --->
    	<cfelse>
        	
            <!--- throw an error --->
            <cfthrow message="Database ID could not be retrieved from the CodeREADr API." type="exception" errorcode="911" />
        
        <!--- end checking if a database id was returned --->
        </cfif>
    
    <!--- otherwise --->
    <cfelse>
    
    	<!--- we do have a valid CodeREADr database id stored, so use it --->
        <cfset thisDatabaseId = qGetEvent.crDatabaseId />
    
    <!--- end checking if we have a valid CodeREADr database id stored (legacy code did not) --->
    </cfif>

    <!--- check if we have a valid CodeREADr service id stored (legacy code did not) --->
    <cfif NOT IsNumeric(qGetEvent.crServiceId) OR qGetEvent.crServiceId EQ 0>
    
    	<!--- no valid CodeREADr service id exists yet, generate the serviceeventName --->
        <cfset thisService = CleanForCodeREADr(DateFormat(qGetEvent.eventStart,'mm.dd.yyyy') & '___' & qGetEvent.eventName & '___' & suffix) />
    
    	<!--- search for this service's id with the CodeREADr API --->
        <cfset thisServiceId = codeREADrService.SearchForService(serviceeventName = thisService) />
        
        <!--- check if a service id was found --->
        <cfif thisServiceId EQ 0>
        
			<!--- it wasn't, we'll have to create the service object --->
            <cfset serviceObj = CreateObject('component','CodeREADr.model.Service').init(
                serviceeventName	= thisService,
                validationMethod 	= 'ondevicedatabase',
                databaseId			= thisDatabaseId,
                duplicateScanValue	= 0,
                viewOtherScans		= 1
            ) />
            
            <!--- and then create the service --->
            <cfset thisServiceId = codeREADrService.CreateService(serviceObj) />
        
        <!--- end checking if a service id was found --->    
        </cfif>
        
        <!--- check if a service id was returned --->
        <cfif thisServiceId NEQ 0>
        
			<!--- it was, update the account service with the service id so we don't have to do all this in the future :) --->
            <cfquery name="qUpdEvent" datasource="#APPLICATION.DSN#">
                UPDATE Events
                SET crServiceId = <cfqueryparam value="#thisServiceId#" cfsqltype="cf_sql_integer" />
                WHERE eventId = <cfqueryparam value="#ARGUMENTS.eventId#" cfsqltype="cf_sql_integer" />
            </cfquery>
    	
        <!--- otherwise --->
    	<cfelse>
        	
            <!--- throw an error --->
            <cfthrow message="Service ID could not be retrieved from the CodeREADr API." type="exception" errorcode="911" />
        
        <!--- end checking if a service id was returned --->
        </cfif>
    
    <!--- otherwise --->
    <cfelse>
    
    	<!--- we do have a valid CodeREADr service id stored, so use it --->
        <cfset thisServiceId = qGetEvent.crServiceId />
    
    <!--- end checking if we have a valid CodeREADr service id stored (legacy code did not) --->
    </cfif>
        
	<!--- assign this user to this service --->
    <cfset codeREADrService.AddServiceUser(
		serviceId	= thisServiceId,
		userIdList	= thisUserId
	) />

	<!--- clear the database of previous records --->
	<cfset codeREADrService.ClearDatabase(thisDatabaseId) />
                
	<!--- set only cfoutput to eliminate white space --->
	<cfsetting enablecfoutputonly="true" />
				
	<!--- save the output to a variable --->
	<cfsavecontent variable="thisEventDetail">
        
		<!--- it is, get the orders for this event --->
		<cfquery name="qGetOrders" datasource="#APPLICATION.DSN#">
			SELECT 		qty, barcode, ticketHolder, membershipId
			FROM 		vw_TicketHoldersList
			WHERE 		eventId = <cfqueryparam value="#ARGUMENTS.eventId#" cfsqltype="cf_sql_integer" />
		</cfquery>
                
		<!--- loop through the orders --->
		<cfloop query="qGetOrders">
        
			<!--- set a temporary member id to zero --->
        	<cfset memId = 0 />
			<!--- check if we have a valid membership id for this ticket holder --->
            <cfif qGetOrders.membershipId NEQ "">
				<!--- we do, assign the membership id --->
            	<cfset memId = qGetOrders.membershipId />
            </cfif>
        
        	<!--- get the RFID for this order (if any) --->
			<cfquery name="qGetRFID" datasource="#APPLICATION.DSN#">
            	SELECT rfidCode, ticketNumber
                FROM rfidMemberships 
                WHERE membershipId = <cfqueryparam value="#memId#" cfsqltype="cf_sql_integer" />
            </cfquery> 
        
        	<!--- get the unclaimed claim keys for this order (if any) --->            
			<cfquery name="qGetClaimKey" datasource="#APPLICATION.DSN#">
            	SELECT claimKey, ticketId
                FROM claimableTickets
                WHERE membershipId = <cfqueryparam value="#memId#" cfsqltype="cf_sql_integer" />
                AND isClaimed = <cfqueryparam value="0" cfsqltype="cf_sql_bit" />
            </cfquery>
            
            <!--- set up a list of ticket numbers to search through --->
            <cfset claimTicketIds = ValueList(qGetClaimKey.ticketId) />
            
			<!--- loop through the quantity of tickets --->
			<cfloop index="iX" from="1" to="#qGetOrders.qty#">
            
            	<!--- check if this ticket has an associated RFID ticket --->
            	<cfif qGetRFID.RecordCount AND qGetRFID.ticketNumber EQ iX>
                
                	<!--- output the RFID serial number instead of a barcode --->
					<cfoutput>#qGetRFID.rfidCode#,#Replace(qGetOrders.ticketHolder,',','','ALL')##chr(13)#</cfoutput>
                    
                <!--- otherwise, check if this ticket has an associated claim key --->
                <cfelseif NOT ListFind(claimTicketIds,iX)>
                
					<!--- it doesn't, so this is a print at home ticket --->
                    <cfoutput>#qGetOrders.barcode##NumberFormat(iX,'00')#,#Replace(qGetOrders.ticketHolder,',','','ALL')##IIF(iX GT 1, DE(' guest ' & (iX - 1)), '')##chr(13)#</cfoutput>
                    
                <!--- end checking if this ticket has an associated RFID ticket --->
                </cfif>
                    
			<!--- end looping through quantity of tickets --->    
        	</cfloop>
		<!--- end looping through the orders --->
		</cfloop>               
            
	<!--- end saving the content to thisEventDetail --->
	</cfsavecontent>
                
	<!--- set cfoutput only back to false --->
	<cfsetting enablecfoutputonly="false" />
        
	<!--- check if there are details to push --->
	<cfif thisEventDetail NEQ "">
        
		<!--- set the filename for this CSV file --->
		<cfset thisCSVFile = ExpandPath('#DateFormat(Now(),'yyyymmdd')##TimeFormat(Now(),'HHmmss')#_#Left(Hash(thisDatabaseId,'SHA-512'),10)#.csv') />
        
		<!--- Write barcodes to CSV format --->
		<cffile action="write" fixnewline="true" file="#thisCSVFile#" output="#Trim(thisEventDetail)#" addnewline="false">
            
		<!--- Push CSV file to Codereadr --->
		<cfset codeREADrService.UploadCSV(
			databaseId 	= thisDatabaseId,
			csvFile		= thisCSVFile
		)>
        
	<!--- end checking if there are details to push --->
	</cfif>
    
</cffunction>


<!--- CLEAR CODEREADR SERVICE --->
<cffunction name="ClearCodeREADrService" access="private" output="false" returntype="void" description="I remove expired services and migrate the services database to the 'archive' service.">
	<cfargument name="eventId" type="numeric" required="true" hint="I am the event ID to use for populating a service and database for this user." />
    
    <cfset var codeREADrService = CreateObject('CodeREADr.API').init() />
    <cfset var qGetEvent = '' />
    <cfset var qUpdEvent = '' />

	<!--- get the information for this event --->
    <cfquery name="qGetEvent" datasource="#APPLICATION.DSN#">
        SELECT crDatabaseId, crServiceId
        FROM Events
        WHERE eventId = <cfqueryparam value="#ARGUMENTS.eventId#" cfsqltype="cf_sql_integer" />
	</cfquery>
    
    <!--- check if the existing database id is not zero (0) --->
    <cfif qGetEvent.crServiceId>
		<!--- it is not zero, delete the service on codeREADrServiceEADr --->
        <cfset codeREADrService.DeleteService(qGetEvent.crServiceId) />
    </cfif>
    
	<!--- check if the existing database id is not zero (0) --->
    <cfif qGetEvent.crDatabaseId>
		<!--- it is not zero, delete the database on codeREADrServiceEADr --->
        <cfset codeREADrService.DeleteDatabase(qGetEvent.crDatabaseId) />
	</cfif>
    
	<!--- reset the service and database id for this event in the database to zero (0) --->
	<cfquery name="qUpdEvent" datasource="#APPLICATION.DSN#">
		UPDATE Events
		SET crServiceId = <cfqueryparam value="0" cfsqltype="cf_sql_integer" />,
        crDatabaseId = <cfqueryparam value="0" cfsqltype="cf_sql_integer" />		
    	WHERE eventId = <cfqueryparam value="#ARGUMENTS.eventId#" cfsqltype="cf_sql_integer" />
	</cfquery>    
    
</cffunction>


<!--- CLEAN FOR CODEREADR --->
<cffunction name="CleanForCodeREADr" access="private" output="false" returntype="string" description="I clean up any textual data sent to CodeREADr (e.g. userName, database and service names, etc.)">
	<cfargument name="stringInput" type="string" required="true" hint="I am the string of data to clean up for CodeREADr" />
    
    <!--- replace all non alpha-numeric characters with an underscore ( _ ) ---> 
    <cfreturn ReReplaceNoCase(ARGUMENTS.stringInput,'[^0-9a-z_]','_','ALL') />
    
</cffunction>