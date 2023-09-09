import { LightningElement,wire } from 'lwc';
import getContact from '@salesforce/apex/ContactController.getContact'
export default class FilteringAndSortingInLWC extends LightningElement {

headings = ["Id","Name","Title","Email"]
fullTableData = []
filteredTable = []
@wire(getContact)
contactHandler({data,error}){
    if(data){
        console.log('data',data)
        this.fullTableData = data
        this.filteredTable = data
    }
    if(error){
        console.log(error)
    }
}
}