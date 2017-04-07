package jfr.webapp.placeholdermanager.bean;

import java.io.Serializable;

@SuppressWarnings("all")
public class ApplicationBean extends Bean implements Serializable{

	public String appName;
	public String appDescription;
	public String appToken;
	
	@Override
	public String toString() {
		return super.toString() + ", appName=" + appName + ", appDescription=" + appDescription;
	}
	
}
