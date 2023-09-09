public class FlowHandler {

    @invocableMethod(label ='delete related Opportunities'
                description = 'Delete related opportunities of given account id')
    public static void OppHandler(List<String> ids)
    {
        List<Opportunity> oppList = [Select Id from Opportunity where AccountId =:ids AND StageName = 'Closed Won'];
        delete oppList;
        
    }
}