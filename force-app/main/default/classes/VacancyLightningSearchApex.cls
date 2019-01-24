public with sharing class VacancyLightningSearchApex {
    
    @AuraEnabled
    public static List<Job_Advertisement__c> getAllVacancies() {
        return [SELECT Id, Name, Salary__c, Location__c, Published_Date__c
				FROM Job_Advertisement__c];
    }
        
    @AuraEnabled
    public static List<Job_Advertisement__c> filterVacancies(String filterName, String filterSalary, String filterDate) {
        List<String> filters = new List<String>();
        
        if(String.isNotBlank(filterName)) {
        	filters.add('Name LIKE \'%' + String.escapeSingleQuotes(filterName)+'%\'');
    	}
        if(filterSalary != 'Salary range') {
        	filters.add('Salary__c =: filterSalary');
    	}
        if( String.isNotBlank(filterDate)) {
        	filters.add('Published_Date__c =: filterDate');
    	}
        return Database.query('SELECT Id, Name, Salary__c, Location__c, Published_Date__c FROM Job_Advertisement__c' + 
                             (filters.isEmpty() ? '' : ' WHERE ' + String.join(filters,' AND ')));
    }
    
    @AuraEnabled
    public static void createRecord (Resume__c resume){
        try{
            if(resume != null){
                insert resume;
            }
        } catch (Exception ex){ 
            System.debug('Something is wrong:' + ex);
        }
    }
    
    @AuraEnabled
    public static void save(Id resumeId, String versionData){ 
        	ContentVersion currentContentVersion = new ContentVersion(
            	Title = 'title',
            	PathOnClient = 'pathOnClient',
            	VersionData = EncodingUtil.base64Decode(versionData),
            	FirstPublishLocationId = resumeId
        	); 
            insert currentContentVersion;
        
    Id cdID = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: currentContentVersion.Id].ContentDocumentId;
        
        
    //currentContentVersion = [select id, ContentDocumentId from ContentVersion WHERE Id =: currentContentVersion.Id];
    ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :currentContentVersion.Id];

ContentDocumentLink contentlink=new ContentDocumentLink();
contentlink.LinkedEntityId=resumeId;
contentlink.ShareType= 'V';
contentlink.ContentDocumentId=testcontent.ContentDocumentId;

insert contentlink;  
    }
    
    /*@AuraEnabled
    public static void uploadFile() {
        if(versionData == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, System.Label.File_is_null));
        } else{
        	deletePreviousFiles();
        	currentContentVersion = new ContentVersion(
            	Title = title,
            	PathOnClient = pathOnClient,
            	VersionData = versionData,
            	FirstPublishLocationId = resume.Id
        	);
        
        	try {
            	insert currentContentVersion;
        	} catch(Exception e) {
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getMessage()));
        	}
        
        	contentVersionId = currentContentVersion.Id;
        	resume.Photo_Code__c = EncodingUtil.base64Encode(currentContentVersion.VersionData);
        	resume.Photo_Title__c = title;
        	resume.Photo_PathOnClient__c = pathOnClient;
        
        	try {
        		update resume;
        	} catch(Exception e) {
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getMessage()));
        	}
        }
    }
    
    public void deletePreviousFiles() {
        List<ContentVersion> contentVersionList = getContentVersionList();
        List<ContentDocument> contentDocumentList = new List <ContentDocument>();
        
        for(ContentVersion temporaryContentVersion : contentVersionList){
            try{
                ContentDocument thisContentDocument = [SELECT Id FROM ContentDocument WHERE Id =: temporaryContentVersion.ContentDocumentId];
           		contentDocumentList.add(thisContentDocument); 
            } catch(QueryException e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getMessage()));
            }
        }
        delete contentDocumentList;
    }*/
}