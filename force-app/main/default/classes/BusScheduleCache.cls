public class BusScheduleCache 
{
    private Cache.OrgPartition part;
    
    public BusScheduleCache()
    {
        this.part = new Cache.OrgPartition('local.BusSchedule');
    }
    
    public void putSchedule(String busLine, Time[] schedule)
    {
        part.put(busLine, schedule);
    }
    
    public Time[] getSchedule(String busLine)
    {
       Time[] shedule = (Time[])part.get(busLine);
       if(shedule !=null)
       {
           return shedule;
       }
       else
       {
           return new List<Time>{Time.newInstance(8,0,0,0), Time.newInstance(17,0,0,0)};
       }
    }
}