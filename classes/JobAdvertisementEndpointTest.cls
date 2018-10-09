@isTest
private class JobAdvertisementEndpointTest {
    
    private static String url = System.URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/Job_Advertisement__c/';
    
    static Job_Advertisement__c createTestRecord() {  //Тестовый Job_Advertisement__c
        Job_Advertisement__c jobAdvertisementTest = new Job_Advertisement__c(  
            Title__c = 'Title',
            Description__c = 'Description',
            Skills_Required__c = 'Skills',
            Education__c = 'Education',
            Manager_Name__c = 'Test Name',
            Email__c = 'Email@gmail.com',
            Phone__c = '+3805454564564'
        );
        //insert jobAdvertisementTest;
        return jobAdvertisementTest;
    }
    
    private static RestRequest getRequest(String jsonBody, String method, String requestUri){  //RestRequest для устранения дублей
		RestRequest request = new RestRequest();
		request.httpMethod = method;
		if(jsonBody!=null){
			request.requestBody = Blob.valueOf(jsonBody);
		}
		request.addHeader('Content-Type', 'application/json');
		request.requestUri = requestUri;
		RestContext.request = request;
		return request;
	}
    
    //Test GET
    
    @isTest
    static void testGetJobAdvertisementId() {
    	Job_Advertisement__c testRecord = createTestRecord();
        insert testRecord;
        String json = System.JSON.serialize(testRecord);
        RestRequest request = getRequest(json, 'GET', url+testRecord.Id);
        request.addParameter('Id', testRecord.Id);
        List<Job_Advertisement__c> jobAdvertisementList = JobAdvertisementEndpoint.getJobAdvertisement();
        System.assert(jobAdvertisementList != null);
           
        for(Job_Advertisement__c jobAdvertisement : jobAdvertisementList){
            System.assertEquals(jobAdvertisement.Id, testRecord.Id);
        }
    }
    
    @isTest
    static void testGetJobAdvertisement() {
        Job_Advertisement__c testRecord = createTestRecord();
        insert testRecord;
    	String json = System.JSON.serialize(testRecord);
        RestRequest request = getRequest(json, 'GET', url+testRecord.Id);
        List<Job_Advertisement__c> jobAdvertisementList = JobAdvertisementEndpoint.getJobAdvertisement();
        System.assert(jobAdvertisementList != null);
           
        for(Job_Advertisement__c jobAdvertisement : jobAdvertisementList){
            System.assertEquals(jobAdvertisement.Id, testRecord.Id);
        }
    }
    
    //Test POST
    
    @isTest
    static void testPostJobAdvertisement() { 
        Job_Advertisement__c testRecord = createTestRecord();
        String json = System.JSON.serialize(testRecord);
        RestRequest request = getRequest(json, 'POST', url+testRecord.Id);
        Job_Advertisement__c ourRecord = JobAdvertisementEndpoint.ParseRequest(request);
        System.assertEquals(testRecord, ourRecord);
        
        Id jobAdvertisementId = JobAdvertisementEndpoint.doPost();
        System.assert(jobAdvertisementId != null);
    }
    
    @isTest
    static void testNotPostJobAdvertisement() {
        Job_Advertisement__c testRecord = createTestRecord();
        String json = '12345';
        RestRequest request = getRequest(json, 'POST', url+testRecord.Id);
        Job_Advertisement__c ourRecord = JobAdvertisementEndpoint.ParseRequest(request);
        System.assertNotEquals(ourRecord, testRecord);
        Id jobAdvertisementId = JobAdvertisementEndpoint.doPost();
        System.assert(jobAdvertisementId != null);
    }
    
    //Тест DELETE
    
    @isTest
    static void testDeleteJobAdvertisementId() {
        Job_Advertisement__c testRecord = createTestRecord();
        insert testRecord;
        RestRequest request = new RestRequest();
        request.requestUri = System.URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/Job_Advertisement__c/Position_ID__c/' + testRecord.Id;
        request.httpMethod = 'GET';
        RestContext.request = request;
		JobAdvertisementEndpoint.deletegetJobAdvertisement();  //Вызываем метод
        List<Job_Advertisement__c> jobAdvertisementList = [SELECT Id FROM Job_Advertisement__c WHERE Position_ID__c =: testRecord.Id];
        System.assert(jobAdvertisementList.size() == 0);      
    }
    
    //Тест PUT(PATCH)
    
    @isTest
    static void testUpdateJobAdvertisementId() {
        Job_Advertisement__c testRecord = createTestRecord();
        insert testRecord;
        RestRequest request = new RestRequest();
        request.requestUri = System.URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/Job_Advertisement__c/Position_ID__c/' + testRecord.Id;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Title__c": "New"}');  //Меняем запись 
        RestContext.request = request;
        Id jobAdvertisementId = JobAdvertisementEndpoint.updateJobAdvertisement();  //Апдейтим
        System.assert(jobAdvertisementId != null);
        Job_Advertisement__c updatedRecord = [SELECT Id, Title__c FROM Job_Advertisement__c WHERE Position_ID__c =: jobAdvertisementId];
        System.assert(updatedRecord != null);
        System.assertEquals(updatedRecord.Title__c, 'New');
    }  
}