public class AccountSalaryHandler {
    
    public static void updateAccountSalary(List<ktrailhead__Account_Salary__c> accSalryNewList,Map<Id,ktrailhead__Account_Salary__c> mapOfOldAccSalary){
        
        List<Account> accListToUpdate = new List<Account>();
        Set<Id> accId = new Set<Id>();
        for(ktrailhead__Account_Salary__c AccS : accSalryNewList){
            accId.add(AccS.ktrailhead__Account__c);
        }
        System.debug('Account Id'+accId);
        List<AggregateResult> aggList = [Select SUM(ktrailhead__Salary__c) total, ktrailhead__Account__r.Id acc,MAX(ktrailhead__Salary__c) max 
                                         from ktrailhead__Account_Salary__c  
                                         WHERE ktrailhead__Account__r.Id IN : accId 
                                         GROUP BY ktrailhead__Account__r.Id];
        System.debug('Aggregate Result'+aggList);
        
        for(AggregateResult agg : aggList){
            Account acc = new Account();
            acc.Id = (Id)agg.get('acc');
            acc.ktrailhead__Total_Salary__c = (Decimal)agg.get('total');
            acc.ktrailhead__Max_Salary__c = (Decimal)agg.get('max');
            accListToUpdate.add(acc);
        }
        System.debug('Acc List to Update'+accListToUpdate);
        if(!accListToUpdate.isEmpty()){
            update accListToUpdate;
        }
        
    }

}