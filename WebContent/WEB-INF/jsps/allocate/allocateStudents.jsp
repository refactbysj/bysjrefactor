<%--
  Created by IntelliJ IDEA.
  User: zhan
  Date: 2017/4/8 0008
  Time: 19:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
    <script type="text/javascript">

        var studentGrid;

        $(function () {
            //获取该教研室老师
            $("#teacherGrid").datagrid({
                url: '${basePath}process/getDepartmentTeacher.html',
                fit: true,
                idField: 'id',
                singleSelect: true,
                rownumbers: true,
                border: false,
                striped: true,
                columns: [[{
                    title: '教师姓名',
                    field: 'name',
                    width: '30%'
                }, {
                    title: '职工号',
                    field: 'no',
                    width: '30%'
                }, {
                    title: '操作',
                    field: 'action',
                    width: '30%',
                    formatter: function (value, row, index) {
                        var str = '';
                        str += $.formatString('<a class="editBtn" data-options="iconCls:\'icon-edit\',plain:true" onclick="allocateStudent(\'{0}\')">匹配</a>', row.id);
                        str += $.formatString('<a class="viewBtn" data-options="iconCls:\'icon-search\',plain:true" onclick="viewAllocatedStudent(\'{0}\')">查看</a>', row.id);
                        return str;
                    }
                }]],
                onLoadSuccess: function () {
                    $(".editBtn").linkbutton({text: '匹配', iconCls: 'icon-edit'});
                    $(".viewBtn").linkbutton({text: '查看', iconCls: 'icon-search'});
                }

            });

            //获取教研室学生
            studentGrid = $("#studentTable").datagrid({
                url: '${basePath}process/getDepartStu.html',
                fit: true,
                idField: 'id',
                rownumbers: true,
                border: false,
                striped: true,
                columns: [[{
                    title: '选择',
                    field: 'action',
                    checkbox: true,
                    width: '5%'
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
                    field: 'studentClass.description',
                    width: '30%',
                    formatter: function (value, row, index) {
                        return row.studentClass.description;
                    }
                }]]

            });

        });

        //查看老师已分配的学生
        function viewAllocatedStudent(tutorId) {
            console.log(tutorId);
            var url = '${basePath}process/getTutorOfStudent.html?tutorId=' + tutorId;
            console.log(url);
            parent.$.modalDialog({
                title: '已匹配学生',
                href: url,
                width: 700,
                height: 400,
                modal: true,
                buttons: [{
                    text: '确定',
                    iconCls: 'icon-ok',
                    handler: function () {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                }]
            })
        }

        //查看所有已分配的学生
        function viewAllAllocatedStudent() {
            var url = '<%=basePath%>process/getDepartAllocatedStu.html';
            parent.$.modalDialog({
                title: '已分配学生',
                href: url,
                width: 700,
                height: 400,
                modal: true,
                buttons: [{
                    text: '关闭',
                    handler: function () {
                        parent.$.modalDialog.handler.dialog('close');
                        $("#studentTable").datagrid('load');
                    }
                }]

            })
        }

        //给指导老师分配学生
        function allocateStudent(tutorId) {
            var students = $("#studentTable").datagrid('getChecked');
            var studentCount = students.length;
            if (studentCount == 0 || studentCount == null) {
                $.messager.alert("提示", "请选择学生", "warning");
            } else {
                var studentIds = '';
                for (var i in students) {
                    studentIds = studentIds + ',' + students[i].id;
                }
                studentIds = studentIds.substring(1, studentIds.length + 1);
                $.messager.confirm("询问", "确认匹配选中的老师和学生?", function (r) {
                    if (r) {
                        $.ajax({
                            url: '/bysj3/process/allocateStudents.html',
                            type: 'POST',
                            dataType: 'json',
                            data: {"stuIds": studentIds, "tutorId": tutorId},
                            success: function (data) {
                                $("#studentTable").datagrid("reload");
                                $.messager.alert("提示", "匹配成功", "info");
                                return true;
                            },
                            error: function () {
                                $.messager.alert("警告", "匹配失败,请稍后再试", "warning");
                                return false;
                            }
                        });
                    }
                });
            }
        }

        //学生检索
        function searchFun() {
            $("#studentTable").datagrid("load", $.serializeObject($("#searchForm")));
        }

        //清空检索条件
        function cancelFun() {
            $("#searchForm input").val('');
            $("#studentTable").datagrid("load", {});
        }

    </script>
</head>
<body>
<div id="head" style="margin-top: 1%">
    <div style="float:left;margin-left: 1%;position: absolute;top: 10px">
        <a class="easyui-linkbutton" onclick="viewAllAllocatedStudent()" href="javascript:void(0)"> 已分配学生
        </a>
    </div>
    <div style="position: absolute;top: 10px;right: 10%">
        <form id="searchForm">
            <span style="color: grey;">学生姓名:</span><input type="text" value="${name}" name="name"
                                                          class="easyui-textbox" id="name" placeholder="请输入学生姓名">

            <span style="color: grey;">学生学号:</span><input type="text" value="${no}" name="no"
                                                          class="easyui-textbox" id="no" placeholder="请输入学号">
            <a class="easyui-linkbutton" href="javascript:void(0)" onclick="searchFun()"
               data-options="iconCls:'icon-search'">查询</a>
            <a class="easyui-linkbutton" href="javascript:void(0)" onclick="cancelFun()"
               data-options="iconCls:'icon-clear'">清空</a>
        </form>

    </div>
</div>

<div id="content">
    <div class="easyui-layout" style="height: 100%;width: 100%;">
        <div data-options="region:'west',title:'老师',split:true" style="width: 50%">
            <table id="teacherGrid" style="width: 100%;height: 80%;"></table>
        </div>
        <div data-options="region:'center',title:'未分配学生',split:true">
            <table id="studentTable" style="height: 80%;width: 100%;"></table>
        </div>
    </div>
</div>
</body>
</html>
