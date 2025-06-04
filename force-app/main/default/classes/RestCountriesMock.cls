@IsTest
global class RestCountriesMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"name":"Spain","alpha2Code":"ES","alpha3Code":"ESP","capital":"Madrid","region":"Europe","regionalBlocs":[{"acronym":"EU"}]}]');
        res.setStatusCode(200);
        return res;
    }
}
