package com.lexken.eval.evalReOpinion.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.lexken.eval.evalReOpinion.service.EvalReOpinionService;
import com.lexken.eval.evalReOpinion.service.EvalReOpinionVO;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.rte.fdl.cmmn.AbstractServiceImpl;

@Service
public class EvalReOpinionServiceImpl extends AbstractServiceImpl implements EvalReOpinionService {
	
	@Resource
	private EvalReOpinionDAO evalReOpinionDAO;
	
	@Resource(name="egovMessageSource")
	EgovMessageSource egovMessageSource;

	/**
	 * 이의신청기간 조회
	 */
	public EvalReOpinionVO selectDetail(EvalReOpinionVO searchVO) throws Exception {
		EvalReOpinionVO resultVO = evalReOpinionDAO.selectDetail(searchVO);
		return resultVO;
	}

	/**
	 * 이의신청기간 목록을 조회  
	 */
	public List selectList(EvalReOpinionVO searchVO) throws Exception {
		return evalReOpinionDAO.selectList(searchVO);
	}

	/**
	 * 이의신청기간 전체목록 카운트
	 */
	public int selectAllRecords(EvalReOpinionVO searchVO) {
		return evalReOpinionDAO.selectAllRecords(searchVO);
	}

	/**
	 * 이의신청기간 페이징목록을 조회
	 */
	public List selectPagingList(EvalReOpinionVO searchVO) {
		return evalReOpinionDAO.selectPagingList(searchVO);
	}


	public int selectListCnt(EvalReOpinionVO searchVO) {
		return evalReOpinionDAO.selectListCnt(searchVO);
	}

	/**
	 * 이의신청기간 등록
	 */
	public String insertData(EvalReOpinionVO dataVO) throws Exception {
		
		/*//중복된 데이터가 있는지 확인
		String findYear = dataVO.getFindYear();
		dataVO.setFindYear(dataVO.getYear());
		EvalReOpinionVO resultVO = evalReOpinionDAO.selectDetail(dataVO);
		
		//중복된 데이터가 있으면 오류 처리
		if(resultVO != null)
			throw processException("info.dupdata.msg2",new String[]{egovMessageSource.getMessage("bsc.common.msg.inputYear")});
		dataVO.setFindYear(findYear);*/
		
		String objectionGubunId = dataVO.getObjectionGubunId();
		dataVO.setObjectionGubunId(dataVO.getObjectionGubunId());
		EvalReOpinionVO resultVO = evalReOpinionDAO.selectDetail(dataVO);
		
		if(resultVO != null)
			throw processException("info.dupdata.msg2",new String[]{egovMessageSource.getMessage("bsc.common.msg.inputYear")});
		dataVO.setObjectionGubunId(objectionGubunId);
		
		evalReOpinionDAO.insertData(dataVO);
		return null;
	}
	
    /**
	 * 이의신청기간 수정
	 */
	public void updateData(EvalReOpinionVO dataVO) throws Exception {
		evalReOpinionDAO.updateData(dataVO);
	}

    /**
	 * 이의신청기간 삭제
	 */
	public void deleteData(EvalReOpinionVO dataVO) throws Exception {
		evalReOpinionDAO.deleteData(dataVO);
	}
                      
    /**
     * 이의신청기간 목록삭제
     */
	public void deleteDataByList(EvalReOpinionVO dataVO) throws Exception {
		String[] years = dataVO.getYears().split("\\|");
		String[] objectionGubunIds = dataVO.getGubunIds().split("\\|");
		
		for (int i = 0; i < years.length; i++) {
			if(years[i] !=null && !"".equals(years[i])){
				if(objectionGubunIds[i]!=null && !"".equals(objectionGubunIds[i])){
					
					dataVO.setYear(years[i]);
					dataVO.setObjectionGubunId(objectionGubunIds[i]);
					evalReOpinionDAO.deleteData(dataVO);
					
				}
			}
		}
	}

}
