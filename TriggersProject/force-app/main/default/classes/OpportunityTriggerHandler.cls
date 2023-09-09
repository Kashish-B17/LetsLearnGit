public class OpportunityTriggerHandler {
    
    public static void sumOfAmountAcc(List<Opportunity> newOppList)
    {
        List<AggregateResult> aggResult = [Select AccountId,Sum(Amount) total, Count(Id) from Opportunity GROUP BY AccountId];
        List<Account> newAccList = new List<Account>();
        
        for(AggregateResult result : aggResult){
            Account acc = new Account();
            acc.Id = (Id)result.get('AccountId');
            acc.Opportunity_Amount__c = (Decimal)result.get('total');
            newAccList.add(acc);
        }
        
        update newAccList;
    }
    
    public static void updateOppName(List<Opportunity> newOppList){
        
        Set<Id> AccId = new Set<Id>();
        for(Opportunity opp : newOppList){
            AccId.add(opp.Account.Id);
        }
        List<Account> AccResult = [Select Id,Description,Name,(SELECT Id,Amount,Name from Opportunities WHERE Amount!=null ORDER BY Amount Desc LIMIT 1) from Account WHERE ID IN :AccId];
        List<Account> newAccList = new List<Account>();
        for(Account acc : AccResult){
            acc.Description = acc.Description+' - '+acc.Opportunities[0].Name;
            newAccList.add(acc);
        }
        update newAccList;
    }
    
    public static void CreateUpdatetask(List<Opportunity> oppNewList,Map<Id,Opportunity>oldMap)
    {
        Set<Id>oppSetId = new Set<Id>();
        Map<Id,Task> newMapTask = new Map<Id,Task>();
        List<Task>tskList = new List<Task>();
        List<Task>tskListToInser = new List<task>();
        
        for(Opportunity opp : oppNewList){
            oppSetId.add(opp.Id);   
        }
        
        for(Task tsk : [Select Id,WhatId from Task WHERE WhatId IN :oppSetId])
        {
            newMapTask.put(tsk.WhatId,tsk);
        }
        
        for(Opportunity oppObj : oppNewList){
            Task newTask;
            
            if(newMapTask.containsKey(oppObj.Id)){
                newTask = newMapTask.get(oppObj.Id);
                newTask.Description = 'This task updated wsith Opp Stage -->'+oppObj.StageName;
                tskList.add(newTask);
            }
            else{
                newTask = new Task();
                newtask.Subject = 'Created with Opp Trigger';
                newTask.WhatId = oppObj.Id;
                newTask.OwnerId = UserInfo.getUserId();
                newTask.Status = 'Not Started';
                newTask.ActivityDate = Date.today();
                tskListToInser.add(newTask);
            }
            
        }
        
        if(!tskListToInser.isEmpty()){
            insert tskListToInser;
        }
        
        if(!tskList.isEmpty())
        {
            update tskList;
        }
        
    }
    
    public static void updateAccountStatus(Map<Id,Opportunity>oldMap,List<Opportunity>oppNewList){
        
        List<Account> accListToUpdate = new List<Account>();
        Set<Id> accIdSet = new Set<Id>();
        List<Account> accIdToUpdate = new List<Account>();
        for(Opportunity oppNew:oppNewList){
            if(oldMap != null){
                if(oppNew.StageName != oldMap.get(oppNew.Id).StageName){
                    accIdSet.add(oppNew.AccountId);	
                }
            }
                else {
                    accIdSet.add(oppNew.AccountId);	
                }
            
            
        }
        Map<Id,String> mapofAccIdandStage = new Map<Id,String>();
        for(Opportunity opp : [Select Id,AccountId,StageName from Opportunity WHERE AccountId IN :accIdSet]){
            if(opp.StageName == 'Closed Won'){
                mapofAccIdandStage.put(opp.AccountId,opp.StageName);
            }
            else if(opp.StageName != 'Closed Won'){
                mapofAccIdandStage.put(opp.AccountId,opp.StageName);
                break;
            }
        }
        
        for(Account acc : [Select Id,Account_Status__c from Account WHERE Id IN :mapofAccIdandStage.keySet()]){
            if(mapofAccIdandStage.ContainsKey(acc.Id)){
                if(mapofAccIdandStage.get(acc.Id) == 'Closed Won'){
                    acc.Account_Status__c = 'Closed';
                }
                else if(mapofAccIdandStage.get(acc.Id) != 'Closed Won'){
                    acc.Account_Status__c = 'Open';
                }
                accListToUpdate.add(acc);
                
                
            }
            
        }
        
        update accListToUpdate;
        
        
    }
    
    public static void updateContactRole(List<Opportunity> oppList,Map<Id,Opportunity>oldMap){
        
        List<OpportunityContactRole>  oppConRole = new List<OpportunityContactRole>();
        Set<Id> oppId = new Set<Id>();
        Set<Id>conId = new Set<Id>();
        Map<Id,Id> oppContactRole = new Map<Id,Id>();
        
        if(!oppList.isEmpty()){
        for(Opportunity opp : oppList){
            if(oldMap != null){
                if(opp.Type != oldMap.get(opp.Id).Type){
                    if(opp.ContactId == null){
                        opp.addError('There is not Contact');
                    }
                    else{
                        oppId.add(opp.Id);
                        conId.add(opp.ContactId);
                        oppContactRole.put(opp.Id,opp.ContactId);
                    }
                }
            }
        }
        }
        
        List<OpportunityContactRole>  oppConRoleToDelete =  [Select Id,OpportunityId,ContactId from OpportunityContactRole WHERE OpportunityId IN :oppId AND ContactId IN :conId];
            
        if(!oppConRoleToDelete.isEmpty()){
            delete oppConRoleToDelete;
        }
            for(Opportunity opp: [Select Id,ContactId from Opportunity WHERE Id IN :oppId]){
                
                OpportunityContactRole oppCon = new OpportunityContactRole();
                oppCon.OpportunityId = opp.Id;
                oppCon.ContactId = opp.ContactId;
                
                oppConRole.add(oppCon);
            }
        if(!oppConRole.isEmpty())
            insert oppConRole;
    }
}