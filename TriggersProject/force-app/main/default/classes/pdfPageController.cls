public with sharing class pdfPageController {
    
    public String pdfText{get;set;}
    
    public pdfPageController()
    {
        pdfText = String.escapeSingleQuotes(
            apexPages.currentPage().getParameters().get('pdfText')
        );
    }
    
    

}