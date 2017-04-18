<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<html>
<head>
    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
    <script type="text/javascript">

        //全局变量，用于刷新数据
        var projectGrid;

        $(function () {
            projectGrid = $("#projectGrid").datagrid({
                url: '${basePath}tutor/getTaskProject.html',
                striped: true,
                singleSelect: true,
                fit: true,
                idField: 'id',
                pagination: true,
                columns: [[{
                    title: '题目(副标题)',
                    field: 'title',
                    width: '40%',
                    formatter: function (value, row, index) {
                        if (row.subTitle == null || row.subTitle == '') {
                            return value;
                        } else {
                            return value + "——" + row.subTitle;
                        }
                    }
                }, {
                    title: '课题类型',
                    field: 'category',
                    width: '7%'
                }, {
                    title: '班级',
                    field: 'studentClass',
                    width: '7%',
                    formatter: function (value, row, index) {
                        return row.student.studentClass.description;
                    }
                }, {
                    title: '学生姓名',
                    field: 'studentName',
                    width: '7%',
                    formatter: function (value, row, index) {
                        return row.student.name;
                    }
                }, {
                    title: '学号',
                    field: 'studentNo',
                    width: '12%',
                    formatter: function (value, row, index) {
                        return row.student.no;
                    }
                }, {
                    title: '指导老师',
                    field: 'proposerName',
                    width: '7%',
                    formatter: function (value, row, index) {
                        return row.proposer.name;
                    }
                }, {
                    title: '状态',
                    field: 'status',
                    width: '6%',
                    formatter: function (value, row, index) {
                        if (row.taskDoc != null) {
                            if (row.taskDoc.auditByDepartmentDirector.approve ||
                                row.taskDoc.auditByBean.approve) {
                                return '<span style="color: green;">通过</span>';
                            } else {
                                return '<span style="color: red;">驳回</span>';
                            }
                        } else {
                            return '未下达';
                        }

                    }
                }, {
                    title: '操作',
                    field: 'action',
                    width: '15%',
                    formatter: function (value, row, index) {
                        var str = '';
                        if (row.taskDoc != null) {
                            str += $.formatString('<a href="javascript:void(0)" class="downLoadBtn" data-options="plain:true,iconCls:\'icon-more\'" onclick="downLoadTask(\'{0}\')"></a>', row.id);
                            str += $.formatString('<a href="javascript:void(0)" class="delBtn" data-options="plain:true,iconCls:\'icon-cancel\'" onclick="delTask(\'{0}\')"></a>', row.id);
                        } else {
                            str += $.formatString('<a href="javascript:void(0)" class="upBtn" data-options="plain:true,iconCls:\'icon-save\'" onclick="upLoadDoc(\'{0}\')"></a>', row.id);
                        }
                        return str;
                    }
                }]],
                onLoadSuccess: function () {
                    $(".downLoadBtn").linkbutton({plain: true, iconCls: 'icon-more', text: '下载'});
                    $(".delBtn").linkbutton({plain: true, iconCls: 'icon-cancel', text: '删除任务书'});
                    $(".upBtn").linkbutton({plain: true, iconCls: 'icon-save', text: '下达任务书'});
                }
            })
        });

        //上传任务书
        function upLoadDoc(id) {
            parent.$.modalDialog({
                href: '${basePath}tutor/toUploadPage.html?projectId=' + id,
                width: '400',
                height: '300',
                modal: true,
                title: '上传任务书',
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
                        parent.$.modalDialog.projectGrid = projectGrid;
                        var f = parent.$.modalDialog.handler.find("#updateTaskDocForm");
                        f.submit();
                    }
                }]

            })
        }


        //下载任务书
        function downLoadTask(id) {
            window.location.href = '${basePath}tutor/downLoadTaskDoc.html?projectId=' + id;
        }

        //删除任务书
        function delTask(id) {
            $.messager.confirm('询问', '是否删除？', function (t) {
                if (t) {
                    $.ajax({
                        url: '${basePath}tutor/deleteTaskDoc.html',
                        type: 'GET',
                        dataType: 'json',
                        data: {"projectId": id},
                        success: function (result) {
                            if (result.success) {
                                $.messager.alert('提示', result.msg, 'info');
                                $('#projectGrid').datagrid('reload');
                            } else {
                                $.messager.alert('提示', result.msg, 'warning');
                            }
                            return true;
                        },
                        error: function () {
                            $.messager.alert('错误', '发生网络错误，请联系管理员', 'error');
                            return false;
                        }
                    });
                }
            })
        }

    </script>

</head>
<body>
<table id="projectGrid" style="width: 100%;height: 100%;"></table>

</body>
</html>

