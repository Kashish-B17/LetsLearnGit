import { LightningElement,wire } from 'lwc';
import {getPicklistValuesByRecordType, getObjectInfo} from 'lightning/uiObjectInfoApi'
import ACCOUNT_OBJECT from '@salesforce/schema/Account'
export default class WireGetPicklistByRecordype extends LightningElement {

    @wire(getObjectInfo,{objectApiName:ACCOUNT_OBJECT})
    objectInfo

    @wire(getPicklistValuesByRecordType, {objectApiName:ACCOUNT_OBJECT, recordTypeId:'$objectInfo.data.defaultRecordTypeId'})
    pickListHandler({data,error}){
        if(data){
            console.log('Picklist Value by Record Type',data)
        }
        if(error){
            console.log(error)
        }
    }


}