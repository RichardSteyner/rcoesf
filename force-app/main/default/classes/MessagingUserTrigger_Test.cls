@isTest
public class MessagingUserTrigger_Test {
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
    }
}