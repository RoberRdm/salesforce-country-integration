@IsTest
public with sharing class CountryAPIServiceTest {
    @IsTest
    static void testFetchCountries() {
        // HTTP response mock to simulate the external API
        Test.setMock(HttpCalloutMock.class, new RestCountriesMock());

        // execute the future call (future)
        Test.startTest();
        CountryAPIService.fetchCountries();
        Test.stopTest();

        // Validate that Country\_\_c records have been inserted
        Integer countCountries = [SELECT COUNT() FROM Country__c];
        System.assert(countCountries > 0, 'Debe existir al menos un registro Country__c');
    }
}
