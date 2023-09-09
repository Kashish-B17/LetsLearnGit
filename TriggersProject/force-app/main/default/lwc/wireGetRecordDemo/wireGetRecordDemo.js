import { LightningElement,wire,api } from 'lwc';
import {getRecord, getFieldValue,getFieldDisplayValue} from  'lightning/uiRecordApi'
import NAME_Field from '@salesforce/schema/Account.Name'
import OWNER_Field from '@salesforce/schema/Account.Owner.Name'
import ANNUAL_REVENUE from '@salesforce/schema/Account.AnnualRevenue'
export default class WireGetRecordDemo extends LightningElement {

    @api recordId
    name
    owner
    annualRevenue

    @wire(getRecord, {recordId : '$recordId', 
    fields: [NAME_Field, ANNUAL_REVENUE, OWNER_Field]})
    // @wire(getRecord, {recordId : '$recordId',layoutTypes:['Full'], modes:['View']})
    accountHandler({data,error}){
        if(data){
            console.log('Account Data',data)
            // this.name = data.fields.Name.value
            // this.owner = data.fields.Owner.value.fields.Name.value;
            // this.annualRevenue = data.fields.AnnualRevenue.value

            this.name = getFieldValue(data,NAME_Field)
            this.owner = getFieldValue(data,OWNER_Field)
            this.annualRevenue = getFieldDisplayValue(data,ANNUAL_REVENUE)
        }

        if(error){
            console.log(error)
        }
    }


}