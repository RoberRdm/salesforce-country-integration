@IsTest
public class CountryUpdateSchedulerTest {
    
    @IsTest
    static void testSchedulerExecution() {
        // We use a clearly future date
        String cron = '0 0 0 1 1 ? 2050'; // january 1, 2050
        
        Test.startTest();
        String jobId = System.schedule('Test Country Scheduler', cron, new CountryUpdateScheduler());
        Test.stopTest();

        // Verify that the job was scheduled successfully
        CronTrigger ct = [
            SELECT Id, CronExpression, TimesTriggered, NextFireTime
            FROM CronTrigger WHERE Id = :jobId
        ];

        System.assertNotEquals(null, ct, 'El trabajo debe estar programado.');
    }
}
