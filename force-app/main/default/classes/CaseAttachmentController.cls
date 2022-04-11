global class CaseAttachmentController 
{
    global String PagePDFContent{ get; set; }
    global String caseObjectId{ 
        get; 
        set {
            UpdatePDFContent(value);
        } 
    }
     
    public void UpdatePDFContent(String caseObjectId)
    {
        try
        {
            PageReference pageRef = Page.CasePDF;
            pageRef.getParameters().put('caseId', caseObjectId);
            PagePDFContent = pageRef.getContent().toString().replace('<html style="display:none !important;">', '<html>');
        }catch(System.Exception ex){}
    }
}