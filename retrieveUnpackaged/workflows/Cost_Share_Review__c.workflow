<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>GLLA_Cost_Share_Review_Final_Notification</fullName>
        <description>GLLA Cost-Share Review Final Notification</description>
        <protected>false</protected>
        <recipients>
            <field>RR_Branch_Chief__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>RR_Section_Chief__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLLA_Email_Notifications/GLLA_Cost_Share_Review_Final_Notifciation</template>
    </alerts>
    <alerts>
        <fullName>GLLA_Cost_Share_Review_Initial_Notification</fullName>
        <description>GLLA Cost-Share Review Initial Notification</description>
        <protected>false</protected>
        <recipients>
            <field>GLLA_Finance_Lead__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>ORC_GLLA_Finance_Contact__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLLA_Email_Notifications/GLLA_Review_Ready_Notifciation</template>
    </alerts>
    <rules>
        <fullName>GLLA Cost-Share Review Final Notification</fullName>
        <actions>
            <name>GLLA_Cost_Share_Review_Final_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Cost_Share_Review__c.Cost_Share_Review_Status__c</field>
            <operation>equals</operation>
            <value>Submitted for Final Notification</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GLLA Cost-Share Review Initial Notification</fullName>
        <actions>
            <name>GLLA_Cost_Share_Review_Initial_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Cost_Share_Review__c.Cost_Share_Review_Status__c</field>
            <operation>equals</operation>
            <value>Ready for Review</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
