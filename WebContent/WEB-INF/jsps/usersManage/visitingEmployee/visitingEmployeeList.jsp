<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<html>
<head>
    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
    <script type="text/javascript">
        var visitingGrid;
        function deleteVisitingEmployee(visitingEmployeeId) {
            $.messager.confirm('询问？','确认删除？',function (t) {
                if(t) {
                    progressLoad();
                    $.ajax({
                        url: '${basePath}usersManage/visitingEmployeeDelete.html',
                        type: 'GET',
                        dataType: 'json',
                        data: {"visitingEmployeeId": visitingEmployeeId},
                        success: function (result) {
                            progressClose();
                            if(result.success) {
                                $("#visitingTable").datagrid('reload');
                                $.messager.alert('提示', result.msg, 'info');
                            }else{
                                $.messager.alert('提示', result.msg, 'warning');
                            }
                            return true;
                        }
                    });
                }
            });
        }
        //添加或修改
        function addOrEditFun(id) {
            var title = '';
            var url = '';
            if(id==null||id=='') {
                url = getAddUrlByRole();
                title = '添加教师';
            }else{
                url = getEditUrlByRole()+'?visitingEmployeeId='+id;
                title='修改教师';
            }
            parent.$.modalDialog({
                href:url,
                title:title,
                model:true,
                width:'60%',
                height:'70%',
                buttons:[{
                    text:'取消',
                    iconCls:'icon-cancel',
                    handler:function () {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                },{
                    text:'提交',
                    iconCls:'icon-ok',
                    handler:function () {
                        parent.$.modalDialog.visitingGrid = visitingGrid;
                        var f = parent.$.modalDialog.handler.find("#editForm");
                        f.submit();
                    }
                }]
            })
        }

        function resetPassword(visitingEmployeeId) {
            //var confirmReset =window.confirm("确认重置？");
            $.messager.confirm('询问？','确认重置？',function (t) {
                if(t) {
                    progressLoad();
                    $.ajax({
                        url: '${basePath}usersManage/resetVisitingEmployeePassword.html',
                        type: 'GET',
                        dataType: 'json',
                        data: {"visitingEmployeeId": visitingEmployeeId},
                        success: function (result) {
                            progressClose();
                            if(result.success) {
                                $("#visitingTable").datagrid('reload');
                                $.messager.alert('提示', result.msg, 'info');
                            }else{
                                $.messager.alert('提示', result.msg, 'warning');
                            }
                            return true;
                        }
                    });
                }
            })


        }

        function searchFun() {
            $("#visitingTable").datagrid('load', $.serializeObject($("#searchForm")));
        }


        function getUrlByRole() {
            var getUrl = '';
            /*教研室主任角色*/
            <sec:authorize ifAnyGranted="ROLE_DEPARTMENT_DIRECTOR"
                       ifNotGranted="ROLE_SCHOOL_ADMIN,ROLE_COLLEGE_ADMIN">
            getUrl = '${basePath}usersManage/department/searchVisitingEmployee.html';
            </sec:authorize>
            /*院级管理员角色 */
            <sec:authorize ifAnyGranted="ROLE_SCHOOL_ADMIN"
                           ifNotGranted="ROLE_COLLEGE_ADMIN">
            getUrl = '${basePath}usersManage/school/searchVisitingEmployee.html';
            </sec:authorize>
            /*校级管理员*/
            <sec:authorize ifAnyGranted="ROLE_COLLEGE_ADMIN">
            getUrl = '${basePath}usersManage/college/searchVisitingEmployee.html';
            </sec:authorize>
            return getUrl;
        }

        function getEditUrlByRole() {
            var editUrl = '';
            /*教研室主任角色*/
            <sec:authorize ifAnyGranted="ROLE_DEPARTMENT_DIRECTOR"
                       ifNotGranted="ROLE_SCHOOL_ADMIN,ROLE_COLLEGE_ADMIN">
            editUrl = '${basePath}usersManage/department/visitingEmployeeEdit.html';
            </sec:authorize>
            /*院级管理员角色 */
            <sec:authorize ifAnyGranted="ROLE_SCHOOL_ADMIN"
                           ifNotGranted="ROLE_COLLEGE_ADMIN">
            editUrl = '${basePath}usersManage/school/visitingEmployeeEdit.html';
            </sec:authorize>
            /*校级管理员*/
            <sec:authorize ifAnyGranted="ROLE_COLLEGE_ADMIN">
            editUrl = '${basePath}usersManage/college/visitingEmployeeEdit.html';
            </sec:authorize>
            return editUrl;
        }

        function getAddUrlByRole() {
            var addUrl = '';
            /*教研室主任角色*/
            <sec:authorize ifAnyGranted="ROLE_DEPARTMENT_DIRECTOR"
                       ifNotGranted="ROLE_SCHOOL_ADMIN,ROLE_COLLEGE_ADMIN">
            addUrl = '${basePath}usersManage/department/visitingEmployeeAdd.html';
            </sec:authorize>
            /*院级管理员角色 */
            <sec:authorize ifAnyGranted="ROLE_SCHOOL_ADMIN"
                           ifNotGranted="ROLE_COLLEGE_ADMIN">
            addUrl = '${basePath}usersManage/school/visitingEmployeeAdd.html';
            </sec:authorize>
            /*校级管理员*/
            <sec:authorize ifAnyGranted="ROLE_COLLEGE_ADMIN">
            addUrl = '${basePath}usersManage/college/visitingEmployeeAdd.html';
            </sec:authorize>
            return addUrl;
        }

        $(function () {

            visitingGrid = $("#visitingTable").datagrid({
                url: getUrlByRole(),
                pagination: true,
                singleSelect: true,
                striped: true,
                fit: true,
                columns: [[{
                    title: '教师姓名',
                    field: 'name',
                    width: '8%'
                }, {
                    title: '职工号',
                    field: 'no',
                    width: '10%'
                }, {
                    title: '性别',
                    field: 'sex',
                    width: '5%'
                }, {
                    title: '所属教研室',
                    field: 'department',
                    width: '15%',
                    formatter: function (value, row) {
                        if (row.department != null) {
                            return row.department.description;
                        }
                    }
                }, {
                    title: '所属公司',
                    field: 'company',
                    width: '18%'
                }, {
                    title: '职位',
                    field: 'proTitle',
                    width: '8%',
                    formatter: function (value, row) {
                        if (row.proTitle != null) {
                            return row.proTitle.description;
                        }
                    }
                }, {
                    title: '学位',
                    field: 'degree',
                    width: '8%',
                    formatter: function (value, row) {
                        if (row.degree != null) {
                            return row.degree.description;
                        }
                    }
                }, {
                    title: '电话',
                    field: 'mobile',
                    width: '8%',
                    formatter: function (value, row) {
                        if (row.contact != null) {
                            return row.contact.moblie;
                        }
                    }
                }, {
                    title: '操作',
                    field: 'action',
                    width: '20%',
                    formatter: function (value, row) {
                        var str = '';
                        str += $.formatString('<a href="javascript:void(0)" class="delBtn" onclick="deleteVisitingEmployee(\'{0}\')"></a>', row.id);
                        str += $.formatString('<a href="javascript:void(0)" class="editBtn" onclick="addOrEditFun(\'{0}\')"></a>', row.id);
                        str += $.formatString('<a href="javascript:void(0)" class="viewBtn" onclick="resetPassword(\'{0}\')"></a>', row.id);
                        return str;
                    }
                }]],
                onLoadSuccess:function () {
                    $(".delBtn").linkbutton({text: '删除', iconCls: 'icon-cancel', plain: true});
                    $(".editBtn").linkbutton({text: '修改', iconCls: 'icon-edit', plain: true});
                    $(".viewBtn").linkbutton({text: '重置密码', iconCls: 'icon-reload', plain: true});
                }
            })
        });

    </script>

</head>
<body>
<div style="position: absolute;top: 10px;">
    <a href="javascript:void(0)" style="margin-left: 10px;" onclick="addOrEditFun()" class="easyui-linkbutton" iconCls="icon-add">添加新教师</a>
    <form method="post" style="display: inline" id="searchForm">
        教师姓名 <input type="text" class="easyui-textbox" name="name" placeholder="请输入教师姓名">
        职工号 <input type="text" class="easyui-textbox" name="no" placeholder="请输入职工号">
        <sec:authorize ifAnyGranted="ROLE_COLLEGE_ADMIN">
            学院
            <select  id="schoolSelect" name="schoolId"
                    onchange="schoolOnSelect()">
                <option value="0">--请选择学院--</option>
                <c:forEach items="${schoolList}" var="school">
                    <option value="${school.id }" class="selectSchool">${school.description}</option>
                </c:forEach>
            </select>
            教研室
            <select id="departmentSelect" name="departmentId"></select>
        </sec:authorize>
        <sec:authorize ifAnyGranted="ROLE_SCHOOL_ADMIN"
                       ifNotGranted="ROLE_COLLEGE_ADMIN">
            教研室
            <select name="departmentId">
                <option value="0">--请选择教研室--</option>
                <c:forEach items="${departments}" var="department">
                    <option value="${department.id}">${department.id}</option>
                </c:forEach>
            </select>
        </sec:authorize>
        <a href="javascript:void(0)" onclick="searchFun()" class="easyui-linkbutton" iconCls="icon-search">查询</a>
    </form>
</div>

<div style="height: 100%;">
    <table id="visitingTable" style="height: 100%"></table>

</div>


</body>
</html>
