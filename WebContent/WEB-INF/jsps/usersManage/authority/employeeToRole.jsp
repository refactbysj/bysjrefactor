<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<html>
<head>
    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
    <script type="text/javascript">

        var employeeGrid;
        //根据用户的角色获取请求的链接
        function getUrlByRole() {
            var url = '';
            <!-- 最高角色是研室主任 -->
            <sec:authorize ifAnyGranted="ROLE_DEPARTMENT_DIRECTOR" ifNotGranted="ROLE_SCHOOL_ADMIN,ROLE_COLLEGE_ADMIN">
            url = "${basePath}usersManage/department/employeeToRole.html";
            </sec:authorize>

            <!-- 最高角色是院级管理员 -->
            <sec:authorize ifAnyGranted="ROLE_SCHOOL_ADMIN" ifNotGranted="ROLE_COLLEGE_ADMIN">
            url = "${basePath}usersManage/school/employeeToRole.html";
            </sec:authorize>

            <!-- 最高角色是校级管理员 -->
            <sec:authorize ifAnyGranted="ROLE_COLLEGE_ADMIN">
            url = "${basePath}usersManage/college/employeeToRole.html";
            </sec:authorize>
            return url;
        }

        //设置角色
        function setRole(id) {
            parent.$.modalDialog({
                href: '${basePath}authority/setEmployeeToRole.html?employeeId=' + id,
                modal: true,
                width: '50%',
                height: '50%',
                title: '角色分配',
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
                        var f = parent.$.modalDialog.handler.find("#roleForm");
                        f.submit();
                    }
                }]
            })
        }

        $(function () {
            var url = getUrlByRole();
            employeeGrid = $("#employeeGrid").datagrid({
                url: url,
                striped: true,
                fit: true,
                singleSelect: true,
                pagination: true,
                columns: [[{
                    title: '教师姓名',
                    field: 'name',
                    width: '10%'
                }, {
                    title: '职工号',
                    field: 'no',
                    width: '10%'
                }, {
                    title: '性别',
                    field: 'sex',
                    width: '5%'
                }, {
                    title: '现有角色',
                    field: 'roles',
                    width: '60%',
                    formatter: function (value, row) {
                        var str = '';
                        var roles = row.user.userRole;
                        for (var index in roles) {
                            str += roles[index].role.description + ",";
                        }
                        str = str.substring(0, str.length - 1);
                        return str;
                    }
                }, {
                    title: '操作',
                    field: 'action',
                    width: '10%',
                    formatter: function (value, row) {
                        return $.formatString('<a class="setRoleBtn" href="javascript:void(0)" onclick="setRole(\'{0}\')"></a>', row.id);
                    }
                }]],
                onLoadSuccess: function () {
                    $(".setRoleBtn").linkbutton({text: '设置', plain: true, iconCls: 'icon-edit'});
                }
            })
        });

        function searchFun() {
            $("#employeeGrid").datagrid('load', $.serializeObject($("#searchForm")));
        }

        function clearFun() {
            $("#searchForm input").val('');
            $("#employeeGrid").datagrid('load', {});
        }
    </script>
</head>
<body>

<div style="position: absolute;top: 10px;right: 5%;">
    <form id="searchForm" method="get">
        <span>教师姓名：</span> <input type="text"
                                  class="easyui-textbox " id="employeeName" name="name">
        <span>职工号：</span> <input type="text"
                                 class="easyui-textbox " id="employeeNo" name="no">
        <%--<sec:authorize ifAnyGranted="ROLE_COLLEGE_ADMIN">
            <select class="easyui-combobox" id="schoolSelect" name="schoolSelect"
                    onchange="schoolOnSelect()">
                    &lt;%&ndash;需要从后台传递一个schoolList的参数，里面存放了所有的学院&ndash;%&gt;
                <option value="0">--请选择学院--</option>
                <c:forEach items="${schoolList}" var="school">
                    <option value="${school.id }" class="selectSchool">${school.description}</option>
                </c:forEach>
            </select>
            <select class="easyui-combobox " id="departmentSelect"
                    style="width: 150px" name="departmentSelect"></select>
        </sec:authorize>
        <sec:authorize ifAnyGranted="ROLE_SCHOOL_ADMIN"
                       ifNotGranted="ROLE_COLLEGE_ADMIN">
            <select name="departmentSelect" class="easyui-combobox">
                <option value="0">--请选择教研室--</option>
                <c:forEach items="${departmentList}" var="department">
                    <option value="${department.id}">${department.description}</option>
                </c:forEach>
            </select>
        </sec:authorize>--%>
        <a href="javascript:void(0)" onclick="searchFun()" class="easyui-linkbutton"
           data-options="iconCls:'icon-search'">查询</a>
        <a href="javascript:void(0)" onclick="clearFun()" class="easyui-linkbutton" data-options="iconCls:'icon-clear'">清空</a>
    </form>
    <br> <br>
</div>
<div style="height: 100%;">
    <table id="employeeGrid"></table>
</div>


</body>
</html>
