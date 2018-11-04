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
			url          :"${context_path}/eval/evalReOpinion/evalReOpinionCheck/evalReOpinionCheckList_json.do" + "?" + str,
			mtype        :"POST",
			datatype     :"json",
			jsonReader   : {
    						page   : "page",
    						total  : "total",
    						root   : "rows",
    						records: function(obj){return obj.length;},
    						repeatitems: false,
                            id     : "id"
    				       },
	        height       : "300px",
			width        : "${jqGrid_width}",
			colModel     :[
							{name:'year'            	,index:'year'            	,width:60    ,align:'center' ,hidden:true  ,title:true  ,label:'년도'},
							{name:'scDeptId'        	,index:'scDeptId'        	,width:80    ,align:'center' ,hidden:true  ,title:true  ,label:'조직코드'},
							{name:'scDeptNm'        	,index:'scDeptNm'        	,width:80    ,align:'center' ,hidden:false ,title:true  ,label:'조직'},
							{name:'objectionGubunId'    ,index:'objectionGubunId'   ,width:30    ,align:'center' ,hidden:true  ,title:true  ,label:'평가구분코드'},
							{name:'objectionGubunNm'    ,index:'objectionGubunNm'   ,width:30    ,align:'center' ,hidden:false ,title:true  ,label:'평가구분'},
							{name:'metricId'        	,index:'metricId'        	,width:60    ,align:'center' ,hidden:true  ,title:true  ,label:'지표 명코드'},
							{name:'metricNm'       		,index:'metricNm'        	,width:60    ,align:'center' ,hidden:false ,title:true  ,label:'지표 명'},
							{name:'objectionId'     	,index:'objectionId'     	,width:100   ,align:'center' ,hidden:true  ,title:true  ,label:'이의신청코드'},
                            {name:'objectionTitle'  	,index:'objectionTitle'  	,width:100   ,align:'center' ,hidden:false ,title:true  ,label:'이의신청제목',formatter:linkUpdate},
                            {name:'objectionUserId'     ,index:'objectionUserId'    ,width:30    ,align:'center' ,hidden:true  ,title:true  ,label:'신청자코드'},
                            {name:'objectionUserNm'     ,index:'objectionUserNm'    ,width:30    ,align:'center' ,hidden:false ,title:true  ,label:'신청자'},
                            {name:'objectionDt'         ,index:'objectionDt'        ,width:30    ,align:'center' ,hidden:false ,title:true  ,label:'신청일'},
                            {name:'statusId'            ,index:'statusId'           ,width:90    ,align:'center' ,hidden:true  ,title:true  ,label:'진행상태코드'},
                            {name:'statusNm'            ,index:'statusNm'           ,width:30    ,align:'center' ,hidden:false ,title:true  ,label:'진행상태'},
                            {name:'reviewResultId'      ,index:'reviewResultId'     ,width:90    ,align:'center' ,hidden:true  ,title:true  ,label:'검토결과코드'},
                            {name:'reviewResultNm'      ,index:'reviewResultNm'     ,width:30    ,align:'center' ,hidden:false ,title:true  ,label:'검토결과'},
                           
							],
			rowNum       : "${jqGrid_rownum}",
			//pager		 : jQuery('#pager'),
			autowidth    : false,
			viewrecords  : true,
			loadonce     : true,
			multiselect  : true,
			cellEdit     : true,
			sortable     : false
			
		});

		/******************************************
		 * 조회
		 ******************************************/
		J("#formFind").submit(function(event) {
			//submit 하기전 작업추가
		});

		/******************************************
		 * 신규 등록
		 ******************************************/
		J("#btnInsert").click(function(e) { 
			e.preventDefault();
			var form = J("#formList")[0];
			J(form.findMode).val("ADD");
			J(form.year).val(J("#findYear").val());
			J(form.objectionGubunId).val();
	
			J("#formList").attr("action", "${context_path}/eval/evalReOpinion/evalReOpinionCheck/evalReOpinionCheckForm.do").submit();
		});

		/******************************************
		 * 삭제 버튼 클릭 이벤트
		 ******************************************/
		J("#btnDelete").click(function() {
			alert("삭제버튼");
			return false;
		});

		if('${evalReOpinionYn}' == 'Y'){
			J("#btnInsert").attr("disabled",false).removeClass("ui-state-disabled");
			J("#btnDelete").attr("disabled",false).removeClass("ui-state-disabled");
		}else{
			J("#btnInsert").attr("disabled",true).addClass("ui-state-disabled");
			J("#btnDelete").attr("disabled",true).addClass("ui-state-disabled");
		}

	});

	/******************************************
	 * jqGrid 수정페이지 링크
	 ******************************************/
	function linkUpdate(cellvalue, options, rowObject) {
		return '<a href=javascript:goModify(' + options.rowId + ')>'+ cellvalue +'</a>';
	}

	/******************************************
	 * 수정
	 ******************************************/
	function goModify(rowId) {

		var form = J("#formList")[0];
		var ret = J("#list").jqGrid('getRowData', rowId);
		
		J(form.year).val(ret.year);
		J(form.findMode).val("MOD");
		J(form.objectionId).val(ret.objectionId);

		J("#formList").attr("action", "${context_path}/eval/evalReOpinion/evalReOpinionCheck/evalReOpinionCheckForm.do").submit();
	}
 
//]]>
</script>
<body id="body">
<div class="Table">
	<div class="Table_blockContainer">
		<h1 class="none">이의신청</h1>
		<div class="tableTop">
    		<!-- search S -->
    		<form:form commandName="searchVO" id="formFind" name="formFind" method="post" action="${context_path}/eval/evalReOpinion/evalReOpinionCheck/evalReOpinionCheckList.do" >
    			<lexken:makeHidden var="${searchVO}" filter="find"  exclude="findYear,findTemplate,findPgmId,findSubPgmId,findHighPgmId"/>
				<input type="hidden"	id="findPgmId"   	name="findPgmId"     	value="${searchVO.findPgmId}" />
				<input type="hidden"	id="findSubPgmId"   name="findSubPgmId"     value="${searchVO.findSubPgmId}" />
				<input type="hidden"	id="findHighPgmId"  name="findHighPgmId"    value="${searchVO.findHighPgmId}" />
				<input type="hidden"	id="findTemplate"   name="findTemplate"     value="${searchVO.findTemplate}" />
				<div class="searchBox popView">
    				<div><div><div>
    				<table summary="이의신청검토 <spring:message code="bsc.common.msg.searchCondition" />">
						<caption class="none">이의신청검토 <spring:message code="bsc.common.msg.searchCondition" /></caption>
						<thead><tr><th></th></tr></thead>
        				<tbody>
            				<tr>
            					<td class="searchBox_tit">
            						<span><label for="findYear"><spring:message code="YEAR" /></label></span>
            						<span class="searchBar">
            							<form:select path="findYear"  class="select w80" items="${codeUtil:getCodeList('017')}"  itemLabel="codeNm"  itemValue="codeId">
            							</form:select>
            						</span>
            					</td>
            					<%-- <td class="searchBox_tit">
            						<span><label for="statusId">평가자</label></span>
            						<span class="searchBar">
            							<form:select path="statusId" class="select w200">
									    <form:option value="" label="전체" />
									    <form:options items="${codeUtil:getCodeList('501')}" itemValue="codeId" itemLabel="codeNm" />
										</form:select>

            						</span>
            					</td> --%>
            					<td class="searchBox_tit">
                					<span><label for="objectionGubunId">평가구분</label></span>
									<span class="searchBar">
										<form:select path="objectionGubunId" class="select w150">
										<form:options items="${codeUtil:getCodeList('500')}" itemValue="codeId" itemLabel="codeNm"/>
										</form:select>
									</span>
                                </td>
            				</tr>
        				</tbody>
    				</table>

					<span class="searchBox_buttonGrp">
    				<input type="image" src="${img_path}/common/btn_search.gif" alt="검색" />
                    </span>

                    </div></div></div>
    	        </div>
    		</form:form>
    		<!-- search E -->
			<div class="clear"></div>
		</div>

		<form:form commandName="searchVO" id="formList" name="formList" method="post" action="${context_path}/eval/evalReOpinion/evalReOpinionItem/evalReOpinionItemProcess.do" >
			<form:hidden path="year"/>
			<form:hidden path="objectionIds"/>
			<form:hidden path="objectionId" id="objectionId"/>
			<form:hidden path="objectionGubunId"/>
			<lexken:makeHidden var="${searchVO.searchKey}" prefix="searchKey." />
			<lexken:makeHidden var="${searchVO}" filter="find" />

			<div id="splitterBox">
				<div>
					<!-- 데이터그리드 Start -->
					<div class="blockGridListTable marGinL">
						<table id="list" summary="이의신청 조회결과">
							<caption class="none">이의신청 조회</caption>
							<thead><tr><th></th></tr></thead>
							<tbody><tr><td></td></tr></tbody>
						</table>
						<div id="pager"></div>
					</div>
					<!--// 데이터그리드 End -->
						<!-- <div id="blockButton" class="blockButton">
							<ul>
								<li><input type="button" id="btnInsert" value="신규" /></li>
								<li><input type="button" id="btnDelete" value="삭제" /></li>
							</ul>
						</div> -->
				</div>
			</div>
		</form:form>
	</div>
	<a id="opinionFancy"></a>
	<div class="clear"></div>
</div>
</body>
