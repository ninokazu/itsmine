package kr.co.kbs.plus.admin.introduction.mapper;

import java.util.HashMap;
import java.util.List;

public interface BroadMapper {
	
	
	public long broadInsert(HashMap<String, Object> param) throws Exception;
	public HashMap<String, Object> broadSelect(HashMap<String, Object> param) throws Exception;
	public long broadUpdate(HashMap<String, Object> param) throws Exception;
	
	public List<HashMap<String, Object>> broadCodeSelect(HashMap<String, Object> param) throws Exception;
	
	public long broadFileInsert(HashMap<String, Object> param) throws Exception;
	public List<HashMap<String, Object>> broadFileSelect(HashMap<String, Object> param) throws Exception;
	public long broadFileUpdate(HashMap<String, Object> param) throws Exception;
	
	public long broadSubInsert(HashMap<String, Object> param) throws Exception;
	public List<HashMap<String, Object>> broadSubSelect(HashMap<String, Object> param) throws Exception;
	public long broadSubUpdate(HashMap<String, Object> param) throws Exception;
	
}
