public class checkVowel {

    public String formatName(String firstName, String lastName) {
    //code here
     String result = '';
    // if((firstName!=null && firstName!='') && (lastName!=null && lastName!='')){
    //     result = lastName+','+' 'firstName;
    // }
    // else if(firstName!=null && firstName!='') && (lastName==null || lastName==''){
    //     result = firstName;
    // }

    //  else if(firstName==null || firstName=='') && (lastName!=null && lastName!=''){
    //     result = lastName;
    // }
    // return result;

    if(!(String.isBlank(firstName)) && !(String.isBlank(lastName))){
        result = lastName+', '+firstName;
        System.debug(result);
    }
     else if(!String.isBlank(firstName) && String.isBlank(lastName)){
        result = firstName;
         System.debug(result);
    }
    else if(String.isBlank(firstName) && !String.isBlank(lastName)){
        result = lastName;
        System.debug(result);
    }

    return result;
}
}