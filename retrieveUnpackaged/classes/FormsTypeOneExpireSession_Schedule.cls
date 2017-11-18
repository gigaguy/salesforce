global class FormsTypeOneExpireSession_Schedule implements Schedulable {
    global void execute(SchedulableContext SC) {
    	FormsTypeOneExpireSession runSchedule = new FormsTypeOneExpireSession();
        runSchedule.expireSession();
    } // End execute(SchedulableContext SC)
    
}