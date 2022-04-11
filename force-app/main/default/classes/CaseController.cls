public class CaseController 
{
    public String caseId{get; set;}
    public Case getCase
    {
        get{
          return [select CaseNumber, OwnerId, Reason, Description, Status, Type from Case where id =: caseId limit 1];
    }
    }
}