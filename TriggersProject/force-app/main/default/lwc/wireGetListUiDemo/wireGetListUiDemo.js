import { LightningElement,wire } from 'lwc';	
//import { getListInfoByName } from 'lightning/uiListsApi';	
import { getListUi } from 'lightning/uiListApi';	
import CONTACT_OBJECt from '@salesforce/schema/Contact'	
export default class WireGetListUiDemo extends LightningElement {	

previousPageToken = null
nextPageToken = null
pageToken = null
contacts = []

    @wire(getListUi,{objectApiName:CONTACT_OBJECt,	
    listViewApiName:'AllContacts',
    pageToken:'$pageToken',
    pageSize:10})	
    listViewHandler({data,error}){	
        if(data){	
            console.log('List Data',data)	
            this.contacts = data.records.records
            this.nextPageToken = data.records.nextPageToken
            this.previousPageToken = data.records.previousPageToken
        }	
        if(error){	
            console.log(error)	
        }	
    }

    handlePrevious(){
        this.pageToken = this.previousPageToken 
    }

    handleNext(){
        this.pageToken = this.nextPageToken
    }	
}