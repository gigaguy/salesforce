/**
 * Constant values necessary for the awards tracking application.
 */

public class AwardConstants {
    // Award Status values
    public static final String AWARD_STATUS_REFERENCE = 'Reference';
    public static final String AWARD_STATUS_PLANNED = 'Planned';
    public static final String AWARD_STATUS_SUBMITTED = 'Submitted';
    public static final String AWARD_STATUS_PENDING_APPROVAL = 'Pending Direct Supervisor Approval';
    public static final String AWARD_STATUS_APPROVED = 'Received by OARS/Approved';
    public static final String AWARD_STATUS_HR_REVIEW = 'HR Review';
    public static final String AWARD_STATUS_SENT_UNION_REVIEW = 'Sent for Union Review';
    public static final String AWARD_STATUS_AWAITING_FUNDING = 'Awaiting Funding';
    public static final String AWARD_STATUS_READY_FOR_SSC = 'Ready for SSC';
    public static final String AWARD_STATUS_TO_SSC = 'To SSC';
    public static final String AWARD_STATUS_FUNDED = 'Funded';
    public static final String AWARD_STATUS_PAID = 'Paid';
    public static final String AWARD_STATUS_REJECTED = 'Rejected';

    // Award Statuses used for calculations
    public static final Set<String> AWARD_STATUS_FOR_BUDGET_CALC = new Set<String>{
            AWARD_STATUS_SUBMITTED,
            AWARD_STATUS_PENDING_APPROVAL,
            AWARD_STATUS_APPROVED,
            AWARD_STATUS_HR_REVIEW,
            AWARD_STATUS_SENT_UNION_REVIEW,
            AWARD_STATUS_AWAITING_FUNDING,
            AWARD_STATUS_READY_FOR_SSC,
            AWARD_STATUS_TO_SSC,
            AWARD_STATUS_FUNDED,
            AWARD_STATUS_PAID
    };

    // Award Document values
    public static final String AWARD_BUDGET_DOCUMENT_RECORDTYPE_NAME = 'Document - Award Budget';
}