package jfr.webapp.placeholdermanager.bean;

import java.io.Serializable;

import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.Root;

@Root
@SuppressWarnings("all")
public class PlaceholderBean extends Bean implements Serializable{

	public long appId;
  	
	@Attribute(name="name") public String placeholderName;
	@Attribute(name="value") public String placeholderValue;
	@Attribute(name="enabled", required=false) public boolean placeholderEnabled;
	
	public PlaceholderBean() {}
	
	public PlaceholderBean(String name, String value) {
		placeholderName = name;
		placeholderValue = value;
		placeholderEnabled = true;
	}
	
	@Override
	public String toString() {
		return super.toString() + ", key=" + placeholderName + ", value=" + placeholderValue;
	}
	
}
