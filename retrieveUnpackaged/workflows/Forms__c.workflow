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
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Dev_Sandbox_Request_Recall_Notification_Template</template>
    </alerts>
    <alerts>
        <fullName>EPA_100_Submission_Confirmation</fullName>
        <description>EPA-100 Submission Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Unlicensed_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/EPA_100_Forms_Submission_Confirmation</template>
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
        <fullName>Form_Submission_Notification</fullName>
        <description>Form Submission Notification</description>
        <protected>false</protected>
        <recipients>
            <field>User_Supervisor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Form_Approval_Request_Notification_Template</template>
    </alerts>
    <alerts>
        <fullName>SF_182_Submission_Confirmation</fullName>
        <description>SF-182 Submission Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Prepare_Form_for__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SF_182_Forms_Submission_Confirm_submitted_by_other_person</template>
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
        <fullName>Approval_Step_SF_182_Prepared_As</fullName>
        <field>Approval_Step__c</field>
        <formula>IF( ISBLANK( Unauthenticated_Owner__c ), 
&quot;Form Prepared for you by &quot; &amp;  CreatedBy.FirstName &amp;&quot; &quot;&amp; CreatedBy.LastName &amp;&quot; - Not Submitted&quot;, 
&quot;Form Prepared for you by &quot; &amp; Unauthenticated_Owner__r.FirstName &amp;&quot; &quot;&amp; Unauthenticated_Owner__r.LastName &amp;&quot; - Not Submitted&quot;)</formula>
        <name>Approval Step - SF-182 Prepared As</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_Approval_Queue</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Awaiting &quot;+ text(Approval_Routing_Options__c) +&quot; Queue Approval&quot;</formula>
        <name>Approval Step - Sent to Approval Queue</name>
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
        <fullName>Approval_Step_Sent_to_Next_Approver_1</fullName>
        <field>Approval_Step__c</field>
        <formula>IF( 
ispickval(of_Approval_Supervisors__c, &quot;2&quot;), 
&quot;Awaiting Supervisor 2 Approval&quot;, 
&quot;Awaiting Funding Official Approval&quot;)</formula>
        <name>Approval Step - Sent to Next Approver1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_Next_Approver_2</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Awaiting &quot;&amp; TEXT( Approval_Routing_Options__c ) &amp;&quot; Queue Approval&quot;</formula>
        <name>Approval Step - Sent to Next Approver2</name>
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
        <fullName>Send_to_Financial</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Sent to Financial&quot;</formula>
        <name>Send to Financial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
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
</Workflow>
