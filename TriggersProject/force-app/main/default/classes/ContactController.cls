public class ContactController {

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContact(){
        return [Select Id,Name,Email from Contact];
    }

}