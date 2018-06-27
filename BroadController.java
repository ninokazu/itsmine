package kr.co.kbs.plus.admin.introduction.controller;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.co.kbs.plus.admin.introduction.service.BroadService;

@RequestMapping("/admapi/v1/introduction/broad")
@RestController
public class BroadController {
	
	private static Logger logger = LoggerFactory.getLogger(BroadController.class);
	
	private static String sessionUserId = null;

	final static String SESSION_USER_ID = "user_id";
	
	@Autowired
	private BroadService broadService;


	@PostMapping("/insertBroad")
	public Map<String, Object> selectAwards(
			HttpServletRequest request,
			HttpServletResponse response){
		
		Enumeration paramName = request.getParameterNames();

		HashMap<String, Object> param = new HashMap<String, Object>();

		while (paramName.hasMoreElements()) {

			String name = (String)paramName.nextElement();

			param.put(name, request.getParameter(name));

			System.out.println(name + " : " + request.getParameter(name));
		}
		
		if (request.getSession(false) != null) {
			sessionUserId = (String)request.getSession(false).getAttribute(SESSION_USER_ID);
		}
		
		param.put("reg_id", sessionUserId);
		
		return broadService.insertBroad(param, request);
	}
	
	
	@GetMapping("/selectBroad")
	public Map<String, Object> selectBroad(
			HttpServletRequest request,
			HttpServletResponse response){
		
		Enumeration paramName = request.getParameterNames();

		HashMap<String, Object> param = new HashMap<String, Object>();

		while (paramName.hasMoreElements()) {

			String name = (String)paramName.nextElement();

			param.put(name, request.getParameter(name));

			System.out.println(name + " : " + request.getParameter(name));
		}
		
		if (request.getSession(false) != null) {
			sessionUserId = (String)request.getSession(false).getAttribute(SESSION_USER_ID);
		}
		
		param.put("reg_id", sessionUserId);
		
		return broadService.selectBroad(param);
	}
	

	
}
