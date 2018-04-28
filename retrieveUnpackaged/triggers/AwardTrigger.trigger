trigger AwardTrigger on Award__c (before insert, before update, after update) {
    if (Trigger.isBefore && Trigger.isInsert) {
        AwardTriggerHandler.beforeInsert(Trigger.new);
    }

    if (Trigger.isBefore && Trigger.isUpdate) {
        AwardTriggerHandler.beforeUpdate(Trigger.newMap, Trigger.oldMap);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        AwardTriggerHandler.afterUpdate(Trigger.newMap, Trigger.oldMap);
    }
}