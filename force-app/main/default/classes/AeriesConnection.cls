public class AeriesConnection {
	public static String getAeriesObject(String version, String objectA, String filters){
        HttpRequest request = new HttpRequest();
        //String endpoint = authentication.EndPoint__c  + authentication.Environment__c + '/'  + action + '?key='+ authentication.API_Key__c + filters;
        //request.setEndpoint('https://demo.aeries.net/aeries/api/v3/schools/');
        request.setEndpoint('https://rcoectesce.asp.aeries.net/admin/api/'+ version + '/' + objectA);
		//System.debug(endpoint);
        //request.setHeader('Authorization', 'Bearer ' + authentication.Token__c);
        request.setHeader('Accept','application/json');
        //request.setHeader('AERIES-CERT','477abe9e7d27439681d62f4e0de1f5e1');
        request.setHeader('AERIES-CERT','90512e648dbe4a738145725593901d5d');
        request.setMethod('GET');
        request.setTimeout(120000);
        Http http = new Http();
        HTTPResponse response;
        try{
            if(!Test.isRunningTest()){
                response = http.send(request);
                System.debug('->AeriesConnection= ' /*+ authentication.Name*/ + ', version = ' + version + ', objectA = ' +  objectA + ') => Response Status Code: ' + response.getStatusCode() + ', Response Body: ' + (String.isNotEmpty(response.getBody()) ? response.getBody().left(255) : ''));
            }else{
                response = new HTTPResponse();
                response.setStatusCode(200);
                if(objectA.equalsIgnoreCase('schools')) response.setBody('[{"SchoolCode": 0,"Name": "RCOE","InactiveStatusCode": "","Address": "","AddressCity": "","AddressState": "CA","AddressZipCode": "","AddressZipExt": "","DoNotReport": false,"StateCountyID": "33","StateDistrictID": "10330","StateSchoolID": "0000000","LowGradeLevel": 18,"HighGradeLevel": 18,"Terms": [],"PrincipalName": "","PrincipalEmailAddress": "","AttendancePeriod": 0,"Tracks": 0,"ScheduleType": "MasterSchedule","SessionType": "Regular","AttendanceType": "Daily","AttendanceReporting": "Negative","ScheduleBasis": "Semester","PhoneNumber": ""},{"SchoolCode": 1,"Name": "School of Career Education","InactiveStatusCode": "","Address": "47-336 Oasis Street","AddressCity": "Indio","AddressState": "CA","AddressZipCode": "92201","AddressZipExt": "","DoNotReport": false,"StateCountyID": "33","StateDistrictID": "74479","StateSchoolID": "","LowGradeLevel": 18,"HighGradeLevel": 18,"Terms": [],"PrincipalName": "","PrincipalEmailAddress": "","AttendancePeriod": 0,"Tracks": 0,"ScheduleType": "MasterSchedule","SessionType": "Regular","AttendanceType": "Daily","AttendanceReporting": "Positive","ScheduleBasis": "Semester","PhoneNumber": "7608633333"},{"SchoolCode": 2,"Name": "Orientation & Assessment","InactiveStatusCode": "","Address": "2100 East Alessandro Blvd","AddressCity": "Riverside","AddressState": "CA","AddressZipCode": "92508","AddressZipExt": "","DoNotReport": false,"StateCountyID": "33","StateDistrictID": "74479","StateSchoolID": "2","LowGradeLevel": 18,"HighGradeLevel": 18,"Terms":[{"TermCode": "F","TermDescription": "","StartDate": "2019-07-01T00:00:00","EndDate": "2019-12-31T00:00:00"}],"PrincipalName": "Roseanne Redfearn","PrincipalEmailAddress": "rrefearn@rcoe.us","AttendancePeriod": 0,"Tracks": 0,"ScheduleType": "MasterSchedule","SessionType": "Regular","AttendanceType": "Daily","AttendanceReporting": "Positive","ScheduleBasis": "Semester","PhoneNumber": "9518264723"}]');
            	else if(objectA.contains('schools/1/students') || objectA.contains('schools/2/students')) response.setBody('[{"PermanentID": 1839,"SchoolCode": 1,"StudentNumber": 1,"StateStudentID": "","LastName": "Alardo","FirstName": "Emily","MiddleName": "","LastNameAlias": "","FirstNameAlias": "","MiddleNameAlias": "","Sex": "M","Grade": 18,"Birthdate": "1982-02-03T00:00:00","ParentGuardianName": "","HomePhone": "9512057048","StudentMobilePhone": "","MailingAddress": "6472 Clovis Pl","MailingAddressCity": "Riverside","MailingAddressState": "CA","MailingAddressZipCode": "92504","MailingAddressZipExt": "","ResidenceAddress": "6472 Clovis Pl","ResidenceAddressCity": "Riverside","ResidenceAddressState": "CA","ResidenceAddressZipCode": "92504","ResidenceAddressZipExt": "","AddressVerified": false,"EthnicityCode": "","RaceCode1": "","RaceCode2": "","RaceCode3": "","RaceCode4": "","RaceCode5": "","UserCode1": "","UserCode2": "","UserCode3": "","UserCode4": "","UserCode5": "","UserCode6": "","UserCode7": "","UserCode8": "","UserCode9": "","UserCode10": "","UserCode11": "","UserCode12": "","UserCode13": "","SchoolEnterDate": "2019-07-12T00:00:00","SchoolLeaveDate": null,"DistrictEnterDate": "2019-07-12T00:00:00","CounselorNumber": 0,"Track": "","AttendanceProgramCodePrimary": "","AttendanceProgramCodeAdditional1": "","AttendanceProgramCodeAdditional2": "","LockerNumber": "","LowSchedulingPeriod": 0,"HighSchedulingPeriod": 0,"InactiveStatusCode": "I","FamilyKey": 0,"LanguageFluencyCode": "","HomeLanguageCode": "","CorrespondanceLanguageCode": "","ParentEdLevelCode": "","ParentEmailAddress": "","StudentEmailAddress": "amyrach33@gmail.com","NetworkLoginID": "","AtRiskPoints": "0.0000","HomeRoomTeacherNumber": "0","NotificationPreferenceCode": ""}]');
            	else if(objectA.equalsIgnoreCase('students/1839/tests')) response.setBody('[{"PermanentID": 1839,"SequenceNumber": 1,"TestID": "eTest-M","TestPart": "0","TestDescription": "Math","GradeLevel": 0,"TestingAdministration": "EA","TestDate": "2019-07-12T00:00:00","TestType": "MT","TestSource": "ALE","Scores": [{"Type": "ScaleScore","Score": 226}]},{"PermanentID": 1839,"SequenceNumber": 2,"TestID": "eTest-R","TestPart": "0","TestDescription": "Reading","GradeLevel": 0,"TestingAdministration": "EA","TestDate": "2019-07-12T00:00:00","TestType": "RD","TestSource": "ALE","Scores": [{"Type": "ScaleScore","Score": 227}]}]');
                else if(objectA.contains('StudentDataChanges')) response.setBody('[{"PermanentID": 2617,"SchoolCode": 2,"StudentNumber": 992},{"PermanentID": 2618,"SchoolCode": 2,"StudentNumber": 993},{"PermanentID": 1609,"SchoolCode": 11,"StudentNumber": 357},{"PermanentID": 1609,"SchoolCode": 12,"StudentNumber": 707},{"PermanentID": 2618,"SchoolCode": 12,"StudentNumber": 709}]');
            }
        }
        catch(Exception e){
            response = new HTTPResponse();
            response.setStatusCode(500);
            System.debug('-->AeriesConnection = ' + 'schools' + ', version = ' + version + ', objectA = ' +  objectA + ') - Callout Exception: ' + e.getMessage());
        }
        return response.getBody();
    }
}