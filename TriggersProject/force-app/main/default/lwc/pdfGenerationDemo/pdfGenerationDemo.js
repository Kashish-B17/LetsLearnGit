import { LightningElement,api } from 'lwc';
import TRAILHEAD_LOGO from '@salesforce/resourceUrl/event';
import generatePDF from '@salesforce/apex/pdfController.generatePDF'
export default class PdfGenerationDemo extends LightningElement {

    @api recordId
    imageUrl = TRAILHEAD_LOGO
    invoiceData = 
    {
        invoiceNo :'123',
        invoiceCreatedDate : 'January 10,2022',
        invoiceDue : 'January 10,2023',
        companyName : 'Sparksuite, Inc',
        address1:'12345, Sunny Road',
        address2: 'SunnyVille, CA 12345'
    }

    clientData = 
    {
        client:'ACME Corp',
        username : 'John Doe',
        email : 'john@example.com'
    }

    services= 
    [
        {name:'Consultant fee',amount:1000.00},
        {name:'Website Design',amount : 300.00},
        {name:'Hosting',amount : 75.00}
    ]

    get totalAmount()
    {
        return this.services.reduce((total,service)=>{
            return total = total+service.amount
        },0)
    }

    pdfHandler()
    {
        let content = this.template.querySelector('.container');
        console.log('content',content.outerHTML)
        generatePDF({recordId:this.recordId, htmlData:content.outerHTML}).then(result => {
            console.log("Id",result)
            window.open(`https://trailheadcom169-dev-ed.file.force.com/servlet/servlet.FileDownload?file=${result.Id}`)
        }).catch(error => {
            console.error(error)
        })
    }
    

}