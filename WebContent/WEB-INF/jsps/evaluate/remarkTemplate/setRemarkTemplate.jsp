<%--
  Created by IntelliJ IDEA.
  User: zhan
  Date: 2016/3/27
  Time: 17:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<html>
<head>
    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
    <script type="text/javascript">
        var templateGrid;

        $(function () {
            templateGrid = $("#templateGrid").datagrid({
                url: '${basePath}evaluate/getRemarkData.html',
                pagination: true,
                fit: true,
                singleSelect: true,
                striped: true,
                idField: 'id',
                columns: [[{
                    title: '评语名称',
                    width: '40%',
                    field: 'title'
                }, {
                    title: '设置用户',
                    width: '10%',
                    field: 'name',
                    formatter: function (value, row) {
                        return row.builder.name;
                    }
                }, {
                    title: '类型',
                    width: '20%',
                    field: 'category'
                }, {
                    title: '操作',
                    field: 'action',
                    width: '20%',
                    formatter: function (value, row) {
                        var str = '';
                        str += $.formatString('<a href="javascript:void(0)" class="viewBtn" onclick="viewTemplate(\'{0}\')"></a>', row.id);
                        str += $.formatString('<a href="javascript:void(0)" class="delBtn" onclick="delTemplate(\'{0}\')"></a>', row.id);
                        str += $.formatString('<a href="javascript:void(0)" class="editBtn" onclick="editTemplate(\'{0}\')"></a>', row.id);
                        return str;
                    }
                }]],
                onLoadSuccess: function () {
                    $(".viewBtn").linkbutton({text: '查看', plain: true, iconCls: 'icon-more'});
                    $(".delBtn").linkbutton({text: '删除', plain: true, iconCls: 'icon-cancel'});
                    $(".editBtn").linkbutton({text: '修改', plain: true, iconCls: 'icon-edit'});
                }
            })
        });

        //查看模版
        function viewTemplate(id) {
            var url = '${basePath}evaluate/viewRemarkTemplate.html?templateId=' + id;
            parent.$.modalDialog({
                href: url,
                title: '查看模版',
                modal: true,
                width: '60%',
                height: '80%',
                buttons: [{
                    text: '关闭',
                    iconCls: 'icon-cancel',
                    handler: function () {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                }]
            })
        }

        //删除模版
        function delTemplate(id) {
            $.messager.confirm('询问', '确认删除？', function (t) {
                if (t) {
                    progressLoad();
                    $.ajax({
                        url: '${basePath}evaluate/delRemarkTemplate.html',
                        type: 'POST',
                        data: {"delId": id},
                        dataType: 'json',
                        success: function (result) {
                            progressClose();
                            if (result.success) {
                                $("#templateGrid").datagrid('load');
                                $.messager.alert('提示', result.msg, 'info');
                            } else {
                                $.messager.alert('警告', result.msg, 'warning');
                            }
                            return true;
                        },
                        error: function () {
                            progressClose();
                            $.messager.alert('错误', '网络错误，请联系管理员', 'error');
                            return false;
                        }
                    })
                }
            })
        }


        //修改
        function editTemplate(id) {
            var url = '${basePath}evaluate/editRemarkTemplate.html?editId=' + id;
            addOrEditTemplate(url, '修改模版');
        }

        //添加
        function addOrEditTemplate(url, title) {
            parent.$.modalDialog({
                href: url,
                title: title,
                modal: true,
                width: '60%',
                height: '80%',
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
                        parent.$.modalDialog.templateGrid = templateGrid;
                        var f = parent.$.modalDialog.handler.find("#setRemarkTemplate");
                        f.submit();
                    }
                }]
            })
        }


    </script>

</head>
<body>
<div style="width: 100%">
    <div style="position: absolute;top: 5px;">
        <span style="font-weight: bold;color: grey;font-size: large;margin-left: 10px">设计题目：</span>
        <a href="javascript:void(0)"
           onclick="addOrEditTemplate('${basePath}evaluate/setDesignRemarkForTutor.html','设计题目——指导教师评语')"
           class="easyui-linkbutton" data-options="iconCls:'icon-edit'"> 指导教师评语条目
        </a>
        <a href="javascript:void(0)"
           onclick="addOrEditTemplate('${basePath}evaluate/setDesignRemarkForReviewer.html','设计题目——评阅人评语')"
           class="easyui-linkbutton"
           data-options="iconCls:'icon-edit'">评阅人评语条目
        </a>
        <a href="javascript:void(0)"
           onclick="addOrEditTemplate('${basePath}evaluate/setDesignRemarkForGroup.html','设计题目——答辩小组评语')"
           class="easyui-linkbutton"
           data-options="iconCls:'icon-edit'">答辩小组评语条目
        </a>

        <span style="font-weight: bold;color: grey;font-size: large;margin-left: 20px">论文题目：</span>
        <a href="javascript:void(0)"
           onclick="addOrEditTemplate('${basePath}evaluate/setPaperRemarkForTutor.html','论文题目——指导教师评语')"
           class="easyui-linkbutton"
           data-options="iconCls:'icon-edit'">指导教师评语条目
        </a>
        <a href="javascript:void(0)"
           onclick="addOrEditTemplate('${basePath}evaluate/setPaperRemarkForReviewer.html','论文题目——评阅人评语')"
           class="easyui-linkbutton"
           data-options="iconCls:'icon-edit'">评阅人评语条目
        </a>
        <a href="javascript:void(0)"
           onclick="addOrEditTemplate('${basePath}evaluate/setPaperRemarkTemplateForGroup.html','论文题目——答辩小组评语')"
           class="easyui-linkbutton"
           data-options="iconCls:'icon-edit'"> 答辩小组评语条目
        </a>
    </div>

    <div style="width: 100%;height: 100%;">
        <table id="templateGrid"></table>
    </div>
</div>
</body>
</html>

