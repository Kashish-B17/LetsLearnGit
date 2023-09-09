public class ContactHandler {
    
    public static void updateCountonAccount(List<Contact> conList)
    {
        Set<Id> accId = new Set<Id>();
        for(Contact con : conList)
        {
            accId.add(con.AccountId);
        }
        
        List<Account> accList = new List<Account>();
        List<AggregateResult> aggrList = [Select Count(Id)con, AccountId from Contact WHERE AccountId IN :accId GROUP BY AccountId];
        
        for(AggregateResult aggr : aggrList)
        {
            Account acc = new Account();
            acc.Id = (Id)aggr.get('AccountId');
            acc.countContact__c = (Decimal)aggr.get('con');
            accList.add(acc);  
        }
        update accList;
    }
    
    public static void validateDuplicacy(List<Contact> conList)
    {
        Set<String>PhoneSet = new Set<String>();
        Set<String> EmailSet = new Set<String>();
        String Error = '';
        for(Contact con : conList)
        {
            PhoneSet.add(con.Phone);
            EmailSet.add(con.Email);
        }
        
        List<COntact> existingList = [Select Id,Phone,Email from Contact WHERE Phone IN :PhoneSet AND Email IN :EmailSet];
        if(!existingList.isEmpty()){
            Error = 'Duplicate Record found';
        }
        
        for(Contact conObj : conList){
            if(Error != ''){
                conObj.addError(Error);
            }
        }
        
    }
    
    public static void validatePrimary(List<Contact> conList)
    {
        Set<Id> accId = new Set<id>();
        String ErrorMessage = '';
        for(Contact con : conList){
            
            If(con.Primary_Contact__c == true){
                accId.add(con.AccountId);
            }
            
        }
        List<Contact> conListExisting = [Select Id,AccountId,Primary_Contact__c from Contact WHERE AccountId IN :accId AND Primary_Contact__c = true];
        if(!conListExisting.isEmpty()){
            ErrorMessage = 'You cannot select it as a primary Contact';
        }
        
        for(Contact con : conList){
            if(ErrorMessage !='')
                con.addError(ErrorMessage);
        }
    }
    
    public static void updateContactWithRT(List<Contact>newList,Map<Id,Contact>oldMap){
        
        Set<Id>accId = new Set<Id>();
        Map<Id,String> mapOfIdAndAccount = new Map<Id,String>();
        
        if(!newList.isEmpty()){
            for(Contact con : newList){
                accId.add(con.AccountId);
            }
        }
        if(!accId.isEmpty()){
            for(Account acc : [Select Id,RecordType.Name,Name FROM Account WHERE Id IN :accId]){
                mapOfIdAndAccount.put(acc.Id,acc.RecordType.Name);
            }
        }
        
        for(Contact con :newList){
            if(!newList.isEmpty() && oldMap == null){
                accId.add(con.AccountId);
                String recordType = mapOfIdAndAccount.get(con.AccountId);
                
                if(recordType == 'Customer'){
                    con.ktrailhead__Contact_Type__c = 'Customer';
                }
                else if(recordType == 'Lead'){
                    con.ktrailhead__Contact_Type__c = 'Lead';
                    
                }
                else if(recordType == 'Partner'){
                    con.ktrailhead__Contact_Type__c = 'Partner';
                }
                
            }
            
            
            else{
                if(!newList.isEmpty() && !oldMap.isEmpty()){
                    String recordType =  mapOfIdAndAccount.get(con.AccountId);
                    if(con.ktrailhead__Contact_Type__c != oldMap.get(con.Id).ktrailhead__Contact_Type__c){
                        if(con.ktrailhead__Contact_Type__c != recordType){
                            System.debug('con.ktrailhead__Contact_Type__c '+con.ktrailhead__Contact_Type__c+'recordType ');
                            con.addError('You cannot change the type');
                        }
                    }
                }
            }
        }
        
        
    }
    
}