trigger AccountSalaryTrigger on ktrailhead__Account_Salary__c (after insert,after update,after delete, after undelete) {
    
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            AccountSalaryHandler.updateAccountSalary(Trigger.new,Trigger.oldMap);	
            
        }
        else if(Trigger.isInsert || Trigger.isUndelete){
             AccountSalaryHandler.updateAccountSalary(Trigger.new,null);	
        }
        else{
             AccountSalaryHandler.updateAccountSalary(Trigger.old,null);	
        }
    }

}