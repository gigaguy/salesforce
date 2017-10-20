trigger Forms on Forms__c (before insert, before update, after update) {
	if (trigger.isBefore && trigger.isinsert) new FormsTriggerHandler().beforeInsert(trigger.new);
    if (trigger.isBefore && trigger.isUpdate) new FormsTriggerHandler().beforeUpdate(trigger.newMap);
	if (trigger.isAfter && trigger.isUpdate) new FormsTriggerHandler().afterUpdate(trigger.newMap);
}