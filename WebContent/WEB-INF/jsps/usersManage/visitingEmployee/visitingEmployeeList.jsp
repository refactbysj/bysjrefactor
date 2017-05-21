<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<html>
<head>
    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
    <script type="text/javascript">
        var visitingGrid;
        function deleteVisitingEmployee(visitingEmployeeId) {
            //var confirmDelete =window.confirm("确认删除？");
            window.wxc.xcConfirm("确认删除？", "confirm", {
                onOk: function () {
                    $.ajax({
                        url: '/bysj3/usersManage/visitingEmployeeDelete.html',
                        type: 'GET',
                        dataType: 'json',
                        data: {"visitingEmployeeId": visitingEmployeeId},
                        success: function (data) {
                            $("#visitingEmployeeRow" + visitingEmployeeId).remove();
                            myAlert("删除成功");
                            return true;
                        },
                        error: function () {
                            myAlert("删除失败,请稍后再试");
                            return false;
                        }
                    });
                }
            });

        }
        function resetPassword(visitingEmployeeId) {
            //var confirmReset =window.confirm("确认重置？");
            window.wxc.xcConfirm("确认重置？", "confirm", {
                onOk: function () {
                    $.ajax({
                        url: '/bysj3/usersManage/resetVisitingEmployeePassword.html',
                        type: 'GET',
                        dataType: 'json',
                        data: {"visitingEmployeeId": visitingEmployeeId},
                        success: function (data) {
                            myAlert("重置成功");
                            return true;
                        },
                        error: function () {
                            myAlert("重置失败,请稍后再试");
                            return false;
                        }
                    });
                }
            });

        }


        function getUrlByRole() {
            var url = '';
            <sec:authorize ifAnyGranted="ROLE_DEPARTMENT_DIRECTOR"
                       ifNotGranted="ROLE_SCHOOL_ADMIN,ROLE_COLLEGE_ADMIN">
            url = '${basePath}usersManage/department/visitingEmployeeAdd.html';
            </sec:authorize>
            <sec:authorize ifAnyGranted="ROLE_SCHOOL_ADMIN"
                           ifNotGranted="ROLE_COLLEGE_ADMIN">
            url = '${basePath}usersManage/school/visitingEmployeeAdd.html';
            </sec:authorize>
            <sec:authorize ifAnyGranted="ROLE_COLLEGE_ADMIN">
            url = '${basePath}usersManage/college/visitingEmployeeAdd.html';
            </sec:authorize>
            return url;
        }

        $(function () {
            visitingGrid = $("#visitingTable").datagrid({
                url: '',
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
                    width: '10%',
                    formatter: function (value, row) {
                        var str = '';
                        str += $.formatString('<a href="javascript:void(0)" class="delBtn" onclick="delFun(\'{0}\')"></a>', row.id);
                        str += $.formatString('<a href="javascript:void(0)" class="editBtn" onclick="editFun(\'{0}\')"></a>', row.id);
                        str += $.formatString('<a href="javascript:void(0)" class="viewBtn" onclick="resetPassword(\'{0}\')"></a>', row.id);
                        return str;
                    }
                }]]
            })
        })
    </script>

</head>
<body>
    <div style="position: absolute;top: 10px;">
        <form action="${actionUrl}" method="post" class="form-inline">
            <div class="form-group">
                <label for="name">教师姓名</label> <input type="text"
                                                      class="form-control " name="name" placeholder="请输入教师姓名">
            </div>
            <div class="form-group">
                <label for="title">职工号</label> <input type="text"
                                                      class="form-control " name="no" placeholder="请输入职工号">
            </div>
            <sec:authorize ifAnyGranted="ROLE_COLLEGE_ADMIN">
                <div class="form-group">
                    <label for="name">学院</label>
                    <select class="form-control" id="schoolSelect" name="schoolId"
                            onchange="schoolOnSelect()">
                        <option value="0">--请选择学院--</option>
                        <c:forEach items="${schoolList}" var="school">
                            <option value="${school.id }" class="selectSchool">${school.description}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="name">教研室</label>
                    <select class="form-control " id="departmentSelect" name="departmentId"></select>
                </div>
            </sec:authorize>
            <sec:authorize ifAnyGranted="ROLE_SCHOOL_ADMIN"
                           ifNotGranted="ROLE_COLLEGE_ADMIN">
                <div class="form-group">
                    <label for="name">教研室</label>
                    <select name="departmentId">
                        <option value="0">--请选择教研室--</option>
                        <c:forEach items="${departments}" var="department">
                            <option value="${department.id}">${department.id}</option>
                        </c:forEach>
                    </select>
                </div>
            </sec:authorize>
            <button type="submit" class="btn btn-default ">查询</button>
        </form>
    </div>

    <div style="height: 100%;">
        <table id="visitingTable" style="height: 100%"></table>

    </div>


</body>
</html>
