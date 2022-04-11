public class AuthorBestSellingTrigger 
{
    public static void updateAuthor(List<Book__c> books)
    {
        set<Id> authId = new set<Id>();
        for(Book__c b : books)
        {
            if(b.Author__c!=null)
                authId.add(b.Author__c);
        }
        Map<Id, Author__c> authorMap = new  Map<Id, Author__c>([select Best_Selling_Type__c, Rating__c, (select Type__c, Rating__c, 
                                                           Name, Author__c from Books__r) from Author__c where id in:authId]);
        List<Author__c> authorsToUpdate = new List<Author__c>();
        if(!authorMap.isEmpty()){
         for(Author__c a : authorMap.values())
         {
             Integer fictionType = 0;
             Integer novelType = 0;
             Integer adventureType = 0;
             Integer comicType = 0;
             Decimal fictionRating = 0;
             Decimal novelRating = 0;
             Decimal adventureRating = 0;
             Decimal comicRating = 0;
             if(authorMap.get(a.id).Books__r!=null)
             {
                 for(Book__c b : authorMap.get(a.id).Books__r)
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
        }
         if(authorsToUpdate.size()!=0)
             update authorsToUpdate;
    }
}