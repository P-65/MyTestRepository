public class CreateCustomerTriggerHandler 
{
    public static void createCustomer(List<Customer1__c> customers)
    {
        set<Id> clientId = new set<Id>();
        for(Customer1__c c : customers)
        {
            clientId.add(c.Client__c);
        }
        Map<id, Client__c> clientMap = new  Map<id, Client__c>([select id, Client_Manager__r.Email, Email__c, Name, (select id, name from Customers1__r) 
                                                                from Client__c where id in:clientId]);
        List<Client_Team_Member__c> teamMembers = new List<Client_Team_Member__c>();
        Integer i = 1;
        for(Customer1__c c : customers)
        {
            Integer flag = 0;
            for(Customer1__c cu : clientMap.get(c.Client__c).Customers1__r)
            {
                 if(c.Name == cu.Name){
                          c.addError('Customer already exists');
                          flag=1;
                          break;
                  }
            }
            if(flag == 0)
            {
                teamMembers.add(new Client_Team_Member__c(Client_Manager_Name__c=clientMap.get(c.Client__c).Client_Manager__c, Client__c=
                                                         c.Client__c, Name='Client Employee'+i, Email__c=clientMap.get(c.Client__c).Client_Manager__r.Email));
                i++;
            }
        }
        try
        {
            if(teamMembers!=null)
                insert teamMembers;
        }
        catch(DmlException e)
        {
            System.debug('Following error has occured');
        }
    }
}