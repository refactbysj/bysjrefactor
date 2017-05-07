<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<html>
<head>
    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
    <script type="text/javascript">
        var mailGrid;
        $(function () {
            mailGrid = $("#sendMailTable").datagrid({
                url:'${basePath}notice/getMailData.html',
                pagination:true,
                fit:true,
                singleSelect:true,
                striped:true,
                columns:[[{
                    title:'标题',
                    width:'30%',
                    field:'title'
                },{
                    title:'发布时间',
                    field:'sendTime',
                    width:'20%',
                    formatter:function (value, row) {
                        console.log(row.addressTime);
                        var date = new Date();
                        date.setTime(row.addressTime);
                        return date.toLocaleString();
                    }
                },{
                    title:'操作',
                    width:'20%',
                    field:'action',
                    formatter:function (value, row) {
                        var str = '';
                        str += $.formatString('<a href="javascript:void(0)" class="detailBtn" onclick="mailDetail(\'{0}\')"></a>', row.id);
                        str += $.formatString('<a href="javascript:void(0)" class="editBtn" onclick="editMail(\'{0}\')"></a>', row.id);
                        str += $.formatString('<a href="javascript:void(0)" class="delBtn" onclick="delMail(\'{0}\')"></a>', row.id);
                        return str;
                    }
                }]],
                onLoadSuccess:function () {
                    $(".detailBtn").linkbutton({text: '查看', plain: true, iconCls: 'icon-more'});
                    $(".editBtn").linkbutton({text: '修改', plain: true, iconCls: 'icon-edit'});
                    $(".delBtn").linkbutton({text: '删除', plain: true, iconCls: 'icon-cancel'});
                }
            })
        });

        //显示详情
        function mailDetail(id) {
            parent.$.modalDialog({
                href:'${basePath}notice/sendViewMail.html?mailId='+id,
                modal:true,
                width:'50%',
                height:'50%',
                title:'邮件详情',
                buttons:[{
                    text:'关闭',
                    iconCls:'icon-cancel',
                    handler:function () {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                }]
            })
        }

        //编辑邮件
        function editMail(id) {
            parent.$.modalDialog({
                href:'${basePath}notice/editMail.html?mailIdToEdit='+id,
                model:true,
                title:'修改邮件',
                width:'50%',
                height:'50%',
                buttons:[{
                    text:'取消',
                    iconCls:'icon-cancel',
                    handler:function () {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                },{
                    text:'提交',
                    iconCls:'icon-edit',
                    handler:function () {
                        parent.$.modalDialog.mailGrid=mailGrid;
                        var f = parent.$.modalDialog.handler.find('#editForm');
                        f.submit();
                    }
                }]
            })
        }

        //写邮件
        function writeMail() {
            parent.$.modalDialog({
                href:'${basePath}notice/sendMail.html',
                modal:true,
                width:'70%',
                height:'80%',
                title:'发送邮件',
                buttons:[{
                    text:'取消',
                    iconCls:'icon-cancel',
                    handler:function () {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                },{
                    text:'发送',
                    iconCls:'icon-ok',
                    handler:function () {
                        parent.$.modalDialog.mailGrid = mailGrid;
                        var f = parent.$.modalDialog.handler.find('#sendMailForm');
                        f.submit();
                    }
                }]
            })
        }

        function delMail(id) {
            $.messager.confirm('询问','确认删除？',function (t) {
                if(t) {
                    progressLoad();
                    $.ajax({
                        url: '${basePath}notice/delMail.html',
                        data: {"mailId": id},
                        dataType: 'json',
                        type: 'post',
                        success: function (result) {
                            progressClose();
                            if(result.success) {
                                $("#sendMailTable").datagrid('reload');
                                $.messager.alert('提示', result.msg, 'info');
                            }else{
                                $.messager.alert('提示', result.msg, 'warning');
                            }
                            return true;
                        },
                        error: function () {
                            progressClose();
                            $.messager.alert('错误', '网络错误，请联系管理员', 'error');
                            return false;
                        }

                    });
                }
            })
        }
    </script>
</head>
<body>

<div style="position: absolute;top: 10px;left: 1%">
    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="writeMail()" data-options="iconCls:'icon-edit'">
        写邮件
    </a>

</div>
<div style="height: 100%;">
    <table id="sendMailTable"></table>
</div>

</body>
</html>


