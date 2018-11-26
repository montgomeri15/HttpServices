@RestResource(urlMapping='/resumeJunctionEndpoint/*')
global with sharing class EndpointResumeJunction {
    
    @HttpGet
    global static List<Resume_Junction__c> getResumeJunction(){
        RestRequest req = RestContext.request;
        Integer rowsToSkip = Integer.valueOf(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1));
        
        List<Resume_Junction__c> resumeJunctionList;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        try{
            resumeJunctionList = [SELECT Candidate__c, Position__c, ExternalID__c
                          		  FROM Resume_Junction__c
                          		  LIMIT 100
                                  OFFSET : rowsToSkip];
            res.responseBody = Blob.valueOf(JSON.serialize(resumeJunctionList));
            res.statusCode = 200;
        } catch(QueryException e){
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 400;
        } catch(Exception e) {
            res.responseBody = Blob.valueOf(String.valueOf(e) + '\n' + e.getStackTraceString());
            res.statusCode = 500;
        }
        return resumeJunctionList;
    } 
}