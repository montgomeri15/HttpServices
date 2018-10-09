@RestResource(urlMapping='/jobAdvertisementEndpoint/*')
global with sharing class JobAdvertisementEndpoint {
    
    @HttpGet
    global static List<Job_Advertisement__c> getJobAdvertisement(){
        RestRequest req = RestContext.request;  //RestContext содержит объекты RestRequest и RestResponse, нужен для доступа к ним
        										//RestRequest - передача данных из HTTP-запроса (сервиса) методу веб-службы Apex RESTful (коллаутам)
        										//RestResponse - передача данных из метода веб-службы Apex RESTful (коллаукт) в ответ HTTP (сервису)
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
        job = (Job_Advertisement__c)JSON.deserialize(body, Job_Advertisement__c.class);
        return job;
	}
    
    @HttpPost
    global static Id doPost() {
        RestRequest req = RestContext.request;  //Возвращает RestRequest для метода Apex REST          
		Job_Advertisement__c job = ParseRequest(req);
        insert job;
        return job.Id;
    }
    
    /*@HttpPost 
	global static Ticket__c postT(TicketWrapper wrapper){
    	Ticket__c thisT = wrapper.converttoSobject();
    	insert thisT;
    	return thisT;
	}

	global class TicketWrapper{
    	public String title {get; set;}
    	public String whattime {get; set;}
    	public String whatdate {get; set;}
    	public String whatplace {get; set;}
    	public String externalId {get; set;}
    	public String manager {get; set;}
    	public String phone {get; set;}
    	public String email {get; set;}

    	public Ticket__c converttoSobject(){
        	return new Ticket__c(
            	Title__c = title,
            	Time__c = whattime,
            	Date__c = whatdate,
            	Place__c = whatplace,
            	Manager__c = manager,
            	Email__c = email,
            	Phone__c = phone,
            	ExtID__c = externalId
            );
    }
}*/

    /*@HttpPost
    global static Job_Advertisement__c postJobAdvertisement(String title, String description, String skills, String education,
                                                            String manager, String email, String phone, String status, String positionId){
                                                                
        Job_Advertisement__c thisJobAdvertisement = new Job_Advertisement__c(
            Title__c = title,
            Description__c = description,
            Skills_Required__c = skills,
            Education__c = education,
            Manager_Name__c = manager,
            Email__c = email,
            Phone__c = phone,
            Position_ID__c = positionId
            );
        upsert thisJobAdvertisement;
        return thisJobAdvertisement;
    }*/
    
    /*@HttpPost 
     webservice static void DeleteJobAdvertisement(String someId)  
     {
        List<Job_Advertisement__c> jaList=[select Id from Job_Advertisement__c where Id = :someId];
        Database.delete(jaList);
     }*/

    /*@HttpDelete
    global static void doDelete() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Job_Advertisement__c account = [SELECT Id FROM Job_Advertisement__c WHERE Id = :accountId];
        delete account; How to return null for list if we have too many records?
    }*/



}