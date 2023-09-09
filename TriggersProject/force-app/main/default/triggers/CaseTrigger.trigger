trigger CaseTrigger on Case (after insert,after update,after delete) 
{
    if(Trigger.isAfter && Trigger.isInsert){
        //CaseTriggerHandler.updateAccount(Trigger.new);
        //CaseTriggerHandler.updateAccountCaseStatus(Trigger.new,null);
        CaseTriggerHandler.createEventContact(Trigger.new);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
        //CaseTriggerHandler.updateAccountCaseStatus(Trigger.new,Trigger.oldMap);
        //CaseTriggerHandler.updateTaskAndAccount(Trigger.new,Trigger.oldMap);
        CaseTriggerHandler.createFollowUpTask(Trigger.new,Trigger.oldMap);
    }
    
     if(Trigger.isAfter && Trigger.isDelete){
        CaseTriggerHandler.updateAccountCaseStatus(Trigger.old,null);
    }
}