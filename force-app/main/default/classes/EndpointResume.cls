@RestResource(urlMapping='/resumeEndpoint/*')
global with sharing class EndpointResume {
    
    @HttpGet
    global static List<Resume__c> getResume(){
        RestRequest req = RestContext.request;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        List<Resume__c> resumeList;
                
        Integer lastIndex = 0;  //последний индекс из коллаута
        Integer step = 200;
        Integer listSize = 400;  //размер одного запроса из коллаута
        
        Database.QueryLocator q = Database.getQueryLocator([SELECT First_Name__c, Last_Name__c, Age__c, Salary__c, Email__c, Phone__c, Currently_Employed__c,
                                                            Additional_Info__c, Photo_Code__c, Photo_Title__c, Photo_PathOnClient__c
                          									FROM Resume__c]);
        Database.QueryLocatorIterator iterator =  q.iterator();  //итерация по кверилокатору
       
        List<Resume__c> totalResumeList = new List<Resume__c>();  //присваиваем локатор листу резюме (его аналог, но в листе)
        while (iterator.hasNext()) {
            Resume__c resume = (Resume__c)iterator.next();
            totalResumeList.add(resume);    
        }  
        
        Integer n = listSize/step;
        List<Resume__c> currentResumeList;
        
        for(Integer j=1; j<=n; j++){
            currentResumeList = new List<Resume__c>();
            step = step * j;
            
        	for(Integer i=lastIndex; i<step; i++){
            	currentResumeList.add(totalResumeList.get(i));
        	}
            try{
                res.responseBody = Blob.valueOf(JSON.serialize(currentResumeList));
                res.statusCode = 200;
            } catch(QueryException e){
            	res.responseBody = Blob.valueOf('Error 400:  ' + e.getMessage());
            	res.statusCode = 400;
        	} catch(Exception e) {
            	res.responseBody = Blob.valueOf('Error 500:  ' + String.valueOf(e) + '\n' + e.getStackTraceString());
            	res.statusCode = 500;
        	}
            lastIndex = lastIndex + step;
            //return currentResumeList;
        }
        
        /*if((lastIndex + listSize) <= totalResumeList.size()) {
            last_i = lastIndex + listSize;
        } else{
            last_i = totalResumeList.size();
        }
        
        System.debug('last_i:  ' + last_i);
        
        for(Integer i=lastIndex; i<last_i; i++) {
            currentResumeList.add(totalResumeList.get(i));
            System.debug('currentResumeList.size():  ' + currentResumeList.size());	
        }*/
        
		
        
        
        /*try{
            Id reqId = RestContext.request.params.get('Id');
  			//if(reqId != null) {
    			resumeList = [SELECT First_Name__c, Last_Name__c, Age__c, Salary__c, Email__c, Phone__c, Status__c,
                          	   		 Additional_Info__c, Photo_Code__c, Photo_Title__c, Photo_PathOnClient__c
                        	  FROM Resume__c
                        	 // WHERE Id > :reqId
                        	 // ORDER BY Id
                        	 // LIMIT 2000
                             ];
            } else {
                resumeList = [SELECT First_Name__c, Last_Name__c, Age__c, Salary__c, Email__c, Phone__c, Currently_Employed__c,
                          		     Additional_Info__c, Photo_Code__c, Photo_Title__c, Photo_PathOnClient__c
                              FROM Resume__c
                              ORDER BY Id
                              LIMIT 200];
  			}
            //res.responseBody = Blob.valueOf(JSON.serialize(currentResumeList));
            res.statusCode = 200;
        } catch(QueryException e){
            res.responseBody = Blob.valueOf('Error 400:  ' + e.getMessage());
            res.statusCode = 400;
        } catch(Exception e) {
            res.responseBody = Blob.valueOf('Error 500:  ' + String.valueOf(e) + '\n' + e.getStackTraceString());
            res.statusCode = 500;
        }*/
        return currentResumeList;
    }
}