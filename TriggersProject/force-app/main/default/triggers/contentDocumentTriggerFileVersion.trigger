trigger contentDocumentTriggerFileVersion on ContentDocumentLink (after insert) {
    
    
    List<Id> customObjectIdsToUpdate = new List<Id>();
    Set<Id> ContentDocumentIdSet = new Set<Id>();
    
    // Iterate through the inserted ContentDocument records
    for (ContentDocumentLink cd : Trigger.new) {
        // Check if the file is associated with a custom object (your custom relationship field)
        System.debug('cd ContentDocuemntId'+cd.ContentDocumentId);
        System.debug('cd linkedentity Id'+cd.LinkedEntityId);
        if (cd.LinkedEntityId != null) {
            customObjectIdsToUpdate.add(cd.LinkedEntityId);
            ContentDocumentIdSet.add(cd.ContentDocumentId);
            System.debug('customObjectIdsToUpdate-->'+customObjectIdsToUpdate);
            System.debug('ContentDocumentIdSet-->'+ContentDocumentIdSet);
        }
    }
    
    ContentDistribution cdi = new ContentDistribution();
    for(ContentVersion cv : [Select Id,CreatedDate,Title from ContentVersion WHERE ContentDocumentId IN :ContentDocumentIdSet ORDER BY CreatedDate DESC LIMIT 1]){
        cdi.Name = cv.Title;
        cdi.PreferencesNotifyOnVisit = false;
        cdi.PreferencesAllowViewInBrowser = true;
        cdi.ContentVersionId = cv.Id;
        insert cdi;   
    }
    System.debug('Content distribution--'+cdi);
    
    List<ContentDistribution> cdData = [Select Id,DistributionPublicUrl from ContentDistribution WHERE Id = :cdi.Id];
    
    // Update the custom object records as needed based on the file uploads
    List<ktrailhead__Employee__c> empList1 = new List<ktrailhead__Employee__c>();
    if (!customObjectIdsToUpdate.isEmpty()) {
        
        List<ktrailhead__Employee__c> empList = [Select Id,ktrailhead__View_File__c from ktrailhead__Employee__c WHERE Id IN :customObjectIdsToUpdate];
        for(ktrailhead__Employee__c emp :empList){
            emp.ktrailhead__View_File__c = cdData[0].DistributionPublicUrl;  
            empList1.add(emp);
        }
        
        System.debug('empList1'+empList1);
    }
    try{
        update empList1;
        
    }
    catch(Exception e){
        System.debug('message'+e.getMessage());
        System.debug('message'+e.getLineNumber());
        System.debug('message'+e.getCause());
    }
}