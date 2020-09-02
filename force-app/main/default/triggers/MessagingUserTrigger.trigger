trigger MessagingUserTrigger on MessagingEndUser (before insert, before update, after insert, after update) {
   if(trigger.isBefore){
 	}else {
         if(trigger.isInsert){
         }
     }
}