import { LightningElement,api,wire } from 'lwc';
import getAccount from '@salesforce/apex/AccountHandler.getAccount';
export default class CallingApexImperatively extends LightningElement {

accounts
// showButton = true;
searchKey = ''
timer
    searchHandler(event)
    {
        //this.showButton = false
        window.clearTimeout(this.timer)
        this.searchKey = event.target.value;
        this.timer = setTimeout(()=>{
            this.callApex()
        },1000)
        console.log('search Key',this.searchKey)
    }
      callApex(){
        getAccount({searchKey:this.searchKey})
        .then(result=>{
            this.accounts = result
            console.log('accpunt',this.accounts)
        }).catch(error=>{
            console.error(error)
        })
    }
       
    


}