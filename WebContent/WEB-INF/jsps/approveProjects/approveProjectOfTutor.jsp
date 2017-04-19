<%--
  Created by IntelliJ IDEA.
  User: zhan
  Date: 2017/4/12 0012
  Time: 12:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
    <script type="text/javascript">
        var projectGrid;
        $(function () {
            projectGrid = $("#approveProjectTable").datagrid({
                url: '${basePath}process/approveProjectsOfTutorData.html',
                fit: true,
                striped: true,
                singleSelect: true,
                pagination: true,
                idField: 'id',
                columns: [[{
                    title: '题目（副标题）',
                    field: 'title',
                    width: '50%',
                    formatter: function (value, row, index) {
                        if (row.subTitle != null && row.subTitle != '') {
                            return value + "——" + row.subTitle;
                        } else {
                            return value;
                        }
                        return value;
                    }
                }, {
                    title: '老师姓名',
                    field: 'proposer',
                    formatter: function (value, row, index) {
                        if (row.proposer != null && row.proposer != '') {
                            return row.proposer.name;
                        } else {
                            return '';
                        }
                    }
                }, {
                    title: '类别',
                    field: 'projectType',
                    formatter: function (value, row, index) {
                        if (row.projectType != null && row.projectType != '') {
                            return row.projectType.description;
                        } else {
                            return '';
                        }
                    }
                }, {
                    title: '类型',
                    field: 'category'
                }, {
                    title: '性质',
                    field: 'projectFidelity',
                    formatter: function (value, row, index) {
                        if (row.projectFidelity != null && row.projectFidelity != '') {
                            return row.projectFidelity.description;
                        } else {
                            return '';
                        }
                    }
                }, {
                    title: '年份',
                    field: 'year'
                }, {
                    title: '审核状态',
                    field: 'audit',
                    formatter: function (value, row, index) {
                        if (row.auditByDirector.approve == null) {
                            return '未审核';
                        }
                        if (row.auditByDirector.approve) {
                            return '通过';
                        } else {
                            return '<span style="color: red;">未通过</span>';
                        }
                    }
                }, {
                    title: '操作',
                    field: 'action',
                    width: '18%',
                    formatter: function (value, row, index) {
                        var str = '';
                        if (row.auditByDirector != null && row.auditByDirector.approve) {
                            str += $.formatString('<a class="backBtn" onclick="backGraduate(\'{0}\')"></a>', row.id);
                        } else {
                            str += $.formatString('<a class="approveBtn" onclick="approveGraduate(\'{0}\')"></a>', row.id);
                        }
                        str += $.formatString('<a class="detailBtn" onclick="detailFun(\'{0}\')"></a>', row.id);
                        return str;
                    }
                }]],
                onLoadSuccess: function () {
                    $(".backBtn").linkbutton({text: '退回', plain: true, iconCls: 'icon-back'});
                    $(".approveBtn").linkbutton({text: '通过', plain: true, iconCls: 'icon-ok'});
                    $(".detailBtn").linkbutton({text: '显示详情', plain: true, iconCls: 'icon-more'});
                }
            });

        });

        function approveGraduate(graduateProjectId) {
            $.messager.confirm('询问', '是否通过', function (t) {
                if (t) {
                    transform(graduateProjectId, true);
                }
            })
        }

        /*退回课题的函数*/
        function backGraduate(graduateProjectId) {
            $.messager.confirm('询问', '是否退回？', function (t) {
                if (t) {
                    transform(graduateProjectId, false);
                }
            })
        }

        function transform(projectId, isApprove) {
            $.ajax({
                url: '${basePath}process/approveOrBack.html',
                data: {"projectId": projectId, "ifApprove": isApprove},
                dataType: 'json',
                type: 'POST',
                success: function (result) {
                    if (result.success) {
                        $("#approveProjectTable").datagrid('reload');
                        return true;
                    } else {
                        $.messager.alert('提示', '操作失败', 'warning');
                        return false;
                    }
                },
                error: function () {
                    $.messager.alert('错误', '网络错误，请联系管理员', 'error');
                    return false;
                }
            });
        }

        function detailFun(id) {
            var url = '${basePath}process/showDetail.html?graduateProjectId=' + id;
            showProjectDetail(url);
        }


        function searchFun() {
            $("#approveProjectTable").datagrid('load', $.serializeObject($("#searchForm")));
        }

        function clearFun() {
            $("#searchForm input").val('');
            $("#approveProjectTable").datagrid('load', {});
        }

        //一键通过所有课题
        function approveAllProject() {
            $.ajax({
                url: '${basePath}process/allApproveProject.html',
                method: 'get',
                success: function (result) {
                    if (result.success) {
                        $.messager.alert('提示', result.msg, 'info');
                        $("#approveProjectTable").datagrid('load');
                    } else {
                        $.messager.alert('提示', result.msg, 'warning');
                    }
                },
                error: function () {
                    $.messager.alert('错误', '网络错误，请联系管理员', 'error');
                }
            })
        }
    </script>
</head>
<body>
<div id="headDiv">
    <div id="searchDiv" style="position: absolute;top:10px;right:5%">
        <form id="searchForm">
            <span style="color: grey;">老师姓名:</span>
            <input type="text"
                   class="easyui-textbox" id="name" name="tutorName">
            <span style="color: grey;margin-left: 5px">题目：</span>
            <input type="text"
                   class="easyui-textbox" id="title" name="title">
            <input type="radio" name="approve">已通过
            <input type="radio" name="approve">未通过
            <a class="easyui-linkbutton" onclick="searchFun()" data-options="iconCls:'icon-search'">查询</a>
            <a class="easyui-linkbutton" onclick="clearFun()" data-options="iconCls:'icon-clear'">清空</a>
        </form>
    </div>
</div>
<div id="content" style="height: 100%;">
    <table id="approveProjectTable" style="width: 100%;height: 80%;"></table>
</div>
</body>
</html>
