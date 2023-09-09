trigger AccountTrigger on Account (after update,before insert,after insert,before delete) {
    /*
    //AccountTriggerHandler.updateRelatedContact(Trigger.New, Trigger.OldMap);
    //AccountTriggerHandler.sendEmailToOwner(Trigger.New, Trigger.OldMap);
    //AccountTriggerHandler.updateOpp(Trigger.New);
    if(Trigger.isBefore && Trigger.isInsert){
        if(!Trigger.new.isEmpty()){
            for(Account acc : Trigger.new){
                if(acc.Phone == null){
                    acc.addError('You cannot inser account with Phone field empty');
                }
            }
        }
    }
    
     List<Contact> conList = new List<Contact>();
    for(Account acc: trigger.new)
    {
        Contact con = new Contact();
        con.LastName = acc.Name;
        con.AccountId = acc.Id;
        conList.add(con);
    }
    insert conList;
    
    if(Trigger.isBefore)
    {
        if(Trigger.isInsert)
        {
            AccountTriggerHandler.validateDuplicacy(Trigger.new);
        }
        
        if(Trigger.isDelete)
        {
            AccountTriggerHandler.restrictActiveDelete(Trigger.old);
        }
        
    }
    */
            if(Trigger.isAfter)
        {
            if(Trigger.isInsert || Trigger.isUpdate)
            {
                //AccountTriggerHandler.createContact(Trigger.new);
                //AccountTriggerHandler.updateOpportunities(Trigger.new);
                //AccountTriggerHandler.sendEmailToContact(Trigger.OldMap, Trigger.newMap);
                //AccountTriggerHandler.closeOpp(Trigger.new);
                AccountTriggerHandler.updateContactOpportunities(Trigger.new,Trigger.oldMap);
            }
            
           
        }
}