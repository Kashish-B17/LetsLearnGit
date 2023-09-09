public class EmployeeHandler {
    
    public static void updateParent(List<Employee__c> empList){
        List<Tech_Firm__c> techList = new List<Tech_Firm__c>();
        Set<Id> empId = new Set<Id>();
        for(Employee__c emp : empList)
        {
            if(emp.Salary__c!=null)
            {
                empId.add(emp.Id);
            }
        }
        List<AggregateResult> listOfAgg = [Select Min(Salary__c) MinSalary, Max(Salary__c) MaxSalary,Tech_Firm__r.Id from Employee__c GROUP BY Tech_Firm__r.Id];
        for(AggregateResult agg : listOfAgg)
        {
            Tech_Firm__c tc = new Tech_Firm__c();
            tc.Id = (Id)agg.get('Id');
            tc.Max_Salarty__c = (Decimal)agg.get('MaxSalary');
            tc.Min_Salary__c = (Decimal)agg.get('MinSalary');
            techList.add(tc);
        }
        update techList;
        
    }
}