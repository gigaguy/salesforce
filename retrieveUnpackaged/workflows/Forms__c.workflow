<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Dev_Sandbox_recalled</fullName>
        <description>Dev Sandbox recalled</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_on_Behalf_Of__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>lee.ron2@epa.gov</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>misty.grooms2@csra.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>twinkle.malhotra2@csra.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Dev_Sandbox_Request_Recall_Notification_Template</template>
    </alerts>
    <alerts>
        <fullName>Sandbox_Approved_Notification_Alert</fullName>
        <description>Sandbox Approved Notification Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_on_Behalf_Of__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>dutrow.paul2@epa.gov</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lee.ron2@epa.gov</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>misty.grooms2@csra.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>twinkle.malhotra2@csra.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Development_Sandbox_Request_Form_Approved_Notification</template>
    </alerts>
    <alerts>
        <fullName>Sandbox_Rejection_Notification_Alert</fullName>
        <description>Sandbox Rejection Notification Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_on_Behalf_Of__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Dev_Sandbox_Request_Rejected_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>Status_Update_to_Submitted_for_Approval</fullName>
        <description>Update to submitted for approval</description>
        <field>Form_Status__c</field>
        <literalValue>Submitted for Approval</literalValue>
        <name>Status Update to Submitted for Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Updated_to_Approved</fullName>
        <field>Form_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Status Updated to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Updated_to_Recalled</fullName>
        <field>Form_Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Status Updated to Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Updated_to_Rejected</fullName>
        <field>Form_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Status Updated to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
