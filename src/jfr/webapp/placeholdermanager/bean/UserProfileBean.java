package jfr.webapp.placeholdermanager.bean;

import java.io.Serializable;

@SuppressWarnings("all")
public class UserProfileBean extends Bean implements Serializable{

	public long appId;
	public long roleId;
  	public String userName, fullName, email;
  	
  	public String roleName;
  	
	
	@Override
	public String toString() {
		return super.toString() + ", userName=" + userName + ", roleId=" + roleId;
	}
	
}
