public class VacancyControllerEmail {
    
    public Boolean checkEmail(String email) {
		if (String.isEmpty(email)) return true;
		Boolean isValid = true;
		String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; 
		Pattern MyPattern = Pattern.compile(emailRegex);
		Matcher MyMatcher = MyPattern.matcher(email);
		if (!MyMatcher.matches()) 
		    isValid = false;
		return isValid;	
	}
    
    public void sendEmailNotification(String popupEmail, Map<Id, Job_Advertisement__c> selectedJobAdvertisementsMap){
        List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
		message.toAddresses = new String[] { popupEmail };
		message.subject = 'List of vacancies for your resume';
        message.setSaveAsActivity(false);
        
        if(!selectedJobAdvertisementsMap.values().isEmpty()){
            message.plainTextBody = 'Today you have chosen these jobs: ' + selectedJobAdvertisementsMap.values() + '. Your resume received and will be reviewed soon.'; 
        } else{
            message.plainTextBody = 'Congratulations! Your resume has been successfully created or modified.';
        }
        allMails.add(message);
        try{
            Messaging.sendEmail(allMails); 
        } catch(EmailException e){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.CONFIRM, e.getMessage()));
        }
    }
}