public class ExampleController 
{
    public ExampleController()
    {
        
    }
    public static List<Contact> getContacts()
    {
       List<Contact> conList=[SELECT AccountId,AssistantName,AssistantPhone,Birthdate,CleanStatus,CreatedById,CreatedDate,Department,Email,FirstName FROM Contact where Department!=null];       
       return conList;
    }
}