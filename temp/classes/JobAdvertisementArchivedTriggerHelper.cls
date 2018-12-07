public class JobAdvertisementArchivedTriggerHelper {
    
    public void removePositionId(Job_Advertisement__c jobAdvertisement){
        List<Resume__c> resumesList  = [SELECT Id, Position_ID__c FROM Resume__c];
            
        for(Resume__c resume : resumesList){
            if(resume.Position_ID__c != null && resume.Position_ID__c.contains(jobAdvertisement.Position_ID__c)){
                List<String> positionIdsList = String.valueOf(resume.Position_ID__c).split(' ');
                    
                for(Integer i=0; i<positionIdsList.size(); i++){
                    if(positionIdsList[i] == jobAdvertisement.Position_ID__c){
                        positionIdsList.remove(i);   
            		} 
                }
                resume.Position_ID__c = String.join(positionIdsList,' ');
                update resume;
            }
        }
    }
}