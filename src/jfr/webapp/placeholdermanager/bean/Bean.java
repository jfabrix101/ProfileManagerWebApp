package jfr.webapp.placeholdermanager.bean;

import java.io.Serializable;
import java.util.Date;

@SuppressWarnings("all")
public abstract class Bean implements Serializable {

	public long id;
	public long tmsInsert;
	public long tmsUpdate;
	
	public long getId() { return id; }
	public void setId(long id) { this.id = id; }
	public long getTmsInsert() { return tmsInsert; 	}
	public void setTmsInsert(long tmsInsert) { this.tmsInsert = tmsInsert; }
	public long getTmsUpdate() { return tmsUpdate; }
	public void setTmsUpdate(long tmsUpdate) { this.tmsUpdate = tmsUpdate; }
	
	public Date getTmsInsertAsDate() { return new Date(tmsInsert); }
	public Date getTmsUpdateAsDate() { return new Date(tmsUpdate); }
	
	@Override
	public String toString() {
		return getClass().getName() + ": Id=" + id;
	}
	
	
}
