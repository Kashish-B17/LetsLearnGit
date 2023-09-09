import { LightningElement} from 'lwc';
export default class BMICalculator extends LightningElement {
    height;
    weight;
    result = 2;
    showResult = false;

  handleWeight(event){
    this.showResult = false;
    this.weight  = event.target.value;
  }

  handleHeight(event){
      this.showResult = false;
      this.height = event.target.value;
  }
  handleClick(){
      let heightLet = this.height/100
      this.result = this.weight/(heightLet*heightLet);
      this.result = this.result.toFixed(1)
      console.log('typeof',typeof(this.result))
      this.showResult = true;
      let intResult = parseInt(this.result, 10)
      console.log('typeof',typeof(intResult))
      //updateCSS(intResult);
      
  }
  /*updateCSS(res){
    console.log('changed css');
    let cssVar = res;
    if(cssVar >= 18){
        return this.template.querySelector('.resultCSS').className.add('green-color');
        
      }
      else{
        return this.template.querySelector('.resultCSS').className.add('red-color');
      }

  }
  */
    
}