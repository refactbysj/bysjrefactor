<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<html>
<head>
    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
    <script type="text/javascript">

        var studentGrid;

        $(function () {
            var url = getListUrl();
            studentGrid = $("#studentGrid").datagrid({
                url:url,
                pagination:true,
                fit:true,
                striped:true,
                singleSelect:true,
                columns:[[{
                    title:'学号',
                    width:'10%',
                    field:'no'
                },{
                    title:'姓名',
                    width:'8%',
                    field:'name'
                },{
                    title:'班级',
                    width:'10%',
                    field:'studentClass',
                    formatter:function (value, row) {
                        if(row.studentClass!=null) {
                            return row.studentClass.description;
                        }
                    }
                },{
                    title:'所属教研室',
                    width:'15%',
                    field:'departmentName',
                    formatter:function (value, row) {
                        if(row.studentClass!=null) {
                            return row.studentClass.major.department.description;
                        }
                    }
                },{
                    title:'联系电话',
                    width:'10%',
                    field:'phone',
                    formatter:function (value, row) {
                        if(row.contact!=null) {
                            return row.contact.moblie;
                        }else{
                            return '';
                        }
                    }
                },{
                    title:'操作',
                    width:'22%',
                    field:'action',
                    formatter:function (value, row) {
                        var str = '';
                        str += $.formatString('<a href="javascript:void(0)" class="delBtn" onclick="delFun(\'{0}\')"></a>', row.id);
                        str += $.formatString('<a href="javascript:void(0)" class="editBtn" onclick="addOrEdit(\'{0}\')"></a>', row.id);
                        str += $.formatString('<a href="javascript:void(0)" class="resetBtn" onclick="resetPasswordFun(\'{0}\')"></a>', row.id);
                        return str;
                    }
                }]],
                onLoadSuccess:function () {
                    $(".delBtn").linkbutton({text: '删除', iconCls: 'icon-cancel', plain: true});
                    $(".editBtn").linkbutton({text: '修改', iconCls: 'icon-edit', plain: true});
                    $(".resetBtn").linkbutton({text: '重置密码', iconCls: 'icon-refresh', plain: true});
                }
            })
        });

        function getListUrl() {
            <!-- 最高角色是研室主任 -->
            <sec:authorize ifAnyGranted="ROLE_DEPARTMENT_DIRECTOR" ifNotGranted="ROLE_SCHOOL_ADMIN,ROLE_COLLEGE_ADMIN">
            return "${basePath}usersManage/department/student.html";
            </sec:authorize>

            <!-- 最高角色是院级管理员 -->
            <sec:authorize ifAnyGranted="ROLE_SCHOOL_ADMIN" ifNotGranted="ROLE_COLLEGE_ADMIN">
            return "${basePath}usersManage/school/student.html";
            </sec:authorize>

            <!-- 最高角色是校级管理员 -->
            <sec:authorize ifAnyGranted="ROLE_COLLEGE_ADMIN">
            return "${basePath}usersManage/college/student.html";
            </sec:authorize>

        }

        //根据角色获取添加的路径
        function getAddUrl() {
            <!-- 最高角色是研室主任 -->
            <sec:authorize ifAnyGranted="ROLE_DEPARTMENT_DIRECTOR" ifNotGranted="ROLE_SCHOOL_ADMIN,ROLE_COLLEGE_ADMIN">
            return "${basePath}usersManage/department/studentAdd.html";
            </sec:authorize>

            <!-- 最高角色是院级管理员 -->
            <sec:authorize ifAnyGranted="ROLE_SCHOOL_ADMIN" ifNotGranted="ROLE_COLLEGE_ADMIN">
            return "${basePath}usersManage/school/studentAdd.html";
            </sec:authorize>

            <!-- 最高角色是校级管理员 -->
            <sec:authorize ifAnyGranted="ROLE_COLLEGE_ADMIN">
            return "${basePath}usersManage/college/studentAdd.html";
            </sec:authorize>
        }

        //根据角色获取修改的路径
        function getEditUrl(id) {
            <!-- 最高角色是研室主任 -->
            <sec:authorize ifAnyGranted="ROLE_DEPARTMENT_DIRECTOR" ifNotGranted="ROLE_SCHOOL_ADMIN,ROLE_COLLEGE_ADMIN">
            return "${basePath}usersManage/department/studentEdit.html?studentId="+id;
            </sec:authorize>

            <!-- 最高角色是院级管理员 -->
            <sec:authorize ifAnyGranted="ROLE_SCHOOL_ADMIN" ifNotGranted="ROLE_COLLEGE_ADMIN">
            return "${basePath}usersManage/school/studentEdit.html?studentId="+id;
            </sec:authorize>

            <!-- 最高角色是校级管理员 -->
            <sec:authorize ifAnyGranted="ROLE_COLLEGE_ADMIN">
            return "${basePath}usersManage/college/studentEdit.html?studentId="+id;
            </sec:authorize>
        }


        //添加或修改
        function addOrEdit(id) {
            var url = '';
            var title = '';
            if(id==null){
                url = getAddUrl();
                title = '添加学生';
            }else{
                url = getEditUrl(id);
                title = '修改学生';
            }
            parent.$.modalDialog({
                href:url,
                modal:true,
                title:title,
                width:'50%',
                height:'50%',
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
                        parent.$.modalDialog.studentGrid = studentGrid;
                        var f = parent.$.modalDialog.handler.find('#editForm');
                        f.submit();
                    }
                }]
            })
        }

        function importStudent() {
            parent.$.modalDialog({
                href:'${basePath}import/upLoadStudent.html',
                modal:true,
                title:'导入学生',
                width:'30%',
                height:'40%',
                buttons:[{
                    text:'取消',
                    iconCls:'icon-cancel',
                    handler:function () {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                },{
                    text:'导入',
                    iconCls:'icon-ok',
                    handler:function () {
                        parent.$.modalDialog.studentGrid = studentGrid;
                        var f = parent.$.modalDialog.handler.find('#importForm');
                        f.submit();
                    }
                }]
            })
        }

        //查询
        function searchFun() {
            $("#studentGrid").datagrid('load', $.serializeObject($("#searchForm")));
        }

        //清空查询条件
        function clearFun() {
            $("#searchForm input").val('');
            $("#schoolSelectModal").val(0);
            $("#departmentSelectModal").empty();
            $("#studentClassModal").empty();
            $("#studentGrid").datagrid('load', {});
        }


        //删除学生
        function delFun(id) {
            $.messager.confirm('询问','确认删除？',function (t) {
                if(t) {
                    progressLoad();
                    $.ajax({
                        url: '${basePath}usersManage/deleteStudent.html',
                        type: 'GET',
                        dataType: 'json',
                        data: {"studentId": id},
                        success: function (result) {
                            progressClose();
                            if(result.success) {
                                $("#studentGrid").datagrid('reload');
                                $.messager.alert('提示', result.msg, 'info');
                            }else{
                                $.messager.alert('提示', result.msg, 'warning');
                            }
                            return true;
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
        function resetPasswordFun(id) {
            $.messager.confirm('询问','确认重置？',function (t) {
                if(t) {
                    progressLoad();
                    $.ajax({
                        url: '${basePath}usersManage/resetPassword.html?',
                        type: 'GET',
                        dataType: 'json',
                        data: {"studentId": id},
                        success: function (result) {
                            progressClose();
                            if(result.success) {
                                $("#studentGrid").datagrid('reload');
                                $.messager.alert('提示', result.msg, 'info');
                            }else{
                                $.messager.alert('提示', result.msg, 'warning');
                            }
                            return true;
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


    </script>
</head>
<body >

    <div style="position: absolute;top: 10px;">
        <form  id="searchForm">

            <a class="easyui-linkbutton" onclick="addOrEdit()" data-options="iconCls:'icon-add'"> 添加新学生</a>
            <a class="easyui-linkbutton" href="javascript:void(0)" data-options="iconCls:'icon-add'" onclick="importStudent()">导入学生Excel</a>
                学生姓名<input type="text" style="width: 6%;" class="easyui-textbox " id="name" name="name">
                学号 <input type="text" style="width: 9%;"  class="easyui-textbox" id="stuNum" name="no">
            <sec:authorize ifAnyGranted="ROLE_COLLEGE_ADMIN">
                <%--需要从后台传递一个schoolList的参数，里面存放了所有的学院--%>
                <select id="schoolSelectModal"
                        name="schoolSelect" onchange="schoolOnSelectModal()">
                    <option value="0">--请选择学院--</option>
                    <c:forEach items="${schoolList}" var="school">
                        <option value="${school.id }" class="selectSchool">${school.description}</option>
                    </c:forEach>
                </select>
                <select id="departmentSelectModal"
                        name="departmentSelect" onchange="departmentOnSelectModal()">

                </select>
                <select id="studentClassModal"
                        name="studentClassSelect">
                    <c:forEach items="${studentClassList}" var="studentClass">
                        <option value="${studentClass.id }">${studentClass.description}</option>
                    </c:forEach>
                </select>
            </sec:authorize>
            <sec:authorize ifAnyGranted="ROLE_SCHOOL_ADMIN"
                           ifNotGranted="ROLE_COLLEGE_ADMIN">
                <select id="departmentSelect"
                        name="departmentSelect" onchange="departmentOnSelect()">
                        <%--需要从后台传递一个departmentList的参数，里面存放了当前用户所在学院的所有教研室--%>
                    <option value="0">--请选择教研室--</option>
                    <c:forEach items="${departmentList}" var="department">
                        <option value="${department.id}" class="selectDepartment">${department.description}</option>
                    </c:forEach>
                </select>
                <select  id="studentClass"
                        name="studentClassSelect">

                </select>
            </sec:authorize>
            <sec:authorize ifAnyGranted="ROLE_DEPARTMENT_DIRECTOR"
                           ifNotGranted="ROLE_SCHOOL_ADMIN,ROLE_COLLEGE_ADMIN">
                <select  id="studentClass"
                        name="studentClassId">
                    <option value="0">--请选择班级--</option>
                    <c:forEach items="${majorList}" var="major">
                        <c:forEach items="${major.studentClass}" var="studentClass">
                            <option value="${studentClass.id}">${studentClass.description}</option>
                        </c:forEach>
                    </c:forEach>
                </select>
            </sec:authorize>
            <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="searchFun()">查询</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-clear'" onclick="clearFun()">清空</a>
        </form>
    </div>

    <div style="height: 100%;">
        <table id="studentGrid" style="height: 100%;"></table>
        <%--<table
                class="table table-striped table-bordered table-hover datatable">
            <thead>
            <tr>
                <th>学号</th>
                <th>姓名</th>
                <th>班级</th>
                <th>所属教研室</th>
                <th>联系电话</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty studentList}">
                    <div class="alert alert-warning alert-dismissable" role="alert">
                        <button class="close" type="button" data-dismiss="alert">&times;</button>
                        没有数据
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${studentList}" var="student">
                        <tr id="studentRow${student.id}">
                            <td id="studentNo${student.id}">${student.no}</td>
                            <td id="studentName${student.id}">${student.name}</td>
                            <td id="studentClass${student.id}">${student.studentClass.description}</td>
                            <td id="studentDepartment${student.id }">${student.studentClass.major.department.description}</td>
                            <td id="studentMoblie${student.id }">${student.contact.moblie}</td>
                            <td><a class="btn btn-danger btn-xs"
                                   onclick="deleteStudent(${student.id})">删除</a> <a
                                    href="/bysj3/usersManage/${edit}/studentEdit.html?studentId=${student.id}"
                                    class="btn btn-warning btn-xs" data-toggle="modal"
                                    data-target="#addOrEditStudent"> <i class="icon-edit"></i>
                                修改
                            </a> <a class="btn btn-success btn-xs" onclick="resetPassword(${student.id})">
                                <i class="icon-lock"></i> 重置密码
                            </a></td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>

            </tbody>
        </table>--%>
    </div>


</body>
</html>
