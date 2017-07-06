<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_2nd_Line_on_CP_approval_by_1st_line</fullName>
        <ccEmails>christopher.alley@cgifederal.com</ccEmails>
        <ccEmails>kedar.joshi@cgifederal.com</ccEmails>
        <ccEmails>naveen.sadhu@cgifederal.com</ccEmails>
        <ccEmails>kenneth.hunter@cgifederal.com</ccEmails>
        <description>Notify 2nd Line on CP approval by 1st line</description>
        <protected>false</protected>
        <recipients>
            <field>Candidates_2nd_Line_Supervisor_Name__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TQB_Email_Templates/Notify_2nd_Line_on_CP_approval_by_1st_line</template>
    </alerts>
    <alerts>
        <fullName>Notify_Candidate_and_1st_Line_that_2nd_Line_Reject_CP</fullName>
        <ccEmails>EPAORDTQBTeam@cgifederal.com</ccEmails>
        <description>Notify Candidate and 1st Line that 2nd Line Rejected CP</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>c121ls@cgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TQB_Email_Templates/TQB_Email_Notification_to_Candidate_and_1st_Line_of_CP_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Notify_Candidate_and_1st_Line_that_2nd_Line_Returned_CP</fullName>
        <ccEmails>EPAORDTQBTeam@cgifederal.com</ccEmails>
        <description>Notify Candidate and 1st Line that 2nd Line Returned CP</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>c121ls@cgi.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TQB_Email_Templates/TQB_Email_Notification_to_Candidate_and_1st_Line_of_CP_Returned_by_Second_Line</template>
    </alerts>
    <alerts>
        <fullName>Notify_on_CP_approval_by_2nd_line</fullName>
        <ccEmails>christopher.alley@cgifederal.com</ccEmails>
        <ccEmails>kedar.joshi@cgifederal.com</ccEmails>
        <ccEmails>naveen.sadhu@cgifederal.com</ccEmails>
        <ccEmails>kenneth.hunter@cgifederal.com</ccEmails>
        <description>Notify on CP approval by 2nd line</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Candidates_1st_Line_Supervisor_Name__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TQB_Email_Templates/Notify_on_CP_approval_by_2nd_line</template>
    </alerts>
    <alerts>
        <fullName>TQB_Notify_1st_Line_Sup_Candidate_has_Submitted_Promotion_Package</fullName>
        <ccEmails>christopher.alley@cgifederal.com</ccEmails>
        <ccEmails>kedar.joshi@cgifederal.com</ccEmails>
        <ccEmails>naveen.sadhu@cgifederal.com</ccEmails>
        <ccEmails>kenneth.hunter@cgifederal.com</ccEmails>
        <description>TQB Notify 1st Line Sup Candidate has Submitted Promotion Package</description>
        <protected>false</protected>
        <recipients>
            <field>Candidates_1st_Line_Supervisor_Name__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TQB_Email_Templates/TQB_Notify_1st_Line_Sup_Candidate_has_Submitted_Candidate_Promotion_Package</template>
    </alerts>
    <rules>
        <fullName>Notify 2nd Line on CP approval by 1st line</fullName>
        <actions>
            <name>Notify_2nd_Line_on_CP_approval_by_1st_line</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>TQB_Candidate_Package__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved By 1st Line Supervisor</value>
        </criteriaItems>
        <description>Notify 2nd Line on CP approval by 1st line</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify Candidate and 1st Line Sup that 2nd Line Returned CP</fullName>
        <actions>
            <name>Notify_Candidate_and_1st_Line_that_2nd_Line_Returned_CP</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>TQB_Candidate_Package__c.Status__c</field>
            <operation>equals</operation>
            <value>Returned</value>
        </criteriaItems>
        <description>Notify Candidate and 1st Line Sup that 2nd Line Returned CP</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify Candidate and 1st Line that 2nd Line Rejected CP</fullName>
        <actions>
            <name>Notify_Candidate_and_1st_Line_that_2nd_Line_Reject_CP</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>TQB_Candidate_Package__c.Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <description>Notify Candidate and 1st Line that 2nd Line Rejected CP</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify on CP approval by 2nd line</fullName>
        <actions>
            <name>Notify_on_CP_approval_by_2nd_line</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>TQB_Candidate_Package__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved By 2nd Line Supervisor</value>
        </criteriaItems>
        <description>Notify on CP approval by 2nd line</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TQB Notify 1st Line Sup Candidate has Submitted Promotion Package</fullName>
        <actions>
            <name>TQB_Notify_1st_Line_Sup_Candidate_has_Submitted_Promotion_Package</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>TQB_Candidate_Package__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>TQB Notify 1st Line Sup Candidate has Submitted Promotion Package</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
