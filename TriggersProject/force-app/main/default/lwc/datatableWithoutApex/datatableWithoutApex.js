import { LightningElement,wire } from 'lwc';
import { getListUi } from 'lightning/uiListApi';
import CONTACT_OBJECt from '@salesforce/schema/Contact'
const COLS = [
     {label :'Name',fieldName:'Name'},
     {label :'Title',fieldName:'Title'},
     {label :'Phone',fieldName:'Phone'},
     {label :'Email',fieldName:'Email', type:'email'},
     ]
export default class DatatableWithoutApex extends LightningElement {

columns = COLS
previousPageToken = null
nextPageToken = null
pageToken = null
contacts = []
displayForm = false;
showButton = true
mainResult = []

@wire(getListUi,{objectApiName:CONTACT_OBJECt,	
listViewApiName:'AllContacts',
pageToken:'$pageToken',
pageSize:10})	
listViewHandler({data,error}){	
        if(data){
            console.log('Update Record Data',data)
            this.nextPageToken = data.records.nextPageToken
            this.previousPageToken = data.records.previousPageToken
            this.mainResult = data;
            this.contacts = data.records.records.map(item=>{
            return{
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


handlePrevious(){
    this.pageToken = this.previousPageToken 
}

handleNext(){
    this.pageToken = this.nextPageToken
}	

handleFirst()
{
    this.previousPageToken = null;
    this.pageToken = this.previousPageToken
    // this.pageToken = null
}

handleLast()
{
    this.nextPageToken = null;
    this.pageToken = this.nextPageToken
    // this.pageToken = null   
    console.log('Page Token Values',this.pageToken)
    console.log('Next Page Token',this.nextPageToken)
}

get disablePrevious(){
    return this.previousPageToken==null;    
}

get disableNext(){
    return this.nextPageToken==null
}

get disableFirst(){
    return this.previousPageToken==null;
}

// get disableLast(){
//     return this.nextPageToken==null
// }

handleClick()
{
    this.displayForm = true;
    this.showButton = false
}

disableButton()
{
this.showButton = true
this.displayForm = false
}

}