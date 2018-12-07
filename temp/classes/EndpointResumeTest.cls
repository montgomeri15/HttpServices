@isTest
private class EndpointResumeTest {
    
    private static String url = System.URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/Resume__c/';
    
    static Resume__c createTestRecord() {
        Resume__c resumeTest = new Resume__c(  
            Full_Name__c = 'Name',
            Age__c = 20,
            Salary__c = 9898,
            Email__c = 'Email@gmail.com',
            Phone__c = '+3805454564564'
        );
        return resumeTest;
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
    
    @isTest
    static void testGetJobAdvertisementId() {
    	Resume__c testRecord = createTestRecord();
        insert testRecord;
        String json = System.JSON.serialize(testRecord);
        RestRequest request = getRequest(json, 'GET', url+testRecord.Id);
        request.addParameter('Id', testRecord.Id);
        List<Resume__c> resumeList = EndpointResume.getResume();
        System.assert(resumeList != null);
        System.assertEquals(resumeList.get(0).Id, testRecord.Id);
    }
    
    //TRIGGER
    
    @isTest
    static void testUpdateStatusTrigger() {
        JobAdvertisementArchivedTriggerHelper triggerHelper = new JobAdvertisementArchivedTriggerHelper();
        
        Resume__c resume = new Resume__c(Email__c = 'test@test.com', Position_ID__c = 'text 999999');
        insert resume;
        Job_Advertisement__c testJobAdvertisement = new Job_Advertisement__c(Position_ID__c = '999999');
        insert testJobAdvertisement;
        
        System.assertEquals('text 999999', resume.Position_ID__c);
        
        testJobAdvertisement.Status__c = 'Archived';
        update testJobAdvertisement;
        
        Test.startTest();
        	triggerHelper.removePositionId(testJobAdvertisement);
        Test.stopTest();
        
        Resume__c resumeTest = [SELECT Position_ID__c FROM Resume__c WHERE Email__c = 'test@test.com'];
        System.assertEquals('text', resumeTest.Position_ID__c);
    }
    
    @isTest
    static void testDeletePositionTrigger() {
        JobAdvertisementArchivedTriggerHelper triggerHelper = new JobAdvertisementArchivedTriggerHelper();
        
        Resume__c resume = new Resume__c(Email__c = 'test@test.com', Position_ID__c = 'text 999999');
        insert resume;
        Job_Advertisement__c testJobAdvertisement = new Job_Advertisement__c(Position_ID__c = '999999');
        insert testJobAdvertisement;
        
        System.assertEquals('text 999999', resume.Position_ID__c);
        
        delete testJobAdvertisement;
        
        Test.startTest();
        	triggerHelper.removePositionId(testJobAdvertisement);
        Test.stopTest();
        
        Resume__c resumeTest = [SELECT Position_ID__c FROM Resume__c WHERE Email__c = 'test@test.com'];
        System.assertEquals('text', resumeTest.Position_ID__c);
    }
}