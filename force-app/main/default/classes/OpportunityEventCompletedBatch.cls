global class OpportunityEventCompletedBatch implements Database.Batchable<sObject>
{
     global Database.QueryLocator start(Database.BatchableContext bc)
     {
         String query = 'select id, Owner.Email, StageName, Name, Probability, CloseDate, Ownerid from Opportunity where CloseDate>TODAY '+
             'and StageName!=\'Completed\'';
         return Database.getQueryLocator(query);
     }
     global void execute(Database.BatchableContext bc, List<Opportunity> opps)
     {
         set<Id> oppId = new set<Id>();
         for(Opportunity opp : opps)
         {
             oppId.add(opp.id);
         }
         List<Event> events = [select EndDateTime, WhatId from Event where WhatId in:oppId];
         System.debug(events);
         Map<Id, List<Event>> oppIdEventMap = new Map<Id, List<Event>>();
         for(Event ev : events)
         {
             if(!oppIdEventMap.containsKey(ev.WhatId))
             {
                 oppIdEventMap.put(ev.WhatId, new List<Event>());
             }
             oppIdEventMap.get(ev.WhatId).add(ev);
         }
         List<Attachment> attachments = [select Name, Body, ParentId from Attachment where ParentId in :oppId];
         System.debug(attachments);
         Map<Id, List<Attachment>> oppIdAttachmentMap = new Map<Id, List<Attachment>>();
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
             if(oppIdEventMap.get(opp.id)!=null)
             {
                 System.debug(oppIdEventMap.get(opp.id).size());
                 eventsSize = oppIdEventMap.get(opp.id).size();
                 for(Event e : oppIdEventMap.get(opp.id))
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
     global void finish(Database.BatchableContext bc)
     {
          
     }
}