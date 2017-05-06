<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<html>
<head>
    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
    <script type="text/javascript">
        var employeeGrid;
        $(function () {
            var url = '';
            <%--最高角色是研室主任--%>
            <sec:authorize ifAnyGranted="ROLE_DEPARTMENT_DIRECTOR" ifNotGranted="ROLE_SCHOOL_ADMIN,ROLE_COLLEGE_ADMIN">
            url = "${basePath}usersManage/department/employee.html";
            </sec:authorize>


            <%--最高角色是院级管理员--%>
            <sec:authorize ifAnyGranted="ROLE_SCHOOL_ADMIN" ifNotGranted="ROLE_COLLEGE_ADMIN">
            url = "${basePath}usersManage/school/employee.html";
            </sec:authorize>

            <%--最高角色是校级管理员--%>
            <sec:authorize ifAnyGranted="ROLE_COLLEGE_ADMIN">
            url = "${basePath}usersManage/college/employee.html";
            </sec:authorize>
            employeeGrid = $("#employeeGrid").datagrid({
                url: url,
                fit: true,
                singleSelect: true,
                pagination: true,
                striped: true,
                columns: [[{
                    title: '职工',
                    width: '10%',
                    field: 'no'
                }, {
                    title: '姓名',
                    width: '10%',

                    field: 'name'
                }, {
                    title: '性别',
                    width: '5%',

                    field: 'sex'
                }, {
                    title: '职称',
                    width: '10%',

                    field: 'proTitle',
                    formatter: function (value, row) {
                        if (row.proTitle != null) {
                            return row.proTitle.description;
                        } else {
                            return '';
                        }
                    }
                }, {
                    title: '所属教研室',
                    field: 'department',
                    width: '10%',

                    formatter: function (value, row) {
                        if (row.department != null) {
                            return row.department.description;

                        } else {
                            return '';
                        }
                    }
                }, {
                    title: '联系电话',
                    width: '13%',

                    field: 'contact',
                    formatter: function (value, row) {
                        if (row.contact != null) {
                            return row.contact.moblie;
                        } else {
                            return '';
                        }
                    }
                }, {
                    title: '学位',
                    width: '10%',

                    field: 'degree',
                    formatter: function (value, row) {
                        if (row.degree != null) {
                            return row.degree.description;
                        } else {
                            return '';
                        }
                    }
                }, {
                    title: '操作',
                    width: '18%',

                    field: 'action',
                    formatter: function (value, row) {
                        var str = '';
                        <sec:authorize ifAnyGranted="ROLE_SCHOOL_ADMIN,ROLE_COLLEGE_ADMIN">
                        str += $.formatString('<a href="javascript:void(0)" class="editBtn" onclick="editFun(\'{0}\')"></a>', row.id);
                        str += $.formatString('<a href="javascript:void(0)" class="delBtn" onclick="deleteEmployee(\'{0}\')"></a>', row.id);
                        </sec:authorize>
                        str += $.formatString('<a href="javascript:void(0)" class="resetBtn" onclick="resetPassword(\'{0}\')"></a>', row.id);
                        return str;
                    }
                }]],
                onLoadSuccess: function () {
                    $(".editBtn").linkbutton({text: '修改', iconCls: 'icon-edit', plain: true});
                    $(".delBtn").linkbutton({text: '删除', iconCls: 'icon-cancel', plain: true});
                    $(".resetBtn").linkbutton({text: '重置密码', iconCls: 'icon-refresh', plain: true});
                }

            })
        });

        //修改
        function getEditUrl(id) {
            <sec:authorize ifAnyGranted="ROLE_DEPARTMENT_DIRECTOR"
                            ifNotGranted="ROLE_SCHOOL_ADMIN,ROLE_COLLEGE_ADMIN">
            return "${basePath}usersManage/department/employeeEdit.html?employeeId="+id;
            </sec:authorize>
            <sec:authorize ifAnyGranted="ROLE_SCHOOL_ADMIN"
                           ifNotGranted="ROLE_COLLEGE_ADMIN">
            return "${basePath}usersManage/school/employeeEdit.html?employeeId="+id;
            </sec:authorize>
            <sec:authorize ifAnyGranted="ROLE_COLLEGE_ADMIN">
            return "${basePath}usersManage/college/employeeEdit.html?employeeId="+id;
            </sec:authorize>
        }

        //添加
        function getAddUrl() {
            <sec:authorize ifAnyGranted="ROLE_DEPARTMENT_DIRECTOR"
                            ifNotGranted="ROLE_SCHOOL_ADMIN,ROLE_COLLEGE_ADMIN">
            return "${basePath}usersManage/department/employeeAdd.html";
            </sec:authorize>
            <sec:authorize ifAnyGranted="ROLE_SCHOOL_ADMIN"
                           ifNotGranted="ROLE_COLLEGE_ADMIN">
            return "${basePath}usersManage/school/employeeAdd.html";
            </sec:authorize>
            <sec:authorize ifAnyGranted="ROLE_COLLEGE_ADMIN">
            return "${basePath}usersManage/college/employeeAdd.html";
            </sec:authorize>
        }

        //修改或添加
        function editFun(id) {
            var title = '';
            var url = '';
            if (id == null || id == '') {
                url = getAddUrl();
                title = '添加教师';
            }else{
                url = getEditUrl(id);
                title = '修改教师';
            }
            parent.$.modalDialog({
                href:url,
                title:title,
                modal: true,
                width: '50%',
                height: '55%',
                buttons: [{
                    text: '取消',
                    iconCls: 'icon-cancel',
                    handler: function () {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                }, {
                    text: '提交',
                    iconCls: 'icon-ok',
                    handler: function () {
                        parent.$.modalDialog.employeeGrid = employeeGrid;
                        var f = parent.$.modalDialog.handler.find("#editForm");
                        f.submit();
                    }
                }]
            })
        }

        //导入教师
        function importFun() {
            parent.$.modalDialog({
                href:'${basePath}import/upLoadEmployee.html',
                title:'导入教师',
                modal: true,
                width: '30%',
                height: '40%',
                buttons: [{
                    text: '取消',
                    iconCls: 'icon-cancel',
                    handler: function () {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                }, {
                    text: '导入',
                    iconCls: 'icon-ok',
                    handler: function () {
                        parent.$.modalDialog.employeeGrid = employeeGrid;
                        var f = parent.$.modalDialog.handler.find("#importForm");
                        f.submit();
                    }
                }]
            })
        }


        //删除教师
        function deleteEmployee(employeeId) {
            $.messager.confirm('询问','确认删除？',function (t) {
                if(t) {
                    progressLoad();
                    $.ajax({
                        url: '${basePath}usersManage/employeeDelete.html',
                        type: 'GET',
                        dataType: 'json',
                        data: {"employeeId": employeeId},
                        success: function (result) {
                            progressClose();

                            if(result.success) {
                                $("#employeeGrid").datagrid('reload');
                                $.messager.alert('提示', result.msg, 'info');
                            }else{
                                $.messager.alert('提示', result.msg, 'warning');
                            }
                        },
                        error: function () {
                            progressClose();
                            $.messager.alert('错误', '网络错误，请联系管理员', 'error');
                            return false;
                        }
                    });
                }
            })
        }

        //重置密码
        function resetPassword(employeeId) {
            $.messager.confirm('询问','确认重置？',function (t) {
                if(t) {
                    progressLoad();
                    $.ajax({
                        url: '${basePath}usersManage/resetpassWord.html',
                        type: 'GET',
                        dataType: 'json',
                        data: {"employeeId": employeeId},
                        success: function (result) {
                            progressClose();
                            if(result.success) {
                                $("#employeeGrid").datagrid('reload');
                                $.messager.alert('提示', result.msg, 'info');
                            }else{
                                $.messager.alert('提示', result.msg, 'warning');
                            }
                        },
                        error: function () {
                            progressClose();
                            $.messager.alert('错误', '网络错误，请联系管理员', 'error');
                            return false;
                        }
                    });
                }
            })

        }

        function searchFun() {
            $("#employeeGrid").datagrid('load', $.serializeObject($("#searchForm")));
        }

        function clearFun() {
            $("#searchForm input").val('');
            $("#schoolSelect").val(0);
            $("#departmentSelect").empty();
            $("#employeeGrid").datagrid('load', {});
        }

    </script>

</head>
<body>

<div style="position: absolute;top: 10px;">

    <form id="searchForm">
        <a class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="editFun()">添加新教师</a>
        <a class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="importFun()">导入教师Excel</a>
        教师姓名<input class="easyui-textbox" style="width: 9%;" type="text" id="name" data-options="" name="name">
        职工号<input class="easyui-textbox" style="width: 9%;" type="text" id="title" name="no">
        <sec:authorize ifAnyGranted="ROLE_COLLEGE_ADMIN">
            学院
            <select id="schoolSelect" name="schoolId"
                    onchange="schoolOnSelect()">
                <option value="0">--请选择学院--</option>
                <c:forEach items="${schoolList}" var="school">
                    <option value="${school.id }" class="selectSchool">${school.description}</option>
                </c:forEach>
            </select>

            教研室
            <select id="departmentSelect"
                    name="departmentId"></select>
        </sec:authorize>
        <sec:authorize ifAnyGranted="ROLE_SCHOOL_ADMIN"
                       ifNotGranted="ROLE_COLLEGE_ADMIN">
            <select name="departmentId">
                <option value="0">-请选择教研室--</option>
                <c:forEach items="${departments}" var="department">
                    <option value="${department.id}">${department.description}</option>
                </c:forEach>
            </select>
        </sec:authorize>
        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="searchFun()">查询</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-clear'" onclick="clearFun()">清空</a>

    </form>

</div>
<div style="height: 100%;">
    <table id="employeeGrid" style="height: 100%;"></table>
</div>

</body>
</html>
