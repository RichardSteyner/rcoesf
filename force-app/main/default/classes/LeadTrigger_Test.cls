@isTest
public class LeadTrigger_Test {
    static testMethod void testAll_Test() {
       
       MessagingEndUser MessagingEndUserTEST = new MessagingEndUser();
       MessagingEndUserTEST.Name = '+51944935304';
       MessagingEndUserTEST.HasInitialResponseSent = false;
       MessagingEndUserTEST.IsoCountryCode = 'PE';
       MessagingEndUserTEST.MessageType = 'Text';
       MessagingEndUserTEST.MessagingConsentStatus ='ImplicitlyOptedIn';
       MessagingEndUserTEST.MessagingPlatformKey ='+51944935304';
       MessagingEndUserTEST.MessagingChannelId ='0Mj4T000000blhzSAA';
       insert MessagingEndUserTEST;

       MessagingEndUser MessagingEndUserTEST2 = new MessagingEndUser();
       MessagingEndUserTEST2.Name = '+51944935306';
       MessagingEndUserTEST2.HasInitialResponseSent = false;
       MessagingEndUserTEST2.IsoCountryCode = 'PE';
       MessagingEndUserTEST2.MessageType = 'Text';
       MessagingEndUserTEST2.MessagingConsentStatus ='ImplicitlyOptedIn';
       MessagingEndUserTEST2.MessagingPlatformKey ='+51944935306';
       MessagingEndUserTEST2.MessagingChannelId ='0Mj4T000000blhzSAA';
       insert MessagingEndUserTEST2;
       
       Lead myLead = new Lead();
       myLead.FirstName = 'Test sg192084';
       myLead.LastName = 'San Juan'; 
       myLead.Company ='Claudia Garcia';
       myLead.Status = 'New';
       myLead.MobilePhone='+51944935304';
       insert myLead;

       Lead myLead2 = new Lead(Id=myLead.Id);
       ApexUtilFlags.LeadTrigger1=true;
       myLead2.Record_State__c='first automatic edition';
       myLead2.LastName = 'San JuanCho';
       myLead2.MobilePhone='+51944935306';
       update myLead2;

       ApexUtilFlags.LeadTrigger1=true;
       myLead2.Record_State__c='Ready to be Update';
       update myLead2;

       ApexUtilFlags.LeadTrigger1=true;
       myLead2.Record_State__c='Already Update';
       update myLead2;
       
    }
}