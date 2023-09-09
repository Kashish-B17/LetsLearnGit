public class OpportunityLineItemTriggerHandler {
    
    public static void restrictOppLItem(List<OpportunityLineItem>oppLitemList)
    {
        /*p<Id,String> mapOfOppFamily = new Map<Id,String>();
Map<Id,String> mapOfProductFamily = new Map<Id,String>();
*/
        Set<Id> productId = new Set<Id>();
        Set<Id> oppId = new Set<Id>();
        String ErrorMessage = '';
        
        for(OpportunityLineItem oppLitem : oppLitemList){
            productId.add(oppLitem.Product2Id);
            oppId.add(oppLitem.OpportunityId);
        }
        Map<Id,Opportunity> mapOfOppFamily = new Map<Id,Opportunity>([Select Id,Product_Family__c from Opportunity WHERE ID IN :oppId]);
        Map<Id,Product2> mapOfProductFamily = new Map<Id,Product2>([Select Id,Family from Product2 WHERE ID IN :productId]);
        
        for(OpportunityLineItem oppLi : oppLitemList)
        {
            if(mapOfOppFamily.containsKey(oppLi.OpportunityId) &&mapOfProductFamily.containsKey(oppLi.Product2Id))
            {
                if(mapOfOppFamily.get(oppLi.OpportunityId).Product_Family__c != mapOfProductFamily.get(oppLi.Product2Id).Family){
                    oppLi.addError('You cannot add this Line Item as product and Opportunity belongs to different family');
                }
                
            } 
        } 
        
        /*
for(OpportunityLineItem oppLitem : oppLitemList)
{
if(!oppLitemList.isEmpty())
{
mapOfOppFamily.put(oppLitem.Id,oppLitem.Opportunity.Product_Family__c);
mapOfProductFamily.put(oppLitem.Id,oppLitem.Product2.Family);   
}

if(mapOfOppFamily.containsKey(oppLitem.Id) == mapOfProductFamily.containsKey(oppLitem.Id))
{
if(mapOfOppFamily.get(oppLitem.Id) != mapOfProductFamily.get(oppLitem.Id)){
ErrorMessage = 'You cannot add this Line Item as product and Opportunity belongs to different family';
oppLitem.addError(ErrorMessage);
}
}
}

if(ErrorMessage!=''){
for(OpportunityLineItem oppLitem : oppLitemList){

}
}
*/
        
    }
    
    public static void updateDescForAccount(Map<Id,OpportunityLineItem>oppMap,Map<Id,OpportunityLineItem>newMap)
    {
        List<Account> accList = new List<Account>();
        Set<Id> oppId = new Set<Id>();
        Map<Id,String> mapOfAccDesc = new Map<Id,String>();

        for(OpportunityLineItem opp : [Select Id,Opportunity.AccountId,LastModifiedDate,Description from OpportunityLineItem WHERE ID IN :newMap.KeySet() ORDER BY LastModifiedDate DESC LIMIT 1]){
            if(String.isNotBlank(opp.Description) && opp.Description != oppMap.get(opp.Id).Description)
            mapOfAccDesc.put(opp.Opportunity.AccountId, opp.Description);
        }
        
        for(Account acc :[Select Id,Description from Account WHERE ID IN :mapOfAccDesc.keySet()]){
            acc.Description = mapOfAccDesc.get(acc.Id);
            accList.add(acc);
        }
        update accList;
    }
    
    public static void createAsset(List<OpportunityLineItem>oppLineList){
        List<Asset> assList = new List<Asset>();
        Set<Id> accId = new Set<Id>();
        for(OpportunityLineItem oli : oppLineList)
        {
            accId.add(oli.Opportunity.AccountId);
        }
        
        if(!accId.isEmpty())
        {
            for(Account acc : [Select Id from Account WHERE ID IN :accId]){
                
                Asset asetObj = new Asset();
                asetObj.Name = 'Asset Created with Account';
                asetObj.AccountId = acc.Id;
                assList.add(asetObj);
            }
        }
        
        if(!assList.isEmpty()){
            insert assList;
        }
        
    }
    
}