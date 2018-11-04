<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/com/lexken/common/include/common-include.jspf" %>
<script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/fms/EgovMultiFile.js'/>" ></script>
<script type="text/javascript" >
//<![CDATA[

	var J = jQuery;

	J(document).ready(function(){

		/*
		if(J("#findTemplate").val() == "popup"){
			J(".popView").addClass("w800");
			J("#body").css("overflow-X", "hidden");
		}else{
			J(".popView").removeClass("w800");
		}
		*/
		
		/******************************************
		 * 돌아가기 이벤트
		 ******************************************/
		J("#btnBack").click(function() {
			J("#form1").attr("action","${context_path}/eval/evalReOpinion/evalReOpinionCheck/evalReOpinionCheckList.do").submit();
		});
		
		/******************************************
		 * 저장버튼 이벤트
		 ******************************************/
		J("#btnInsert").click(function(e) {
			e.preventDefault();
			J("#form1 #statusId").val("05");
			saveChk();
		});

		
		/******************************************
		 * 완료버튼 이벤트
		 ******************************************/
		J("#btnOk").click(function(e) {
			e.preventDefault();
			J("#form1 #statusId").val("06");
			saveChk();
		});

		/******************************************
		 * 비고 byte 체크
		 ******************************************/
		J("#chkContent").checkbyte({
			indicator:J("#chkContentIndicator"),
			limit:4000
		});
		J("#chkContent").trigger("keyup");
		
		/******************************************
		 * 버튼 처리
		 ******************************************/
		btnDisable();
	});
	
	/******************************************
	 * 상태값 확인 후 버튼 처리
	 ******************************************/
	function btnDisable(){
		//진행상태 확인
		if('${dataVO.statusId}' == '06'){
			J("#btnInsert").attr("disabled", true).addClass("ui-state-disabled");
			J("#btnOk").attr("disabled", true).addClass("ui-state-disabled");
		}
	}
	
	/******************************************
	 * 필수입력 체크
	 ******************************************/
	function saveChk() {
		
		var reviewResultId = J("input:radio[name='reviewResultId']:checked").val(); 
		
		if( reviewResultId == null && reviewResultId == "" ) {
			J.showMsgBox("수용/미수용을 선택해 주십시오", null, null);
			return;
		}

		J.showConfirmBox("저장하시겠습니까?", "saveDo"); //saveDo() 콜백함수 호출

	}
	
	/******************************************
	 * 저장
	 ******************************************/
	function saveDo(){
		J("#form1").attr("action", "${context_path}/eval/evalReOpinion/evalReOpinionCheck/evalReOpinionCheckProcess.do").submit();
	}

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
		window.location.href = "<c:url value='/cmm/fms/FileDown.do?atchFileId="+encodeURIComponent(atchFileId)+"&fileSn="+fileSn+"'/>"; //window.open("<c:url value='/cmm/fms/FileDown.do?atchFileId="+encodeURIComponent(atchFileId)+"&fileSn="+fileSn+"'/>");
	}
	
	/******************************************
	 * 첨부파일 화면컨트롤
	******************************************/
	function fn_egov_check_file(flag) {

		<c:choose>
			<c:when test="${searchVO.findMode eq 'MOD'}">

				if (flag=="Y") {
					document.getElementById('file_upload_posbl').style.display = "block";
					document.getElementById('file_upload_imposbl').style.display = "none";
				} else {
					document.getElementById('file_upload_posbl').style.display = "none";
					document.getElementById('file_upload_imposbl').style.display = "block";
				}

			</c:when>
			<c:otherwise>
				<c:if test="${searchVO.findMode ne 'MOD'}">
					if (flag=="Y") {
						document.getElementById('file_upload_posbl').style.display = "block";
						document.getElementById('file_upload_imposbl').style.display = "none";
					} else {
						document.getElementById('file_upload_posbl').style.display = "none";
						document.getElementById('file_upload_imposbl').style.display = "block";
					}
				</c:if>
			</c:otherwise>
		</c:choose>
	}



//]]>
</script>
<body id="body">
<form:form commandName="dataVO" id="form1" name="form1" method="post" enctype="multipart/form-data" >
	<lexken:makeHidden var="${searchVO.searchKey}" prefix="searchKey."/>
	<lexken:makeHidden var="${searchVO}" filter="find" />
	<form:hidden path="statusId" />
	<input type="hidden"	id="year"       	name="year"         	value="${dataVO.year}" />
	<input type="hidden"	id="objectionId"       	name="objectionId"         	value="${dataVO.objectionId}" />
	<input type="hidden"	id="scDeptId"       	name="scDeptId"         	value="${sessionScope.loginVO.scDeptId}" />
	<input type="hidden"	id="statusYn"       	name="statusYn"         	value="" />
	<input type="hidden"	id="obejctionTermYn"       	name="obejctionTermYn"         	value="${obejctionTermYn}" />

    <div class="Table">
    	<div class="Table_blockContainer">
    		<div class="tableTop">
    			<div class="searchBox">
                <div><div><div>
                    <table summary="검색조건">
                        <caption class="none">검색조건</caption>
                        <thead><tr><th></th><th></th></tr></thead>
                        <tbody>
                            <tr>
								<td class="searchBox_tit"><spring:message code="YEAR" /> : <span class="searchBar">${searchVO.year}년</span></td>
							</tr>
                        </tbody>
                    </table>
                </div></div></div>
                </div>
    		</div>
    		<div class="blockDetail">
    					<table summary="이의신청 등록">
							<caption class="none">이의신청 등록</caption>
		    				<colgroup>
		    					<col width="15%" />
		    					<col width="85%" />
		    				</colgroup>
		    				<tbody>
		    					<tr>
		    						<th scope="row">이의신청 정보</th>
		    					</tr>
		    					<tr>
									<th scope="row"><label for="objectionTitle">이의신청 제목</label></th>
									<td colspan="8">
										${dataVO.objectionTitle}
									</td>
								</tr>
								<tr>
									<th scope="row"><label for="objectionGubunNm">평가구분</label></th>
									<td colspan="8">
										${dataVO.objectionGubunNm}
									</td>
								</tr>
								<tr>
									<th scope="row" ><label for="scDeptNm">요청부서</label></th>
									<td colspan="2">
										${dataVO.scDeptNm}
									</td>
									<th scope="row" width="70px"><label for="objectionUserNm">요청자</label></th>
									<td colspan="2">
										${dataVO.objectionUserNm}
									</td>
									<th scope="row" width="70px"><label for="objectionDt">신청일</label></th>
									<td colspan="2">
										<fmt:formatDate value="${dataVO.objectionDt}" pattern="YYYY.MM.dd"/>
									</td>
								</tr>
								<tr>
									<th scope="row"><label for="metricNm">지표</label></th>
									<td colspan="8">
										${dataVO.metricNm}
									</td>
								</tr>
								<tr>
									<th scope="row"><label for="objectionContent">이의신청 내용</label></th>
									<td colspan="8">
										${dataVO.objectionContent}
									</td>
								</tr>
	    						<tr>
	    							<th scope="row">파일목록</th>
	    							<td colspan="8">
	    								<c:import url="/cmm/fms/selectFileInfsForUpdate.do" charEncoding="utf-8">
											<c:param name="param_atchFileId" value="${dataVO.objectionAtchFileId}" />
	    								</c:import>
	    							</td>
	    						</tr>
		    				</tbody>
		    			</table>
		    			<br/><br/>
		    			<table summary="이의신청 등록">
							<caption class="none">이의신청 등록</caption>
		    				<colgroup>
		    					<col width="15%" />
		    					<col width="85%" />
		    				</colgroup>
		    				<tbody>
		    					<tr>
		    						<th scope="row">이의신청 검토</th>
		    					</tr>
		    					<tr>
									<th scope="row"><label for="reviewResultId">수용/미수용</label></th>
									<td colspan="8">
										<form:radiobuttons path="reviewResultId" items="${codeUtil:getCodeList('502')}" itemValue="codeId" itemLabel="codeNm" delimiter="&nbsp;&nbsp;&nbsp;&nbsp;"/>
									</td>
								</tr>
								<tr>
									<th scope="row"><label for="reviewContent">검토내용</label></th>
									<td colspan="8">
										<form:textarea path="reviewContent" class="inputbox w1000" rows="5" /><form:errors path="reviewContent" class="error"/>
									</td>
								</tr>
		   						<c:if test="${!dataVO.reviewAtchFileId == null}">
		    						<tr>
		    							<th scope="row">첨부목록</th>
		    							<td>
		    								<c:import url="/cmm/fms/selectFileInfsForUpdate.do" charEncoding="utf-8">
												<c:param name="param_atchFileId" value="${dataVO.reviewAtchFileId}" />
		    								</c:import>
		    							</td>
		    						</tr>
		    					</c:if> 
		    					<tr>
								    <th scope="row">파일첨부</th>
								    <td>
								    <div id="file_upload_posbl">
							            <table width="100%" cellspacing="0" cellpadding="0" border="0" align="center">
										    <tr>
										        <td><input name="파일첨부" id="egovComFileUploader" type="file" title="첨부파일명 입력"/></td>
										    </tr>
										     <tr>
										        <td>
										        	<div id="egovComFileList"></div>
										        </td>
											</tr>
							   	        </table>
									</div>
									<div id="file_upload_imposbl">
							            <table width="100%" cellspacing="0" cellpadding="0" border="0" align="center">
										    <tr>
										        <td><spring:message code="common.imposbl.fileupload" /></td>
										    </tr>
							   	        </table>
									</div>
									</td>
							    </tr>
		    				</tbody>
		    			</table>
		    			<div class="h10"></div>
		    			<div class="blockButton">
			    			<ul class="">
								<li><input type="button" id="btnBack" value="돌아가기" /></li>
								<li><input type="button" id="btnInsert" value="저장" /></li>
								<li><input type="button" id="btnOk" value="완료" /></li>
			    			</ul>
			    		</div>
			    		
    		</div>
    	</div>
    	<div class="clear"></div>
    </div>
    <div class="h20"></div>
    </form:form>
</body>