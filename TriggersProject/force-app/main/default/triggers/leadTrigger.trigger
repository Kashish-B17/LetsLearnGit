trigger leadTrigger on Lead (after update) {
    
    //leadTriggerHandler.createTask(Trigger.new,Trigger.oldMap);
    leadTriggerHandler.updateConvertedData(Trigger.new,Trigger.oldMap);
}