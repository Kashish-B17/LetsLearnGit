trigger OpportunitiesTrigger on Opportunity (after update,after insert) {
    
        //OpportunityTriggerHandler.sumOfAmountAcc(Trigger.new);
        //OpportunityTriggerHandler.updateOppName(Trigger.new);
        //OpportunityTriggerHandler.CreateUpdatetask(Trigger.new,Trigger.OldMap);
        if(Trigger.isAfter && Trigger.isUpdate)
        //OpportunityTriggerHandler.updateAccountStatus(Trigger.OldMap, Trigger.new);
    OpportunityTriggerHandler.updateContactRole(Trigger.new,Trigger.oldMap);
        if(Trigger.isAfter && Trigger.isInsert)
            OpportunityTriggerHandler.updateAccountStatus(null, Trigger.new);

    
}