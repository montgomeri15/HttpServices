@RestResource(urlMapping='/jobAdvertisementEndpoint/*')
global with sharing class JobAdvertisementEndpoint {
    
    @HttpGet
    global static List<Job_Advertisement__c> getJobAdvertisement(){
        RestRequest req = RestContext.request;  //RestContext содержит объекты RestRequest и RestResponse, нужен для доступа к ним
        										//RestRequest - передача данных из HTTP-запроса (коллаута) методу веб-службы Apex RESTful (сервису)
        										//RestResponse - передача данных из метода веб-службы Apex RESTful (сервиса) в ответ HTTP (коллауту)
   		String jobAdvId = req.params.get('Id');
        List<Job_Advertisement__c> jobAdvList;
        
        if(jobAdvId != null){
            jobAdvList = [SELECT Id, Title__c, Location__c, Description__c, Salary__c, Skills_Required__c, Education__c, Manager_Name__c, Email__c, Phone__c, Status__c, Position_ID__c 
                          FROM Job_Advertisement__c
                          WHERE Id =: jobAdvId
                          LIMIT 1000];
        } else{
            jobAdvList = [SELECT Id, Title__c, Location__c, Description__c, Salary__c, Skills_Required__c, Education__c, Manager_Name__c, Email__c, Phone__c, Status__c, Position_ID__c 
                          FROM Job_Advertisement__c
                          LIMIT 1000];
        }
        return jobAdvList;
    }
    
    public static Job_Advertisement__c ParseRequest(RestRequest req) {
		Job_Advertisement__c job = new Job_Advertisement__c();
        String body = req.requestBody.toString();
        
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        try{
        	job = (Job_Advertisement__c)JSON.deserialize(body, Job_Advertisement__c.class);
            res.responseBody = Blob.valueOf(JSON.serialize(job));
            res.statusCode = 200;
        } catch(JSONException e){
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 400;   
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(String.valueOf(e) + '\n' + e.getStackTraceString());
            res.statusCode = 500;
        }
        return job;
	}
    
    @HttpPost
    global static Id doPost() {
        RestRequest req = RestContext.request;  //Возвращает RestRequest для метода Apex REST          
        Job_Advertisement__c job = ParseRequest(req);
        insert job;
        return job.Id;
    }
    
    @HttpDelete
 	global static void deletegetJobAdvertisement() {
        RestRequest req = RestContext.request;
        String jobAdvId = req.params.get('Id');
        Job_Advertisement__c jobAdvertisement = [SELECT Id FROM Job_Advertisement__c WHERE Position_ID__c =: jobAdvId];
        if(jobAdvertisement != null){
            delete jobAdvertisement;
        }
 	}
    
    @HttpPatch
    global static Id updateJobAdvertisement() {
        RestRequest req = RestContext.request;
        String jobAdvId = req.params.get('Id');
        Job_Advertisement__c jobAdvertisement = [SELECT Id FROM Job_Advertisement__c WHERE Position_ID__c =: jobAdvId];
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(req.requestbody.tostring());  //Десериализация JSON-а в мапу
        for(String fieldName : params.keySet()) {
            jobAdvertisement.put(fieldName, params.get(fieldName));
        }
        update jobAdvertisement;
        return jobAdvertisement.Id;
    }
}