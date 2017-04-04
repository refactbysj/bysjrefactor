<%--
  Created by IntelliJ IDEA.
  User: zhan
  Date: 2017/4/4 0004
  Time: 11:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
    <title>时间设置</title>
    <script type="text/javascript">
        var holidayGrid;
        $(function () {
            holidayGrid = $("#holidayGrid").datagrid({
                url:'${basePath}findHolidayPageData.html',
                striped:true,
                method:'post',
                pagination:true,
                fit:true,
                idField:'id',
                singleSelect:true,
                columns:[[{
                    title:'开始时间',
                    field:'beginTime',
                    width:'12%',
                    formatter:function (value, row, index) {
                        return value;
                    }
                },{
                    title:'结束时间',
                    field:'endTime',
                    width:'12%'
                },{
                    title:'原因',
                    field:'description',
                    width:'60%'
                },{
                    field:'action',
                    title:'操作',
                    width:'12%',
                    formatter:function (value, row, index) {
                        var str = '';
                        <%--<sec:authorize ifAnyGranted="ROLE_DEPARTMENT_DIRECTOR">--%>
                        str += $.formatString('<a href="javascript:void(0)" class="editBtn" data-options="plain:true,iconCls:\'icon-edit\'" onclick="editFun(\'{0}\')"></a>',row.id);
                        str += $.formatString('<a href="javascript:void(0)" class="delBtn" data-options="plain:true,iconCls:\'icon-cancel\'" onclick="delFun(\'{0}\')"></a>',row.id);
                        <%--</sec:authorize>--%>
                        return str;
                    }
                }]],
                onLoadSuccess:function (data) {
                    $('.editBtn').linkbutton({text: '编辑', plain: true, iconCls: 'icon-edit'});
                    $('.delBtn').linkbutton({text: '删除', plain: true, iconCls: 'icon-cancel'});
                }
            })
        });




        function addOrEditTime(url,title) {
            $("#setTimeWindow").dialog({
                title:title,
                width:'400px',
                height:'200px',
                href:url,
                cache:false,
                modal:true,
                buttons:[{
                    text:'取消',
                    iconCls:'icon-cancel',
                    handler:function () {
                        $("#setTimeWindow").dialog('close');
                    }
                },{
                    text:'保存',
                    iconCls:'icon-edit',
                    handler:function () {
                        $("#editTimeForm").submit();
                    }
                }]
            })
        }

        function addHoliday(url,title) {
           parent.$.modalDialog({
               title:title,
               href:url,
               width:500,
               height:300,
               buttons:[{
                   text:'取消',
                   iconCls:'icon-cancel',
                   handler:function () {
                       parent.$.modalDialog.handler.dialog('close');
                   }
               },{
                   text:'提交',
                   iconCls:'icon-add',
                   handler:function () {
                       parent.$.modalDialog.openner_grid = holidayGrid;
                       var f = parent.$.modalDialog.handler.find('#holidayAddForm');
                       f.submit();
                   }
               }]

           })
        }

        function editFun(editId) {
            var url = 'addOrEditHolidayTime.html?editId=' + editId;
            addHoliday(url, '修改节假日');
        }

        //删除节假日
        function delFun(id) {
            $.messager.confirm("询问","您是否要删除当前节假日？",function (b) {
                if(b) {
                    progressLoad();
                    $.post("${basePath}delHolidayTime.html",{
                        delId:id
                    },function (result) {
                        result = $.parseJSON(result);
                        console.log(result.success);
                        if (result.success) {
                            $.messager.alert("提示", result.msg, "info");
                            holidayGrid.datagrid("reload");
                        }else{
                            $.messager.alert("提示", result.msg, "warning");
                        }
                        progressClose();
                    })
                }
            },"JSON")
        }


    </script>
</head>
<body>
<%--如果是教研室主任则显示--%>
<div class="row">
    <div class="col-md-3" style=" text-align:center; ">
        <c:choose>
            <c:when test="${ifShowProposeProjectTime == 0}">
                <a href="javascript:void(0)" onclick="addOrEditTime('addOrEditProposeProjectTime.html','设置教师申报题目时间')" class="easyui-linkbutton" data-options="iconCls:'icon-add'">
                    <h5>设置教师申报题目时间</h5>
                </a>
            </c:when>
            <c:when test="${ifShowProposeProjectTime ==1}">
                <p>教师申报题目时间</p>
                <p>(${proposeProjectStartTime}---${proposeProjectEndTime})</p>
                <a href="javascript:void(0)" onclick="addOrEditTime('addOrEditProposeProjectTime.html','修改教师申报题目时间')" class="easyui-linkbutton" data-options="iconCls:'icon-edit'"
                   title="修改申报题目时间"> 修改
                </a>
            </c:when>
        </c:choose>
    </div>
    <div class="col-md-3" style=" text-align:center; ">
        <c:choose>
            <c:when test="${ifShowOpeningReportTime == 0}">
                <a href="javascript:void(0)" onclick="addOrEditTime('addOrEditOpeningReportTime.html','设置审核开题报告时间')" class="easyui-linkbutton" data-options="iconCls:'icon-add'">
                   <h5>设置审核开题报告时间</h5>
                </a>
            </c:when>
            <c:when test="${ifShowOpeningReportTime ==1}">
                <!-- <span class="label label-success"> -->
                <p>审核开题报告时间</p>
                <p>(${openingReportStartTime}---${openingReportEndTime})</p>
                <a class="easyui-linkbutton" data-options="iconCls:'icon-edit'"
                   href="javascript:void(0)" onclick="addOrEditTime('addOrEditOpeningReportTime.html','修改开题报告时间')"
                   title="修改开题报告时间"> 修改</a>
            </c:when>
        </c:choose>
    </div>
    <div class="col-md-3" style=" text-align:center; ">
        <c:choose>
            <c:when test="${ifShowProjectTimeSpan == 0}">
                <a onmouseup="advicetime()" href="javascript:void(0)" onclick="addOrEditTime('addOrEditProjectTimeSpan.html','设置毕业设计起始时间')"
                   class="easyui-linkbutton" data-options="iconCls:'icon-add'" id="time"><h5>设置毕业设计起始时间</h5>
                </a>

            </c:when>
            <c:when test="${ifShowProjectTimeSpan ==1}">
                <p>设置毕业设计起始时间</p>

                <p>(${projectTimeSpanStartTime}---${projectTimeSpanEndTime})</p>
                <a class="easyui-linkbutton" data-options="iconCls:'icon-edit'"
                   href="javascript:void(0)" onclick="addOrEditTime('addOrEditProjectTimeSpan.html','修改毕业设计起始时间')"
                    title="修改毕业设计起始时间"> 修改</a>
            </c:when>
        </c:choose>
    </div>
    <div class="col-md-3" style=" text-align:center; ">
        <a href="javascript:void(0)" onclick="addHoliday('addOrEditHolidayTime.html','添加节假日')" class="easyui-linkbutton" data-options="iconCls:'icon-add'">
                <h5>添加节假日</h5>
        </a>
    </div>
</div>

<div id="setTimeWindow"></div>
<span style="color: grey;font-size: large;font-weight: bold">节假日列表</span>
<div id="holidayDiv" style="width: 100%;height:72%;margin-top: 10px">

    <table id="holidayGrid" style="width: 90%;height: 40%;">
    </table>
</div>


</body>
</html>
