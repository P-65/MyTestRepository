public class AddPrimaryContact implements Queueable 
{
    private Contact con;
    private String state;
    public AddPrimaryContact(Contact c, String state)
    {
        this.con=c;
        this.state=state;
    }
    public void execute(QueueableContext context)
    {
        List<Account> accounts=[SELECT Id, BillingState FROM Account WHERE BillingState=:this.state LIMIT 200];
        List<Contact> conList=new List<Contact>();
        for(Account a : accounts)
        {
            Contact c=new Contact();
            c=this.con.clone(false, false, false, false);
            c.AccountId=a.Id;
            conList.add(c);
        }
        insert conList;
    }
}