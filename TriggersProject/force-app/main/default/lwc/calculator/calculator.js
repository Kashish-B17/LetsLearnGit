import { LightningElement,api } from 'lwc';
export default class Calculator extends LightningElement {
    result = ''
    resultAfter
    
 optionsList = [{label : '7' , title :'7' ,variant : 'brand'} , {label : '8' , title :'8' ,variant : 'brand'}, {label : '9' , title :'9' ,variant : 'brand'}, {label : '/' , title :'/' ,variant : 'brand-outline'}, {label : '4' , title :'4' ,variant : 'brand'} , {label : '5' , title :'5' ,variant : 'brand'}, {label : '6' , title :'6' ,variant : 'brand'}, {label : '*' , title :'*' ,variant : 'brand-outline'}, {label : '3' , title :'3' ,variant : 'brand'} , {label : '2' , title :'2' ,variant : 'brand'}, {label : '1' , title :'1' ,variant : 'brand'}, {label : '-' , title :'-' ,variant : 'brand-outline'}, {label : 'X' , title :'X' ,variant : 'destructive'} , {label : '0' , title :'0' ,variant : 'brand'}, {label : '=' , title :'=' ,variant : 'success'},{label : '+' , title :'+' ,variant : 'brand-outline'} ];
handleButtonselect(event){

if(event.target.title != '=' && event.target.title != 'Clr'){
    let selectedValue = event.target.label;
    this.resultAfter = '';
    this.result = this.result+selectedValue;
}
else if(event.target.title == '='){
    this.resultAfter = eval(this.result)
    this.result = '';
}
else if(event.target.title == 'Clr'){
    this.result = '';
    this.resultAfter = '';

}

    }
}