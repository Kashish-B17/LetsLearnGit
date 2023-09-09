trigger ParentObjectTrigger on Parent_Object__c (before delete) {
    
    ParentObjectTriggerHandler.restrictParentToDelete(trigger.OldMap);

}