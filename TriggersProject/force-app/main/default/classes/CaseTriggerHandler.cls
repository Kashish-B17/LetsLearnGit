public class CaseTriggerHandler 
{
    public static void updateAccount(List<Case>caseList)
    {
        Map<Id, String> mapOfaccId = new Map<Id,String>();
        List<Account> accList = new List<Account>();
        for(Case caObj : caseList)
        {
            if(caObj.AccountId!=null)
            {
                mapOfaccId.put(caObj.AccountId, caObj.CaseNumber);   
            }
        }
        
        for(Account acc:[Select Id,Latest_Case_Number__c from Account WHERE ID IN :mapOfaccId.keySet()])
        {
            acc.Latest_Case_Number__c = mapOfaccId.get(acc.Id);
            accList.add(acc);
        }
        update accList;
        
    }
    
    public static void updateAccountCaseStatus(List<Case>caseList,Map<Id,Case>caseOldMap){
        
        Set<Id> accId = new Set<Id>();
        Map<Id,Decimal> newStatusMap = new Map<Id,Decimal>();
        Map<Id,Decimal> closedStatusMap = new Map<Id,Decimal>();
        List<Account> accListToUpdate = new List<Account>();
        
        if(caseList != null){
            for(Case ca : caseList){
                if(caseOldMap != null){
                    if(ca.Status != caseOldMap.get(ca.Id).Status){
                        accId.add(ca.AccountId);
                    }
                }
                else{
                    accId.add(ca.AccountId);
                }
            }
        }
        List<AggregateResult> aggrList = [Select  COUNT(Id) countId,Status,AccountId  from Case WHERE AccountId IN :accId GROUP BY Status,AccountId];
        
        for(AggregateResult ag : aggrList){
            Account a = new Account();
            a.Id = (Id)ag.get('AccountId');
            if(ag.get('Status') == 'New'){
                newStatusMap.put(a.Id,(Decimal)ag.get('countId'));
            }
            if(ag.get('Status') == 'Working'){
                closedStatusMap.put(a.Id,(Decimal)ag.get('countId'));
            }        
            
        }
        
        for(Account acc : [Select Id,ktrailhead__Closed_Status__c,ktrailhead__New_Status__c from Account WHERE Id IN :accId]){
            acc.ktrailhead__New_Status__c = newStatusMap.get(acc.Id);
            acc.ktrailhead__Closed_Status__c = closedStatusMap.get(acc.Id);
            accListToUpdate.add(acc);
        }
        
        if(! accListToUpdate.isEmpty() )
            update accListToUpdate;
    }
    
    public static void updateTaskAndAccount(List<Case>caseList,Map<Id,Case>caseOldMap){
        Map<Id, Case> mapOfaccIdAndCase = new Map<Id,Case>();
        List<Account> accList = new List<Account>();
        List<Task> taskList = new List<Task>();
        Map<Id,String> mapOfIdtask = new Map<Id,String>();
        
        if(caseList != null){
            for(Case ca : caseList){
                if(caseOldMap != null){
                    if(ca.Status != caseOldMap.get(ca.Id).Status){
                        mapOfaccIdAndCase.put(ca.AccountId,ca);
                        mapOfIdtask.put(ca.Id,ca.Status);
                    }
                }
                else{
                    mapOfaccIdAndCase.put(ca.AccountId,ca);
                    mapOfIdtask.put(ca.Id,ca.Status);
                }
            }
        }
        
        for(Account acc : [Select Id,ktrailhead__Latest_Case_Number__c,Description from Account WHERE Id IN :mapOfaccIdAndCase.keySet()]){
            acc.ktrailhead__Latest_Case_Number__c = mapOfaccIdAndCase.get(acc.Id).CaseNumber;
            acc.Description = mapOfaccIdAndCase.get(acc.Id).Status;
            accList.add(acc);
        }
        System.debug('accList--'+accList);
        for(Task ta : [Select Id,Status,WhatId from Task WHERE WhatId IN :mapOfIdtask.keySet()]){
            ta.Status = mapOfIdtask.get(ta.WhatId);
            taskList.add(ta);
        }
        System.debug('taskList--'+taskList);
        
        if(!taskList.isEmpty()){
            update taskList;
        }
        if(!accList.isEmpty()){
            update accList;
        }
    }
    
    public static void createEventContact(List<Case>caseList){
        
        List<Case>caseListToUpdate = new List<Case>();
        List<Event> eveList = new List<Event>();
        Set<Id> accId = new Set<Id>();
        Set<Id> conId = new Set<Id>();
        Map<Id,Case>mapOfAccAndCase = new Map<Id,Case>();
        if(!caseList.isEmpty()){
            for(Case ca : caseList){
                if(ca.AccountId!=null){
                    accId.add(ca.AccountId);
                    mapOfAccAndCase.put(ca.AccountId,ca);
                }
            }
        }
        
        for(Contact con :[Select Id,ktrailhead__Primary_Contact__c,AccountId from Contact 
                          WHERE AccountId IN :mapOfAccAndCase.keySet() 
                          AND ktrailhead__Primary_Contact__c = true LIMIT 1])
        {
            
            Case ca = new Case();
            ca.Id = mapOfAccAndCase.get(con.AccountId).Id;
            ca.ContactId = con.Id;
            caseListToUpdate.add(ca);
            
            Event e = new Event();
            e.Subject = mapOfAccAndCase.get(con.AccountId).Subject;
            e.ActivityDate = Date.today()+4;
            e.WhoId = con.Id;
            e.DurationInMinutes = 60;
            e.ActivityDateTime = DateTime.now();
            eveList.add(e);
            
        }
        if(!eveList.isEmpty())
            insert eveList;
        if(!caseListToUpdate.isEmpty())
            update caseListToUpdate;
    }
    
    public static void createFollowUpTask(List<Case> newList,Map<Id,Case>oldMap){
        
        List<Task> taskList = new List<Task>();
        Set<Id>accId = new Set<Id>();
        
        if(!newList.isEmpty()){
            for(Case ca : newList){
                if(!oldMap.isEmpty() && ca.ktrailhead__Escalation_Required__c == true && oldMap.get(ca.Id).ktrailhead__Escalation_Required__c == false){
                    accId.add(ca.AccountId);
                }
            }
        }
        for(Contact con : [Select Id, AccountId from Contact WHERE AccountId IN : accId]){
            
            Task ta = new Task();
            ta.WhatId = con.AccountId;
            ta.WhoId = con.Id;
            ta.ActivityDate = Date.today()+4;
            ta.Subject = 'Task created for follow up on escalation';
            ta.Status = 'Not Started';
            taskList.add(ta);
            
        }
        
        insert taskList;
    }
}