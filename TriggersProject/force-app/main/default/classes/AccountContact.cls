public class AccountContact {

    @AuraEnabled(cacheable=true)
    public static List<Account> allAccountWithContact()
    {
        return [Select Id,Name, Phone, Website,(Select Id,Name,Phone,Email from Contacts) from Account Limit 5];
    } 

}