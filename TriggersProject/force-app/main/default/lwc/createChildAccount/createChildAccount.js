import { LightningElement,api } from 'lwc';
import LightningModal from 'lightning/modal';
import Account_OBJECT from '@salesforce/schema/Account'
import NAME_FIELD from '@salesforce/schema/Account.Name'
import Description_FIELD from '@salesforce/schema/Account.Description'
import PHONE_FIELD from '@salesforce/schema/Account.Phone'
import Website_FIELD from '@salesforce/schema/Account.Website';
import AnnualRevenue_FIELD from '@salesforce/schema/Account.AnnualRevenue';
import { NavigationMixin } from 'lightning/navigation';
export default class CreateChildAccount extends NavigationMixin(LightningElement) {

@api openform

    @api recordId
 objectName =   Account_OBJECT   
    fields={ 
        nameField:NAME_FIELD,
        titleField:Description_FIELD,
        phoneField:PHONE_FIELD,
        emailField:Website_FIELD
    }

handleCancel(event)
{
   const closeButton = new CustomEvent("hidebutton",{
       detail:'true'
   });

   this.dispatchEvent(closeButton);
   console.log('handle cancel')
}

    handleSuccess(event) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.detail.id,
                objectApiName: 'Account',
                actionName: 'view'
            },
        });
    }
}