import { LightningElement, wire } from 'lwc';
import { subscribe, MessageContext } from 'lightning/messageService'
import COUNTING_UPDATED_CHANNEL from '@salesforce/messageChannel/Counting_Update__c'

export default class SubLWC extends LightningElement {

    subscription = null
    counter = 0

    @wire(MessageContext)
    messageContext

    connectedCallback() {
        this.subscribeToMessageChannel()
        console.log('Connected called')
    }

    subscribeToMessageChannel() {
        console.log('subscribe called')
        this.subscription = subscribe(
            this.messageContext,
            COUNTING_UPDATED_CHANNEL,
            (message) => this.handleMessage(message)

        );

    }

    handleMessage(message) {
        console.log('alert vala message', message)
        if (message.operator == 'add') {
            this.counter += message.constant;
        }

        if (message.operator == 'subtract') {
            this.counter -= message.constant;
        }

        if (message.operator == 'multiply') {
            this.counter *= message.constant;
        }

    }



}