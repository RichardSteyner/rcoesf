@isTest
public class ContactTrigguer_Test {

    static testMethod void testAll_Test() {

       MessagingEndUser MessagingEndUserTEST = new MessagingEndUser();
       MessagingEndUserTEST.Name = '+51944935404';
       MessagingEndUserTEST.HasInitialResponseSent = false;
       MessagingEndUserTEST.IsoCountryCode = 'PE';
       MessagingEndUserTEST.MessageType = 'Text';
       MessagingEndUserTEST.MessagingConsentStatus ='ImplicitlyOptedIn';
       MessagingEndUserTEST.MessagingPlatformKey ='+51944935404';
       MessagingEndUserTEST.MessagingChannelId ='0Mj4T000000blhzSAA';
       insert MessagingEndUserTEST;

       MessagingEndUser MessagingEndUserTEST2 = new MessagingEndUser();
       MessagingEndUserTEST2.Name = '+51944935405';
       MessagingEndUserTEST2.HasInitialResponseSent = false;
       MessagingEndUserTEST2.IsoCountryCode = 'PE';
       MessagingEndUserTEST2.MessageType = 'Text';
       MessagingEndUserTEST2.MessagingConsentStatus ='ImplicitlyOptedIn';
       MessagingEndUserTEST2.MessagingPlatformKey ='+51944935405';
       MessagingEndUserTEST2.MessagingChannelId ='0Mj4T000000blhzSAA';
       insert MessagingEndUserTEST2;

       Contact myContact = new Contact();
       myContact.FirstName = 'Test sg192084 FirstName 1';
       myContact.LastName = 'Mayte Cirprian';
       myContact.Salutation ='Mr.';
       myContact.MobilePhone='+51944935404';
       insert myContact;

       ApexUtilFlags.contactTrigger1=true;
       Contact myContact2 = new Contact(Id=myContact.Id);
       myContact2.Record_State__c='first automatic edition';
       myContact2.MobilePhone='+51944935405';
       myContact2.FirstName = 'FirstName 1';
       myContact2.LastName = 'Cirprian';
       update myContact2;

       ApexUtilFlags.contactTrigger1=true;
       myContact2.Record_State__c='Ready to be Update';
       update myContact2;

       ApexUtilFlags.contactTrigger1=true;
       myContact2.Record_State__c='Already Update';
       update myContact2;
    }
}