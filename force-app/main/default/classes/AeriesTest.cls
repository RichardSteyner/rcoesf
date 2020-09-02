@isTest
public class AeriesTest {
    
    @isTest static void testStudentParser(){
        StudentParser sp = new StudentParser();
        sp.AddressVerified = true;
        sp.AtRiskPoints = 'test AtRiskPoints';
        sp.AttendanceProgramCodeAdditional1 = 'test AttendanceProgramCodeAdditional1';
        sp.AttendanceProgramCodeAdditional2 = 'test AttendanceProgramCodeAdditional2';
        sp.AttendanceProgramCodePrimary = 'test AttendanceProgramCodePrimary';
        sp.CounselorNumber = 1;
        sp.EthnicityCode = 'test EthnicityCode';
        sp.FamilyKey = 10;
        sp.FirstNameAlias = 'test FirstNameAlias';
        sp.LastNameAlias = 'test LastNameAlias';
        sp.LockerNumber = 'test LockerNumber';
        sp.MiddleNameAlias = 'test MiddleNameAlias';
        sp.NetworkLoginID = 'test NetworkLoginID';
        sp.NotificationPreferenceCode = 'test NotificationPreferenceCode';
        sp.ParentEdLevelCode = 'test ParentEdLevelCode';
        sp.ParentGuardianName = 'test ParentGuardianName';
        sp.RaceCode1 = 'test RaceCode1';
        sp.RaceCode2 = 'test RaceCode2';
        sp.RaceCode3 = 'test RaceCode3';
        sp.RaceCode4 = 'test RaceCode4';
        sp.RaceCode5 = 'test RaceCode5';
        sp.SchoolEnterDate = null;
        sp.SchoolLeaveDate = null;
        sp.Track = 'test Track';
        sp.UserCode1 = 'test UserCode1';
        sp.UserCode2 = 'test UserCode2';
        sp.UserCode3 = 'test UserCode3';
        sp.UserCode4 = 'test UserCode4';
        sp.UserCode5 = 'test UserCode5';
        sp.UserCode6 = 'test UserCode6';
        sp.UserCode7 = 'test UserCode7';
        sp.UserCode8 = 'test UserCode8';
        sp.UserCode9 = 'test UserCode9';
        sp.UserCode10 = 'test UserCode10';
        sp.UserCode11 = 'test UserCode11';
        sp.UserCode12 = 'test UserCode12';
        sp.UserCode13 = 'test UserCode13';
    }
    
    @isTest static void testApexUtilFE(){
        Account acc = new Account(Name='Test School', School_Code__c=1);
        insert acc;
        Test.startTest();
        ApexUtil.findEscuela(-1);
        Test.stopTest();
    }
    
    @isTest static void testApexUtilEAV(){
        System.assertEquals('', ApexUtil.emailAddressValid('test@1'));
    }
    
    @isTest static void testApexUtilVYD(){
        System.assertEquals(false, ApexUtil.validYearDate(null)); 
        Datetime aux = Datetime.valueOf('2019-07-12 00:00:00');
        System.assertEquals(true, ApexUtil.validYearDate(aux.date()));  
        aux = Datetime.valueOf('7821-07-12 00:00:00');
        System.assertEquals(false, ApexUtil.validYearDate(aux.date()));
    }
    
    @isTest static void testSchoolBatch(){
        Test.startTest();
        Database.executeBatch(new AeriesGetSchoolsBatch(true), 150);
        Test.stopTest();
    }
    
    @isTest static void testStudentBatch(){
        Account acc = new Account(Name='Test School', School_Code__c=1);
        insert acc;
        Test.startTest();
        Database.executeBatch(new AeriesGetStudentsBatch(1), 150);
        Test.stopTest();
    }
    
    @isTest static void testTestScoreBatch(){
        Account acc = new Account(Name='Test School', School_Code__c=1);
        insert acc;
        Contact con = new Contact(LastName='Test Student', AeriesPermanentID__c='1839', Company__c='1', Student_Number__c=123, AccountId=acc.Id);
        insert con;
        Test.startTest();
        Database.executeBatch(new AeriesGetTestScoresBatch(30, new Set<String>{'1839'}, 1), 150);
        Test.stopTest();
    }
    
    @isTest static void testStudentUpdateBatch(){
        Account acc = new Account(Name='Test School', School_Code__c=1);
        insert acc;
        StudentChangeParser scp = new StudentChangeParser();
        scp.PermanentID = 1839;
        scp.SchoolCode = 1;
        scp.StudentNumber = 1;
        Test.startTest();
        Database.executeBatch(new AeriesGetStudentsUpdateBatch(30, new List<StudentChangeParser>{scp}), 150);
        Test.stopTest();
    }
    
    @isTest static void testStudentDataChangeBatch1(){
        Test.startTest();
        Database.executeBatch(new AeriesGetStudentDataChangesBatch(false, 'student'), 150);
        Test.stopTest();
    }
    
    @isTest static void testStudentDataChangeBatch2(){
        Test.startTest();
        Database.executeBatch(new AeriesGetStudentDataChangesBatch(true, 'test'), 150);
        Test.stopTest();
    }
    
    @isTest static void testConvertLeadLightning(){
        Account acc = new Account(Name='Test School', School_Code__c=1);
        insert acc;
        Lead objLead = new Lead(FirstName='Richard', LastName='Urupeque', Orientation_Date__c=System.now().date(), Company='Cloud', School__c=acc.Id);
        insert objLead;
        Test.startTest();
        AeriesConvertLead.convertLeadLightning(objLead.id);
        Test.stopTest();
    }
    
    @isTest static void testScheduler(){
		AeriesGetSchedule scheduler= new AeriesGetSchedule();
        SchedulableContext sc;
        Test.startTest();
		scheduler.execute(sc);
        Test.stopTest();
	}

}