public class AccountHelper {
    
    @AuraEnabled(cacheable=true)
    public static List<Account> fetchAccount(string searchType){
        String query = '';
        if(String.isNotBlank(searchType)){
            String searchKey = 'Name LIKE \'' + '%' + searchType + '%\'';
            query = 'Select Id,Name,Phone,Website from Account WHERE '+searchKey;
        }
        else{
            query = 'Select Id,Name,Phone,Website from Account';
        }
         
        return Database.query(query);
    }

}