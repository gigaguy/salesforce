public class RevokeLicense
{@future
public static void revoke(Id myid)
{
User u = [Select id, isActive from User where id =:myid];
u.isActive = false;
update u;
}     
}