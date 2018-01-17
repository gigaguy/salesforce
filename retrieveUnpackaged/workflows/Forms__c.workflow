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
        <fullName>FinalApproval</fullName>
        <description>FinalApproval</description>
        <protected>false</protected>
        <recipients>
            <field>Cardholder_AO_Name__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Purchase_Card_Email_Template_Approved_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>Final_Approval_Email</fullName>
        <description>Final Approval Email</description>
        <protected>false</protected>
        <recipients>
            <field>Unlicensed_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Forms_Final_Approval</template>
    </alerts>
    <alerts>
        <fullName>Final_Rejection_Email</fullName>
        <description>Final Rejection Email</description>
        <protected>false</protected>
        <recipients>
            <field>Unlicensed_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Forms_Final_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Notify_Assigned_to_and_AO_for_Purchase_Card</fullName>
        <description>Notify Assigned to and AO for Purchase Card</description>
        <protected>false</protected>
        <recipients>
            <field>Approving_Official__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Assigned_to__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Notify_Pending_Action_Purchase_Card</template>
    </alerts>
    <alerts>
        <fullName>Reject_Request</fullName>
        <description>Reject Request</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Purchase_Card_Email_Template_Rejected_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>Sandbox_Approved_Jira_Alert</fullName>
        <ccEmails>jira@epabiac.atlassian.net</ccEmails>
        <description>Sandbox Approved Jira Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>king.roy@epa.gov</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Development_Sandbox_Request_Form_Approved_Jira</template>
    </alerts>
    <alerts>
        <fullName>Sandbox_Approved_Notification_Alert</fullName>
        <ccEmails>BAP_Admins@epa.gov</ccEmails>
        <description>Sandbox Approved Notification Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_on_Behalf_Of__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Development_Sandbox_Request_Form_Approved_Notification</template>
    </alerts>
    <alerts>
        <fullName>Sandbox_Complete_Email_Notification</fullName>
        <ccEmails>BAP_Admins@epa.gov</ccEmails>
        <description>Sandbox Complete Email Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_on_Behalf_Of__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Development_Sandbox_Request_Form_Approved_Admin_Notification</template>
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
    <alerts>
        <fullName>Submission_Confirmation</fullName>
        <description>Submission Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Unlicensed_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Forms_Submission_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>Update_Requestor</fullName>
        <description>Update Requestor</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Purchase_Card_Approval_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>Update_Requestor_2</fullName>
        <description>Update Requestor</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Purchase_Card_Approval_Confirmation</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_Step_Approved</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Approved&quot;</formula>
        <name>Approval Step - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Recalled</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Recalled&quot;</formula>
        <name>Approval Step - Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Rejected</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Rejected&quot;</formula>
        <name>Approval Step - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_AO</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Awaiting AO Approval&quot;</formula>
        <name>Approval Step - Sent to AO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_DD</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Awaiting Division Director/Manager Approval&quot;</formula>
        <name>Approval Step - Sent to DD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_PCM</fullName>
        <description>approval step to send to the purchase card manager for review</description>
        <field>Approval_Step__c</field>
        <formula>&quot;Awaiting Purchase Card Manager Approval&quot;</formula>
        <name>Approval Step - Sent to PCM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_Supervisor</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Awaiting Supervisor Approval&quot;</formula>
        <name>Approval Step - Sent to Supervisor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_Timekeeper</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Awaiting Timekeeper Approval&quot;</formula>
        <name>Approval Step - Sent to Timekeeper</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Update_Approved</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Approved&quot;</formula>
        <name>Approval Step - Update Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Update_Rejected</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Rejected&quot;</formula>
        <name>Approval Step - Update Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Manager_Signature</fullName>
        <field>Immediate_Supervisor_s_Signature__c</field>
        <literalValue>1</literalValue>
        <name>Manager Signature</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Send_to_Purchase_Card_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>New_Purchase_Card_Actions</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Send to Purchase Card Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
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
    <fieldUpdates>
        <fullName>UpdateAOApprovalStep</fullName>
        <description>Update approval official approval step value.</description>
        <field>Approval_Step__c</field>
        <formula>&quot;1&quot;</formula>
        <name>UpdateAOApprovalStep</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateApprovalStep0</fullName>
        <description>Update approval step value to 0</description>
        <field>Approval_Step__c</field>
        <formula>&apos;0&apos;</formula>
        <name>UpdateApprovalStep0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateApprovalStep10</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;0&quot;</formula>
        <name>UpdateApprovalStep0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateApprovalStep_0</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;0&quot;</formula>
        <name>UpdateApprovalStep0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateManagerApprovalStep</fullName>
        <description>update approval step value.</description>
        <field>Approval_Step__c</field>
        <formula>&quot;2&quot;</formula>
        <name>UpdateManagerApprovalStep</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Purchase Card Assigned to Notification</fullName>
        <actions>
            <name>Notify_Assigned_to_and_AO_for_Purchase_Card</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Forms__c.Assigned_to__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>New-Convenience Check,New-Approving Official (AO),Change-Cardholder AO,Change-Name on Card/Check,Change-Contact Information,Change-Suspension of Card/Check,Change-Monthly Limit,Cancellation-Check or Card,Purchase Card</value>
        </criteriaItems>
        <description>sends email notification to Assigned to and Approving Official for purchase card provisioning when the assigned to is entered</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
