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
        $(function () {
            $("#projectTable").datagrid({
                url: '${basePath}process/getProjectsData.html',
                striped: true,
                pagination:true,
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
                    width:'4%',
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
                    field: 'name',
                    width:'8%'
                }, {
                    title: '审核状态',
                    align:'center',
                    width:'5%',
                    field: 'auditByDirector.approve',
                    formatter: function (value, row, index) {
                        if (value == null) {
                            return '在审';
                        } else if (value == true) {
                            return '已通过';
                        } else {
                            return '已退回';
                        }
                    }
                }, {
                    title: '操作',
                    width:'14%',
                    align:'center',
                    field: 'action',
                    formatter: function (value, row, index) {
                        var str = '';
                        if (${ACTION_EDIT_PROJECT!=null&&ACTION_EDIT_PROJECT==true}) {
                            str += $.formatString('<a href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true,iconCls:\'icon-edit\'" onclick="editProject(\'{0}\')">修改</a>', row.id);
                            str += $.formatString('<a href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true,iconCls:\'icon-edit\'" onclick="detailProject(\'{0}\')">显示详情</a>', row.id)
                        }
                        if (${ifShowAll=='0'}) {
                            if (${ABLE_TO_UPDATE==1}) {
                                str += $.formatString('<a href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true,iconCls:\'icon-edit\'" onclick="editProject(\'{0}\')">修改</a>', row.id);
                                str += $.formatString('<a href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true,iconCls:\'icon-cancel\'" onclick="delProject(\'{0}\')">删除</a>', row.id);
                                str += $.formatString('<a href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true,iconCls:\'icon-cancel\'" onclick="cloneProject(\'{0}\')">克隆</a>', row.id);
                            } else {
                                str += '不在修改时间范围内';
                            }
                        }
                        return str;
                    }

                }, {
                    title: '详情',
                    align:'center',
                    width:'2%',
                    field: 'action',
                    formatter: function (value, row, index) {
                        var str = '';
                        if (${ifShowAll=='0'||ifShowAll=='1'}) {
                            str += $.formatString('<a href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true,iconCls:\'icon-edit\'" onclick="detailProject(\'{0}\')">显示详情</a>', row.id)
                        }
                        return str;
                    }
                }]]
            })
        });

        $("#123").on("hidden.bs.modal", function () {
            $(this).removeData("bs.modal");
        });

        function cloneProject(projectId) {
            $.ajax({
                url: '/bysj3/process/cloneProjectById.html',
                data: {"cloneId": projectId},
                dataType: 'json',
                type: 'get',
                success: function (data) {
                    myAlert("克隆成功");
                    window.location = '/bysj3/process/myProjects.html';
                    return true;
                },
                error: function () {
                    myAlert("克隆失败，请稍后再试");
                    return false;
                }
            });
        }

        function delProject(delId) {
            //var confirmDel = window.confirm("确认删除？");
            window.wxc.xcConfirm("确认删除", "confirm", {
                onOk: function () {
                    $.ajax({
                        url: '/bysj3/process/delProject.html',
                        data: {"delId": delId},
                        dataType: 'json',
                        type: 'POST',
                        success: function (data) {
                            $("#project" + delId).remove();
                            /*var projectCount = $("#viewCount").text();
                             $("#viewCount").html(projectCount - 1);*/
                            changPageCount();
                            myAlert("删除成功！");
                            return true;
                        },
                        error: function () {
                            myAlert("网络故障，请稍后再试！");
                            return false;
                        }
                    });
                }
            });


        }


        function viewProject(category) {
            $("#projectTable").datagrid('load',{
                category:category
            })
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
                            href="javascript:void(0)" onclick="viewProject('设计')">
                        <span class="glyphicon glyphicon-adjust">查看设计题目</span>
                            <%--<i class="icon-coffee"></i>查看设计题目--%>
                    </a>
                    <a
                            <c:if test="${viewProjectTitle=='paper'}">class="btn btn-primary btn-sm" </c:if>
                            <c:if test="${viewProjectTitle!='paper'}">class="btn btn-default btn-sm"</c:if>
                            class="btn btn-default"
                            href="javascript:void(0)" onclick="viewProject('论文')">
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
                            href="javascript:void(0)" onclick="viewProject('设计')">
                        <span class="glyphicon glyphicon-adjust">查看设计题目</span>
                    </a>
                    <a
                            <c:if test="${viewProjectTitle=='paper'}">class="btn btn-primary btn-sm" </c:if>
                            <c:if test="${viewProjectTitle!='paper'}">class="btn btn-default btn-sm"</c:if>
                            href="javascript:void(0)" onclick="viewProject('论文')">
                        <span class="glyphicon glyphicon-adjust">查看论文题目</span>
                    </a>
                        <%--<a class="btn btn-default" href="test.html" data-toggle="modal" data-target="#test">
                            <span class="glyphicon-book">测试</span>
                        </a>--%>
                    <br><br>
                    <c:choose>
                        <c:when test="${ABLE_TO_UPDATE==1}">
                            <a href="<%=basePath%>process/addOrEditDesignProject.html" data-toggle="modal"
                               id="addDesignModel"
                               data-backdrop="static" data-keyboard="false"
                               data-target="#editProjectModal"
                               class="btn btn-primary btn-sm">
                                <span class="glyphicon glyphicon-plus">添加设计题目</span>
                            </a>
                            <a href="<%=basePath%>process/addOrEditPaperProject.html" data-toggle="modal"
                               id="addPaperModel"
                               data-backdrop="static" data-keyboard="false"
                               data-target="#editProjectModal"
                               class="btn btn-primary btn-sm">
                                <span class="glyphicon glyphicon-plus">添加论文题目</span>
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
        <form action="${actionUrl}" class="form-inline" role="form">
            <div class="form-group">
                题目：
                <%--value=${title}用来获取当前查询题目的名称 --%>
                <input type="text" class="easyui-textbox" name="title" value="${title}" required="required">
                <button class="easyui-linkbutton" type="submit" data-options="iconCls:'icon-search'">查询</button>
            </div>

        </form>
    </div>
</div>
<div style="height: 90%;width: 100%;">
    <table id="projectTable" style="height: 100%"></table>
</div>

</body>
</html>





