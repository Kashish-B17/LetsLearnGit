trigger EmployeeTrigger on Employee__c (after insert,after update,after delete,after undelete) {

    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
    {
        EmployeeHandler.updateParent(Trigger.new);
    }
}