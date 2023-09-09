public class AccountTriggerHandler {
    
    public static void updateRelatedContact(List<Account> newAccList, Map<Id,Account> oldMapAcc)
    {
        Map<Id,String> mapOfIDandName = new Map<Id,String>();
        List<Contact> conListToUpdate = new List<Contact>();
        for(Account acc : newAccList)
        {
            Boolean isChanged = (oldMapAcc != null)?(oldMapAcc.get(acc.Id).Name != acc.Name) ? true : false : false;
            mapOfIDandName.put(acc.id,acc.Name);
        }
        for(Contact con : [Select Id, Name, Email, AccountId from Contact WHERE AccountId IN :oldMapAcc.KeySet()])
        {
            
            con.FirstName = mapOfIDandName.get(con.AccountId);
            conListToUpdate.add(con);
            
            
        }
        update conListToUpdate;
    }
    /*
public static void sendEmailToOwner(List<Account> newAccList, Map<Id,Account> oldMapAcc){
List<Messaging.SingleEmailMessage> listOfEmail = new List<Messaging.SingleEmailMessage>();

for(Account acc : newAccList)
{   
Boolean isOwnerChanged = (oldMapAcc != null)?(oldMapAcc.get(acc.Id).ownerId != acc.OwnerId) ? true : false : false;
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setTargetObjectId = acc.id;
mail.setToAddress = 

}
}
*/
    public static void updateOpp(List<Account> accList){
        List<Opportunity> oppListToUpdate = new List<Opportunity>();
        Set<Id> accId = new Set<Id>();
        
        for(Account acc : accList){
            accId.add(acc.Id);
        }
        
        for(Opportunity opp : [Select Id,StageName, CreatedDate from Opportunity WHERE StageName != 'Closed Won' AND CreatedDate < LAST_N_DAYS : 30]){
            opp.StageName = 'Closed Lost';
            oppListToUpdate.add(opp);
        }
        
        update oppListToUpdate;
    }
    /*
Approach 1
List<Contact> conListToUpdate = new List<Contact>();
List<Contact> conList = [Select id,Name,AccountId from Contact Where AccountId IN :oldMapAcc.KeySet()];
for(Account acc : newAccList){
for(Contact con : conList){
con.FirstName = acc.Name;
conListToUpdate.add(con);
}
}

update conListToUpdate;

*/
    public static void countOppLieItem(List<OpportunityLineItem>oppLitemlist)
    {
        Set<Id> oppList = new Set<Id>();
        for(OpportunityLineItem oppLitem : oppLitemlist){
            oppList.add(oppLitem.OpportunityId);
        }
        
        Map<Id,Decimal> CountToUpdateMap = new Map<Id,Decimal>();
        
        for(Opportunity opp : [Select Id,AccountId, Account.ID from Opportunity WHERE ID IN:oppList]){
            CountToUpdateMap.put(opp.AccountId,0);
        }
        
        List<Account> accList = new List<Account>();
        List<AggregateResult> aggList = [Select Count(Id)oli,Opportunity.AccountId from OpportunityLineItem Where ListPrice > 50000 AND Opportunity.AccountId IN :CountToUpdateMap.keyset() GROUP BY Opportunity.AccountId];
        for(AggregateResult agg : aggList){
            CountToUpdateMap.put((Id)agg.get('AccountId'),(Decimal)agg.get('oli'));
        }
        
        for(Account acc : [Select Id from Account Where ID IN:CountToUpdateMap.keySet()]){
            
            acc.Opp_Line_Item_Count__c = CountToUpdateMap.get(acc.Id);
            accList.add(acc);
        }
        update accList;
        
    }
    
    
    public static void validateDuplicacy(List<Account> accList)
    {
        List<Account> listofAccount = [Select Id,Name from Account WHERE Name!=null];
        Map<String,Id> mapOfName = new Map<String,Id>();
        for(Account acc : listofAccount)
        {
            mapOfName.put(acc.Name,acc.Id);
        }
        
        for(Account accObj : accList)
        {
            if(mapOfName.containsKey(accObj.Name))
            {
                accObj.addError('Duplicate record was found with this Name');
            }
        }
        
    }
    
    public static void createContact(List<Account> accList)
    {
        
        List<Contact> conList = new List<Contact>();
        Boolean isCreated = true;
        if(isCreated == true)
        {
            isCreated = false;
            for(Account acc : accList)
            {
                if(acc.createContact__c == true)
                {
                    Contact con = new Contact();
                    con.AccountId = acc.Id;
                    con.Phone = acc.Phone;
                    con.LastName = 'Creating with Related';
                    conList.add(con);
                }
            }
            insert conList;
        } 
        
        
        
        
    }
    
    public static void updateOpportunities(List<Account> accList)
    {
        List<Opportunity> oppList = new List<Opportunity>();
        Set<Id> accId = new Set<Id>();
        for(Account acc :accList)
        {
            accId.add(acc.Id);
        }
        
        for(Opportunity opp : [SELECT Id, StageName, AccountId, CreatedDate FROM Opportunity WHERE CreatedDate < LAST_N_DAYS:30 AND AccountId IN :accId AND StageName!='Closed Won'])
        {
            opp.StageName = 'Closed Lost';
            oppList.add(opp);
        }
        update oppList;
        
    }
    
    public static void restrictActiveDelete(List<Account> accList)
    {
        for(Account acc : accList)
        {
            if(acc.Active__c == 'Yes')
            {
                acc.addError('You cannot delete a active record');
            }
        }
    }
    
    
    
    public static void sendEmailToContact(Map<Id,Account>newMapOfAccId, Map<Id,Account>mapOfOldAccount){
        Set<Id> accId = New Set<Id>();
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        for(Id recordId :newMapOfAccId.keySet())
        {
            if(mapOfOldAccount.get(recordId).Type != (newMapOfAccId.get(recordId).Type))
            {
                accId.add(recordId);
            }
        }
        for(Contact con : [Select Id,Name,Email,Account.Name, AccountId from Contact WHERE AccountId IN :accId])
        {
            List<String> mailList = new List<String>();
            mailList.add(UserInfo.getUserEmail());
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setHtmlBody('your Account is updated '+con.Account.Name);
            mail.setToAddresses(mailList); 
            mail.setSubject('Please check the Updated Account');
            emailList.add(mail);            
        }
        
        Messaging.sendEmail(emailList);
        
    }
    
    public static void closeOpp(List<Account>accList)
    {
        List<Opportunity>oppList = new List<Opportunity>();
        Set<Id> accIdSet = new Set<Id>();
        if(accList.size()>0){
            for(Account acc : accList)
            {
                if(acc.Close_all_Opps__c == true)
                {
                    accIdSet.add(acc.Id);
                }
            }
        }
        
        for(Opportunity opp : [Select Id,Probability,StageName from Opportunity WHERE AccountId IN :accIdSet AND Probability > 70]){
            if(opp!=null){
                opp.StageName = 'Closed Won';
                opp.CloseDate = Date.today();
                oppList.add(opp);
            }
            
        }
        update oppList;
        
    }
    
    public static void updateCountOnAccOLI(List<OpportunityLineItem>oliList){
        List<Account>accListToUpdate = new List<Account>();
        Map<Id,Decimal> countToUpodate = new Map<Id,Decimal>();
        Set<Id> oppId = new Set<Id>();
        for(OpportunityLineItem oli : oliList)
        {
            oppId.add(oli.OpportunityId);
        }
        
        for(Opportunity opp : [Select Id,AccountId from Opportunity WHERE ID IN :oppId]){
            countToUpodate.put(opp.AccountId,0);
        }
        
        List<AggregateResult> aggList = [Select Count(Id)oli,Opportunity.AccountId from OpportunityLineItem Where Opportunity.AccountId IN :countToUpodate.keyset() GROUP BY Opportunity.AccountId];
        
        for(AggregateResult agg : aggList)
        {
            countToUpodate.put((Id)agg.get('AccountId'),(Decimal)agg.get('oli'));
        }
        
        for(Account acc : [Select Id,Name from Account WHERE ID IN :countToUpodate.keySet()]){
            acc.Count_OLI__c = countToUpodate.get(acc.Id);
            accListToUpdate.add(acc);            
        }
        
        update accListToUpdate;
    }
    
    public static void updateContactOpportunities(List<Account> accList,Map<Id,Account>oldMapAcc){
        
        List<Contact> conListToUpdate = new List<Contact>();
        List<Opportunity> oppList = new List<Opportunity>();
        Set<Id> accIdSet = new Set<Id>();
        
        if(!accList.isEmpty()){
            for(Account acc :accList){
                if(oldMapAcc != null){
                    if(acc.ktrailhead__Account_Status__c != oldMapAcc.get(acc.Id).ktrailhead__Account_Status__c && acc.ktrailhead__Account_Status__c == 'Inactive'){
                        accIdSet.add(acc.Id);
                    }
                }
            }
        }
        
        if(!accIdSet.isEmpty()){
            
            for(Contact con :[Select Id,DoNotCall,AccountId from Contact WHERE AccountId IN :accIdSet]){
                con.DoNotCall = true;
                conListToUpdate.add(con);
            }
            System.debug('conListToUpdate is '+conListToUpdate);
            
            for(Opportunity opp :[Select Id,AccountId,StageName from Opportunity WHERE AccountId IN :accIdSet AND StageName = 'Closed Won']){
                oppList.add(opp);
            }
        }
        
        if(!conListToUpdate.isEmpty())
            update conListToUpdate;
        if(!oppList.isEmpty())
            delete oppList;
    } 
    
    
}