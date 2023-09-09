import { LightningElement } from 'lwc';
import firstTemplate from './firstTemplate.html'
import secondTemplate from './secondTemplate.html'

export default class LifeCycleHooksDemo extends LightningElement {

loadFirst = true
errorOcc
stack
constructor(){
    super()
    console.log('Constructor Called from Parent');
}

connectedCallback(){
    console.log('Connected Callback called from Parent')
}

render(){
    console.log('Render Called from Parent');
    if(this.loadFirst == true){
        return firstTemplate
    }
    else{
        return secondTemplate
    }
}
renderedCallback(){
    console.log('Rendered Callback Called from Parent');
}

disconnectedCallback(){
    console.log('Disconnected Callback called from Parent')
}

errorCallback(error, stac){
    console.log('Error Callback Called from Parent');
    this.errorOcc = error
    this.stack = this.stack    
}
}