import { LightningElement,api,wire,track } from 'lwc';
import fetchAccount from '@salesforce/apex/AccountHelper.fetchAccount';
export default class FetchAccountDatatable extends LightningElement 
{

column = [{label: 'Account Name', fieldName: 'Name', type: 'text'}, {label: 'Account Number', fieldName: 'AccountNumber', type: 'text'}, {label: 'Phone', fieldName: 'Phone', Phone: 'phone'}, {label: 'Website', fieldName: 'Website', type: 'url'}];
error;
@api searchType = ''
@api currentPageNo = 1;
totalRecords
isNavigation = true;
totalPage 
showButton = true
showCloseForm = false;
@track startingRecord 
@track endingRecord
pageSize = 5;
@track data = []
@track items = [];
first = 1
last = 5
pageListNo = [];

@wire (fetchAccount,{searchType:"$searchType"})
getAccount({data,error}){
if(data){
this.items = data;
this.totalRecords = data.length
this.totalPage = Math.ceil(this.totalRecords/this.pageSize)
this.displayRecordPerPage()
this.pageListNo = []
this.currentPageNo = 1
console.log('total Page',this.totalPage) 
this.endingRecord = this.pageSize;
if(this.totalPage <5){
    this.first = 1
    this.last = this.totalPage
}
else{
    this.first = 1
    this.last = 5
}
 for (let i = this.first; i <= this.last; i++) {
                    this.pageListNo.push(i);

                }
                if (this.totalPage === 1) {
                    this.isNavigation = false
                    //if page 1 is avilable 
                } else {
                    this.isNavigation = true
                }
}
else if(error){
this.error = error;
}
}
handleSearchAll(event){
this.searchType = event.target.value;
}

handleButton()
{
    console.log('button clicked',this.showCloseForm)
this.showCloseForm = true;
this.showButton = false;
console.log('button clicked after ',this.showCloseForm)
}

disableButton(event)
{
this.showButton = event.detail;
console.log('close button',this.showButton)
this.showCloseForm = false;
}

handlePrevious(){
    this.pageListNo = []
if(this.currentPageNo >= 1){
    this.currentPageNo = this.currentPageNo-1
    if(this.first!=1){
        this.first -=1
        if(this.totalPage>5){
            this.last -=1
        }
    }
     for (let i = this.first; i <= this.last; i++) {
                    this.pageListNo.push(i);

                }
    this.displayRecordPerPage()
console.log('curent page after clicking Previous',this.currentPageNo)
}
}

handleNext(){
    this.pageListNo = []
    console.log('Next Click Page',this.currentPageNo)
if(this.currentPageNo < this.totalPage){
    this.currentPageNo = this.currentPageNo+1
    if(this.last!=this.totalPage){
        this.first+=1
        if(this.totalPage>5){
            this.last+=1
        }
    }
}
     for (let i = this.first; i <= this.last; i++) {
                    this.pageListNo.push(i);
                }
    console.log('curent page after clicking Next else',this.currentPageNo)
   
 this.displayRecordPerPage()
}

handleFirst()
{
    this.currentPageNo = 1;
    this.pageListNo = []
    this.first = 1
    this.last = 5
    for (let i = this.first; i <= this.last; i++) {
            this.pageListNo.push(i);

        }
    this.displayRecordPerPage();

}

handleLast()
{
    this.currentPageNo = this.totalPage;
    this.pageListNo = []
    this.first = this.totalPage-4
    this.last = this.totalPage
    for (let i = this.first; i <= this.last; i++) {
            this.pageListNo.push(i);

        }
    this.displayRecordPerPage()
}

handleClick(button)
{
    this.currentPageNo = button.target.label;
    this.displayRecordPerPage()
}
displayRecordPerPage()
{
    //this.startingRecord = ((page -1) * this.pageSize) ;
    //this.endingRecord = (this.pageSize * page);

    this.endingRecord = (this.endingRecord > this.totalRecords) 
                        ? this.totalRecords : this.endingRecord; 

        let begin = (this.currentPageNo - 1) * parseInt(this.pageSize);
        let end = parseInt(begin) + parseInt(this.pageSize);
    
        this.data = this.items.slice(begin, end);
        
        this.startingRecord = begin + parseInt(1);
        this.endingRecord = end > this.totalRecords ? this.totalRecords : end;
        this.end = end > this.totalRecords ? true : false;
}

 get disableFirst() {
        return this.last <= 5
    }
    get disableLast() {
        if (this.totalPage > 5) {
            return this.first == this.totalPage - 4;
        } else {
            return this.pageListNo.length <= 5
        }

    }
    get disablePrevious() {
        return this.currentPageNo == 1;
    }
    get disableNext() {
      
        return this.currentPageNo === this.totalPage
    }
}