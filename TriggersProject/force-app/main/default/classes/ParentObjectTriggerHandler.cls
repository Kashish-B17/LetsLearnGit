public class ParentObjectTriggerHandler {
    
    public static void restrictParentToDelete(Map<Id,Parent_Object__c> oldMapParent)
    {
        for(Parent_Object__c pObj : [Select id,(Select Id from Child_Objects__r ) from Parent_Object__c Where Id IN :oldMapParent.KeySet()] ){
            if(pObj.Child_Objects__r.size() >= 10){
                System.debug('pObj.Child_Objects__r.size');
                pObj.addError('You cannot delete a record if child is more than 10');
            }
        }
    }
}