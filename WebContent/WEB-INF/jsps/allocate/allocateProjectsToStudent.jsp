<%--
  Created by IntelliJ IDEA.
  User: zhan
  Date: 2017/4/10 0010
  Time: 21:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>

    <script type="text/javascript">
        $(function () {
            //获取未分配课题
            $("#allocateProject").datagrid({
                url: '${basePath}process/getProjects.html',
                fit: true,
                idField: 'id',
                singleSelect: true,
                border: false,
                striped: true,
                columns: [[{
                    title: '标题（及副标题）',
                    field: 'title',
                    width: '60%',
                    formatter: function (value, row, index) {
                        var title = '';
                        if (row.subTitle == null || row.subTitle == '') {
                            title = value;
                        } else {
                            title = value + "——" + row.subTitle;
                        }
                        return title;
                    }
                }, {
                    title: '年份',
                    field: 'year',
                    width: '10%'
                }, {
                    title: '类别',
                    field: 'category',
                    width: '10%'
                }, {
                    title: '操作',
                    field: 'action',
                    width: '20%',
                    formatter: function (value, row, index) {
                        var str = '';
                        str += $.formatString('<a class="allocateBtn" href="javascript:void(0)" onclick="allocateStudent(\'{0}\')"></a>', row.id);
                        str += $.formatString('<a class="viewBtn" href="javascript:void(0)" onclick="detailProject(\'{0}\')"></a>', row.id);
                        return str;
                    }
                }]],
                onLoadSuccess: function () {
                    $(".allocateBtn").linkbutton({text: '匹配', plain: true, iconCls: 'icon-ok'});
                    $(".viewBtn").linkbutton({text: '查看', plain: true, iconCls: 'icon-search'});
                }
            });

            $("#allocatedStudent").datagrid({
                url: '${basePath}process/getStudents.html',
                fie: true,
                border: false,
                idField: 'id',
                singleSelect: true,
                striped: true,
                columns: [[{
                    title: '选择',
                    field: 'action',
                    width: '2%',
                    checkbox: true
                }, {
                    title: '姓名',
                    field: 'name',
                    width: '30%'
                }, {
                    title: '学号',
                    field: 'no',
                    width: '30%'
                }, {
                    title: '班级',
                    field: 'studentClass',
                    width: '35%',
                    formatter: function (value, row, index) {
                        return row.studentClass.description;
                    }
                }]]
            })
        });

        //分配学生
        function allocateStudent(graduateProjectId) {
            var students = $("#allocatedStudent").datagrid('getChecked');
            var studentCount = students.length;
            if (studentCount == null || studentCount == 0) {
                $.messager.alert("提示", "请选择学生", "warning");
                return false;
            } else {
                var getStudentId = '';
                for (var i in students) {
                    getStudentId = getStudentId + ',' + students[i].id;
                }
                getStudentId = getStudentId.substring(1, getStudentId.length + 1);
                $.messager.confirm('询问', '确认匹配选中的学生和题目？', function (t) {
                    if (t) {
                        $.ajax({
                            url: '${basePath}process/allocateProjectsToStudents.html',
                            type: 'POST',
                            dataType: 'json',
                            data: {"studentId": getStudentId, "graduateProjectId": graduateProjectId},
                            success: function (result) {
                                if (result.success) {
                                    $("#allocatedStudent").datagrid('reload');
                                    $("#allocateProject").datagrid('reload');
                                    $.messager.alert("提示", result.msg, 'info');
                                } else {
                                    $.messager.alert("警告", result.msg, 'warning');
                                }
                                return true;
                            },
                            error: function () {
                                $.messager.alert('错误', '网络错误，请联系管理员', 'error');
                                return false;
                            }
                        });
                    }
                });
            }
        }

        //搜索
        function searchFun() {
            $("#allocatedStudent").datagrid('load', $.serializeObject($("#searchForm")));
        }

        //清空查询条件
        function clearFun() {
            $("#searchForm input").val('');
            $("#allocatedStudent").datagrid('load', {});
        }

        //查看课题详情
        function detailProject(id) {
            var url = '${basePath}process/showDetail.html?graduateProjectId=' + id;
            showProjectDetail(url);
        }

        //查看已分配的题目
        function viewAllocatedProject() {
            parent.$.modalDialog({
                href: '${basePath}process/getAllocatedProject.html',
                modal: true,
                width: 600,
                height: 400,
                buttons: [{
                    text: '关闭',
                    iconCls: 'icon-cancel',
                    handler: function () {
                        $("#allocatedStudent").datagrid('reload');
                        $("#allocateProject").datagrid('reload');
                        parent.$.modalDialog.handler.dialog('close');
                    }
                }]
            })
        }
    </script>
</head>
<body>

<div id="head">
    <div id="alloctedBtn" style="float: left;position: absolute;top: 10px;left: 10px">
        <a href="javascript:void(0)" onclick="viewAllocatedProject()" class="easyui-linkbutton">已分配学生和课题</a>
    </div>
    <div id="searchDiv" style="float:right;position: absolute;top: 10px;right: 10%">
        <form id="searchForm">

            <span style="color: grey;">学生姓名:</span><input type="text" name="name" value="${name}"
                                                          class="easyui-textbox" id="name">

            <span style="color: grey;">学生学号:</span><input type="text" name="no" value="${no}"
                                                          class="easyui-textbox" id="no">
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="searchFun()"
               data-options="iconCls:'icon-search'">搜索</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="clearFun()"
               data-options="iconCls:'icon-clear'">清空</a>
        </form>

    </div>
</div>
<div class="easyui-layout" style="width: 100%;height: 100%">
    <div data-options="region:'west',title:'未分配题目'" style="width: 60%;height: 100%">
        <table id="allocateProject"></table>
    </div>
    <div data-options="region:'center',title:'未分配学生'">
        <table id="allocatedStudent"></table>
    </div>
</div>
</body>
</html>
