<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>BAP_Generic_Submission_Confirmation</fullName>
        <description>BAP Generic Submission Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Unauthenticated_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/BAP_Forms_Generic_Submission_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>BAP_Provisioning_Request_to_Jira</fullName>
        <ccEmails>jira@epabiac.atlassian.net</ccEmails>
        <description>BAP Provisioning Request to Jira</description>
        <protected>false</protected>
        <recipients>
            <recipient>king.roy@epa.gov</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/BAP_Provisioning_Request_Form_Approved_Jira</template>
    </alerts>
    <alerts>
        <fullName>BAP_Provisioning_User_Request_Completed</fullName>
        <description>BAP Provisioning User Request Completed</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_on_Behalf_Of__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Technical_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/BAP_User_Provisioning_Approved_Notification_Template</template>
    </alerts>
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
        <fullName>EPA_3160_6v5_Leave_Bank_Approved</fullName>
        <description>EPA-3160-6v5 Leave Bank Approved</description>
        <protected>false</protected>
        <recipients>
            <field>Unlicensed_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/EPA_3160_6v5_Leave_Bank_Approved</template>
    </alerts>
    <alerts>
        <fullName>EPA_3160_6v5_Moving_to_Leave_Bank_Team</fullName>
        <description>EPA-3160-6v5 Moving to Leave Bank Team</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/EPA_3160_6v5_Moving_to_Leave_Bank_Team</template>
    </alerts>
    <alerts>
        <fullName>FinalApproval</fullName>
        <description>FinalApproval</description>
        <protected>false</protected>
        <recipients>
            <field>Cardholder_AO_Name__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Purchase_Card_Provisioning_Templates/Purchase_Card_Email_Template_Approved_Confirmation</template>
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
            <field>Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Assigned_to__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Purchase_Card_Provisioning_Templates/Notify_Pending_Action_Purchase_Card</template>
    </alerts>
    <alerts>
        <fullName>ORD_111_Submission_Confirmation</fullName>
        <description>ORD-111 Submission Confirmation (prepared for another user)</description>
        <protected>false</protected>
        <recipients>
            <field>Prepare_Form_for__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/ORD_111_Forms_Submission_Confirm_submitted_by_other_person</template>
    </alerts>
    <alerts>
        <fullName>Purchase_Card_Approved_Notice_to_PC_Team_for_Action</fullName>
        <description>Purchase Card Approved Notice to PC Team for Action</description>
        <protected>false</protected>
        <recipients>
            <recipient>creed.suzette2@epa.gov</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kristine.sisson2@csra.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lyles.dianne2@epa.gov</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>misty.grooms2@csra.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nathaniel.villforth3@csra.com.epa</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Purchase_Card_Provisioning_Templates/Purchase_Card_Team_Action_Needed</template>
    </alerts>
    <alerts>
        <fullName>Purchase_Card_Approver_1_Approved_Notification</fullName>
        <description>Purchase Card Approver 1 Approved Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Cardholder_AO_Name__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Purchase_Card_Provisioning_Templates/Purchase_Card_Approved_by_Approver_1</template>
    </alerts>
    <alerts>
        <fullName>Purchase_Card_Approver_2_Approved_Notification</fullName>
        <description>Purchase Card Approver 2 Approved Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Cardholder_AO_Name__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Purchase_Card_Provisioning_Templates/Purchase_Card_Approved_by_Approver_2</template>
    </alerts>
    <alerts>
        <fullName>Purchase_Card_Team_Action_Completion_Notification</fullName>
        <description>Purchase Card Team Action Completion Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Cardholder_AO_Name__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Purchase_Card_Provisioning_Templates/Purchase_Card_Team_Action_Completed_Notification</template>
    </alerts>
    <alerts>
        <fullName>Reject_Request</fullName>
        <description>Reject Request</description>
        <protected>false</protected>
        <recipients>
            <field>Cardholder_AO_Name__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Purchase_Card_Provisioning_Templates/Purchase_Card_Email_Template_Rejected_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>SF_182_Final_Approval_to_Funding_Official</fullName>
        <description>SF-182 Final Approval to Funding Official</description>
        <protected>false</protected>
        <recipients>
            <field>User_Funding_Official__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SF_182_Forms_Final_Approval_to_Funding_Official</template>
    </alerts>
    <alerts>
        <fullName>SF_182_Submission_Confirmation</fullName>
        <description>SF-182 Submission Confirmation (prepared for another user)</description>
        <protected>false</protected>
        <recipients>
            <field>Prepare_Form_for__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SF_182_Forms_Submission_Confirm_submitted_by_other_person</template>
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
        <fullName>Approval_Step_Prepared_As</fullName>
        <field>Approval_Step__c</field>
        <formula>IF( ISBLANK( Unauthenticated_Owner__c ), 
&quot;Form Prepared for &quot; &amp; Prepare_Form_for__r.FirstName  &amp; &quot; &quot; &amp; Prepare_Form_for__r.LastName &amp; &quot; by &quot; &amp;  CreatedBy.FirstName &amp;&quot; &quot;&amp; CreatedBy.LastName &amp;&quot; - Not Submitted&quot;, 
&quot;Form Prepared for &quot; &amp; Prepare_Form_for__r.FirstName  &amp; &quot; &quot; &amp; Prepare_Form_for__r.LastName &amp; &quot; by &quot; &amp; Unauthenticated_Owner__r.FirstName &amp;&quot; &quot;&amp; Unauthenticated_Owner__r.LastName &amp;&quot; - Not Submitted&quot;)</formula>
        <name>Approval Step - Prepared As</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
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
        <fullName>Approval_Step_Sent_to_Escalated_Apprvr</fullName>
        <field>Approval_Step__c</field>
        <formula>IF(  
OR(
   Escalate_to_Chief_Learning_Officer__c = true,
   Training_Start_Date__c &lt;= TODAY(),
   Direct_Cost_Total__c &gt; 25000,
   Indirect_Total__c &gt; 25000
  ),
&quot;Awaiting Sharon Riding&apos;s Approval (Escalated Approver)&quot;,
&quot;&quot; )</formula>
        <name>Approval Step - Sent to Escalated Apprvr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_Funding_Official</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Awaiting Funding Official Approval&quot;</formula>
        <name>Approval Step - Sent to Funding Official</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_Leave_Bank_Team</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Awaiting Leave Bank Team Approval&quot;</formula>
        <name>Approval Step - Sent to Leave Bank Team</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_Next_Approver3</fullName>
        <description>ORD-111 checks for Additional Reviewer</description>
        <field>Approval_Step__c</field>
        <formula>IF( ISBLANK( Additional_Reviewer__c ) , 
&quot;Awaiting QA Manager Approval&quot;, 
&quot;Awaiting Additional Reviewer Approval&quot;)</formula>
        <name>Approval Step - Sent to Next Approver3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_Next_Approver4</fullName>
        <description>EPA-3160-6v5 checks Location field for next approver</description>
        <field>Approval_Step__c</field>
        <formula>&quot;Awaiting &quot; &amp; 
 TEXT(Employee_Location__c) &amp;
&quot; Approval&quot;</formula>
        <name>Approval Step - Sent to Next Approver4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_Next_Approver_1</fullName>
        <field>Approval_Step__c</field>
        <formula>IF(RecordType.DeveloperName = &quot;SF_182&quot;, 
IF( 
ispickval(of_Approval_Supervisors__c, &quot;2&quot;), 
&quot;Awaiting Supervisor 2 Approval&quot;, 
&quot;Awaiting Funding Official Approval&quot;), 
&quot;Awaiting Next Approver&quot;)</formula>
        <name>Approval Step - Sent to Next Approver1</name>
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
        <fullName>Approval_Step_Sent_to_QA_Manager</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Awaiting QA Manager Approval&quot;</formula>
        <name>Approval Step - Sent to QA Manager</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_Queue_Approval</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Awaiting &quot;&amp; TEXT( Approval_Routing_Options__c ) &amp;&quot; Queue Approval&quot;</formula>
        <name>Approval Step - Sent to Queue Approval</name>
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
        <fullName>BAP_Final_Approval</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Approved&quot;</formula>
        <name>BAP Final Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BAP_Final_Rejection</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Rejected&quot;</formula>
        <name>BAP Final Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BAP_Request_Submitted_Step</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Submitted for Approval&quot;</formula>
        <name>BAP Request Submitted</name>
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
        <fullName>Rejection_Remove_Manager_Signature</fullName>
        <field>Immediate_Supervisor_s_Signature__c</field>
        <literalValue>0</literalValue>
        <name>Rejection - Remove Manager Signature</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
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
        <reevaluateOnChange>true</reevaluateOnChange>
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
        <fullName>Waiver_Auth_Signature</fullName>
        <field>Waiver_Authorized_Signature__c</field>
        <literalValue>1</literalValue>
        <name>Waiver Auth Signature</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Purchase Card Assigned to Notification</fullName>
        <actions>
            <name>Notify_Assigned_to_and_AO_for_Purchase_Card</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Forms__c.Assigned_to__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Purchase Card: Cancellation Check or Card,Purchase Card: Change Cardholder AO,Purchase Card: Change Contact Information,Purchase Card: Change Monthly Limit,Purchase Card: Change Name on Card/Check,Purchase Card: Change Suspension of Card/Check</value>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Purchase Card: New Approving Official (AO),Purchase Card: New Convenience Check,Purchase Card: New Purchase Card</value>
        </criteriaItems>
        <description>sends email notification to Assigned to and Approving Official for purchase card provisioning when the assigned to is entered</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Purchase Card Team Action Completed Notification</fullName>
        <actions>
            <name>Purchase_Card_Team_Action_Completion_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Forms__c.Form_Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
