public class DeleteClientTriggerHandler 
{
    public static void deleteClient(Map<id, Client__c> clientsMap)
    {
        List<Customer1__c> customers = [select id, Name, Email__c, Client__c from Customer1__c where Client__c in:clientsMap.keySet()];
        system.debug(customers);
        Map<id, List<Customer1__c>> custMap = new  Map<id, List<Customer1__c>>();
        for(Customer1__c c : customers)
        {
           if(!custMap.containsKey(c.Client__c))
           {
               custMap.put(c.Client__c, new List<Customer1__c>());
           }
           custMap.get(c.Client__c).add(c);
        }
        List<Client_Team_Member__c> teamMembers = [select id, Name, Client__c, Email__c from Client_Team_Member__c where Client__c in:clientsMap.keySet()];
        system.debug(teamMembers);
        Map<id, List<Client_Team_Member__c>> teamMemberMap = new  Map<id, List<Client_Team_Member__c>>();
        for(Client_Team_Member__c c : teamMembers)
        {
           if(!teamMemberMap.containsKey(c.Client__c))
           {
               teamMemberMap.put(c.Client__c, new List<Client_Team_Member__c>());
           }
           teamMemberMap.get(c.Client__c).add(c);
        }
        List<Messaging.SingleEmailMessage> mails = new  List<Messaging.SingleEmailMessage>();
        List<Client_Team_Member__c> teamMemberDeleteList = new List<Client_Team_Member__c>();
        for(Client__c c : clientsMap.values())
        {
             Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
             String[] toAddresses = new String[]{c.Email__c};
             mail.setToAddresses(toAddresses);
             mail.setSubject(c.Name+' has been deleted');
             mail.setPlainTextBody('Dear '+c.Name+', your record has been deleted');
             mails.add(mail);
             if(custMap.get(c.id)!=null)
             {
                 for(Customer1__c cr : custMap.get(c.id))
                 {
                      Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
                      String[] toAddresses1 = new String[]{cr.Email__c};
                      mail1.setToAddresses(toAddresses1);
                      mail1.setSubject('Client '+c.Name+' has been deleted');
                      mail1.setPlainTextBody('Dear '+cr.Name+', your client '+c.Name+' has been deleted');
                      mails.add(mail1);
                 }
             }
             if(teamMemberMap.get(c.id)!=null)
             {
                 for(Client_Team_Member__c t : teamMemberMap.get(c.id))
                 {
                      teamMemberDeleteList.add(t);
                      Messaging.SingleEmailMessage mail2 = new Messaging.SingleEmailMessage();
                      String[] toAddresses2 = new String[]{t.Email__c};
                      mail2.setToAddresses(toAddresses2);
                      mail2.setSubject('Client '+c.Name+' has been deleted');
                      mail2.setPlainTextBody('Dear '+t.Name+', your client '+c.Name+' has been deleted');
                      mails.add(mail2);
                 }
             }
        }
        if(teamMemberDeleteList.size()!=0)
             delete teamMemberDeleteList;
        if(mails.size()!=0)
             Messaging.sendEmail(mails);
        
    }
}