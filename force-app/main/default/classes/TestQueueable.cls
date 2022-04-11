public class TestQueueable implements Queueable{
    
    public void execute(QueueableContext qc)
    {
        system.debug('test');
        system.enqueuejob(new TestQueueable2());
    }

}