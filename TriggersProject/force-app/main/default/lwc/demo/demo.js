import { LightningElement ,api } from 'lwc';

export default class SelectList extends LightningElement {

    @api optionsList = [{value : 'email' , label :'emailLabel' ,iconName : 'utility:email'} , {value : 'Post' , label :'postLabel' , iconName : 'utility:share_post'}];

    handleButtonselect (event){


        console.log(event.detail.value);

        let selectedValue = event.detail.value;
        let selectedObject  = this.optionsList.find(function(element){
                    return element.value === selectedValue;
        });

        console.log('selected Label ->' + selectedObject.label);

    }
}