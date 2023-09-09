import { LightningElement } from 'lwc';
import firstTemplate from './firstChildTemplate.html'
import secondTemplate from './secondChildTemplate.html'
export default class LifeCycleHooksDemoChild extends LightningElement {

loadFirst = true
errorOcc
stack
constructor(){
    super()
    console.log('Constructor Called Child');
}

connectedCallback(){
    console.log('Connected Callback called Child')
}

render(){
    console.log('Render Called Child');
    if(this.loadFirst == true){
        return firstTemplate
    }
    else{
        return secondTemplate
    }
}
renderedCallback(){
    console.log('Rendered Callback Called Child');
}

disconnectedCallback(){
    console.log('Disconnected Callback called Child')
}

errorCallback(error, stac){
    console.log('Error Callback Called');
    this.errorOcc = error
    this.stack = this.stack    
}
}