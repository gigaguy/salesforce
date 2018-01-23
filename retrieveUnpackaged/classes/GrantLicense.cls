public class GrantLicense
{@future
public static void grant(Id myid)
{
User u = [Select id, isActive from User where id =:myid];
u.isActive = true;
update u;
}     
}