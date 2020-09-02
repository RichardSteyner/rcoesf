global class AeriesGetSchoolsBatch implements Database.Batchable<SchoolParser>, Database.Stateful, Database.AllowsCallouts{
    public Boolean isAll;
    global AeriesGetSchoolsBatch(Boolean isAll){
        this.isAll = isAll;
    }
    global List<SchoolParser> start(Database.BatchableContext BC){
        List<SchoolParser> lista = new List<SchoolParser>();
       	lista = (List<SchoolParser>) json.deserialize(AeriesConnection.getAeriesObject('v3', 'schools', ''), List<SchoolParser>.class);
        return lista;
    }
    global void execute(Database.BatchableContext BC, List<SchoolParser> scope){
        try{
            Map<Decimal, Account> accounts = new Map<Decimal, Account>();
            Map<Decimal, Contact> contacts = new Map<Decimal, Contact>();
            for(SchoolParser item : scope){
                System.debug(item.Name);
                accounts.put(item.SchoolCode, new Account(Name=item.Name, School_Code__c=item.SchoolCode, InactiveStatusCode__c=item.InactiveStatusCode, 
                                                          BillingStreet=item.Address, BillingCity=item.AddressCity, BillingState=item.AddressState, 
                                                          BillingPostalCode=item.AddressZipCode, State_Country_ID__c=item.StateCountyID, 
                                                          State_District_ID__c=item.StateDistrictID, State_School_ID__c=item.StateSchoolID,
                                                          Low_Grade_Level__c=item.LowGradeLevel, High_Grade_Level__c=item.HighGradeLevel, 
                                                          Attendance_Period__c=item.AttendancePeriod, Tracks__c=item.Tracks, 
                                                          Schedule_Type__c=item.ScheduleType, Session_Type__c=item.SessionType,
                                                          Attendance_Type__c=item.AttendanceType, Attendance_Reporting__c=item.AttendanceReporting, 
                                                          Schedule_Basis__c=item.ScheduleBasis, Phone=item.PhoneNumber));
                if(String.isNotEmpty(item.PrincipalName)){
                    contacts.put(item.SchoolCode, new Contact(FirstName=item.getFirstName(), LastName=item.getLastName(), School_Code__c=item.SchoolCode, 
                                                                 Title='Principal', Email=item.PrincipalEmailAddress));
                }
            	//System.debug('Country: ' + item.country + '...State: ' + item.state_province);
            }
            
            System.debug(accounts);
            System.debug(contacts);
            List<Database.UpsertResult> upsertResults;
            
            upsertResults = Database.upsert(accounts.values(), Account.School_Code__c, false);
            for(Database.UpsertResult upsertResult:upsertResults) {
                if(!upsertResult.isSuccess()) {
                    for(Database.Error upsertError : upsertResult.getErrors()) 
                        System.debug('AeriesGetSchoolsBatch - Account Upsert Error: ' + upsertError.getMessage());
                } else {
                    //contacts[0].AccountId=upsertResult.id; 
                }
            }
            
            for(Account acc : accounts.values()){
                if(acc.Id!=null)
                {
                    if(contacts.get(acc.School_Code__c)!=null) contacts.get(acc.School_Code__c).AccountId=acc.Id;
                    //System.debug('Add: ' + acc.Name + '-' + acc.Id);
                }
                else{
                    if(contacts.get(acc.School_Code__c)!=null) contacts.remove(acc.School_Code__c);
                    System.debug('Remove: ' + acc.Name);
                }
            }
            
            upsertResults = Database.upsert(contacts.values(), Contact.School_Code__c, false);
            for(Database.UpsertResult upsertResult:upsertResults) {
                if(!upsertResult.isSuccess()) {
                    for(Database.Error upsertError : upsertResult.getErrors()) 
                        System.debug('AeriesGetSchoolsBatch - Contact Upsert Error: ' + upsertError.getMessage());
                }
            }
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    global void finish(Database.BatchableContext BC){
        System.debug('Finsih AeriesGetSchoolsBatch');
        if(!Test.isRunningTest()){
            if(isAll) ApexUtil.findEscuela(-1);//este batch es para extraer todos los records
            else Database.executeBatch(new AeriesGetStudentDataChangesBatch(false, 'student')); //este es para extraer los actualizados
        }
    }
}