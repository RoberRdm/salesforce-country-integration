public with sharing class LeadCountryHandler {

 public static void populateCountryInfo(List<Lead> newLeads, Map<Id, Lead> oldMap) {
        Set<Id> countryIds = new Set<Id>();

        // Collect all Country__c Ids from new/updated Leads
        for (Lead l : newLeads) {
            // If it's an insert (oldMap == null) or on update the Country__c has changed
            if (l.Country__c != null && (oldMap == null || oldMap.get(l.Id).Country__c != l.Country__c)) {
                countryIds.add(l.Country__c);
            }
        }

        if (countryIds.isEmpty()) return;

        Map<Id, Country__c> countryMap = new Map<Id, Country__c>(
            [SELECT Id, Capital__c, Region__c, RegionalBloc__c FROM Country__c WHERE Id IN :countryIds]
        );

        for (Lead l : newLeads) {
            if (l.Country__c != null && countryMap.containsKey(l.Country__c)) {
                Country__c country = countryMap.get(l.Country__c);
                l.CountryCapital__c = country.Capital__c;
                l.CountryRegion__c = country.Region__c;
                l.RegionalBloc__c = country.RegionalBloc__c;
            }
        }
    }
}
