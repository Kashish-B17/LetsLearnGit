import { LightningElement,track } from 'lwc';
import EVENT from '@salesforce/resourceUrl/event';
import sendEmail from '@salesforce/apex/EmailHandler.sendEmail';
export default class RsvpComponent extends LightningElement 
{
    @track email = '';
    isModalOpen = false
    event = EVENT;
    clickHandler()
    {
        this.isModalOpen = true
    }

    closeModal() {
        this.isModalOpen = false;
    }
    submitDetails() {
        this.isModalOpen = false;
        console.log("Sending email to", this.email);
        sendEmail({ toAddress: this.email, subject: "Confirmation for event", body: "Congratulations you have register for event"});
    }

    handleChange(event) {
        if (event.target.name === 'emailAddress') {
            this.email = event.target.value;
        }
    }
    
}