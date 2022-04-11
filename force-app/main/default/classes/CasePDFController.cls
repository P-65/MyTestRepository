public class CasePDFController 
{
    public Id caseID
    {
        get
        {
            if(caseID == null && ApexPages.currentPage().getParameters().get('caseId') != null)
            {
                caseID = ApexPages.currentPage().getParameters().get('caseId');
            }
            return caseID;
        }
        set;
    }
    
    public Case cs
    {
        get
        {
            return [select CaseNumber, OwnerId, Reason, Description, Status from Case where id =: caseID limit 1];
        }
        set;
    }
}