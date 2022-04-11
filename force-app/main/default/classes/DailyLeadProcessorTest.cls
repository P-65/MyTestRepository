@isTest
private class DailyLeadProcessorTest 
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
        DailyLeadProcessor dlp=new DailyLeadProcessor();
        System.schedule('Daily', '0 0 * * * ?', dlp);
        Test.stopTest();
    }
}