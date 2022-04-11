public class FutureTest {
    public FutureTest()
    {
        FutureTest.task1();
        FutureTest.task2();
        

    }
 
    public static void task1()
        {
            system.debug('task--->task1');
        }
        
      public static void task2()
        {
            system.debug('task--->task2');
        }
    
      @future
      public static void task3(List<Id> accIds)
      {
          List<Contact> contoinsert = new List<Contact>();
          for(Id accId : accIds)
          {
              Contact con = new Contact();
              con.lastname = 'Contact';
              con.firstname = 'test';
              con.AccountId = accId;
              contoinsert.add(con);
          }
          
          if(contoinsert!=null && !contoinsert.isEmpty())
          insert contoinsert;
      }
   
    
    
}