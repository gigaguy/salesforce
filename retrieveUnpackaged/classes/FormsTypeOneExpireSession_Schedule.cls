global class FormsTypeOneExpireSession_Schedule implements Schedulable {
	global void execute(SchedulableContext sc) {
        database.executeBatch(new FormsTypeOneExpireSession());
	}
}