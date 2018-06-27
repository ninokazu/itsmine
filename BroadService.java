package kr.co.kbs.plus.admin.introduction.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.kbs.plus.admin.config.RoutingContext;
import kr.co.kbs.plus.admin.introduction.mapper.BroadMapper;
import kr.co.kbs.plus.admin.service.NbroadAwsService;
import kr.co.kbs.plus.admin.vo.MapVo;

@Service
public class BroadService {
	
	@Autowired
	private BroadMapper broadMapper;
	
	@Autowired
	private NbroadAwsService nbroadAwsService;

	@Transactional
	public HashMap<String,Object> insertBroad(HashMap<String, Object> param, HttpServletRequest request) {
		
		RoutingContext.setRouterId("introduce");
		
		MapVo res = new MapVo();
		
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest)request;
		
		try {
			
			broadMapper.broadUpdate(param);
			broadMapper.broadFileUpdate(param);
			broadMapper.broadSubUpdate(param);
			
			broadMapper.broadInsert(param);
			
			if("N".equals(param.get("division")) || "D".equals(param.get("division")) || "E".equals(param.get("division")) || "R".equals(param.get("division"))){
				List<HashMap<String, Object>> broadCodeSelect = new ArrayList<HashMap<String, Object>>();
				broadCodeSelect = broadMapper.broadCodeSelect(param);
				for(int i=0;i<broadCodeSelect.size();i++){
					HashMap<String, Object> broadCodeSelectMap = broadCodeSelect.get(i);
					param.put("code", broadCodeSelectMap.get("code"));
					for(int j=0;j<2;j++){
						String device = j==0? "P":"M";
						param.put("device", device);
						for(int k=1;k<=Integer.parseInt(broadCodeSelectMap.get("image_num").toString());k++ ){
							String fileName = broadCodeSelectMap.get("division")+"_"+broadCodeSelectMap.get("code")+"_"+device+"_"+k;
							param.put("param_name", fileName);
							MultipartFile multipartFile = null;
							multipartFile = multipartRequest.getFile(fileName);
							if (multipartFile != null) {
								HashMap<String, Object> img  = nbroadAwsService.uploadFile(multipartFile, "admin");
								param.put("file_name", img.get("upload_file_name"));
								param.put("file_url", img.get("file_path"));
								
								broadMapper.broadFileInsert(param);
							}else{
								if(null!=param.get(fileName+"_name") && null!=param.get(fileName+"_url")){
									param.put("file_name", param.get(fileName+"_name"));
									param.put("file_url", param.get(fileName+"_url"));
									
									broadMapper.broadFileInsert(param);
								}
							}
						}
					}
				}
			}
			if("S".equals(param.get("division")) || "C".equals(param.get("division")) || "E".equals(param.get("division"))){
				String params = param.get("params").toString();
				ObjectMapper mapper = new ObjectMapper();
				JsonNode broadList = mapper.readTree(params);
				
				int chkNum = 1;
				for (JsonNode broad : broadList) {
					HashMap<String, Object> broadMap = new HashMap<String,Object>();
					broadMap.put("division", param.get("division"));
					broadMap.put("reg_id", param.get("reg_id"));
					broadMap.put("year", null!=broad.get("year")?broad.get("year").asText():null);
					broadMap.put("title_e", null!=broad.get("title_e")?broad.get("title_e").asText():null);
					broadMap.put("title_k", null!=broad.get("title_k")?broad.get("title_k").asText():null);
					broadMap.put("introduce_e", null!=broad.get("introduce_e")?broad.get("introduce_e").asText():null);
					broadMap.put("introduce_k", null!=broad.get("introduce_k")?broad.get("introduce_k").asText():null);
					broadMap.put("broad_time", null!=broad.get("broad_time")?broad.get("broad_time").asText():null);
					for(int j=0;j<2;j++){
						String device = j==0? "pc_":"mobile_";
						String fileName = device+chkNum;
						MultipartFile multipartFile = null;
						multipartFile = multipartRequest.getFile(fileName);
						if (multipartFile != null) {
							HashMap<String, Object> img = nbroadAwsService.uploadFile(multipartFile, "admin");
							broadMap.put("thumbnail_"+device+"name", img.get("upload_file_name"));
							broadMap.put("thumbnail_"+device+"url", img.get("file_path"));
						}else{
							if(null!=broad.get("thumbnail_"+device+"name") && null!=broad.get("thumbnail_"+device+"url")){
								broadMap.put("thumbnail_"+device+"name", broad.get("thumbnail_"+device+"name").asText());
								broadMap.put("thumbnail_"+device+"url", broad.get("thumbnail_"+device+"url").asText());
							}
						}
					}
					broadMapper.broadSubInsert(broadMap);
					chkNum++;
				}
				
				
			}
			
			res.put("rtn_code", 0);
			res.put("rtn_msg", "OK");
			
		} catch (Exception e) {
			e.printStackTrace();
			res.put("rtn_code", -1);
			res.put("rtn_msg", "FAIL : " + e.getMessage());
		}finally{
			RoutingContext.clearRouterId();
		}
		
		return res;
		
	}

	
	public HashMap<String,Object> selectBroad(HashMap<String, Object> param) {
		
		RoutingContext.setRouterId("introduce");
		
		MapVo res = new MapVo();
		
		HashMap<String, Object> data = new HashMap<String,Object>();
		HashMap<String, Object> broadcast = new HashMap<String,Object>();
		
		try {
			
			HashMap<String, Object> broadSelect = broadMapper.broadSelect(param);
			System.out.println("broadSelect>>>>" + broadSelect);
			if(null!=broadSelect){
				
				if("N".equals(param.get("division")) || "D".equals(param.get("division")) || "E".equals(param.get("division")) || "R".equals(param.get("division"))){
					data.put("standard_date", broadSelect.get("standard_date"));
					List<HashMap<String, Object>> broadFileSelect = broadMapper.broadFileSelect(param);
					
					for(int i=0;i<broadFileSelect.size();i++){
						HashMap<String, Object> broadFileSelectMap = broadFileSelect.get(i);
						broadcast.put(broadFileSelectMap.get("param_name").toString()+"_url", broadFileSelectMap.get("file_url").toString());
						broadcast.put(broadFileSelectMap.get("param_name").toString()+"_name", broadFileSelectMap.get("file_name").toString());
					}
					data.put("broadcast", broadcast);
					
				}
				if("S".equals(param.get("division")) || "C".equals(param.get("division")) || "E".equals(param.get("division"))){
					data.put("standard_date", broadSelect.get("standard_date"));
					List<HashMap<String, Object>> broadFileSelect = broadMapper.broadSubSelect(param);
					data.put("broadcastArr", broadFileSelect);
				}
			}else{
				res.put("rtn_code", 0);
				res.put("rtn_msg", "EMPTY DATA");
				return res;
			}
			
			res.put("data", data);
			res.put("rtn_code", 0);
			res.put("rtn_msg", "OK");
			
		} catch (Exception e) {
			e.printStackTrace();
			res.put("rtn_code", -1);
			res.put("rtn_msg", "FAIL : " + e.getMessage());
		}finally{
			RoutingContext.clearRouterId();
		}
		
		return res;
		
	}


}
