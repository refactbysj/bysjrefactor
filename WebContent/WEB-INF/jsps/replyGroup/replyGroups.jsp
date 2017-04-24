<%--
  Created by IntelliJ IDEA.
  User: 张战
  Date: 2016/3/1
  Time: 14:32
  To change this template use File | Settings | File Templates.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<html>
<head>
    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
    <script type="text/javascript">
        var replyGrid;
        function delReplyGroup(replyGroupId) {
            $.messager.confirm('询问', '确认删除？', function (t) {
                if (t) {
                    $.ajax({
                        url: '${basePath}process/delReplyGroupById.html',
                        data: {"replyGroupId": replyGroupId},
                        dataType: 'json',
                        type: 'POST',
                        success: function (result) {
                            if (result.success) {
                                $("#replyGroupGrid").datagrid('load');
                                $.messager.alert('提示', result.msg, 'info');
                            } else {
                                $.messager.alert('提示', result.msg, 'warning');
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

        $(function () {
            replyGrid = $("#replyGroupGrid").datagrid({
                url: '${basePath}process/getReplyGroup.html',
                singleSelect: true,
                striped: true,
                pagination: true,
                fit: true,
                columns: [[{
                    title: '小组名称',
                    field: 'description',
                    width: '10%'
                }, {
                    title: '小组组长',
                    field: 'leaderName',
                    width: '5%',
                    formatter: function (value, row) {
                        return row.leader.name;
                    }
                }, {
                    title: '答辩老师',
                    field: 'members',
                    width: '30%',
                    formatter: function (value, row) {
                        var str = '';
                        var tutors = row.members;
                        for (var i in tutors) {
                            str += tutors[i].name + ",";
                        }
                        return str.substring(0, str.length - 1);
                    }
                }, {
                    title: '答辩学生',
                    field: 'replyStudent',
                    width: '40%',
                    formatter: function (value, row) {
                        var str = '';
                        var students = row.student;
                        for (var i in students) {
                            str += students[i].name + ",";
                        }
                        return str.substring(0, str.length - 1);
                    }
                }, {
                    title: '所属教研室',
                    field: 'departmentName',
                    formatter: function (value, row) {
                        return row.department.description;
                    }
                }, {
                    title: '操作',
                    field: 'action',
                    width: '10%',
                    formatter: function (value, row) {
                        var str = '';
                        str += $.formatString('<a href="javascript:void(0)" class="delBtn" onclick="delReplyGroup(\'{0}\')"></a>', row.id);
                        str += $.formatString('<a href="javascript:void(0)" class="editBtn" onclick="addOrEditReplyGroup(\'{0}\')"></a>', row.id);
                        return str;
                    }
                }]],
                onLoadSuccess: function () {
                    $(".delBtn").linkbutton({text: '删除', iconCls: 'icon-cancel', plain: true});
                    $(".editBtn").linkbutton({text: '修改', iconCls: 'icon-edit', plain: true});
                }
            })
        });

        //添加或修改答辩小组
        function addOrEditReplyGroup(id) {
            var url;
            var title;
            if (id == null) {
                title = '添加答辩小组';
                url = '${basePath}process/addReplyGroup.html'
            } else {
                title = '修改答辩小组';
                url = '${basePath}process/editReplyGroup.html?groupId=' + id;
            }

            parent.$.modalDialog({
                href: url,
                modal: true,
                width: '60%',
                height: '80%',
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
                        parent.$.modalDialog.replyGrid = replyGrid;
                        var f = parent.$.modalDialog.handler.find("#editReplyGroupForm");
                        f.submit();
                    }
                }]
            })
        }

        function searchFun() {
            $("#replyGroupGrid").datagrid('load', $.serializeObject($("#searchForm")));
        }

        function clearFun() {
            $("#searchForm input").val('');
            $("#replyGroupGrid").datagrid('load', {});
        }
    </script>

</head>
<body>
<div style="width: 100%">

    <div style="position: absolute;top: 10px;right:5%">
        <form id="searchForm">
            <span style="color: grey;">小组名称：</span>
            <input type="text" name="replyGroupName" class="easyui-textbox"
                   id="name">
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="searchFun()"
               data-options="iconCls:'icon-search'">查询</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="clearFun()"
               data-options="iconCls:'icon-clear'">清空</a>
        </form>
    </div>
    <div style="position: absolute;top: 10px;left: 2%;">
        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'"
           onclick="addOrEditReplyGroup(null)">添加答辩小组</a>
    </div>
    <div style="height: 100%">
        <table id="replyGroupGrid"></table>
        <%--<table
                class="table table-striped table-bordered table-hover datatable">
            <thead>
            <tr>
                <th>小组名称</th>
                <th>小组组长</th>
                <th>答辩老师</th>
                <th>答辩学生</th>
                <th>所属教研室</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty replyGroupList}">
                </c:when>
                <c:otherwise>
                    <c:forEach items="${replyGroupList}" var="replyGroup">
                        <tr id="replyGroupList${replyGroup.id}">
                            <td>${replyGroup.description}</td>
                            <td>${replyGroup.leader.name}</td>
                                &lt;%&ndash;答辩老师&ndash;%&gt;
                            <td><c:forEach items="${replyGroup.members}" var="tutor">
                                ${tutor.name} &nbsp;&nbsp;
                            </c:forEach></td>
                                &lt;%&ndash;答辩学生&ndash;%&gt;
                            <td><c:forEach items="${replyGroup.graduateProject}"
                                           var="graduateProject">
                                ${graduateProject.student.name}&nbsp;&nbsp;
                            </c:forEach></td>
                            <td>${replyGroup.department.description}</td>
                            <td>
                                <button class="btn btn-danger btn-xs"
                                        onclick="delReplyGroup(${replyGroup.id})">
                                    <i class="icon-remove"></i> 删除
                                </button>
                                <a class="btn btn-warning btn-xs"
                                   href="<%=basePath%>process/editReplyGroup.html?groupId=${replyGroup.id}"
                                   data-toggle="modal" data-target="#addOrEditReplyGroup"><i class="icon-edit"></i>
                                    修改</a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>

            </tbody>
        </table>--%>

    </div>
</div>

</body>
</html>


