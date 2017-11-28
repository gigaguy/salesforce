<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_TQB_Chair_Approved</fullName>
        <field>TQB_Chair_Approved__c</field>
        <literalValue>1</literalValue>
        <name>Update TQB Chair Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_to_Candidate_Package</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Candidate_Package</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update to Candidate Package</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
