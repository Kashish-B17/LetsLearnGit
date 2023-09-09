trigger OpportunityLineItemTrigger on OpportunityLineItem (after insert, after delete,before insert,after update) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            //AccountTriggerHandler.countOppLieItem(Trigger.new);
            AccountTriggerHandler.updateCountOnAccOLI(Trigger.new);
            OpportunityLineItemTriggerHandler.createAsset(Trigger.new);
        }
        if(Trigger.isDelete){
            //AccountTriggerHandler.countOppLieItem(Trigger.old);
        }
        if(Trigger.isUpdate){
            OpportunityLineItemTriggerHandler.updateDescForAccount(Trigger.OldMap,Trigger.newMap);
        }
        
    }
    
    if(Trigger.isBefore && Trigger.isInsert){
        //OpportunityLineItemTriggerHandler.restrictOppLItem(Trigger.new);
    }
}