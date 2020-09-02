public class AeriesConvertLead {
    
    @AuraEnabled
    public static String convertLeadLightning(String id){
        Lead objLead = [select Id, AeriesPermanentId__c, Student_Number__c, Company, FirstName, MiddleName, LastName, Gender__c, Grade__c, Date_of_Birth__c,
                        Phone, MobilePhone, Street, City, State, PostalCode, Email, Orientation_Date__c, School__c, Converted__c
                        from Lead 
                        where Id =: id];
        Decimal auxSchoolCode;
        if(objLead.Converted__c) return 'Error: Lead has already been converted.!';
        if(objLead.Orientation_Date__c != null){
        //if(String.isNotBlank(objLead.AeriesPermanentID__c)){
        	if(objLead.School__c == null) return 'Error: School required.!';
            Contact objContact = new Contact();
            //objContact.AeriesPermanentID__c = objLead.AeriesPermanentID__c;
            objContact.Student_Number__c = objLead.Student_Number__c;
            objContact.AccountId = objLead.School__c;
            String recordTypeStudent = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Student') != null ? Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Student').getRecordTypeId() : null;
            objContact.RecordTypeId = recordTypeStudent;
            //company
            /*try{
                auxSchoolCode = Integer.valueOf(objLead.Company);
            }catch(Exception e){
                System.debug('Error: Exception: ' + e.getMessage());
                return 'Error: Exception: ' + e.getMessage();
            }
            List<Account> auxList = [select Id from Account where School_Code__c =: auxSchoolCode];
            String accountId = !auxList.isEmpty() ? auxList[0].Id : null;
            if(accountId!=null){
                objContact.AccountId = accountId;
            }
            else{
                System.debug('Error: No school with Company value was found.');
                return 'Error: No school with Company value was found.';
            }*/
            objContact.Company__c = objLead.Company;
            objContact.FirstName = objLead.FirstName;
            objContact.MiddleName = objLead.MiddleName;
            objContact.LastName = objLead.LastName;
            objContact.Gender__c = objLead.Gender__c;
            objContact.Grade__c = objLead.Grade__c;
            objContact.Date_of_Birth__c = objLead.Date_of_Birth__c;
            objContact.Phone = objLead.Phone;
            objContact.MobilePhone = objLead.MobilePhone;
            objContact.MailingStreet = objLead.Street;
            objContact.MailingCity = objLead.City;
            objContact.MailingState = objLead.State;
            objContact.MailingPostalCode = objLead.PostalCode;
            objContact.Email = objLead.Email;
            //upsert objContact Contact.AeriesPermanentID__c;
            try{
                insert objContact;
                objLead.Converted__c = true;
                update objLead;
                System.debug(objContact.Id);
                return objContact.Id;
            }catch(Exception e){
                System.debug('Error: Exception: ' + e.getLineNumber() + ' - ' + e.getMessage());
                return 'Error: Exception DML.';
            }
        }else{
            System.debug('Error: AeriesPermanentID__c null.!');
            return 'Error: Orientation Date is required.!';
        }
        //return 'OK';
    }

}