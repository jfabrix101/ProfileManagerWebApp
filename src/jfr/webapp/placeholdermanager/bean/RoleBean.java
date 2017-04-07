package jfr.webapp.placeholdermanager.bean;

import java.io.Serializable;

import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.Root;

@SuppressWarnings("all")
@Root
public class RoleBean extends Bean implements Serializable{

	public long appId;
  	@Attribute(name="name") public String roleName = "";
  	@Attribute(name="description", required=false) public String roleDescription;
	
	@Override
	public String toString() {
		return super.toString() + ", roleName=" + roleName + ", description=" + roleDescription;
	}
	
}
