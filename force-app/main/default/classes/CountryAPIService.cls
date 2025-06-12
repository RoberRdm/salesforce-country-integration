// Servicio que hace el callout
public with sharing class CountryAPIService {
    // Inner class to hold country data returned by the API
    //HOLA 
    //test 
    public class CountryData {
        public String name;
        public String alpha2Code;
        public String alpha3Code;
        public String capital;
        public String region;
        public List<RegionalBloc> regionalBlocs;
    }
    // Inner class to represent regional bloc information
    public class RegionalBloc {
        public String acronym;
    }
    // Future method to asynchronously fetch all countries from the external API
    @future(callout=true)
    public static void fetchCountries() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://restcountries.com/v2/all');
        request.setMethod('GET');

        try {
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                parseAndUpsertCountries(response.getBody());
            } else {
                System.debug('Error: ' + response.getStatusCode());
            }
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
        }
    }
    // Parses the JSON response and upserts Country__c records
    private static void parseAndUpsertCountries(String jsonResponse) {
        List<CountryData> countries = (List<CountryData>) JSON.deserialize(jsonResponse, List<CountryData>.class);
        List<Country__c> countryRecords = new List<Country__c>();

        for (CountryData c : countries) {
            Country__c country = new Country__c();
            country.Name = c.name;
            country.Alpha2Code__c = c.alpha2Code;
            country.Alpha3Code__c = c.alpha3Code;
            country.Capital__c = c.capital;
            country.Region__c = c.region;
            // Combine all regional bloc acronyms into a comma-separated string
            if (c.regionalBlocs != null && c.regionalBlocs.size() > 0) {
                List<String> acronyms = new List<String>();
                for (RegionalBloc rb : c.regionalBlocs) {
                    acronyms.add(rb.acronym);
                }
                country.RegionalBloc__c = String.join(acronyms, ', ');
            }

            countryRecords.add(country);
        }
        // Upsert countries based on the unique Alpha3Code__c field
        upsert countryRecords Alpha3Code__c;
    }
}
