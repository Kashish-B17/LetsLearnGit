import { LightningElement,wire,api } from 'lwc';
import {createRecord} from 'lightning/uiRecordApi'
import CONTACT_OBJECT from '@salesforce/schema/Contact'
import {ShowToastEvent} from 'lightning/platformShowToastEvent'
export default class WireCreateRecord extends LightningElement {

    formFields = {}
    @api showForm = false
    changeHandler(event)
    {
        const{name,value} = event.target
        this.formFields[name] = value

    }

    createContact()
    {
        const recordInput = {apiName:CONTACT_OBJECT.objectApiName, fields:this.formFields}
        createRecord(recordInput).then(result =>{
             this.ShowToastEvent('Success',`Contact created with ${result.id}`,'success')
             this.template.querySelector('form.createForm').reset()
             this.formFields = {}
        }).catch(error=>{
            this.ShowToastEvent('Error creating records',error.body.message,'error')
        })

      
    }


    ShowToastEvent(title,message,variant){
        this.dispatchEvent(new ShowToastEvent({
            title,
            message,
            variant:variant || 'success'
        }))
          const saveButton = new CustomEvent("savebutton",{
       detail:'true'
   });

   this.dispatchEvent(saveButton);
   console.log('handle cancel')
    }

handleCancel(event)
{
   const closeButton = new CustomEvent("hidebutton",{
       detail:'true'
   });

   this.dispatchEvent(closeButton);
   console.log('handle cancel')
}


}