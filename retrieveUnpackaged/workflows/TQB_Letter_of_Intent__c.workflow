<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>TQB_1st_Line_Sup_Rejects_Candidate_LOI</fullName>
        <ccEmails>christopher.alley@cgifederal.com</ccEmails>
        <ccEmails>kedar.joshi@cgifederal.com</ccEmails>
        <ccEmails>naveen.sadhu@cgifederal.com</ccEmails>
        <ccEmails>kenneth.hunter@cgifederal.com</ccEmails>
        <description>TQB 1st Line Sup Rejects Candidate LOI</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Candidates_1st_Line_Supervisor_Name__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TQB_Email_Templates/TQB_Email_Notification_to_Candidate_and_TQB_Coord_of_LOI_Rejected</template>
    </alerts>
    <alerts>
        <fullName>TQB_1st_line_sup_Returns_Candidate_LOI</fullName>
        <ccEmails>christopher.alley@cgifederal.com</ccEmails>
        <ccEmails>kedar.joshi@cgifederal.com</ccEmails>
        <ccEmails>naveen.sadhu@cgifederal.com</ccEmails>
        <ccEmails>kenneth.hunter@cgifederal.com</ccEmails>
        <description>TQB 1st line sup Returns Candidate LOI</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Candidates_1st_Line_Supervisor_Name__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TQB_Email_Templates/TQB_Email_Notification_to_Candidate_and_TQB_Coord_of_LOI_Returned</template>
    </alerts>
    <alerts>
        <fullName>TQB_Notify_1st_line_supervisor_that_LOI_is_Submitted</fullName>
        <ccEmails>christopher.alley@cgifederal.com</ccEmails>
        <ccEmails>kedar.joshi@cgifederal.com</ccEmails>
        <ccEmails>naveen.sadhu@cgifederal.com</ccEmails>
        <ccEmails>kenneth.hunter@cgifederal.com</ccEmails>
        <description>TQB Notify 1st line supervisor that LOI is Submitted</description>
        <protected>false</protected>
        <recipients>
            <field>Candidates_1st_Line_Supervisor_Name__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TQB_Email_Templates/TQB_Email_Notification_to_1st_line_sup_of_LOI_Submitted</template>
    </alerts>
    <alerts>
        <fullName>X1st_Line_Supervisor_Approves_Candidate_LOI</fullName>
        <ccEmails>christopher.alley@cgifederal.com</ccEmails>
        <ccEmails>kedar.joshi@cgifederal.com</ccEmails>
        <ccEmails>naveen.sadhu@cgifederal.com</ccEmails>
        <ccEmails>kenneth.hunter@cgifederal.com</ccEmails>
        <description>1st Line Supervisor Approves Candidate LOI</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>TQB_COORDINATOR</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TQB_Email_Templates/TQB_Email_Notification_to_Candidate_and_TQB_Coord_of_LOI_Approved</template>
    </alerts>
    <fieldUpdates>
        <fullName>Status_value</fullName>
        <description>Status field value to submitted when candidate user saves LOI</description>
        <field>Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Status value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TQB_Update_LOI_Status_Date_Field</fullName>
        <description>Updates LOI status date when status changes.</description>
        <field>Status_Date__c</field>
        <formula>today()</formula>
        <name>TQB Update LOI Status Date Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Status as submitted when saved for LOI</fullName>
        <actions>
            <name>TQB_Notify_1st_line_supervisor_that_LOI_is_Submitted</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Status_value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>status field should be submitted when the candidate clicks on save button</description>
        <formula>$Profile.Name =&quot;TQB Candidate User Profile&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TQB 1st Line Sup Rejects Candidate LOI</fullName>
        <actions>
            <name>TQB_1st_Line_Sup_Rejects_Candidate_LOI</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>TQB_Letter_of_Intent__c.Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <description>TQB 1st Line Sup Rejects Candidate LOI</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TQB 1st Line Supervisor Approves LOI</fullName>
        <actions>
            <name>X1st_Line_Supervisor_Approves_Candidate_LOI</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>TQB_Letter_of_Intent__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>TQB 1st line supervisor approves LOI</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TQB 1st line supervisor returns LOI</fullName>
        <actions>
            <name>TQB_1st_line_sup_Returns_Candidate_LOI</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>TQB_Letter_of_Intent__c.Status__c</field>
            <operation>equals</operation>
            <value>Returned</value>
        </criteriaItems>
        <description>Notification is sent when 1st line supervisor returns LOI</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TQB Candidate Submits LOI</fullName>
        <actions>
            <name>TQB_Notify_1st_line_supervisor_that_LOI_is_Submitted</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>TQB_Letter_of_Intent__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>Candidate submits LOI to 1st line supervisor</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TQB Update LOI Status Date Field</fullName>
        <actions>
            <name>TQB_Update_LOI_Status_Date_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>TQB Update LOI Status Date Field</description>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
