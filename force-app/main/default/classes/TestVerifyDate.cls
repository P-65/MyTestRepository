@isTest
public class TestVerifyDate 
{
  @isTest static void checkDate1()
  {
       Date d1=date.parse('06/20/20');
       Date d2=date.parse('06/28/20');
       Date a=VerifyDate.CheckDates(d1,d2);
       System.assertEquals(d2,a);
  }
  @isTest static void checkDate2()
  {
       Date d1=date.parse('06/20/20');
       Date d2=date.parse('07/28/20');
       Date d3=date.parse('06/30/20');     
       Date a=VerifyDate.CheckDates(d1,d2);
       System.assertEquals(d3,a);
  }
    
}