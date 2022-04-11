@isTest
public class TestAuthorBestSellingTypeBatch 
{
    @isTest static void testAuthorBestSell()
    {
        Author__c a = new Author__c(Name='Chethan');
        insert a;
        List<Book__c> books = new List<Book__c>();
        books.add(new Book__c(Name='Five Point Someone', Type__c='Fiction', Rating__c=4.5, Author__c=a.id));
        books.add(new Book__c(Name='2 States', Type__c='Adventure', Rating__c=3, Author__c=a.id));
        books.add(new Book__c(Name='The 3 Mistakes', Type__c='Fiction', Rating__c=4, Author__c=a.id));
        books.add(new Book__c(Name='The 4 Mistakes', Type__c='Fiction', Rating__c=4.5, Author__c=a.id));
        books.add(new Book__c(Name='The 5 Mistakes', Type__c='Novel', Rating__c=4, Author__c=a.id));
        books.add(new Book__c(Name='The 6 Mistakes', Type__c='Comic', Rating__c=4, Author__c=a.id));
        insert books;
        Test.startTest();
        Database.executeBatch(new AuthorBestSellingTypeBatch());
        Test.stopTest();
        Author__c at = [select Name, Best_Selling_Type__c, Rating__c from Author__c where id=:a.id];
        System.assert(at.Best_Selling_Type__c == 'Fiction');
        System.assert(at.Rating__c == 4.5);
    }
}