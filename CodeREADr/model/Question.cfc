<!--- Question Model                                                                          --->
<!--- ==============                                                                          --->
<!---                                                                                         --->
<!--- Written by Denard Springle (denard.springle@gmail.com) of Virtual Solutions Group, LLC  --->
<!--- http://www.vsgcom.net/. This work is licensed under a Creative Commons                  --->
<!--- Attribution-ShareAlike 3.0 Unported License.                                            --->
<!---                                                                                         --->
<!--- Source code available on GitHub:                                                        --->
<!--- https://github.com/ddspringle/cfCodeREADr                                               --->
<!---                                                                                         --->

<cfcomponent displayname="Question" output="false" hint="">
<cfproperty name="questionId" type="string" default="" />
<cfproperty name="text" type="string" default="" />
<cfproperty name="type" type="string" default="" />
<cfproperty name="answerIdList" type="string" default="" />
<cfproperty name="answerTextList" type="string" default="" />

<!--- pseudo-contructor --->
<cfset variables.instance = {
			questionId = '',
			text = '',
			type = '',
			answerIdList = '',
			answerTextList = ''
	} />
<cffunction name="init" access="public" output="false" returntype="any" hint="">
  <cfargument name="questionId" type="string" required="true" default="" hint="" />
  <cfargument name="text" type="string" required="true" default="" hint="" />
  <cfargument name="type" type="string" required="true" default="" hint="" />
  <cfargument name="answerIdList" type="string" required="true" default="" hint="" />
  <cfargument name="answerTextList" type="string" required="true" default="" hint="" />
  
  <!--- set the initial values of the bean --->
  <cfscript>
  	setQuestionId(ARGUMENTS.questionId);
  	setText(ARGUMENTS.text);
  	setType(ARGUMENTS.type);
	setAnswerIdList(ARGUMENTS.answerIdList);
	setAnswerTextList(ARGUMENTS.answerTextList);
  </cfscript>
  <cfreturn this>
</cffunction>

<!--- setters --->
<cffunction name="setQuestionId" access="public" output="false" hint="">
  <cfargument name="questionId" type="string" required="true" default="" hint="" />
  <cfset variables.instance.questionId = ARGUMENTS.questionId />
</cffunction>

<cffunction name="setText" access="public" output="false" hint="">
  <cfargument name="text" type="string" required="true" default="" hint="" />
  <cfset variables.instance.text = ARGUMENTS.text />
</cffunction>

<cffunction name="setType" access="public" output="false" hint="">
  <cfargument name="type" type="string" required="true" default="" hint="" />
  <cfset variables.instance.type = ARGUMENTS.type />
</cffunction>

<cffunction name="setAnswerIdList" access="public" output="false" hint="">
  <cfargument name="answerIdList" type="string" required="true" default="" hint="" />
  <cfset variables.instance.answerIdList = ARGUMENTS.answerIdList />
</cffunction>

<cffunction name="setAnswerTextList" access="public" output="false" hint="">
  <cfargument name="answerTextList" type="string" required="true" default="" hint="" />
  <cfset variables.instance.answerTextList = ARGUMENTS.answerTextList />
</cffunction>

<!--- getters --->
<cffunction name="getQuestionId" access="public" output="false" hint="">
  <cfreturn variables.instance.questionId />
</cffunction>

<cffunction name="getText" access="public" output="false" hint="">
  <cfreturn variables.instance.text />
</cffunction>

<cffunction name="getType" access="public" output="false" hint="">
  <cfreturn variables.instance.type />
</cffunction>

<cffunction name="getAnswerIdList" access="public" output="false" hint="">
  <cfreturn variables.instance.answerIdList />
</cffunction>

<cffunction name="getAnswerTextList" access="public" output="false" hint="">
  <cfreturn variables.instance.answerTextList />
</cffunction>

<!--- utility methods --->
<cffunction name="getMemento" access="public" output="false" hint="">
   <cfreturn variables.instance />
</cffunction>

</cfcomponent>