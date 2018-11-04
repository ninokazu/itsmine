<%
/*************************************************************************
* CLASS 명      : nonmetItemList
* 작 업 자      : 김윤기
* 작 업 일      : 2014년 5월 26일
* 기    능      : 비계량평가항목관리
* ---------------------------- 변 경 이 력 --------------------------------
* 번호    작 업 자     작   업   일       변 경 내 용           비  고
* ----  --------  -----------------  -------------------------  -----------
*  1     김윤기      2014년 5월 26일             최 초 작 업
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
			url          :"${context_path}/eval/nonmet/nonmetItem/nonmetItemList_json.do" + "?" + str,
			mtype        :"POST",
			datatype     :"json",
			jsonReader   : {
    						page   : "page",
    						total  : "total",
    						root   : "rows",
    						records: "records",
    						//records: function(obj){return obj.length;},
    						repeatitems: false,
                            id     : "id"
    				       },
	        height       : "${jqGrid_height}",
			width        : "${jqGrid_width}",
			//colNames     :['기준년도', '평가구분', '<spring:message code="METRIC_NM" /> POOL ID', '평가항목코드', '항목명', '가중치', '비고', '정렬순서', '생성일자'],
			colModel     :[
							{name:'year'                 ,index:'year'                 ,width:150   ,align:'center' ,hidden:true ,title:true ,label:'기준년도'},
                            {name:'evalGubun'            ,index:'evalGubun'            ,width:150   ,align:'center' ,hidden:true ,title:true ,label:'평가구분'},
                            {name:'metricGrpId'          ,index:'metricGrpId'          ,width:150   ,align:'center' ,hidden:true ,title:false ,label:'<spring:message code="METRIC_NM" /> POOL ID'},
                            {name:'itemId'               ,index:'itemId'               ,width:150   ,align:'center' ,hidden:true ,title:true ,label:'평가항목코드'},
                            {name:'itemNm'               ,index:'itemNm'               ,width:250   ,align:'left' ,hidden:false ,title:true ,label:'항목명' ,formatter:linkUpdate},
                            {name:'weight'               ,index:'weight'               ,width:150   ,align:'center' ,hidden:false ,title:true ,label:'가중치'},
                            {name:'content'              ,index:'content'              ,width:150   ,align:'center' ,hidden:true ,title:true ,label:'비고'},
                            {name:'sortOrder'            ,index:'sortOrder'            ,width:100   ,align:'center' ,hidden:false ,title:true ,label:'정렬순서'},
                            {name:'createDt'             ,index:'createDt'             ,width:150   ,align:'center' ,hidden:true ,title:true ,label:'생성일자'}
							],
			/*
			페이징 사용시
			pager		 : "#pager",
			rowNum     : "20",
			*/
			rowNum       : "${jqGrid_rownum}",
			autowidth    : false,
			viewrecords  : true,
			/*
			페이징 사용시
			loadonce     : false,
			*/
			loadonce     : true,
			multiselect  : true,
			cellEdit     : true,
			caption:"비계량평가항목관리"
		}).setGridWidth("${jqGrid_width}");
		//J("#list").jqGrid('hideCol',"year");


		/******************************************
		 * 조회
		 ******************************************/
		J("#formFind").submit(function(event) {
			//submit 하기전 작업추가
		});

		/******************************************
		 * 신규 등록
		 ******************************************/
		J("#btnInsert").click(function() {
			var form = J("#formList")[0];
			J(form.year).val(J("#findYear").val());
			J(form.evalGubun).val("01");
			//J(form.evalGubun).val(J("#findEvalGubun").val());
			//J(form.evalGubunNm).val(J("#findEvalGubun :selected").text());
			J(form.metricGrpId).val(J("#findMetricGrpId").val());
			J(form.metricGrpNm).val(J("#findMetricGrpId :selected").text());
			J(form.findMode).val("ADD");
			J("#formList").attr("action", "${context_path}/eval/nonmet/nonmetItem/nonmetItemForm.do").submit();
		});



		/******************************************
		 * 년도 변경 이벤트
		 ******************************************/
		J("#findYear").change(function() {
			refresh();
			return false;
		});

		/******************************************
		 * 삭제 버튼 클릭 이벤트
		 ******************************************/
		J("#btnDelete").click(function() {
			goDelete();
			return false;
		});

		/******************************************
		 * 엑셀다운로드 버튼 클릭 이벤트
		 ******************************************/
		J("#btnExcelDown").click(function() {
			var count = J("#list").jqGrid('getGridParam', 'records');

			if(count > 0){
				excelDownload();
				return false;
			}else{
				J.showMsgBox("엑셀다운로드할 내용이 없습니다.");
				return false;
			}
		});


        /******************************************
         * 년마감시 버튼 비활성화
         ******************************************/
        if("<c:out value="${closing.closingYn}"/>" == "Y"  || "<c:out value="${closing.evalConfirmYn}"/>" =="Y" || "<c:out value="${closing.evalClosingYn}"/>" == "Y"  ){
        	J("#btnInsert, #btnDelete").attr("disabled",true);
        }



	});

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
		J("#year").val(J("#findYear").val());
		J("#evalGubun").val(ret.evalGubun);
		J("#metricGrpId").val(J("#findMetricGrpId").val());
		J("#metricGrpNm").val(J("#findMetricGrpId :selected").text());
		J("#itemId").val(ret.itemId);
		J(form.findMode).val("MOD");
		J("#formList").attr("action", "${context_path}/eval/nonmet/nonmetItem/nonmetItemForm.do").submit();
	}

	/******************************************
	 * 삭제
	 ******************************************/
	function goDelete(isPreview) {
		if(!J.gridSelectChk("list")){
			J.showMsgBox("삭제할 데이터를 선택하십시요", null, null);
		} else {
			J.showConfirmBox("삭제하시겠습니까?", "deleteDo"); //deleteDo() 콜백함수 호출
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
		var evalGubuns = "";
		var metricGrpIds = "";
		var itemIds = "";

		for (var i = 0; i < ids.length; i++) {
			J.each(id, function (index, value) {
				if (value == ids[i]) {
					rowdata = J("#list").getRowData(ids[i]);
					itemIds += rowdata.itemId + '|';
				}
			});
		}

		J("#year").val(J("#findYear").val());
		J("#evalGubun").val(J("#findEvalGubun").val());
		J("#metricGrpId").val(J("#findMetricGrpId").val());
		J("#itemIds").val(itemIds);

		J(form.findMode).val("DELLIST");
		J("#formList").attr("action", "${context_path}/eval/nonmet/nonmetItem/nonmetItemProcess.do").submit();
		return false;
	}


	function refresh(){
		var formFind=J("#formFind")[0];
		var formList=J("#formList")[0];
		J(formList.findYear).val(J(formFind.findYear).val());

		J.ajax({
            url      : "${context_path}/eval/nonmet/nonmetItem/nonmetMetricGrpList_json.do",
            cache    : false,
        	type     : "GET",
        	data     : J("#formList").serialize(),
        	dataType : "json",
        	contentType : "application/xml",
            success  : function (data) {
            	//등급
        		var rows = data.rows;

            	var obj=J("select[name=findMetricGrpId]");
            	//데이터 삭제
            	obj.empty();

        		//데이터등록
        		J(rows).each(function(index, item){
        			J(obj).append(new Option(item.metricGrpNm,item.metricGrpId));
        		});
            }
        });

	}

	/******************************************
	 * 엑셀다운로드
	 ******************************************/
	function excelDownload(){
		var formFind=J("#formFind")[0];
		var form=J("#formList")[0];
		J(form.findYear).val(J("#findYear").val());

		J(form.findEvalGubun).val(J(formFind.findEvalGubun).val());
		J(form.findMetricGrpId).val(J(formFind.findMetricGrpId).val());
		J(form.evalGubunNm).val(J("#findEvalGubun :selected").text());
		J(form.metricGrpNm).val(J("#findMetricGrpId :selected").text());


		J("#formList").attr("action", "${context_path}/eval/nonmet/nonmetItem/nonmetItemListExcelDownload.do").submit();
		return false;
	}


//]]>
</script>

<div class="Table">
	<div class="Table_blockContainer">
		<h1 class="none">비계량평가항목관리</h1>
		<div class="tableTop">

    		<!-- search S -->
    		<form:form commandName="searchVO" id="formFind" name="formFind" method="post" action="${context_path}/eval/nonmet/nonmetItem/nonmetItemList.do" >
    			<lexken:makeHidden var="${searchVO}" filter="find" exclude="findYear,findEvalGubun,findMetricGrpId" />
    			<input type="hidden" name="findEvalGubun" value="01"/>
				<div class="searchBox">
    				<div><div><div>
    				<table summary="비계량평가항목관리 <spring:message code="bsc.common.msg.searchCondition" />">
						<caption class="none">비계량평가항목관리 <spring:message code="bsc.common.msg.searchCondition" /></caption>
						<thead><tr><th></th></tr></thead>
        				<tbody>
            				<tr>
            					<td class="searchBox_tit ">
            						<%-- 삭제시 exclude 삭제처리 할것 --%>
            						<span><label for="findYear"><spring:message code="YEAR" /></label></span>
            						<span class="searchBar">
            							<form:select path="findYear"  class="select w80" items="${codeUtil:getCodeList('017')}"  itemLabel="codeNm"  itemValue="codeId">
            							</form:select>
            						</span>
            					</td>
            					<%-- 컬럼 예제 display:none을 시켜서 우선 평가구분을 없는것 처럼 처리한다. --%>
            					<!-- <td class="searchBox_tit" style="display:none;">
                					<span><label for="findEvalGubun">평가구분</label></span>
								    <form:select path="findEvalGubun" class="select w100" items="${dataList}" itemLabel="evalGubunNm" itemValue="evalGubun">
           							</form:select>
                                </td>
                                 -->
            					<td class="searchBox_tit">
                					<span><label for="findMetricGrpId"><spring:message  code="METRIC_GRP_NM" /></span>
           							<form:select path="findMetricGrpId" class="select w100" items="${nonMetricGrpList}" itemLabel="metricGrpNm" itemValue="metricGrpId">
           							</form:select>
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

		<form:form commandName="searchVO" id="formList" name="formList" method="post" action="${context_path}/eval/nonmet/nonmetItem/nonmetItemProcess.do" >
			<form:hidden path="year"  />
			<form:hidden path="itemIds" />
			<form:hidden path="itemId"  />
			<form:hidden path="evalGubun"  />
			<form:hidden path="evalGubunNm"  />
			<form:hidden path="metricGrpId"  />
			<form:hidden path="metricGrpNm"  />
			<lexken:makeHidden var="${searchVO.searchKey}" prefix="searchKey." />
			<lexken:makeHidden var="${searchVO}" filter="find" />

			<div id="splitterBox">
				<div>
					<!-- 데이터그리드 Start -->
					<div class="blockGridListTable">
						<table id="list" summary="비계량평가항목관리 조회결과">
							<caption class="none">비계량평가항목관리 조회</caption>
							<thead><tr><th></th></tr></thead>
							<tbody><tr><td></td></tr></tbody>
						</table>
						<div id="pager"></div>
					</div>
					<!--// 데이터그리드 End -->
					<div class="blockButton_all">
						<c:if test="${closing.closingYn == 'Y' || closing.evalClosingYn == 'Y' || closing.evalConfirmYn == 'Y'}">
						<div class="blockButton_l left_comm">
							<c:if test="${closing.closingYn == 'Y'}">
								<span><img src="${img_path}/common/icon_comm.gif" >${searchVO.findYear}년 성과가 마감되었습니다.</span><br/>
							</c:if>
							<c:if test="${closing.evalClosingYn == 'Y'}">
								<span><img src="${img_path}/common/icon_comm.gif" >${searchVO.findYear}년 평가가 마감되었습니다.</span><br/>
							</c:if>
							<c:if test="${closing.evalConfirmYn == 'Y'}">
								<span><img src="${img_path}/common/icon_comm.gif" >${searchVO.findYear}년 평가가 확정되었습니다.</span><br/>
							</c:if>
						</div>
						</c:if>
						<div class="blockButton">
							<ul>
								<li><input type="button" id="btnInsert" value="신규" /></li>
								<li><input type="submit" id="btnDelete" value="삭제" /></li>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</form:form>
	</div>
	<div class="clear"></div>
</div>
