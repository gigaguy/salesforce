<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Award_QSI_Congratulations_Email</fullName>
        <description>Award QSI Congratulations Email</description>
        <protected>false</protected>
        <recipients>
            <field>Emp_Name__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Award_Email_Templates/Award_QSI_Congratulations_Email</template>
    </alerts>
    <alerts>
        <fullName>Award_QSI_RO_Email</fullName>
        <description>Award QSI Req Off Email</description>
        <protected>false</protected>
        <recipients>
            <field>Owner_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Award_Email_Templates/Award_QSI_RO_Email</template>
    </alerts>
    <alerts>
        <fullName>Award_Receipt_RO_Email</fullName>
        <description>Award Receipt for Req Off Email</description>
        <protected>false</protected>
        <recipients>
            <field>Owner_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Award_Email_Templates/Award_Receipt_Email_Supervisor</template>
    </alerts>
    <alerts>
        <fullName>Award_Rejected_Email_Notification</fullName>
        <description>Award Rejected Email Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Award_Email_Templates/Award_Rejected_Email</template>
    </alerts>
    <alerts>
        <fullName>Award_Rejection_Notice</fullName>
        <description>Rejection notice sent to award&apos;s owner if an award is rejected.</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Award_Email_Templates/Award_Rejected_Email</template>
    </alerts>
    <alerts>
        <fullName>Congratulations_Award_Email</fullName>
        <description>Congratulations Award Email</description>
        <protected>false</protected>
        <recipients>
            <field>Emp_Name__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Award_Email_Templates/Award_Congratulations_Email</template>
    </alerts>
    <alerts>
        <fullName>OTS_Award_Congratulations_Email</fullName>
        <description>OTS Award Congratulations Email</description>
        <protected>false</protected>
        <recipients>
            <field>Emp_Name__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Award_Email_Templates/OTS_Award_Congratulations_Email</template>
    </alerts>
    <alerts>
        <fullName>OTS_Award_Supervisor_Email</fullName>
        <description>OTS Award Supervisor Email</description>
        <protected>false</protected>
        <recipients>
            <field>Owner_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Award_Email_Templates/OTS_Award_Receipt_Email_Supervisor</template>
    </alerts>
    <fieldUpdates>
        <fullName>Award_Status_Equals_Submitted</fullName>
        <description>Update the award&apos;s status to Submitted after a User submits an award for approval.</description>
        <field>Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Award Status Equals Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Award_Status_Pending_Supervisor_Approval</fullName>
        <description>Set the award&apos;s status to Pending Direct Supervisor Approval.</description>
        <field>Status__c</field>
        <literalValue>Pending Direct Supervisor Approval</literalValue>
        <name>Award Status Pending Supervisor Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Status_Award_Rejected</fullName>
        <description>Set the award&apos;s status to Rejected if the award is rejected.</description>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Final Status Award Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Status_Equals_Approved</fullName>
        <description>Update the awards status to Approved when the award is approved.</description>
        <field>Status__c</field>
        <literalValue>Received by OARS/Approved</literalValue>
        <name>Final Status Equals Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Award_Status_Post_Dir_Super_Reject</fullName>
        <description>Set the award status to rejected if an awardee&apos;s direct supervisor rejects the award.</description>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Set Award Status Post Dir Super Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Award_Status_to_Approved</fullName>
        <description>After the direct supervisor approves an award, set the status back to Received by OARS/Approved</description>
        <field>Status__c</field>
        <literalValue>Received by OARS/Approved</literalValue>
        <name>Set Award Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Award_Status_to_Planned</fullName>
        <description>Set the award status to planned whenever an award approval has been recalled.</description>
        <field>Status__c</field>
        <literalValue>Planned</literalValue>
        <name>Set Award Status to Planned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_to_Planned</fullName>
        <description>If an award is recalled, then set the status back to Planned.</description>
        <field>Status__c</field>
        <literalValue>Planned</literalValue>
        <name>Set Status to Planned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Submission_Date</fullName>
        <description>Set the submission date when the award is submitted for approval.</description>
        <field>Submitted_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set Submission Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Equals_Approved</fullName>
        <description>Update the award&apos;s status to approved if approved by supervisor/IOAA (if necessary) or if the award skipped the approval steps.</description>
        <field>Status__c</field>
        <literalValue>Received by OARS/Approved</literalValue>
        <name>Status Equals Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Equals_Submitted</fullName>
        <description>Update the award&apos;s status to submitted when the user first submits an award for approval.</description>
        <field>Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Status Equals Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_IOAA_Approval_Date</fullName>
        <field>IOAA_Approval_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update IOAA Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Supervisor_Approval_Date</fullName>
        <field>Supervisor_Approval_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Supervisor Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
