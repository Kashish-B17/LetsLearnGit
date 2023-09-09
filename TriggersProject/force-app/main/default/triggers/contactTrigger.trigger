trigger contactTrigger on Contact (after insert, after delete, after update,before insert,before update) {
    
    if(Trigger.isBefore && Trigger.isInsert){
        //ContactHandler.validatePrimary(Trigger.new);
        ContactHandler.updateContactWithRT(Trigger.new,null);
    }
    /*
    if(Trigger.isAfter){
        if(Trigger.isInsert)
        {
            ContactHandler.updateCountonAccount(Trigger.new);
        }
        if(Trigger.isUpdate)
        {
            ContactHandler.updateCountonAccount(Trigger.new);
        }
        if(Trigger.isDelete)
        {
            ContactHandler.updateCountonAccount(Trigger.old);
        }
    }
*/
    if(Trigger.isBefore && Trigger.isUpdate){
        ContactHandler.updateContactWithRT(Trigger.new,Trigger.oldMap);
    }
    
    
}