import { LightningElement,wire } from 'lwc';
import {updateRecord} from 'lightning/uiRecordApi'
import { getListUi } from 'lightning/uiListApi';	
 import CONTACT_OBJECT from '@salesforce/schema/Contact'
 const COLS = [
     {label :'Id',fieldName:'Id'},
     {label :'Name',fieldName:'Name'},
     {label :'Title',fieldName:'Title'},
     {label :'Phone',fieldName:'Phone',editable:true},
     {label :'Email',fieldName:'Email', type:'email',editable:true},
     ]
export default class WireUpdateRecord extends LightningElement {

contacts = []
columns = COLS
draftValues = []
    @wire(getListUi,{objectApiName:CONTACT_OBJECT,	
    listViewApiName:'AllContacts'
    })
    listViewHandler({data,error}){	
        if(data){
            console.log('Update Record Data',data)
            this.contacts = data.records.records.map(item=>{
            return{
                "Id": this.getValue(item,'Id'),
                "Name" : this.getValue(item,'Name'),
                "Title": this.getValue(item,'Title'),
                "Phone": this.getValue(item,'Phone'),
                "Email": this.getValue(item,'Email')
            }
            })
        }
        if(error){
            console.log('Error',error)
        }
    }

    getValue(data,field){
        return data.fields[field].value
    }

    handleSave(event){
        console.log('Evebnt',JSON.stringify(event.detail.draftValues))
        const recordInputs = event.detail.draftValues.map(draft=>{
            const fields = {...draft}
            return{fields:fields}
        })
        const promise = recordInputs.map(recordInput=>updateRecord(recordInput))
        Promise.all(promise).then(()=>{
            console.log('Contact update')
            this.draftValues = []
        }).catch(Error=>{
            console.log('Error',Error)
        })
        
    }
}