public class leadTriggerHandler {
    
    public static void createTask(List<Lead> leadList,Map<Id,Lead> oldMap){
        
        Set<Id>accId = new Set<Id>();
        Set<Id>conId = new Set<Id>();
        Set<Id>oppId = new Set<Id>();
        List<Task> taskList = new List<Task>();
        Map<Id,Contact> taskContact = new Map<Id,Contact>();
        Map<Id,Account> taskAccount = new Map<Id,Account>();
        Map<Id,Opportunity> taskOpportunity = new Map<Id,Opportunity>();
        
        if(leadList != null){
            for(Lead leadObj : leadList){
                if(oldMap != null){
                    if(leadObj.IsConverted && !(oldMap.get(leadObj.Id).IsConverted)){
                        if(leadObj.ConvertedAccountId != null || leadObj.ConvertedContactId != null || leadObj.ConvertedOpportunityId != null){
                            accId.add(leadObj.ConvertedAccountId);
                            conId.add(leadObj.ConvertedContactId);
                            oppId.add(leadObj.ConvertedOpportunityId);   
                        }
                    }
                }
                
            }
        }
        
        if(leadList != null ){
            if(!accId.isEmpty()){
                taskAccount = new Map<Id,Account>([Select Id,Name from Account WHERE Id IN :accId]);
            }
            if(!accId.isEmpty()){
                taskContact = new Map<Id,Contact>([Select Id,Name,Email from Contact WHERE Id IN :conId]);
            }
            
            if(!accId.isEmpty()){
                taskOpportunity = new Map<Id,Opportunity>([Select Id,Name from Opportunity WHERE Id IN :oppId]);
            }
            
            
            for(Lead leadObj : leadList){
                Task tas = new Task();
                tas.WhoId = leadObj.ConvertedContactId;
                tas.WhatId = leadObj.ConvertedOpportunityId;
                tas.ActivityDate = Date.today()+7;
                tas.Status = 'Not Started';
                tas.Subject = 'Follow up task for converted Leads';
                
                tas.Description = 'Lead Name :'+leadObj.FirstName+' '+leadObj.LastName+'\n'+
                    'Lead Email :'+leadObj.Email+'\n'+
                    'Lead Phone :'+leadObj.Phone+'\n'+
                    'Account Name :'+taskAccount.get(leadObj.ConvertedAccountId).Name+'\n'+
                    'Contact Name :'+taskContact.get(leadObj.ConvertedContactId).Name+'\n'+
                    'Opportunity Name :'+taskOpportunity.get(leadObj.ConvertedOpportunityId).Name;
                taskList.add(tas);
            }
        }
        
        if(! taskList.isEmpty())
            insert taskList;
    }
    
    public static void updateConvertedData(List<Lead>leadList, Map<Id,Lead> oldMap){
        
        Set<Id>accId = new Set<Id>();
        Set<Id>conId = new Set<Id>();
        List<Account> accListToUpdate = new List<Account>();
        List<Contact> conListToUpdate = new List<Contact>();
        List<Opportunity> oppListToUpdate = new List<Opportunity>();
        Map<Id,String> oppIdLeadnameMap = new Map<Id,String>();
        
        if(leadList != null){
            for(Lead leadObj : leadList){
                if(oldMap != null){
                    if(leadObj.IsConverted && !(oldMap.get(leadObj.Id).IsConverted)){
                        if(leadObj.ConvertedAccountId != null || leadObj.ConvertedContactId != null || leadObj.ConvertedOpportunityId != null){
                            accId.add(leadObj.ConvertedAccountId);
                            conId.add(leadObj.ConvertedContactId);  
                            oppIdLeadnameMap.put(leadObj.ConvertedOpportunityId,leadObj.FirstName+' '+leadObj.LastName);
                        }
                    }
                }   
            }
        }
        
        if(!accId.isEmpty()){
            for(Account acc : [Select Id from Account WHERE Id IN :accId]){
                acc.ktrailhead__Active__c = 'Yes';
                accListToUpdate.add(acc);
            }
        }
        
        if(!conId.isEmpty()){
            for(Contact con : [Select Id from Contact WHERE Id IN :conId]){
                con.ktrailhead__Lead_Contact__c = 'Yes';
                conListToUpdate.add(con);
            }
        }
        if(!oppIdLeadnameMap.isEmpty()){
            for(Opportunity opp : [Select Id from Opportunity WHERE Id IN :oppIdLeadnameMap.keySet()]){
                opp.Description = oppIdLeadnameMap.get(opp.Id);
                oppListToUpdate.add(opp);
            }
        }
        
        if(oppListToUpdate.isEmpty())
            update oppListToUpdate;
        
        if(!conListToUpdate.isEmpty())
            update conListToUpdate;
        
        if(!accListToUpdate.isEmpty())
            update accListToUpdate;
        
        
    }
    
}