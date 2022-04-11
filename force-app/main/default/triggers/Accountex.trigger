trigger Accountex on Account (before insert) {
    if(trigger.isbefore){
        System.debug('Account data--'+trigger.new);
    }
}