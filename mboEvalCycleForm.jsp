<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/com/lexken/common/include/common-include.jspf" %>
<script type="text/javascript" src="<c:url value="/validator.do"/>"></script>
<validator:javascript formName="mboEvalCycleVO" staticJavascript="false" xhtml="true" cdata="false"/>
<script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/fms/EgovMultiFile.js'/>" ></script>
<script type="text/javascript" >
//<![CDATA[

	var J = jQuery;

	J(document).ready(function(){


		/******************************************
		 * 수정폼일 경우 평가상세과제구분 체크박스 적용
		 ******************************************/
		 if("${searchVO.findMode}"=="MOD"){
			J("input:checkbox[name=detailSubjectGubun]").each(function(){
				<c:forEach items="${detailSubjectGubunList}" var="item">
					if(J(this).val()=="${item.detailSubjectGubun}"){
						J(this).attr("checked", true);
					}
				</c:forEach>
			});
		 }

		/******************************************
		 * 평가시작종료일자 클릭시 달력팝업 이벤트
		 ******************************************/
		J("#evalStartDt").datepicker({
			dateFormat: 'yy.mm.dd'
		});
		J("#evalEndDt").datepicker({
			dateFormat: 'yy.mm.dd'
		});

		/******************************************
		 * 평가시작일  change 이벤트
		 ******************************************/
		J("#evalStartDt").change(function() {
			if(J("#evalStartDt").val() == "" || J("#evalStartDt").val() >= J("#evalEndDt").val()){
			J("#evalEndDt").val(J("#evalStartDt").val());
			}
		});

		var form = J("#form1")[0];
		if(J(form.findMode).val() == "MOD" ){
			J(form.evalStartDt).attr("disabled", false);
			J(form.evalEndDt).attr("disabled", false);
			J(form.evalStartDt).removeClass("disable");
			J(form.evalEndDt).removeClass("disable");
		}
		/******************************************
		 * 취소버튼 (돌아가기)
		 ******************************************/
		J("#btnBack").click(function() {
			J("#form1").attr("action", "${context_path}/prs/eval/mboEvalCycle/mboEvalCycleList.do").submit();
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
		 * 정렬순서 ctrl + v 방지, 숫자만 입력
		 ******************************************/
		J("#sortOrder").bind('paste',function(e){
			return false;
		});
		J("#sortOrder").numericOnly();

		J("#weight").numericOnly({allow:"."});
		J("#weight").css("ime-mode", "disabled");
		J("#weight").bind("paste", function(e){
			return false;
		});
		J("#evalStartDt").bind('paste keydown keypress keyup',function(e){
			return false;
		});
		J("#evalEndDt").bind('paste keydown keypress keyup',function(e){
			return false;
		});

		/******************************************
		 * 평가주기에 평가단이 속해있을 경우 사용여부 비활성화
		 ******************************************/
		if("${dataVO.findUseYn}" == "Y" && "${dataVO.mboEvalUnitCnt}" != "0"){
			 J("#findUseYn").attr("disabled", true).attr("class", "select w210 readonly");
		}

	});

	/******************************************
	 * 필수입력 체크
	 ******************************************/
	function saveChk() {
		var form = J("#form1")[0];

		if(!validateMboEvalCycleVO(form)){
			return;
		}

		var evalStartDt = J("#evalStartDt").val();
        var evalEndDt = J("#evalEndDt").val();
		if(!comparePeriod2(evalStartDt,evalEndDt,"평가 시작일","평가 종료일")){
            J("#evalEndDt").focus();
            return;
        }

		if(J("input:checkbox[name=detailSubjectGubun]:checked").length<1){
			J.showMsgBox("평가대상 상세과제구분 선택은 필수입니다.");
			return;
		}

		J.showConfirmBox("저장하시겠습니까?", "saveDo"); //saveDo() 콜백함수 호출
	}

	/******************************************
	 * 저장
	 ******************************************/
	function saveDo() {
		J("#findUseYn").attr("disabled", false);
		J("#form1").attr("action", "${context_path}/prs/eval/mboEvalCycle/mboEvalCycleProcess.do").submit();
	}

	/******************************************
	 * 두 날짜 비교하여 결과를 리턴
	 ******************************************/
	function comparePeriod2(fromValue, toValue, fromName, toName){
		if(fromValue == "" || toValue == "") return true;
		var del = /[^(0-9)]/gi;
		var fromDate = Number(fromValue.replace(del,""));
		var toDate = Number(toValue.replace(del,""));
		var msg;

		if (fromDate > toDate) {
			msg = "[" + fromName + "] 보다  [" + toName + "] 이 빠를 수 없습니다..";
			alert(msg);
			return false;
		}

		return true;
	}


//]]>
</script>
<form:form commandName="dataVO" id="formList" name="formList" method="post" >
 <lexken:makeHidden var="${searchVO.searchKey}" prefix="searchKey."/>
 <lexken:makeHidden var="${searchVO}" filter="find" />
</form:form>
<form:form commandName="dataVO" id="form1" name="form1" method="post">
 <lexken:makeHidden var="${searchVO.searchKey}" prefix="searchKey."/>
 <lexken:makeHidden var="${searchVO}" filter="find" exclude="findUseYn" />
 	<form:hidden path="year" />
	<input type="hidden" id="evalMboGrpId" name="evalMboGrpId" value="${searchVO.evalMboGrpId}" />
	<form:hidden path="evalCycleId" />

    <div class="Table">
    	<div class="Table_blockContainer">
    		<div class="tableTop">
    		    <!-- 검색 테이블 Start -->
                <div class="searchBox">
	                <div><div><div>
	                    <table summary="검색조건">
	                        <caption class="none">검색조건</caption>
	                        <thead><tr><th></th><th></th></tr></thead>
	                        <tbody>
	                            <tr>
		                        	<td class="searchBox_tit">기준년도 : <span class="searchBar"><c:out value="${searchVO.findYear}" />년</span></td>
		                     		<td class="searchBox_tit">MBO실적평가군 : <span class="searchBar"><c:out value="${mboEvalGrpData.evalMboGrpNm}" /></span></td>
	                     		</tr>
	                        </tbody>
	                    </table>
	                </div></div></div>
                </div>
    			<div class="clear"></div>
    		</div>
    		<div class="blockDetail">
    			<table summary="MBO평가주기 등록">
					<caption class="none">MBO평가주기 등록</caption>
    				<colgroup>
    					<col width="15%" />
    					<col width="35%" />
    					<col width="15%" />
    					<col width="35%" />
    				</colgroup>
    				<tbody>
    					<tr>
							<th scope="row"><span class="txt_red">(*)</span><label for="evalCycleNm">평가주기</label></th>
							<td colspan="3"><form:input path="evalCycleNm" class="inputbox w200" maxlength="66"/><form:errors path="evalCycleNm" class="error"/></td>
						</tr>
						<tr>
							<th scope="row"><label for="evalMon">평가월</label></th>
							<td colspan="3">
								<form:select path="evalMon" >
									<form:options items="${codeUtil:getCodeList('024')}"  itemLabel="codeNm"  itemValue="codeId"/>
								</form:select>
							</td>
						</tr>
						<tr>
							<th scope="row"><span class="txt_red">(*)</span><label for="evalStartDt">평가시작일</label></th>
							<td>
								<form:input path="evalStartDt" class="inputbox w200" maxlength="10"/><form:errors path="evalStartDt" class="error"/>
							</td>
							<th scope="row"><span class="txt_red">(*)</span><label for="evalEndDt">평가종료일</label></th>
							<td>
								<form:input path="evalEndDt" class="inputbox w200" maxlength="10"/><form:errors path="evalEndDt" class="error"/>
							</td>
						</tr>
						<tr>
							<th scope="row"><span class="txt_red">(*)</span><label for="weight">가중치</label></th>
							<td colspan="3"><form:input path="weight" class="inputbox w200" maxlength="5"/><form:errors path="weight" class="error"/></td>
						</tr>
						<tr>
							<th scope="row"><span class="txt_red">(*)</span><label for="sortOrder">정렬순서</label></th>
							<td colspan="3"><form:input path="sortOrder" class="inputbox w200" maxlength="5"/><form:errors path="sortOrder" class="error"/></td>
						</tr>
						<tr>
							<th scope="row"><label for="findUseYn">사용여부</label></th>
							<td colspan="3">
    							<form:select path="findUseYn" class="select w210" items="${codeUtil:getCodeList('011')}"  itemLabel="codeNm"  itemValue="codeId">
    							</form:select>
    						</td>
						</tr>
						<tr>
							<th scope="row"><span class="txt_red">(*)</span><label for="detailSubjectGubun">평가대상 상세과제구분</label></th>
							<td colspan="3">
    							<form:checkboxes path="" name="detailSubjectGubun" items="${codeUtil:getCodeList('316')}"  itemLabel="codeNm"  itemValue="codeId" delimiter="&nbsp;&nbsp;&nbsp;"/>
    						</td>
						</tr>
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
