public class AccountHandler {

    @AuraEnabled
    public static List<Account> getAccount(String searchKey)
    {
          String key = '%' + searchKey + '%';
        return [Select id,Name, Type, AccountNumber, Active__c from Account Where Name Like :key];
        
    }
}