global class AuthorBestSellingTypeBatch implements Database.Batchable<sObject>
{
     global Database.QueryLocator start(Database.BatchableContext bc)
     {
         String query = 'select Name, Best_Selling_Type__c, Rating__c from Author__c';
         return Database.getQueryLocator(query);
     }
     global void execute(Database.BatchableContext bc, List<Author__c> authors)
     {
         set<Id> authId = new set<Id>();
         for(Author__c a : authors)
         {
             authId.add(a.id);
         }
         List<Book__c> books =[select id, Type__c, Rating__c, Name, Author__c from Book__c where Author__c in:authId];
         Map<Id, List<Book__c>> authIdBookMap = new Map<Id, List<Book__c>>();
         for(Book__c b : books)
         {
             if(!authIdBookMap.containsKey(b.Author__c))
             {
                 authIdBookMap.put(b.Author__c, new List<Book__c>());
             }
             authIdBookMap.get(b.Author__c).add(b);
         }
         List<Author__c> authorsToUpdate = new List<Author__c>();
         for(Author__c a : authors)
         {
             Integer fictionType = 0;
             Integer novelType = 0;
             Integer adventureType = 0;
             Integer comicType = 0;
             Decimal fictionRating = 0;
             Decimal novelRating = 0;
             Decimal adventureRating = 0;
             Decimal comicRating = 0;
             if(authIdBookMap.get(a.id)!=null)
             {
                 for(Book__c b : authIdBookMap.get(a.id))
                 {
                     if(b.Type__c == 'Fiction')
                     {
                         fictionType++;
                         fictionRating+=b.Rating__c;
                     }
                     else if(b.Type__c == 'Novel')
                     {
                         novelType++;
                         novelRating+=b.Rating__c;
                     }
                     else if(b.Type__c == 'Adventure')
                     {
                         adventureType++;
                         adventureRating+=b.Rating__c;
                     }
                     else if(b.Type__c == 'Comic')
                     {
                         comicType++;
                         comicRating+=b.Rating__c;
                     }
                 }
                 if(fictionType>novelType && fictionType>adventureType && fictionType>comicType)
                 {
                     a.Best_Selling_Type__c = 'Fiction';
                     a.Rating__c = fictionRating/fictionType;
                     authorsToUpdate.add(a);
                 }
                 else if(novelType>fictionType && novelType>adventureType && novelType>comicType)
                 {
                     a.Best_Selling_Type__c = 'Novel';
                     a.Rating__c = novelRating/novelType;
                     authorsToUpdate.add(a);
                 }
                 else if(adventureType>novelType && adventureType>fictionType && adventureType>comicType)
                 {
                     a.Best_Selling_Type__c = 'Adventure';
                     a.Rating__c = adventureRating/adventureType;
                     authorsToUpdate.add(a);
                 }
                 else if(comicType>novelType && comicType>adventureType && comicType>fictionType)
                 {
                     a.Best_Selling_Type__c = 'Comic';
                     a.Rating__c = comicRating/comicType;
                     authorsToUpdate.add(a);
                 }
             }
         }
         if(authorsToUpdate.size()!=0)
             update authorsToUpdate;
     }
     global void finish(Database.BatchableContext bc)
     {
          
     }
}