<%
/*************************************************************************
* CLASS 명      : mboEvalCycleList
* 작 업 자      : 양도경
* 작 업 일      : 2014년 11월 18일
* 기    능      : MBO평가주기
* ---------------------------- 변 경 이 력 --------------------------------
* 번호    작 업 자     작   업   일       변 경 내 용           비  고
* ----  --------  -----------------  -------------------------  -----------
*  1     양도경      2014년 11월 18일             최 초 작 업
**************************************************************************/
%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/com/lexken/common/include/common-include.jspf" %>
<script type="text/javascript">
//<![CDATA[


	var J = jQuery;

	J(document).ready(function(){

		/******************************************
		 * 데이터 그리드 출력
		 ******************************************/
		var str = J('#formFind').serialize();

		jQuery("#list").jqGrid({
			url          :"${context_path}/prs/eval/mboEvalCycle/mboEvalCycleList_json.do" + "?" + str,
			mtype        :"POST",
			datatype     :"json",
			jsonReader   : {
    						page   : "page",
    						total  : "total",
    						root   : "rows",
    						records: "records",
    						repeatitems: false,
                            id     : "id"
    				       },
	        height       : "${jqGrid_height}",
			width        : "${jqGrid_width}",
			colModel     :[
							{name:'year'                 ,index:'year'                 ,width:100   ,align:'center' ,hidden:true ,title:true ,label:'기준년도'},
                            {name:'evalMboGrpId'         ,index:'evalMboGrpId'         ,width:100   ,align:'center' ,hidden:true ,title:true ,label:'실적평가군코드'},
                            {name:'evalCycleId'          ,index:'evalCycleId'          ,width:100   ,align:'center' ,hidden:true ,title:false ,label:'평가주기코드'},
                            {name:'evalCycleNm'          ,index:'evalCycleNm'          ,width:200   ,align:'left' ,hidden:false ,title:true ,label:'평가주기',formatter:linkUpdate},
                            {name:'evalMon'              ,index:'evalMon'              ,width:100   ,align:'center' ,hidden:false ,title:true ,label:'평가월',formatter:linkConcat},
                            {name:'evalStartDt'          ,index:'evalStartDt'          ,width:100   ,align:'center' ,hidden:false ,title:true ,label:'평가시작일'},
                            {name:'evalEndDt'            ,index:'evalEndDt'            ,width:100   ,align:'center' ,hidden:false ,title:true ,label:'평가종료일'},
                            {name:'mboEvalUserCnt'       ,index:'mboEvalUserCnt'       ,width:80   ,align:'center' ,hidden:false ,title:true ,label:'평가대상자',formatter:linkMboEvalUserList},
                            {name:'mboEvalUnitCnt'       ,index:'mboEvalUnitCnt'       ,width:100   ,align:'center' ,hidden:false ,title:true ,label:'평가단',formatter:linkMboEvalMemberGrpList},
                            {name:'weight'               ,index:'weight'               ,width:100   ,align:'center' ,hidden:false ,title:true ,label:'가중치',formatter:linkWeight},
                            {name:'weightSum'            ,index:'weightSum'            ,width:100   ,align:'center' ,hidden:false ,title:true ,label:'가중치합'},
                            {name:'sortOrder'            ,index:'sortOrder'            ,width:100   ,align:'center' ,hidden:false ,title:true ,label:'정렬순서',formatter:linkSort}
							],
			rowNum       : "${jqGrid_rownum}",
			autowidth    : false,
			viewrecords  : true,
			loadonce     : true,
			multiselect  : true,
			cellEdit     : true,
			caption:"MBO평가주기",
			loadComplete : function(){
				/******************************************
				 * 정렬순서 ctrl + v 방지, 숫자만 입력
				 ******************************************/
				J("input[name=sortOrders]").bind('paste',function(e){
					return false;
				});
				J("input[name=sortOrders]").numericOnly();

				J("input[name=weights]").bind('paste',function(e){
					return false;
				});
				J("input[name=weights]").numericOnly({allow:"."});
				J("input[name=weights]").css("ime-mode", "disabled");

				/******************************************
				 * 가중치합 셀 병합
				 ******************************************/
				J("#list").rowspan("list", 11, 11);

				/******************************************
				 * 가중치합 값 적용
				 ******************************************/
				J("#"+1).find('td').eq('11').html(weightSum); // jqGrid 첫번째 로우의 11번째 셀인 weightSum에 합산한 값을 넣는다
			}
		}).setGridWidth("${jqGrid_width}");
		
		/******************************************
		 * fancybox 설정
		 ******************************************/
		J("#anchor").fancybox();

		/******************************************
		 * 취소버튼 (돌아가기)
		 ******************************************/
		J("#btnBack").click(function() {
			J("#formList").attr("action", "${context_path}/prs/eval/mboEvalGrp/mboEvalGrpList.do").submit();
		});
		
		/******************************************
		 * 복사버튼
		 ******************************************/
		J("#btnCopy").click(function() {
			popMboEvalCopyList();
		});

		/******************************************
		 * 조회
		 ******************************************/
		J("#formFind").submit(function(event) {
		});

		/******************************************
		 * 일괄저장 버튼 클릭 이벤트
		 ******************************************/
		J("#btnModify").click(function() {
			goAllModify();
			return false;
		});

		/******************************************
		 * 신규 등록
		 ******************************************/
		J("#btnInsert").click(function() {
			var form = J("#formList")[0];
			J(form.findMode).val("ADD");
			J("#formList").attr("action", "${context_path}/prs/eval/mboEvalCycle/mboEvalCycleForm.do").submit();
		});

		/******************************************
		 * 삭제 버튼 클릭 이벤트
		 ******************************************/
		J("#btnDelete").click(function() {
			goDelete();
			return false;
		});

		/******************************************
		 * 엑셀 다운로드 이벤트
		 ******************************************/
		J("#btnExcelDown").click(function() {
			excelDownload();
			return false;
		});

	});

	/******************************************
	 * 평가주기 복사팝업
	 ******************************************/
	function popMboEvalCopyList() {
		var evalCycleId = "";
		if(!J.gridSelectChk("list")){
			J.showMsgBox("복사할 데이터를 선택하십시요", null, null);
		}else{
			if(J("#list input:checkbox:checked").length>1){
				J.showMsgBox("평가주기는 1개만 선택 가능합니다.", null, null);
			}else{
				J("#anchor").attr("href","${context_path}/prs/eval/mboEvalCycle/popCopyList.do");
				J("#anchor").click();
			}
		}
	}

	/******************************************
	 * 평가주기 복사팝업에서 복사 실행시
	 ******************************************/
	function copyDo(copyEvalCycleId, copyEvalMboGrpId){

		J.fancybox.close();

		var form = J("#formList")[0];
		J("#copyEvalCycleId").val(copyEvalCycleId);
		J("#copyEvalMboGrpId").val(copyEvalMboGrpId);
		
		var evalCycleId = "";
		var ids = J("#list").jqGrid('getDataIDs');
		J("#list input:checkbox").each(function(index) {
			if(J(this).is(":checked")==true){
				var rowdata = J("#list").getRowData(ids[index]);
				evalCycleId = rowdata.evalCycleId;
			}
		});
		J("#evalCycleId").val(evalCycleId);
		J(form.findMode).val("COPY");
		
		J("#formList").attr("action","${context_path}/prs/eval/mboEvalCycle/mboEvalCycleProcess.do").submit();
	}

	/******************************************
	 * 평가월 문자열 붙이기
	 ******************************************/
	function linkConcat(cellvalue, options, rowObject) {
		if(cellvalue==null){
			cellvalue="";
		}
		cellvalue = cellvalue += "월";
		return cellvalue;
	}

	/******************************************
	 * 가중치 input 처리
	 ******************************************/
	var weightSum = 0;
	function linkWeight(cellvalue, options, rowObject) {
		var str = '';
		if(cellvalue==null){
			cellvalue="";
		}
		weightSum += parseInt(cellvalue);
		str += '<input type="text"  name="weights" value="' + cellvalue + '" class="inputboxNum w50 textRight" maxlength="5" />';
		return str;
	}

	/******************************************
	 * jqGrid 정렬순서
	 ******************************************/
	function linkSort(cellvalue, options, rowObject) {
		var str = '';
		if(cellvalue==null){
			cellvalue="";
		}
		str += '<input type="text"  name="sortOrders" value="' + cellvalue + '" class="inputboxNum w50 textRight" maxlength="5" />';
		return str;
	}

	/******************************************
	 * 평가대상자 목록 링크
	 ******************************************/
	function linkMboEvalUserList(cellvalue, options, rowObject) {
		return '<a href=javascript:goMboEvalUserList(' + options.rowId + ')>' + cellvalue + '</a>';
	}

	/******************************************
	 * 평가대상자 목록
	 ******************************************/
	function goMboEvalUserList(rowId){
		var form = J("#formList")[0];
		J(form.findUseYn).val(J("#findUseYn").val());
		var ret = J("#list").jqGrid('getRowData',rowId);
		J("#evalMboGrpId").val(ret.evalMboGrpId);
		J("#evalCycleId").val(ret.evalCycleId);
		J("#formList").attr("action", "${context_path}/prs/eval/mboEvalUser/mboEvalUserList.do").submit();
		return false;
	}

	/******************************************
	 * jqGrid 수정페이지 링크
	 ******************************************/
	function linkUpdate(cellvalue, options, rowObject) {
		return '<a href=javascript:goModify(' + options.rowId + ')>' + cellvalue + '</a>';
	}

	/******************************************
	 * 수정
	 ******************************************/
	function goModify(rowId) {
		var form = J("#formList")[0];
		var ret = J("#list").jqGrid('getRowData',rowId);

		J("#evalMboGrpId").val(ret.evalMboGrpId);
		J("#evalCycleId").val(ret.evalCycleId);
		J(form.findMode).val("MOD");
		J("#formList").attr("action", "${context_path}/prs/eval/mboEvalCycle/mboEvalCycleForm.do").submit();
	}

	/******************************************
	 * 평가단 목록 링크
	 ******************************************/
	function linkMboEvalMemberGrpList(cellvalue, options, rowObject) {
		return '<a href=javascript:goMboEvalMemberGrpList(' + options.rowId + ')>' + cellvalue + '</a>';
	}

	/******************************************
	 * 평가단 목록
	 ******************************************/
	function goMboEvalMemberGrpList(rowId){
		var form = J("#formList")[0];
		J(form.findUseYn).val(J("#findUseYn").val());
		var ret = J("#list").jqGrid('getRowData',rowId);
		J("#evalCycleId").val(ret.evalCycleId);
		J("#formList").attr("action", "${context_path}/prs/eval/mboEvalUnit/mboEvalUnitList.do").submit();
		return false;
	}


	/******************************************
	 * 일괄저장
	 ******************************************/
	function goAllModify() {
		var count = J("#list").jqGrid('getGridParam', 'records');
		var saveChk = true;

		//정렬기준 null체크 중복체크
		if (count > 0) {
			J("input[name=weights]").each(function(a, value) {
						if (J("input[name=weights]").eq(a).val() == "") {
							J.showMsgBox("가중치를 입력하세요", null, J("input[name=weights]").eq(a));
							saveChk = false;
							return false;
						}
			});
			J("input[name=sortOrders]").each(function(a, value) {
						if (J("input[name=sortOrders]").eq(a).val() == "") {
							J.showMsgBox("정렬순서를 입력하세요", null, J("input[name=sortOrders]").eq(a));
							saveChk = false;
							return false;
						}
			});
			J("input[name=sortOrders]").each(
					function(a, value) {
						if (!isNumber(J("input[name=sortOrders]").eq(a).val())) {
							J.showMsgBox("정렬순서는 숫자만 입력가능합니다", null, J("input[name=sortOrders]").eq(a));
							saveChk = false;
							return false;
						}
			});
			J("input[name=sortOrders]").each(function(i, value) {
					J("input[name=sortOrders]").each(function(j, value) {
						if (i != j && J("input[name=sortOrders]").eq(i).val() == J("input[name=sortOrders]").eq(j).val()) {
							J.showMsgBox("정렬순서는 동일한 정렬로 입력하실 수 없습니다", null, J("input[name=sortOrders]").eq(i));
							saveChk = false;
							return false;
						}
					});
			});
			if (saveChk) {
				J.showConfirmBox("일괄수정을 하시겠습니까?", "sortDo"); //insertDo() 콜백함수 호출
			}
		} else {
			J.showMsgBox("일괄수정할 내용이 없습니다.");
			return false;
		}
	}

	/******************************************
	 * 일괄저장처리
	 ******************************************/
	function sortDo() {
		var form = J("#formList")[0];
		var id = J("#list").getGridParam('selarrrow');
		var ids = J("#list").jqGrid('getDataIDs');
		var rowdata = "";
		var evalCycleIds = "";

		for (var i = 0; i < ids.length; i++) {
			var tmp = J("#formList input[name=sortOrders]").eq(i).val();
			if (0 < tmp.length) {
				rowdata = J("#list").getRowData(ids[i]);
				evalCycleIds += rowdata.evalCycleId + '|';
			}
		}

		J("#evalCycleIds").val(evalCycleIds);
		J(form.findMode).val("SORT");
		J("#formList").attr("action","${context_path}/prs/eval/mboEvalCycle/mboEvalCycleProcess.do").submit();
		return false;

	}

	/******************************************
	 * 삭제
	 ******************************************/
	function goDelete(isPreview) {
		var form = J("#formFind")[0];
		var findUseYn = J(form.findUseYn).val();
		var chk = true;

		if (findUseYn == 'N') {
			J.showMsgBox("이미 삭제된 항목입니다.", null, null);
			return;
		}else{
			if(!J.gridSelectChk("list")){
				J.showMsgBox("삭제할 데이터를 선택하십시요", null, null);
			} else {
				// 평가단이 있을 경우 삭제 방지 처리
				var ids = J("#list").jqGrid('getDataIDs');
				J("#list input:checkbox").each(function(index) {
					var rowdata = J("#list").getRowData(ids[index]);

					if(J(rowdata.mboEvalUnitCnt).text() != 0) { //비교조건 대상 컬럼
						J.showMsgBox("평가단이 1개 이상인 평가주기는 삭제할 수 없습니다.", null, J(this));
						chk = false;
						return false;
					}
				});
				if(chk==true){
					J.showConfirmBox("삭제하시겠습니까?", "deleteDo"); //deleteDo() 콜백함수 호출
				}
			}
		}
	}

	/******************************************
	 * 삭제처리
	 ******************************************/
	function deleteDo() {
		var form = J("#formList")[0];
		var id = J("#list").getGridParam('selarrrow');
		var ids = J("#list").jqGrid('getDataIDs');
		var rowdata = "";
		var evalCycleIds = "";

		for (var i = 0; i < ids.length; i++) {
			J.each(id, function (index, value) {
				if (value == ids[i]) {
					rowdata = J("#list").getRowData(ids[i]);
					evalCycleIds += rowdata.evalCycleId + '|';
				}
			});
		}

		J("#evalCycleIds").val(evalCycleIds);
		J(form.findMode).val("DELLIST");
		J("#formList").attr("action", "${context_path}/prs/eval/mboEvalCycle/mboEvalCycleProcess.do").submit();
		return false;
	}

	/******************************************
	 * 엑셀다운로드
	 ******************************************/
	function excelDownload(){
		var count = J("#list").jqGrid('getGridParam', 'records');

		if(count>0){
			J("#formList").attr("action", "${context_path}/prs/eval/mboEvalCycle/mboEvalCycleListExcelDownload.do").submit();
			return false;
		}else{
			J.showMsgBox("엑셀 다운로드할 내용이 없습니다.");
			return false;
		}
	}
//]]>
</script>

<div class="Table">
	<div class="Table_blockContainer">
		<h1 class="none">MBO평가주기</h1>
		<div class="tableTop">

    		<!-- search S -->
    		<form:form commandName="searchVO" id="formFind" name="formFind" method="post" action="${context_path}/prs/eval/mboEvalCycle/mboEvalCycleList.do" >
    			<lexken:makeHidden var="${searchVO}" filter="find" exclude="findUseYn" />
				<form:hidden path="evalMboGrpId"  />
				<div class="searchBox">
    				<div><div><div>
    				<table summary="MBO평가주기 <spring:message code="bsc.common.msg.searchCondition" />">
						<caption class="none">MBO평가주기 <spring:message code="bsc.common.msg.searchCondition" /></caption>
						<thead><tr><th></th></tr></thead>
        				<tbody>
            				<tr>
								<td class="searchBox_tit">
									기준년도 : <span class="searchBar"><c:out value="${searchVO.findYear}" />년</span>
								</td>
            					<td class="searchBox_tit">
            						MBO실적평가군 : <span class="searchBar"><c:out value="${mboEvalGrpData.evalMboGrpNm}" /></span>
            					</td>
            					<td class="searchBox_tit">
                					<span><label for="findUseYn"><spring:message  code="USE_YN" /></label></span>
                					<span class="searchBar">
									    <form:select path="findUseYn" class="select w100">
									    	<form:options items="${codeUtil:getCodeList('011') }" itemLabel="codeNm" itemValue="codeId" />
            							</form:select>
            						</span>
                                </td>
            				</tr>
        				</tbody>
    				</table>
					<span class="searchBox_buttonGrp">
    				<input type="image" src="${img_path}/common/btn_search.gif" alt="검색" />
                      <input  id="btnExcelDown" type="image" alt="엑셀" src="${img_path}/common/btn_excel.gif">
                    </span>
                    </div></div></div>
    	        </div>
    		</form:form>
    		<!-- search E -->
			<div class="clear"></div>
		</div>

		<form:form commandName="searchVO" id="formList" name="formList" method="post" action="${context_path}/prs/eval/mboEvalCycle/mboEvalCycleProcess.do" >
			<form:hidden path="year"  />
			<form:hidden path="evalMboGrpId"  />
			<form:hidden path="evalCycleIds" />
			<form:hidden path="evalCycleId"  />
			<form:hidden path="copyEvalMboGrpId"  />
			<form:hidden path="copyEvalCycleId"  />
			<lexken:makeHidden var="${searchVO.searchKey}" prefix="searchKey." />
			<lexken:makeHidden var="${searchVO}" filter="find" />

			<div id="splitterBox">
				<div>
					<!-- 데이터그리드 Start -->
					<div class="blockGridListTable">
						<table id="list" summary="MBO평가주기 조회결과">
							<caption class="none">MBO평가주기 조회</caption>
							<thead><tr><th></th></tr></thead>
							<tbody><tr><td></td></tr></tbody>
						</table>
						<div id="pager"></div>
					</div>
					<!--// 데이터그리드 End -->
					<div class="blockButton_all">
						<div class="blockButton_l"></div>
						<div class="blockButton">
							<ul>
								<li><input type="button" id="btnBack" value="돌아가기" /></li>
								<li><input type="button" id="btnCopy" value="복사하기" /></li>
								<li><input type="button" id="btnModify" value="일괄저장" /></li>
								<li><input type="button" id="btnInsert" value="신규" /></li>
								<li><input type="submit" id="btnDelete" value="삭제" /></li>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</form:form>
	</div>
	<a id="anchor"></a>
	<div class="clear"></div>
</div>
