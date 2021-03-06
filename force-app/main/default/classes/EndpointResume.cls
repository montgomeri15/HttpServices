@RestResource(urlMapping='/resumeEndpoint/*')
global with sharing class EndpointResume {
    
    @HttpGet
    global static List<Resume__c> getResume(){
        RestRequest req = RestContext.request;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        List<Resume__c> resumeList;
                
        try{
            resumeList = [SELECT First_Name__c, Last_Name__c, Age__c, Salary__c, Email__c, Phone__c, Currently_Employed__c,
                          		 Additional_Info__c, Photo_Code__c, Photo_Title__c, Photo_PathOnClient__c, Position_ID__c
                          FROM Resume__c
                          WHERE SystemModStamp >= LAST_N_DAYS:1 
                          ORDER BY Id
                          LIMIT 50000];
            res.responseBody = Blob.valueOf(JSON.serialize(resumeList));
            res.statusCode = 200;
        } catch(Exception e) {
            res.statusCode = 500;
        }
        return resumeList;
    }
}