public class ApexUtil {
    
    public static void findEscuela(Decimal firstEscuela){
        Integer i = 0;
        List<Account> accList = [select Id, School_Code__c from Account where School_Code__c!=null and School_Code__c >: firstEscuela order by School_Code__c asc limit 1];
        if(accList.size()>0){
        	//Database.executeBatch(new AeriesGetStudentsBatch(true, accList[0].School_Code__c));
            if(!Test.isRunningTest()) System.scheduleBatch(new AeriesGetStudentsBatch(accList[0].School_Code__c), 'AeriesGetStudentsBatch-' + accList[0].School_Code__c, 1, 200);
        }
    }
    
    public static String emailAddressValid(String email) {
		if (String.isEmpty(email)) return '';
			
		// Regex source: http://www.regular-expressions.info/email.html
		String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; 
		Pattern MyPattern = Pattern.compile(emailRegex);
		Matcher MyMatcher = MyPattern.matcher(email);
	
		if (!MyMatcher.matches()) 
		    return '';
		return email;	
	}
    
    public static Boolean validYearDate(Date auxDate){
        if(auxDate!=null && auxDate.year()>1700 && auxDate.year()<4000)
            return true;
        return false;
    }

}