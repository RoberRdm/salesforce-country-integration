@IsTest
public class LeadCountryHandlerTest {

    @IsTest
    static void testBeforeInsert() {
        // Create test Country record
        Country__c c = new Country__c(
            Name = 'Testland',
            Capital__c = 'Testville',
            Region__c = 'Test Region',
            RegionalBloc__c = 'Test Bloc'
        );
        insert c;

        // Create Lead with reference to Country
        Lead l = new Lead(
            LastName = 'InsertTest',
            Company = 'TestCo',
            Country__c = c.Id
        );

        Test.startTest();
        insert l;
        Test.stopTest();

        Lead insertedLead = [SELECT CountryCapital__c, CountryRegion__c, RegionalBloc__c FROM Lead WHERE Id = :l.Id];

        System.assertEquals('Testville', insertedLead.CountryCapital__c);
        System.assertEquals('Test Region', insertedLead.CountryRegion__c);
        System.assertEquals('Test Bloc', insertedLead.RegionalBloc__c);
    }

    @IsTest
    static void testAfterUpdate() {
        // Create initial Country object
        Country__c c1 = new Country__c(
            Name = 'Testland1',
            Capital__c = 'Capital1',
            Region__c = 'Region1',
            RegionalBloc__c = 'Bloc1'
        );
        insert c1;

        // Create new Country for update
        Country__c c2 = new Country__c(
            Name = 'Testland2',
            Capital__c = 'Capital2',
            Region__c = 'Region2',
            RegionalBloc__c = 'Bloc2'
        );
        insert c2;

        // Create Lead with the first Country reference
        Lead l = new Lead(
            LastName = 'UpdateTest',
            Company = 'TestCo',
            Country__c = c1.Id
        );
        insert l;

        // Change the Lead's Country__c to trigger after update
        l.Country__c = c2.Id;

        Test.startTest();
        update l;
        Test.stopTest();

        Lead updatedLead = [SELECT CountryCapital__c, CountryRegion__c, RegionalBloc__c FROM Lead WHERE Id = :l.Id];

        System.assertEquals('Capital2', updatedLead.CountryCapital__c);
        System.assertEquals('Region2', updatedLead.CountryRegion__c);
        System.assertEquals('Bloc2', updatedLead.RegionalBloc__c);
    }
}
