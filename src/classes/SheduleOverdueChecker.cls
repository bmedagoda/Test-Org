global class SheduleOverdueChecker implements Schedulable
{
     //Call Scheduled class & method
    global void execute(SchedulableContext SC) 
    {
        OverdueChecker odc=new OverdueChecker();
        odc.updateApplicant();
    }
}