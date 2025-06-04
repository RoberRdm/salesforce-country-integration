public with sharing class CountryUpdateScheduler implements Schedulable {
    public void execute(SchedulableContext context) {
        CountryAPIService.fetchCountries(); // call to the future method
    }
}
