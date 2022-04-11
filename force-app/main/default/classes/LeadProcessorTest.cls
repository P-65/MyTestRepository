@isTest
private class LeadProcessorTest 
{
   @testsetup
    static void setup()
    {
        List<Lead> leads=new List<Lead>();
        for(Integer i=0;i<200;i++)
        {
            leads.add(new Lead(FirstName='Test', LastName='Max'+i, LeadSource='TestForce', Company='Tech Mahindra'));
        }
        insert leads;
    }
    static testmethod void test()
    {
        Test.startTest();
        LeadProcessor lp=new LeadProcessor();
        Id batchId=Database.executeBatch(lp);
        Test.stopTest();
        System.assertEquals(200, [SELECT count() FROM Lead WHERE LeadSource='Dreamforce']);
    }
}