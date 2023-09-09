import { LightningElement,wire } from 'lwc';
import {getPicklistValues, getObjectInfo} from 'lightning/uiObjectInfoApi'
import INDUSTRT_Field from '@salesforce/schema/Account.Industry'
import ACCOUNT_OBJECT from '@salesforce/schema/Account'
export default class WireGetPIcklistValueInfo extends LightningElement {

    selectedIndustry = ''
    IndustryOption = []
    
    @wire(getObjectInfo,{objectApiName:ACCOUNT_OBJECT})
    objectInfo


    @wire(getPicklistValues, {recordTypeId:'$objectInfo.data.defaultRecordTypeId',fieldApiName:INDUSTRT_Field})
    industryPicklist({data, error}){
        if(data){
            console.log('Picklist Data',data)
            this.IndustryOption = [...this.generatePicklist(data)]
        }
        if(error){
            console.log(error)
        }
    }

    // get options() {
    //     return [
    //         { label: 'New', value: 'new' },
    //         { label: 'In Progress', value: 'inProgress' },
    //         { label: 'Finished', value: 'finished' },
    //     ];
    // }

    generatePicklist(data){
        return data.values.map(item => ({
            label:item.label, value: item.value
        }))

    }
    handleChange(event) {
        this.selectedIndustry = event.detail.value;
    }
}