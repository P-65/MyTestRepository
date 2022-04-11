public class StringArrayTest 
{
   public StringArrayTest()
   {
       
   }
   public static String[] generateStringArray(Integer a)
   {
       String[] s=new String[a];
       for(Integer n=0;n<a;n++)
       {
           s[n]='Test '+n;
       }
       return s;
   }
}