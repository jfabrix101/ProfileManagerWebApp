package jfr.webapp.placeholdermanager.bean;

import java.io.Serializable;

import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.Root;

@SuppressWarnings("all")
@Root(name="permission")
public class PermissionBean extends Bean implements Serializable{

	public long appId;
  	@Attribute(name="name") public String permissionName = "";
  	@Attribute(name="description", required=false) public String permissionDesc = "";
	
	@Override
	public String toString() {
		return super.toString() + ", permissionName=" + permissionName + ", desc=" + permissionDesc;
	}
	
}
