<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<html>
<head>
    <%--只能放在head里面--%>
    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>

    <script type="text/javascript">
        //全局变量，用于刷新数据
        var projectGrid;
        $(function () {
            projectGrid = $('#stageAchievement').datagrid({
                url: '${basePath}student/getStageAchievementsData.html',
                striped: true,
                fit: true,
                idField: 'id',
                pagination: true,
                singleSelect: true,
                columns: [[
                    {
                        field: 'issueDate',
                        formatter: function (value, rec) {
                            var unixTimestamp = new Date(rec.issuedDate);
                            return unixTimestamp.toLocaleString();
                        }
                        , title: '上传时间', width: '30%', align: 'center'
                    },
                    {
                        field: 'remark',
                        formatter: function (value, rec) {
                            if (rec.remark == null) {
                                return '无';
                            }
                            else {
                                return rec.remark;
                            }
                        }, title: '教师评语', width: '30%', align: 'center'
                    },
                    {
                        title: '操作',
                        field: 'action',
                        width: '40%',
                        formatter: function (value, rec) {
                            var str = '';
                            str += $.formatString('<a href="javascript:void(0)" class="downLoadBtn" data-options="plain:true,iconCls:\'icon-more\'" onclick="downLoadStageAchievement(\'{0}\')"></a>', rec.id);
                            str += $.formatString('<a href="javascript:void(0)" class="delBtn" data-options="plain:true,iconCls:\'icon-cancel\'" onclick="deleteStageAchievement(\'{0}\')"></a>', rec.id);
                            return str;
                        }
                    }
                ]],
                onLoadSuccess: function () {
                    $(".downLoadBtn").linkbutton({plain: true, iconCls: 'icon-more', text: '下载'});
                    $(".delBtn").linkbutton({plain: true, iconCls: 'icon-cancel', text: '删除'});
                    $(".upBtn").linkbutton({plain: true, iconCls: 'icon-save', text: '上传'});
                }
            });
        });
        //上传阶段成果
        function upLoadStageAchievement() {
            parent.$.modalDialog({
                href: '${basePath}student/toUploadStageAchievement.html',
                width: '40%',
                height: '50%',
                //modal:是否生成模态窗口????
                modal: true,
                title: '上传阶段成果',
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
                        parent.$.modalDialog.stageAchGird = projectGrid;
                        var f = parent.$.modalDialog.handler.find("#updateStageAchievementForm");
                        f.submit();
                    }
                }]

            })
        }
        //下载阶段成果
        function downLoadStageAchievement(id) {
            window.location.href = '${basePath}student/download/stageAchievement.html?stageAchievementId=' + id;
        }
        //删除阶段成果
        function deleteStageAchievement(id) {
            $.messager.confirm("询问", "确认删除？", function (t) {
                if (t) {
                    progressLoad();
                    $.ajax({
                        url: '${basePath}student/deleteStageAchievement.html',
                        type: 'GET',
                        dateType: 'json',
                        data: {"stageAchievementId": id},
                        success: function (result) {
                            progressClose();
                            result = $.parseJSON(result);
                            if (result.success) {
                                $.messager.alert('提示', result.msg, 'info');
                                $('#stageAchievement').datagrid('reload');
                            } else {
                                $.messager.alert('提示', result.msg, 'warning');
                            }
                            return true;
                        },
                        error: function () {
                            progressClose();
                            $.messager.alert('错误', '发生网络错误，请联系管理员', 'error');
                            return false;
                        }
                    });
                }
            });
        }
    </script>
</head>
<body>
<c:choose>
<c:when test="${message!=null}">
    <span style="color:red;font-size: xx-large;margin-left: 2%">目前没有选择课题，请尽快联系指导老师</span>
</c:when>
<c:otherwise>
<div id="uploadDiv">
    <a href="javascript:void(0)" style="position: absolute;top: 10px;left: 2%;" onclick="upLoadStageAchievement()"
       class="easyui-linkbutton" data-options="iconCls:'icon-add'">上传</a>
</div>

<div style="height: 100%;">

    <table id="stageAchievement" style="width: 100%;height: 100%;"></table>

</div>
</body>
</c:otherwise>
</c:choose>

</html>
