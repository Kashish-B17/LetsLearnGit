import { LightningElement,wire } from 'lwc';
import {getRecord} from 'lightning/uiRecordApi';
import Id from '@salesforce/user/Id';
//import Name_field from '@salesforce/schema/User.Name'
// import Email_field from '@salesforce/schema/User.Email'
// const fields = [Name_field,Email_field]
export default class WireDemoUserDetail extends LightningElement {
UserId = Id
UserData
    @wire(getRecord, {recordId :'0055g00000F7L7BAAV',fields:['user.Name']})
    userDetails({data,error})
    {
        if(data)
        {
            this.UserData = data.fields
            console.log('Data',this.UserData)
        }

        if(error)
        {
            console.log('error ',error)
        }
    }
}