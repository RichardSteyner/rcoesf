global class StudentParser {
    
    public Integer PermanentID {get;set;}
    public Integer SchoolCode {get;set;}
    public Integer StudentNumber {get;set;}
    public String StateStudentID {get;set;}
    public String LastName {get;set;}
    public String FirstName {get;set;}
    public String MiddleName {get;set;}
    public String LastNameAlias {get;set;}
    public String FirstNameAlias {get;set;}
    public String MiddleNameAlias {get;set;}
    public String Sex {get;set;}
    public Integer Grade {get;set;}
    public Datetime Birthdate {get;set;}
    public String ParentGuardianName {get;set;}
    public String HomePhone {get;set;}
    public String StudentMobilePhone {get;set;}
    public String MailingAddress {get;set;}
    public String MailingAddressCity {get;set;}
    public String MailingAddressState {get;set;}
    public String MailingAddressZipCode {get;set;}
    public String MailingAddressZipExt {get;set;}
    public String ResidenceAddress {get;set;}
    public String ResidenceAddressCity {get;set;}
    public String ResidenceAddressState {get;set;}
    public String ResidenceAddressZipCode {get;set;}
    public String ResidenceAddressZipExt {get;set;}
    public Boolean AddressVerified {get;set;}
    public String EthnicityCode {get;set;}
    public String RaceCode1 {get;set;}
    public String RaceCode2 {get;set;}
    public String RaceCode3 {get;set;}
    public String RaceCode4 {get;set;}
    public String RaceCode5 {get;set;}
    public String UserCode1 {get;set;}
    public String UserCode2 {get;set;}
    public String UserCode3 {get;set;}
    public String UserCode4 {get;set;}
    public String UserCode5 {get;set;}
    public String UserCode6 {get;set;}
    public String UserCode7 {get;set;}
    public String UserCode8 {get;set;}
    public String UserCode9 {get;set;}
    public String UserCode10 {get;set;}
    public String UserCode11 {get;set;}
    public String UserCode12 {get;set;}
    public String UserCode13 {get;set;}
    public Datetime SchoolEnterDate {get;set;}
    public Datetime SchoolLeaveDate {get;set;}
    public Datetime DistrictEnterDate {get;set;}
    public Integer CounselorNumber {get;set;}
    public String Track {get;set;}
    public String AttendanceProgramCodePrimary {get;set;}
    public String AttendanceProgramCodeAdditional1 {get;set;}
    public String AttendanceProgramCodeAdditional2 {get;set;}
    public String LockerNumber {get;set;}
    public Integer LowSchedulingPeriod {get;set;}
    public Integer HighSchedulingPeriod {get;set;}
    public String InactiveStatusCode {get;set;}
    public Integer FamilyKey {get;set;}
    public String LanguageFluencyCode {get;set;}
    public String HomeLanguageCode {get;set;}
    public String CorrespondanceLanguageCode {get;set;}
    public String ParentEdLevelCode {get;set;}
    public String ParentEmailAddress {get;set;}
    public String StudentEmailAddress {get;set;}
    public String NetworkLoginID {get;set;}
    public String AtRiskPoints {get;set;}
    public String HomeRoomTeacherNumber {get;set;}
    public String NotificationPreferenceCode {get;set;}
    
    public String getAeriesID(){
        return String.valueOf(PermanentID);
    }
    
    public Date getBirthdate(){
        return (Birthdate == null) ? null : Birthdate.date(); //return (Birthdate == null) ? null : ApexUtil.validYearDate(Birthdate.date()) ? Birthdate.date() : null;
    }
    
    public String getGender(){
        if(Sex.equalsIgnoreCase('M'))
            return 'Male';
        else if(Sex.equalsIgnoreCase('F'))
            return 'Female';
        return '';
    }

}