<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<html>
<head>
    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
    <script type="text/javascript">

        $(function () {
            var url = '';
            <sec:authorize ifAllGranted="ROLE_DEPARTMENT_DIRECTOR" ifNotGranted="ROLE_DEAN">
            url = 'getTaskDocsByDirector.html';
            </sec:authorize>
            <!-- 拥有院长角色，但不拥有教研室主任角色 -->
            <sec:authorize ifAllGranted="ROLE_DEAN" ifNotGranted="ROLE_DEPARTMENT_DIRECTOR">
            url = 'getTaskDocsByDean.html';
            </sec:authorize>
            <!-- 同时拥有教研室主任和院长角色 -->
            <sec:authorize ifAllGranted="ROLE_DEAN,ROLE_DEPARTMENT_DIRECTOR">
            url = 'getTaskDocsByDirectorAndDean.html';
            </sec:authorize>

            $("#taskGrid").datagrid({
                url: url,
                striped: true,
                fit: true,
                idField: 'id',
                pagination: true,
                singleSelect: true,
                columns: [[{
                    title: '题目(副标题)',
                    field: 'title',
                    width: '40%',
                    formatter: function (value, row) {
                        if (row.subTitle == null||row.subTitle=='') {
                            return row.title;
                        } else {
                            return row.title + "——" + row.subTitle;
                        }
                    }
                }, {
                    title: '指导老师',
                    field: 'proposer',
                    formatter: function (value, row) {
                        return row.proposer.name;
                    }
                }, {
                    title: '学生姓名',
                    field: 'name',
                    formatter: function (value, row) {
                        return row.student.name;
                    }
                }, {
                    title: '学号',
                    field: 'no',
                    formatter: function (value, row) {
                        return row.student.no;
                    }
                }, {
                    title: '班级',
                    field: 'student',
                    formatter: function (value, row) {
                        return row.student.studentClass.description;
                    }
                },
                    //教研室主任
                    <sec:authorize ifAllGranted="ROLE_DEPARTMENT_DIRECTOR" ifNotGranted="ROLE_DEAN">
                    {
                        title: '状态',
                        field: 'auditByDepartmentDirector',
                        formatter: function (value, row) {
                            if (row.taskDoc.auditByDepartmentDirector.approve) {
                                return '<span style="color:green">通过</span>';
                            } else {
                                return '<span style="color: red;">退回</span>';
                            }
                        }
                    },
                    </sec:authorize>
                    //院长
                    <sec:authorize ifAllGranted="ROLE_DEAN" ifNotGranted="ROLE_DEPARTMENT_DIRECTOR">
                    {
                        title: '状态',
                        field: 'auditByBean',
                        formatter: function (value, row) {
                            if (row.taskDoc.auditByBean.approve) {
                                return '<span style="color: green;">通过</span>';
                            } else {
                                return '<span style="color: red;">退回</span>';
                            }
                        }
                    },
                    </sec:authorize>
                    //院长、教研室主任
                    <sec:authorize ifAllGranted="ROLE_DEAN,ROLE_DEPARTMENT_DIRECTOR">
                    {
                        title: '教研室主任审核状态',
                        field: 'auditByDepartmentDirector',
                        formatter: function (value, row) {
                            if (row.taskDoc.auditByDepartmentDirector.approve) {
                                return '<span style="color:green">通过</span>';
                            } else {
                                return '<span style="color: red;">退回</span>';
                            }
                        }
                    }, {
                        title: '院长审核状态',
                        field: 'auditByBean',
                        formatter: function (value, row) {
                            if (row.taskDoc.auditByBean.approve) {
                                return '<span style="color: green;">通过</span>';
                            } else {
                                return '<span style="color: red;">退回</span>';
                            }
                        }
                    },
                    </sec:authorize>
                    {
                        title: '操作',
                        field: 'action',
                        width: '20%',
                        formatter: function (value, row) {
                            var str = '';
                            str += $.formatString('<a href="javascript:void(0)" class="detailBtn" data-options="iconCls:\'icon-more\'" onclick="showDetail(\'{0}\')"></a>', row.id);
                            //只拥有教研室主任角色
                            <sec:authorize ifAllGranted="ROLE_DEPARTMENT_DIRECTOR" ifNotGranted="ROLE_DEAN">
                            if (row.taskDoc.auditByDepartmentDirector.approve) {
                                str += $.formatString('<a href="javascript:void(0)" class="rejectBtn" data-options="iconCls:\'icon-ok\'" onclick="rejectTaskDoc(\'{0}\')"></a>', row.taskDoc.id);
                            } else {
                                str += $.formatString('<a href="javascript:void(0)" class="approveBtn" data-options="iconCls:\'icon-undo\'" onclick="approveTaskDoc(\'{0}\')"></a>', row.taskDoc.id);
                            }
                            </sec:authorize>
                            //只拥有院长角色
                            <sec:authorize ifAllGranted="ROLE_DEAN" ifNotGranted="ROLE_DEPARTMENT_DIRECTOR">
                            if (row.taskDoc.auditByBean.approve) {
                                str += $.formatString('<a href="javascript:void(0)" class="rejectBtn" data-options="iconCls:\'icon-ok\'" onclick="rejectTaskDoc(\'{0}\')"></a>', row.taskDoc.id);
                            } else {
                                str += $.formatString('<a href="javascript:void(0)" class="approveBtn" data-options="iconCls:\'icon-undo\'" onclick="approveTaskDoc(\'{0}\')"></a>', row.taskDoc.id);
                            }
                            </sec:authorize>
                            //同时拥有院长和教研室主任角色
                            <sec:authorize ifAllGranted="ROLE_DEAN,ROLE_DEPARTMENT_DIRECTOR">
                            if (row.taskDoc.auditByBean.approve) {
                                str += $.formatString('<a href="javascript:void(0)" class="rejectBtn" data-options="iconCls:\'icon-ok\'" onclick="rejectTaskDoc(\'{0}\')"></a>', row.taskDoc.id);
                            } else {
                                str += $.formatString('<a href="javascript:void(0)" class="approveBtn" data-options="iconCls:\'icon-undo\'" onclick="approveTaskDoc(\'{0}\')"></a>', row.taskDoc.id);
                            }
                            </sec:authorize>
                            return str;
                        }
                    }

                ]],
                onLoadSuccess: function () {
                    $(".detailBtn").linkbutton({text: '显示详情', iconCls: 'icon-more', plain: true});
                    $(".rejectBtn").linkbutton({text: '退回', iconCls: 'icon-back', plain: true});
                    $(".approveBtn").linkbutton({text: '通过', iconCls: 'icon-ok', plain: true});
                }
            });
        });

        //显示详情
        function showDetail(id) {
            var url = '${basePath}process/showDetail.html?graduateProjectId=' + id;
            showProjectDetail(url);
        }


        //通过任务书
        function approveTaskDoc(taskDocId) {
            var url = '';
            //只拥有教研室主任角色
            <sec:authorize ifAllGranted="ROLE_DEPARTMENT_DIRECTOR" ifNotGranted="ROLE_DEAN">
            url = '${basePath}approveTaskDocByDepartment.html';
            </sec:authorize>
            //只拥有院长角色
            <sec:authorize ifAllGranted="ROLE_DEAN" ifNotGranted="ROLE_DEPARTMENT_DIRECTOR">
            url = '${basePath}approveTaskDocByDean.html';
            </sec:authorize>
            //拥有教研室主任和院长角色
            <sec:authorize ifAllGranted="ROLE_DEAN,ROLE_DEPARTMENT_DIRECTOR">
            url = '${basePath}approveTaskDocByDirectorAndDean.html';
            </sec:authorize>

            $.messager.confirm('询问', '确认通过？', function (t) {
                if (t) {
                    $.ajax({
                        url: url,
                        type: 'GET',
                        dateType: 'json',
                        data: {"taskDocId": taskDocId},
                        success: function (result) {
                            result = $.parseJSON(result);
                            if (result.success) {
                                $.messager.alert('提示', result.msg, 'info');
                                $("#taskGrid").datagrid('reload');
                            } else {
                                $.messager.alert('警告', result.msg, 'warning');
                            }
                            return true;
                        },
                        error: function () {
                            $.messager.alert('错误', '网络错误，请联系管理员', 'error');
                            return false;
                        }
                    });
                }
            })
        }


        //退回任务书
        function rejectTaskDoc(taskDocId) {
            var url = '';
            //只拥有教研室主任角色
            <sec:authorize ifAllGranted="ROLE_DEPARTMENT_DIRECTOR" ifNotGranted="ROLE_DEAN">
            url = '${basePath}rejectTaskDocByDepartment.html';
            </sec:authorize>
            //只拥有院长角色
            <sec:authorize ifAllGranted="ROLE_DEAN" ifNotGranted="ROLE_DEPARTMENT_DIRECTOR">
            url = '${basePath}rejectTaskDocByDean.html';
            </sec:authorize>
            //拥有教研室主任和院长角色
            <sec:authorize ifAllGranted="ROLE_DEAN,ROLE_DEPARTMENT_DIRECTOR">
            url = '${basePath}rejectTaskDocByDirectorAndDean.html';
            </sec:authorize>
            $.messager.confirm('询问', '是否退回？', function (t) {
                if (t) {
                    $.ajax({
                        url: url,
                        type: 'GET',
                        dateType: 'json',
                        data: {"taskDocId": taskDocId},
                        success: function (result) {
                            result = $.parseJSON(result);
                            if (result.success) {
                                $.messager.alert('提示', result.msg, 'info');
                                $("#taskGrid").datagrid('reload');
                            } else {
                                $.messager.alert('警告', result.msg, 'warning');
                            }
                            return true;
                        },
                        error: function () {
                            $.messager.alert('错误', '网络错误，请联系管理员', 'error');
                            return false;
                        }
                    });
                }
            })

        }


        //查询
        function searchFun() {
            $("#taskGrid").datagrid('load', $.serializeObject($("#searchForm")));
        }

        //清空查询条件
        function clearFun() {
            $("#titleInput").val('');
            $("input[name=approve]").attr('checked', false);
            $("#taskGrid").datagrid('load', {});
        }

    </script>

</head>
<body>
<div style="width: 100%;height: 100%;">
    <div style="position: absolute;top: 10px;right: 100px;">
        <form id="searchForm">
            题目<input type="text" class="easyui-textbox" id="titleInput" name="title">
            <input type="radio" name="approve" id="approve" value="${true}">通过
            <input type="radio" name="approve" id="reject" value="${false}">未通过
            <input type="radio" name="approve" id="all" value="${null}">全部
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="searchFun()"
               data-options="iconCls:'icon-search'">查询</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="clearFun()"
               data-options="iconCls:'icon-clear'">清空</a>
        </form>
    </div>

    <table id="taskGrid"></table>
</div>

</body>
</html>
