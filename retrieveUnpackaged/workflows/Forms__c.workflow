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
        <fullName>EPA_3160_6v5_Leave_Bank_Approved</fullName>
        <description>EPA-3160-6v5 Leave Bank Approved</description>
        <protected>false</protected>
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
        <fullName>Email_to_Funding_Official</fullName>
        <description>Email to Funding Official</description>
        <protected>false</protected>
        <recipients>
            <field>User_Funding_Official__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/BAP_Forms_Approved_Form</template>
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
        <template>unfiled$public/Form_Submission_Notification_Template</template>
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
        <fullName>Approval_PCOR_Approved_by_508_Approver</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Awaiting &quot; &amp; 
IF(NOT(ISBLANK(IT_Reviewer__c)),&quot;IT Reviewer Approval&quot;, 
IF(NOT(ISBLANK(Approving_Official__c)),&quot;Approving Official&quot;, 
IF(NOT(ISBLANK(FCO__c)),&quot;FCO Approval&quot;, 
&quot;&quot; 
)))</formula>
        <name>Approval PCOR - Approved by 508 Approver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_PCOR_Approved_by_Deputy_Dir</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Awaiting &quot; &amp; 
IF(NOT(ISBLANK(Director__c)),&quot;Director Approval&quot;, 
IF(NOT(ISBLANK(Property__c)),&quot;Property Approval&quot;, 
IF(NOT(ISBLANK(X508_Compliance_Approver__c)),&quot;508 Compliance Approval&quot;, 
IF(NOT(ISBLANK(IT_Reviewer__c)),&quot;IT Reviewer Approval&quot;, 
IF(NOT(ISBLANK(Approving_Official__c)),&quot;Approving Official&quot;, 
IF(NOT(ISBLANK(FCO__c)),&quot;FCO Approval&quot;, 
&quot;&quot; 
))))))</formula>
        <name>Approval PCOR - Approved by Deputy Dir</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_PCOR_Approved_by_Director</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Awaiting &quot; &amp; 
IF(NOT(ISBLANK(Property__c)),&quot;Property Approval&quot;, 
IF(NOT(ISBLANK(X508_Compliance_Approver__c)),&quot;508 Compliance Approval&quot;, 
IF(NOT(ISBLANK(IT_Reviewer__c)),&quot;IT Reviewer Approval&quot;, 
IF(NOT(ISBLANK(Approving_Official__c)),&quot;Approving Official&quot;, 
IF(NOT(ISBLANK(FCO__c)),&quot;FCO Approval&quot;, 
&quot;&quot; 
)))))</formula>
        <name>Approval PCOR - Approved by Director</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_PCOR_Approved_by_Div_Dir_1</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Awaiting &quot; &amp;  
IF(NOT(ISBLANK(Division_Director_2__c)),&quot;Division Director 2 Approval&quot;, 
IF(NOT(ISBLANK(Deputy_Director__c)),&quot;Deputy Director Approval&quot;, 
IF(NOT(ISBLANK(Director__c)),&quot;Director Approval&quot;, 
IF(NOT(ISBLANK(Property__c)),&quot;Property Approval&quot;, 
IF(NOT(ISBLANK(X508_Compliance_Approver__c)),&quot;508 Compliance Approval&quot;, 
IF(NOT(ISBLANK(IT_Reviewer__c)),&quot;IT Reviewer Approval&quot;, 
IF(NOT(ISBLANK(Approving_Official__c)),&quot;Approving Official&quot;, 
IF(NOT(ISBLANK(FCO__c)),&quot;FCO Approval&quot;, 
&quot;&quot; 
))))))))</formula>
        <name>Approval PCOR - Approved by Div Dir 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_PCOR_Approved_by_Div_Dir_2</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Awaiting &quot; &amp;  
IF(NOT(ISBLANK(Deputy_Director__c)),&quot;Deputy Director Approval&quot;, 
IF(NOT(ISBLANK(Director__c)),&quot;Director Approval&quot;, 
IF(NOT(ISBLANK(Property__c)),&quot;Property Approval&quot;, 
IF(NOT(ISBLANK(X508_Compliance_Approver__c)),&quot;508 Compliance Approval&quot;, 
IF(NOT(ISBLANK(IT_Reviewer__c)),&quot;IT Reviewer Approval&quot;, 
IF(NOT(ISBLANK(Approving_Official__c)),&quot;Approving Official&quot;, 
IF(NOT(ISBLANK(FCO__c)),&quot;FCO Approval&quot;, 
&quot;&quot; 
)))))))</formula>
        <name>Approval PCOR - Approved by Div Dir 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_PCOR_Approved_by_IT_Reviewer</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Awaiting &quot; &amp; 
IF(NOT(ISBLANK(Approving_Official__c)),&quot;Approving Official&quot;, 
IF(NOT(ISBLANK(FCO__c)),&quot;FCO Approval&quot;, 
&quot;&quot; 
))</formula>
        <name>Approval PCOR - Approved by IT Reviewer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_PCOR_Approved_by_Official</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Awaiting &quot; &amp; 
IF(NOT(ISBLANK(FCO__c)),&quot;FCO Approval&quot;, 
&quot;&quot; 
)</formula>
        <name>Approval PCOR - Approved by Official</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_PCOR_Approved_by_Property</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Awaiting &quot; &amp; 
IF(NOT(ISBLANK(X508_Compliance_Approver__c)),&quot;508 Compliance Approval&quot;, 
IF(NOT(ISBLANK(IT_Reviewer__c)),&quot;IT Reviewer Approval&quot;, 
IF(NOT(ISBLANK(Approving_Official__c)),&quot;Approving Official&quot;, 
IF(NOT(ISBLANK(FCO__c)),&quot;FCO Approval&quot;, 
&quot;&quot; 
))))</formula>
        <name>Approval PCOR - Approved by Property</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_PCOR_Card_Holder_Approved</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Awaiting &quot; &amp;
IF(NOT(ISBLANK(Division_Director_1__c)),&quot;Division Director 1 Approval&quot;,
IF(NOT(ISBLANK(Division_Director_2__c)),&quot;Division Director 2 Approval&quot;,
IF(NOT(ISBLANK(Deputy_Director__c)),&quot;Deputy Director Approval&quot;,
IF(NOT(ISBLANK(Director__c)),&quot;Director Approval&quot;,
IF(NOT(ISBLANK(Property__c)),&quot;Property Approval&quot;,
IF(NOT(ISBLANK(X508_Compliance_Approver__c)),&quot;508 Compliance Approval&quot;,
IF(NOT(ISBLANK(IT_Reviewer__c)),&quot;IT Reviewer Approval&quot;,
IF(NOT(ISBLANK(Approving_Official__c)),&quot;Approving Official&quot;,
IF(NOT(ISBLANK(FCO__c)),&quot;FCO Approval&quot;,
&quot;&quot;
)))))))))</formula>
        <name>Approval PCOR - Card Holder Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_PCOR_Initial</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Awaiting &quot; &amp;
IF(NOT(ISBLANK(Card_Holder__c)),&quot;Card Holder Approval&quot;,
IF(NOT(ISBLANK(Division_Director_1__c)),&quot;Division Director 1 Approval&quot;,
IF(NOT(ISBLANK(Division_Director_2__c)),&quot;Division Director 2 Approval&quot;,
IF(NOT(ISBLANK(Deputy_Director__c)),&quot;Deputy Director Approval&quot;,
IF(NOT(ISBLANK(Director__c)),&quot;Director Approval&quot;,
IF(NOT(ISBLANK(Property__c)),&quot;Property Approval&quot;,
IF(NOT(ISBLANK(X508_Compliance_Approver__c)),&quot;508 Compliance Approval&quot;,
IF(NOT(ISBLANK(IT_Reviewer__c)),&quot;IT Reviewer Approval&quot;,
IF(NOT(ISBLANK(Approving_Official__c)),&quot;Approving Official&quot;,
IF(NOT(ISBLANK(FCO__c)),&quot;FCO Approval&quot;,
&quot;&quot;
))))))))))</formula>
        <name>Approval PCOR - Initial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
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
&quot;Form Prepared for you by &quot; &amp;  CreatedBy.FirstName &amp;&quot; &quot;&amp; CreatedBy.LastName &amp;&quot; - Not Submitted&quot;, 
&quot;Form Prepared for you by &quot; &amp; Unauthenticated_Owner__r.FirstName &amp;&quot; &quot;&amp; Unauthenticated_Owner__r.LastName &amp;&quot; - Not Submitted&quot;)</formula>
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
        <fullName>Approval_Step_Sent_to_Approval_Queue</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Awaiting &quot;+ text(Approval_Routing_Options__c) +&quot; Queue Approval&quot;</formula>
        <name>Approval Step - Sent to Approval Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_Escalated_Apprvr</fullName>
        <field>Approval_Step__c</field>
        <formula>IF(  Escalate_to_Chief_Learning_Officer__c = true,
&quot;Awaiting Sharon Riding&apos;s Approval (Escalated Approver)&quot;,
&quot;Awaiting Supervisor Approval&quot; )</formula>
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
        <fullName>Approval_Step_Sent_to_Invoice_Approver</fullName>
        <field>Approval_Step__c</field>
        <formula>&quot;Awaiting Invoice Approver&quot;</formula>
        <name>Approval Step - Sent to Invoice Approver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
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
&quot;Awaiting Additional Reviewer Approval&quot;, 
&quot;Awaiting QA Manager Approval&quot;)</formula>
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
        <fullName>Leave_Bank_Coordinator_Signature</fullName>
        <field>Local_Leave_Bank_Coordinator_Signature__c</field>
        <literalValue>1</literalValue>
        <name>Leave Bank Coordinator Signature</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
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
        <fullName>SF182_Final_Sharing_Confirmation</fullName>
        <field>Form_emailed_to_Cincinnati__c</field>
        <literalValue>1</literalValue>
        <name>SF182 Final Sharing Confirmation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
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
    <fieldUpdates>
        <fullName>Waiver_Auth_Signature</fullName>
        <field>Waiver_Authorized_Signature__c</field>
        <literalValue>1</literalValue>
        <name>Waiver Auth Signature</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>test</fullName>
        <field>Approval_Step__c</field>
        <name>test</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
