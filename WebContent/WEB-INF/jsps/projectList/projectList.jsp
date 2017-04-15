<%--
  Created by IntelliJ IDEA.
  User: zhan
  Date: 2017/4/5 0005
  Time: 22:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
    <script type="text/javascript">
        var projectGrid;
        $(function () {
            var url = '';
            //我申报的题目
            if (${ifShowAll=='0'}) {
                url = '${basePath}process/myProjects.html';
            }
            //查询现有题目
            else if (${ifShowAll=='1'}) {
                url = '${basePath}process/getProjectsData.html';
            }
            //更改老师毕业设计
            else if (${changProject=='1'}) {
                url = '${basePath}process/getChangProjectData.html';
            }
            projectGrid = $("#projectTable").datagrid({
                url: url,
                striped: true,
                pagination:true,
                pageSize: 15,
                pageList: [10, 15, 20, 30, 40, 60],
                fit:true,
                idField:'id',
                singleSelect:true,
                columns: [[{
                    title: '提交状态',
                    align:'center',
                    field: 'proposerSubmitForApproval',
                    width:'7%',
                    formatter: function (value, row, index) {
                        var str = '';
                        if (value) {
                            str = '已送审'
                        } else {
                            str = '送审';
                        }
                        return str;
                    }
                }, {
                    title: '题目名称',
                    width:'25%',
                    align:'center',
                    field: 'title'
                }, {
                    title: '副标题',
                    align:'center',
                    field: 'subTitle',
                    width:'15%',
                    formatter: function (value, row, index) {
                        if (value == null || value == '') {
                            return '';
                        } else {
                            return value;
                        }
                    }
                }, {
                    title: '年份',
                    align:'center',
                    field: 'year',
                    width:'7%',
                    formatter: function (value, row, index) {
                        if (value == null || value == '') {
                            return '未设置';
                        } else {
                            return value;
                        }
                    }
                }, {
                    title: '类别',
                    align:'center',
                    field: 'category',
                    width: '6%',
                    formatter: function (value, row, index) {
                        if (value == null || value == '') {
                            return '未设置';
                        } else {
                            return value;
                        }
                    }
                }, {
                    title: '出题教师',
                    align:'center',
                    field: 'proposer.name',
                    width: '8%',
                    formatter: function (value, row, index) {
                        if (row.proposer) {
                            return row.proposer.name;
                        } else {
                            return value;
                        }
                    }
                }, {
                    title: '审核状态',
                    align:'center',
                    width:'5%',
                    field: 'auditByDirector.approve',
                    formatter: function (value, row, index) {
                        var info = row.auditByDirector.approve;
                        if (info == null) {
                            return '<span style="color: cornflowerblue;">在审</span>';
                        } else if (info) {
                            return '<span>已通过<span>';
                        } else {
                            return '<span style="color: red">已退回<span>';
                        }
                    }
                }, {
                    title: '操作',
                    width: '18%',
                    align:'center',
                    field: 'action',
                    formatter: function (value, row, index) {
                        var str = '';
                        if (${ACTION_EDIT_PROJECT!=null&&ACTION_EDIT_PROJECT==true}) {
                            str += $.formatString('<a href="javascript:void(0)" class="editBtn" data-options="plain:true,iconCls:\'icon-edit\'" onclick="editProject(\'0\',\'{0}\')"></a>', row.id);
                        }
                        if (${ifShowAll=='0'}) {
                            if (${ABLE_TO_UPDATE=='1'}) {
                                str += $.formatString('<a href="javascript:void(0)" class="editBtn" data-options="plain:true,iconCls:\'icon-edit\'" onclick="editProject(\'0\',\'{0}\')"></a>', row.id);
                                str += $.formatString('<a href="javascript:void(0)" class="cloneBtn" data-options="plain:true,iconCls:\'icon-cancel\'" onclick="cloneProject(\'{0}\')"></a>', row.id);
                                str += $.formatString('<a href="javascript:void(0)" class="delBtn" data-options="plain:true,iconCls:\'icon-cancel\'" onclick="delProject(\'{0}\')"></a>', row.id);
                            } else {
                                str += '不在修改时间范围内';
                            }
                        }
                        return str;
                    }

                }, {
                    title: '详情',
                    align:'center',
                    width: '8%',
                    field: 'action1',
                    formatter: function (value, row, index) {
                        var str = '';
                        str += $.formatString('<a href="javascript:void(0)" class="detailBtn" data-options="plain:true,iconCls:\'icon-edit\'" onclick="detailProject(\'{0}\')"></a>', row.id);
                        return str;
                    }
                }]],
                onLoadSuccess: function (data) {
                    $('.editBtn').linkbutton({text: '修改', plain: true, iconCls: 'icon-edit'});
                    $(".delBtn").linkbutton({text: '删除', plain: true, iconCls: 'icon-cancel'});
                    $(".cloneBtn").linkbutton({text: '克隆', plain: true, iconCls: 'icon-reload'});
                    $('.detailBtn').linkbutton({text: '显示详情', plain: true, iconCls: 'icon-more'});
                }
            })
        });

        function cloneProject(projectId) {
            progressLoad();
            $.ajax({
                url: '/bysj3/process/cloneProjectById.html',
                data: {"cloneId": projectId},
                dataType: 'json',
                type: 'get',
                success: function (result) {
                    progressClose();
                    if (result.success) {
                        $.messager.alert('提示', result.msg, 'info');
                        $("#projectTable").datagrid('reload');
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

        //删除课题
        function delProject(delId) {
            $.messager.confirm('询问', '确认删除？', function (t) {
                if (t) {
                    progressLoad();
                    $.ajax({
                        url: '/bysj3/process/delProject.html',
                        data: {"delId": delId},
                        dataType: 'json',
                        type: 'POST',
                        success: function (result) {
                            progressClose();
                            if (result.success) {
                                $.messager.alert('提示', result.msg, 'info');
                                $("#projectTable").datagrid('reload');
                            } else {
                                $.messager.alert('警告', result.msg, 'warning');
                            }
                            return true;
                        },
                        error: function () {
                            $.messager.alert("错误", '删除失败，请联系管理员', 'error');
                            return false;
                        }
                    });
                }
            });
        }


        //添加或修改课题
        function editProject(url, id) {
            var title = '';
            console.log("url:" + url);
            console.log('id:' + id);
            if (id == null || id == '') {
                title = '添加课题';
            } else {
                title = '修改课题';
                url = '${basePath}process/editProject.html?editId=' + id;
            }
            parent.$.modalDialog({
                href: url,
                width: 700,
                height: 500,
                modal: true,
                title: title,
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
                        parent.$.modalDialog.project_Grid = projectGrid;
                        var f = parent.$.modalDialog.handler.find("#editProject");
                        f.submit();
                    }
                }]

            })
        }

        //查看课题详情
        function detailProject(id) {
            var url = '${basePath}process/showDetail.html?graduateProjectId=' + id;
            showProjectDetail(url);
        }


        function viewProject(category) {
            $("#projectTable").datagrid('load',{
                category:category
            })
        }

        //查询
        function searchFun() {
            $("#projectTable").datagrid('load', $.serializeObject($("#titleForm")));
        }

        //清空查询条件
        function clearFun() {
            $("#titleForm input").val('');
            $("#projectTable").datagrid('load', {});
        }
    </script>

</head>
<body>
<div id="head">
    <div style="float: left;margin-left: 1%">
        <c:choose>
            <c:when test="${ifShowAll == '1' }">
                <div class="form-group">
                    <a
                            <c:if test="${viewProjectTitle=='all'}">class="btn btn-primary btn-sm" </c:if>
                            <c:if test="${viewProjectTitle!='all'}">class="btn btn-default btn-sm"</c:if>
                            href="<%=basePath%>process/listProjects.html">
                        <span class="glyphicon glyphicon-adjust">查看全部题目</span>
                            <%-- <i class="icon-home"></i>查看全部题目--%>

                    </a>
                    <a
                            <c:if test="${viewProjectTitle=='design'}">class="btn btn-primary btn-sm" </c:if>
                            <c:if test="${viewProjectTitle!='design'}">class="btn btn-default btn-sm"</c:if>
                            href="javascript:void(0)" onclick="viewProject('设计题目')">
                        <span class="glyphicon glyphicon-adjust">查看设计题目</span>
                            <%--<i class="icon-coffee"></i>查看设计题目--%>
                    </a>
                    <a
                            <c:if test="${viewProjectTitle=='paper'}">class="btn btn-primary btn-sm" </c:if>
                            <c:if test="${viewProjectTitle!='paper'}">class="btn btn-default btn-sm"</c:if>
                            class="btn btn-default"
                            href="javascript:void(0)" onclick="viewProject('论文题目')">
                        <span class="glyphicon glyphicon-adjust">查看论文题目</span>
                            <%--<i class="icon-desktop"></i>查看论文题目--%>
                    </a>
                </div>

            </c:when>
            <c:when test="${ifShowAll=='0'}">
                <div class="form-group">
                    <a
                            <c:if test="${viewProjectTitle=='all'}">class="btn btn-primary btn-sm" </c:if>
                            <c:if test="${viewProjectTitle!='all'}">class="btn btn-default btn-sm"</c:if>
                            href="<%=basePath%>process/myProjects.html">
                        <span class="glyphicon glyphicon-adjust">查看全部题目</span>
                    </a>
                    <a
                            <c:if test="${viewProjectTitle=='design'}">class="btn btn-primary btn-sm" </c:if>
                            <c:if test="${viewProjectTitle!='design'}">class="btn btn-default btn-sm"</c:if>
                            href="javascript:void(0)" onclick="viewProject('设计题目')">
                        <span class="glyphicon glyphicon-adjust">查看设计题目</span>
                    </a>
                    <a
                            <c:if test="${viewProjectTitle=='paper'}">class="btn btn-primary btn-sm" </c:if>
                            <c:if test="${viewProjectTitle!='paper'}">class="btn btn-default btn-sm"</c:if>
                            href="javascript:void(0)" onclick="viewProject('论文题目')">
                        <span class="glyphicon glyphicon-adjust">查看论文题目</span>
                    </a>
                        <%--<a class="btn btn-default" href="test.html" data-toggle="modal" data-target="#test">
                            <span class="glyphicon-book">测试</span>
                        </a>--%>
                    <c:choose>
                        <c:when test="${ABLE_TO_UPDATE==1}">
                            <a href="javascript:void(0)"
                               onclick="editProject('${basePath}process/addOrEditDesignProject.html')"
                               id="addDesignModel" data-options="iconCls:'icon-add'"
                               class="easyui-linkbutton">
                                添加设计题目
                            </a>
                            <a href="javascript:void(0)"
                               onclick="editProject('${basePath}process/addOrEditPaperProject.html')"
                               id="addPaperModel" data-options="iconCls:'icon-add'"
                               class="easyui-linkbutton">
                                添加论文题目
                            </a>
                        </c:when>
                        <c:otherwise>
                            <label class="label label-warning">当前时间不在审报题目的时间范围内</label>
                        </c:otherwise>
                    </c:choose>

                </div>

            </c:when>
        </c:choose>
    </div>
    <div style="margin-right: 10%;float: right;">
        <form id="titleForm">
                题目：
            <input type="text" class="easyui-textbox" name="title" value="${title}">
            <a class="easyui-linkbutton" onclick="searchFun()" data-options="iconCls:'icon-search'">查询</a>
            <a class="easyui-linkbutton" onclick="clearFun()" data-options="iconCls:'icon-clear'">清空</a>

        </form>
    </div>
</div>
<div style="height: 90%;width: 100%;">
    <table id="projectTable" style="height: 100%"></table>
</div>

</body>
</html>





