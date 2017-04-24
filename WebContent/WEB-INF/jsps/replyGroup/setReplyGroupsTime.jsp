<%--
  Created by IntelliJ IDEA.
  User: 张战
  Date: 2016/3/19
  Time: 14:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<html>
<head>
    <%@include file="/WEB-INF/jsps/includeURL.jsp" %>
    <script type="text/javascript">

        var setGroupGrid;
        $(function () {
            setGroupGrid = $("#setGroupGrid").datagrid({
                url: '${basePath}replyGroups/getReplyGroupData.html',
                singleSelect: true,
                fit: true,
                pagination: true,
                striped: true,
                columns: [[{
                    title: '小组名称',
                    field: 'description'
                }, {
                    title: '小组组长',
                    field: 'leaderName',
                    formatter: function (value, row) {
                        return row.leader.name;
                    }
                }, {
                    title: '答辩老师',
                    field: 'tutors',
                    width: '23%',
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
                    width: '32%',
                    formatter: function (value, row) {
                        var str = '';
                        var students = row.student;
                        for (var i in students) {
                            str += students[i].name + ',';
                        }
                        return str.substring(0, str.length - 1);
                    }
                }, {
                    title: '开始时间',
                    field: 'startTime',
                    formatter: function (value, row) {
                        if (row.replyTime == null) {
                            return '未设置';
                        } else {
                            return getTimeByMillions(row.replyTime.beginTime);
                        }
                    }
                }, {
                    title: '结束时间',
                    field: 'endTime',
                    formatter: function (value, row) {
                        if (row.replyTime == null) {
                            return '未设置';
                        } else {
                            return getTimeByMillions(row.replyTime.endTime);
                        }
                    }
                }, {
                    title: '答辩地点',
                    field: 'classRoom',
                    formatter: function (value, row) {
                        if (row.classRoom == null) {
                            return '未设置';
                        } else {
                            return row.classRoom.description;
                        }
                    }
                }, {
                    title: '操作',
                    field: 'action',
                    width: '14%',
                    formatter: function (value, row) {
                        var str = '';
                        if (row.replyTime == null || row.classRoom == null) {
                            str += $.formatString('<a href="javascript:void(0)" class="setTimeBtn" onclick="setReplyTime(\'{0}\')"></a>', row.id);
                        } else {
                            str += $.formatString('<a href="javascript:void(0)" class="editTimeBtn" onclick="setReplyTime(\'{0}\')"></a>', row.id);
                        }
                        return str;
                    }
                }]],
                onLoadSuccess: function () {
                    $(".setTimeBtn").linkbutton({text: '设置答辩时间地点', plain: true, iconCls: 'icon-add'});
                    $(".editTimeBtn").linkbutton({text: '修改', plain: true, iconCls: 'icon-edit'});
                }
            });

        });

        //搜索
        function searchFun() {
            $("#setGroupGrid").datagrid('load', $.serializeObject($("#searchForm")));
        }

        //清空查询条件
        function clearFun() {
            $("#searchForm input").val('');
            $("#setGroupGrid").datagrid('load', {});
        }

        //把毫秒值转换成日期
        function getTimeByMillions(millions) {
            var beginDate = new Date(millions);
            var year = beginDate.getFullYear() + '年';
            var month = beginDate.getMonth() + 1 + '月';
            var day = beginDate.getDate() + '日';
            return year + month + day;
        }

        //设置答辩时间地点
        function setReplyTime(id) {
            parent.$.modalDialog({
                href: '${basePath}replyGroups/setTimeAndClassRoom.html?replyGroupId=' + id,
                modal: true,
                width: '30%',
                height: '40%',
                title: '设置答辩时间地点',
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
                        parent.$.modalDialog.setGroupGrid = setGroupGrid;
                        var f = parent.$.modalDialog.handler.find("#setReplyForm");
                        f.submit();
                    }
                }]
            })
        }
    </script>

</head>
<body>
<div style="width: 100%">
    <div style="position: absolute;top: 10px;right: 5%;">
        <form id="searchForm">
            <div class="form-group ">
                <span style="color: grey;">小组名称：</span> <input type="text"
                                                               class="easyui-textbox" name="groupName" id="name">
                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
                   onclick="searchFun()">查询</a>
                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-clear'"
                   onclick="clearFun()">清空</a>
            </div>
        </form>
    </div>


    <div style="height: 100%;">
        <table id="setGroupGrid"></table>
    </div>


</div>
</body>
</html>
