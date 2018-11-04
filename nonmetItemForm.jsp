<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/com/lexken/common/include/common-include.jspf" %>
<script type="text/javascript" src="<c:url value="/validator.do"/>"></script>
<validator:javascript formName="nonmetItemVO" staticJavascript="false" xhtml="true" cdata="false"/>
<script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/fms/EgovMultiFile.js'/>" ></script>
<script type="text/javascript" >
//<![CDATA[

	var J = jQuery;

	J(document).ready(function(){

		/******************************************
		 * 취소버튼 (돌아가기)
		 ******************************************/
		J("#btnBack").click(function() {
			J("#formList").attr("action", "${context_path}/eval/nonmet/nonmetItem/nonmetItemList.do").submit();
		});

		/******************************************
		 * 저장버튼 이벤트
		 ******************************************/
		J("#btnInsert").click(function(e) {
			e.preventDefault();
			saveChk();
		});

		/******************************************
		 * 저장버튼 이중 클릭 방지
		 ******************************************/
		J("form").submit(function(){
			J("#btnInsert").unbind();
		});

		/******************************************
		 * 항목설명 byte 체크
		 ******************************************/
		J("#content").checkbyte({
			indicator:J("#indicator"),
			limit:4000
		});
		J("#content").trigger("keyup");


		/******************************************
        * 숫자만입력받도록처리
        ******************************************/
		J("#weight").css("ime-mode","disabled");
		J("#weight").keyup(function(){
			J(this).val(J(this).val().replace(/[^(0-9)\.]/g,''));
		});

		J("#sortOrder").css("ime-mode","disabled");
		J("#sortOrder").keyup(function(){
			J(this).val(J(this).val().replace(/[^(0-9)\.]/g,''));
		});


	});

	/******************************************
	 * 필수입력 체크
	 ******************************************/
	function saveChk() {
		var form = J("#form1")[0];

		if(!J.checkLength("itemNm", "평가항목명", 1, 200)) {
			return;
		} else if(!J.checkLength("weight", "가중치", 1, 10)) {
			return;
		}


		J.showConfirmBox("저장하시겠습니까?", "saveDo"); //saveDo() 콜백함수 호출
	}

	/******************************************
	 * 저장
	 ******************************************/
	function saveDo() {
		J("#form1").attr("action", "${context_path}/eval/nonmet/nonmetItem/nonmetItemProcess.do").submit();
	}



	/******************************************
	 * 첨부파일 설정
	 ******************************************/
	function makeFileAttachment(){

		 var maxFileNum = 100;
	     if(maxFileNum==null || maxFileNum==""){
	    	 // 첨부파일 한계 갯수
	    	 maxFileNum = 3;
	     }
	     //N이면 첨부불가함
	     fn_egov_check_file('Y');
		 var multi_selector = new MultiSelector( document.getElementById( 'egovComFileList' ), maxFileNum );
		 multi_selector.addElement( document.getElementById( 'egovComFileUploader' ) );

	}

	/******************************************
	 * 첨부파일 다운로드
	******************************************/
	function fn_egov_downFile(atchFileId, fileSn){
		fileDownload("<c:url value='/cmm/fms/FileDown.do?atchFileId="+encodeURIComponent(atchFileId)+"&fileSn="+fileSn+"'/>");
	}

	/******************************************
	 * 첨부파일 화면컨트롤
	******************************************/
	function fn_egov_check_file(flag) {
		if (flag=="Y") {
			document.getElementById('file_upload_posbl').style.display = "block";
			document.getElementById('file_upload_imposbl').style.display = "none";
		} else {
			document.getElementById('file_upload_posbl').style.display = "none";
			document.getElementById('file_upload_imposbl').style.display = "block";
		}
	}

//]]>
</script>
<form:form commandName="dataVO" id="formList" name="formList" method="post" >
 <lexken:makeHidden var="${searchVO.searchKey}" prefix="searchKey."/>
 <lexken:makeHidden var="${searchVO}" filter="find" />
</form:form>
<form:form commandName="dataVO" id="form1" name="form1" method="post" enctype="multipart/form-data" >
 <lexken:makeHidden var="${searchVO.searchKey}" prefix="searchKey."/>
 <lexken:makeHidden var="${searchVO}" filter="find" />
 	<input type="hidden" name="year" 		value="<c:out value="${searchVO.year}"/>" />
	<input type="hidden" name="evalGubun"  value="<c:out value="${searchVO.evalGubun}"/>"/>
	<input type="hidden" name="metricGrpId" value="<c:out value="${searchVO.metricGrpId}"/>"/>
	<input type="hidden" name="itemId" value="<c:out value="${searchVO.itemId}"/>"/>


    <div class="Table">
    	<div class="Table_blockContainer">
    		<div class="tableTop">
			<!-- search S -->
				<div class="searchBox">
    				<div><div><div>
    				<table summary="평가항목관리 조건">
						<caption class="none">평가항목관리 조건<spring:message code="bsc.common.msg.searchCondition" /></caption>
						<thead><tr><th></th></tr></thead>
        				<tbody>
            				<tr>
            					<td class="searchBox_tit">
                			 		<span><spring:message  code="YEAR" /></span>
                			 		<span class="searchBar">
                			 		<c:out value="${searchVO.findYear}"></c:out>
                			 		</span>
                                </td>
                                <%-- 우선 style="display:none;" 평가구분을 숨긴다. --%>
                                <td class="searchBox_tit" style="display:none;">
                                	<span>평가구분</span>
                                	<span class="searchBar">
                                	<c:out value="${codeUtil:getCodeName('150', searchVO.evalGubun)}"></c:out>
                                	</span>
                                </td>
                                <td class="searchBox_tit">
                                	<span><label for="metricGrpId"><spring:message code="METRIC_GRP_NM"></spring:message> </label></span>
                                	<span class="searchBar">
                                	<c:out value="${searchVO.metricGrpNm}"></c:out>
                                	</span>
                                </td>
            				</tr>
        				</tbody>
    				</table>
                    </div></div></div>
    	        </div>
    		<!-- search E -->
    			<div class="clear"></div>
    		</div>
    		<div class="blockDetail">
    			<table summary="비계량평가항목관리 등록">
					<caption class="none">비계량평가항목관리 등록</caption>
    				<colgroup>
    					<col width="15%" />
    					<col width="85%" />
    				</colgroup>
    				<tbody>
    											<tr>
							<th scope="row"><label for="itemNm"><span class="txt_red">(*)</span>평가항목명</label></th>
							<td><form:input path="itemNm" class="inputbox w200" maxlength="66"/><form:errors path="itemNm" class="error"/></td>
						</tr>
						<tr>
							<th scope="row"><label for="weight"><span class="txt_red">(*)</span>평가가중치</label></th>
							<td><form:input path="weight" class="inputbox w200" maxlength="22"/><form:errors path="weight" class="error"/></td>
						</tr>
						<tr>
							<th scope="row"><label for="content">평가설명</label></th>
							<td>
   							<form:textarea path="content" class="tabletext h100"  />
							<br /><span id="indicator">0</span>/4000byte
							</td>
						</tr>
						<tr>
							<th scope="row"><label for="sortOrder">정렬순서</label></th>
							<td><form:input path="sortOrder" class="inputbox w200" maxlength="22"/><form:errors path="sortOrder" class="error"/></td>
						</tr>

    					<%-- <tr>
    						<th scope="row">첨부파일 목록</th>
    						<td>
    							<c:import url="/cmm/fms/selectFileInfsForUpdate.do" charEncoding="utf-8">
									<c:param name="param_atchFileId" value="${dataVO.atchFileId}" />
								</c:import>
							</td>
    					</tr>
    					<tr>
						    <th height="23"><spring:message code="cop.atchFile" /></th>
						    <td>
						    <div id="file_upload_posbl" >
					            <table width="100%" cellspacing="0" cellpadding="0" border="0" align="center">
								    <tr>
								        <td><input name="file_1" id="egovComFileUploader" type="file" title="첨부파일명 입력"/></td>
								    </tr>
								    <tr>
								        <td>
								        	<div id="egovComFileList"></div>
								        </td>
								    </tr>
					   	        </table>
							</div>
							<div id="file_upload_imposbl"  style="display:none;" >
					           <table width="100%" cellspacing="0" cellpadding="0" border="0" align="center">
								    <tr>
								        <td><spring:message code="common.imposbl.fileupload" /></td>
								    </tr>
					   	        </table>
							</div>
							</td>
						  </tr> --%>
    				</tbody>
    			</table>
    		</div>
    		<div class="blockButton">
    			<ul>
    				<li><input type="button" id="btnBack"   value="돌아가기" /></li>
    				<li><input type="submit" id="btnInsert" value="저장" /></li>
    			</ul>
    		</div>
    	</div>
    	<div class="clear"></div>
    </div>
</form:form>
