package jfr.webapp.placeholdermanager.xml;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jfabrix101.ewaf.util.SimpleXMLHelper;
import jfr.webapp.placeholdermanager.bean.PermissionBean;
import jfr.webapp.placeholdermanager.bean.PlaceholderBean;
import jfr.webapp.placeholdermanager.bean.RoleBean;

import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.Element;
import org.simpleframework.xml.ElementList;
import org.simpleframework.xml.ElementMap;
import org.simpleframework.xml.Root;

@Root(name="application")
@SuppressWarnings("all")
public class XmlApplicationDescription {

	public static String VERSION = "1.0";
	
	public @Attribute String version = VERSION;
	
	public @Element String name;
	public @Element(required=false) String description = "";
	public @Element(required=false) String appToken = "";
	
	
	
	@ElementList(required=false, name="roles", entry="role", type=RoleBean.class, inline=false)
	public List<RoleBean> roleList = new ArrayList<RoleBean>();
	
	@ElementList(required=false, name="permissions", entry="permission", type=PermissionBean.class, inline=false)
	public List<PermissionBean> permissionList = new ArrayList<PermissionBean>();
	
	@ElementMap(required=false, keyType=String.class, valueType=String.class, name="profiles", 
			entry="profile", key="roleName", value="permissionName", attribute=true, inline=false)
	public Map<String, String> applicationProfileMap = new HashMap<String, String>();
	
	@ElementList(required=false, name="placeholders", entry="placehoder", type=PlaceholderBean.class, inline=false)
	public List<PlaceholderBean> placeholderList = new ArrayList<PlaceholderBean>();
	
	public static void main(String[] args) {
		XmlApplicationDescription x = new XmlApplicationDescription();
		x.name = "Applicazione di esempio";
		x.description = "descrizione dell'applicazione";
		x.appToken = "1234567890-12345-67890";
		
		x.applicationProfileMap.put("admin", "showConfig");
		x.applicationProfileMap.put("admin", "showData");
		x.applicationProfileMap.put("admin", "removeConfig");
		x.applicationProfileMap.put("admin", "importPDF");
		x.applicationProfileMap.put("developer", "importPDF");
		
		
		
		x.placeholderList.add(new PlaceholderBean("k1", "v1"));
		x.placeholderList.add(new PlaceholderBean("k2", "v2"));
		x.placeholderList.add(new PlaceholderBean("k3", "v3"));
		
		System.out.println(SimpleXMLHelper.toString(x));
		
	}
}
