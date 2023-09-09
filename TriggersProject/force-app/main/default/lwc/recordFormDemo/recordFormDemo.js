import { LightningElement,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Name_Field from '@salesforce/schema/Account.Name';
import Revenue_Field from '@salesforce/schema/Account.AnnualRevenue';
import Active_Status from '@salesforce/schema/Account.Description';
export default class RecordFormDemo extends LightningElement {

    fieldList = [Name_Field,Revenue_Field,Active_Status];
    @api recordId
    @api objectApiName

    handleSubmit(event)
    {
        const ev = new ShowToastEvent({
            title : 'Success',
            message : 'Record Saved successfully',
            variant:'success'
        });
        this.dispatchEvent(ev);
    }
}