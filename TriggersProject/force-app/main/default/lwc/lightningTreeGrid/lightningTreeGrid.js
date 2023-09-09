import { LightningElement,wire } from 'lwc';
import allAccountWithContact from '@salesforce/apex/AccountContact.allAccountWithContact'
export default class LightningTreeGrid extends LightningElement {

gridData = []

    @wire(allAccountWithContact)
    fetchAccountsWithContact({data,error}){
        if(data){
            console.log('data for accounts',data);
            this.formatGridData(data)
        }

        else if(error){
            console.log('error',error)
        }
    }

    gridColumns = [
    {
        label :'Name',
        fieldName : 'Name',
        type :'text'
    },

    {
        label :'Phone',
        fieldName : 'Phone',
        type :'text'
    },

     {
        label :'Account Website',
        fieldName : 'Website',
        type :'url',
        typeAttributes :{
            target:'_blank'
        }
    }

    ]

    formatGridData(result){
        this.gridData = result.map(items=>{
            const {Contacts,...accounts} = items
            return {...accounts, "_children":Contacts}
        })

        console.log(this.gridData)
    }

}