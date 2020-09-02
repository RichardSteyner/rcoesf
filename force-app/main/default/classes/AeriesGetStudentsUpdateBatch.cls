global class AeriesGetStudentsUpdateBatch implements Database.Batchable<StudentParser>, Database.Stateful, Database.AllowsCallouts{
    public Integer size;
    public List<StudentChangeParser> studentsChange;
    public List<StudentChangeParser> studentsChangeProcessed;
    global AeriesGetStudentsUpdateBatch(Integer size, List<StudentChangeParser> studentsChange){
        this(size, studentsChange, new List<StudentChangeParser>(studentsChange));
    }
    global AeriesGetStudentsUpdateBatch(Integer size, List<StudentChangeParser> studentsChange, List<StudentChangeParser> studentsChangeProcessed){
        this.size = size;
        this.studentsChange = studentsChange;
        this.studentsChangeProcessed = studentsChangeProcessed;
    }
    global List<StudentParser> start(Database.BatchableContext BC){
        List<StudentChangeParser> auxStudentsChange = new List<StudentChangeParser>();
        Integer i = 1;
        for(StudentChangeParser aux : studentsChangeProcessed){if(i > size){break;}auxStudentsChange.add(aux);i++;}
        System.debug('auxStudentsChange: ' + auxStudentsChange);
        
        List<StudentParser> lista0 = new List<StudentParser>();
        List<StudentParser> lista1 = new List<StudentParser>();
        
        for(StudentChangeParser aux : auxStudentsChange){
            lista1 = (List<StudentParser>) json.deserialize(AeriesConnection.getAeriesObject('v3', 'schools/' + aux.SchoolCode + '/students/' + aux.PermanentID, ''), List<StudentParser>.class);
        	if(studentsChangeProcessed.indexOf(aux) != -1) studentsChangeProcessed.remove(studentsChangeProcessed.indexOf(aux));
            lista0.addAll(lista1);
        }
        
        return lista0;
    }
    global void execute(Database.BatchableContext BC, List<StudentParser> scope){
        try{
            //Map<Decimal, Account> accounts = new Map<Decimal, Account>();
            Map<String, Contact> contacts = new Map<String, Contact>();
            //Map<String, Lead> leads = new Map<String, Lead>();
            
            Map<Decimal, String> schoolCodes = new Map<Decimal, String>();
            for(StudentParser item : scope){
                schoolCodes.put(item.SchoolCode, '');
            }
            System.debug('schoolCodes: ' + schoolCodes);
            for(Account acc : [select Id, School_Code__c from Account where School_Code__c in: schoolCodes.keySet()]){
                schoolCodes.put(acc.School_Code__c, acc.Id);
            }
            
            for(StudentParser item : scope){
                if(schoolCodes.get(item.SchoolCode)!=''){
                    System.debug(item.LastName);
                    contacts.put(item.getAeriesID(), new Contact(AeriesPermanentID__c=item.getAeriesID(), Student_Number__c=item.StudentNumber, Company__c=String.valueOf(item.SchoolCode), 
                                                                 FirstName=item.FirstName, MiddleName=item.MiddleName, LastName=item.LastName, 
                                                                 Gender__c=item.getGender(), Grade__c=item.Grade, Date_of_birth__c=item.getBirthdate(), 
                                                                 Phone=item.HomePhone, MobilePhone=item.StudentMobilePhone, MailingStreet=item.MailingAddress, 
                                                                 MailingCity=item.MailingAddressCity, MailingState=item.MailingAddressState, 
                                                                 MailingPostalCode=item.MailingAddressZipCode, Email=item.StudentEmailAddress,
                                                                 AccountId=schoolCodes.get(item.SchoolCode)));
                }
            }
            
            System.debug(contacts);
            List<Database.UpsertResult> upsertResults;
            
            upsertResults = Database.upsert(contacts.values(), Contact.AeriesPermanentID__c, false);
            for(Database.UpsertResult upsertResult:upsertResults) {
                if(!upsertResult.isSuccess()) {
                    for(Database.Error upsertError : upsertResult.getErrors()) 
                        System.debug('AeriesGetStudentsBatch - Contact Upsert Error: ' + upsertError.getMessage());
                }
            }
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    global void finish(Database.BatchableContext BC){
        System.debug('Finish AeriesGetStudentsUpdateBatch');
        if(!Test.isRunningTest()){
            if(studentsChangeProcessed.size()>0) System.scheduleBatch(new AeriesGetStudentsUpdateBatch(size, studentsChange, studentsChangeProcessed), 'AeriesGetStudentsUpdateBatch', 1, 100);
        	else Database.executeBatch(new AeriesGetStudentDataChangesBatch(false, 'test')); //llamar a student batch para traer los ultimos test modificados
        }
    }
}