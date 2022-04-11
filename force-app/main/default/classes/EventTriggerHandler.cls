public class EventTriggerHandler 
{
    public static void assignVolunteer(List<Event> events)
    {
        List<User> users = [select id, name from user where name in('Business Admin', 'Bank Customer', 'Sales1', 'Sale2')];
        Map<String, User> userMap = new  Map<String, User>();
        for(User u : users)
        {
            userMap.put(u.name, u);
        }
        for(Event e : events)
        {
            if(e.Subject == 'Email')
                e.OwnerId = userMap.get('Business Admin').id;
            else if(e.Subject == 'Meeting')
                e.OwnerId = userMap.get('Bank Customer').id;
            else if(e.Subject == 'Other')
                e.OwnerId = userMap.get('Sales1').id;
            else if(e.Subject == 'Call')
                e.OwnerId = userMap.get('Sale2').id;
            else if(e.Subject == 'Send Letter/Quote')
                e.OwnerId = userMap.get('Sale2').id;
        }
    }
    public static void updateOpp(List<Event> events)
    {
        set<Id> oppId = new set<Id>();
        for(Event e : events)
        {
            if(e.whatid!=null)
                oppId.add(e.WhatId);
        }
        List<Opportunity> opps = [select StageName, Owner.Email, Name, Probability, CloseDate,  
                                  (select EndDateTime from Events) from Opportunity where id in:oppId];
         List<Attachment> attachments = [select Name, Body, ParentId from Attachment where ParentId in :oppId];
         System.debug(attachments);
         Map<Id, List<Attachment>> oppIdAttachmentMap = new Map<Id, List<Attachment>>();// binary fields cannot be used in join query, body returns binary output
         for(Attachment a : attachments)
         {
             if(!oppIdAttachmentMap.containsKey(a.ParentId))
             {
                 oppIdAttachmentMap.put(a.ParentId, new List<Attachment>());
             }
             oppIdAttachmentMap.get(a.ParentId).add(a);
         }
         List<Opportunity> oppUpdateList = new List<Opportunity>();
         List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
         EmailTemplate emailTemplate = [Select Id, Subject, Description, Body from EmailTemplate
                                        where name = 'Opportunity Completed mail' limit 1];
         Contact c = [select id, Email from Contact where email <> null limit 1]; //dummy contact for setTargetObjectId
         for(Opportunity opp : opps)
         {
             Integer eventsSize = 0;
             Integer eventsCompletedSize = 0;
             if(opp.Events!=null)
             {
                 System.debug(opp.Events.size());
                 eventsSize = opp.Events.size();
                 for(Event e : opp.Events)
                 {
                     if(e.EndDateTime < DateTime.now())
                     {
                         eventsCompletedSize++;
                     }
                 }
                 System.debug(eventsCompletedSize);
             }
             if(eventsCompletedSize == eventsSize && eventsSize!=0 && eventsCompletedSize!=0)
             {
                 opp.StageName = 'Completed';
                 oppUpdateList.add(opp);
                 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                 mail.setTargetObjectId(c.id); 
                 mail.setTreatTargetObjectAsRecipient(true);
                 mail.setTemplateID(emailTemplate.Id);
                 mail.setWhatId(opp.Id);
                 if(oppIdAttachmentMap.get(opp.id)!=null)
                 {
                      List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                      for(Attachment at : oppIdAttachmentMap.get(opp.id))
                      {
                          Messaging.Emailfileattachment ft = new Messaging.Emailfileattachment();
                          ft.setFileName(at.Name);
                          ft.setBody(at.Body);
                          fileAttachments.add(ft);
                      }
                      mail.setFileAttachments(fileAttachments);
                 }
                 String[] toAddresses = new String[]{opp.Owner.Email};
                 mail.setSaveAsActivity(false);
                 mail.setToAddresses(toAddresses);
                 mails.add(mail);
             }
         }
         if(oppUpdateList.size()!=0)
             update oppUpdateList;
         if(mails.size()!=0)
             Messaging.sendEmail(mails);
    }
}