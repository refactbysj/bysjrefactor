<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8" %>
<html>
<head>
	<%@ include file="/WEB-INF/jsps/includeURL.jsp"%>
	<script type="text/javascript">
		var receiveGrid;
        $(function () {
            receiveGrid = $("#recevieMailTable").datagrid({
                url:'${basePath}notice/getMailToMeData.html',
                pagination:true,
                fit:true,
                striped:true,
                singleSelect:true,
                columns:[[{
                    title:'标题',
                    field:'title',
					width:'30%',
                    formatter:function (value, row) {
                        return row.mail.title;
                    }
                },{
                    title:'发布时间',
                    field:'time',
					width:'15%',
                    formatter:function (value, row) {
                        var date = new Date();
                        date.setTime(row.mail.addressTime);
                        return date.toLocaleString();
                    }
                },{
                    title:'发件人',
					width:'8%',
                    field:'addressor',
                    formatter:function (value, row) {
                        return row.mail.addressor.name;
                    }
                },{
                    title:'状态',
                    field:'status',
					width:'5%',
                    formatter:function (value, row) {
                        if(row.isRead) {
                            return '<span style="color: green;">已读</span>';
                        }else{
                            return '未读';
                        }
                    }
                },{
                    title:'操作',
					width:'20%',
                    field:'action',
                    formatter:function (value,row) {
                        var str = '';
                        str += $.formatString('<a href="javascript:void(0)" onclick="detailFun(\'{0}\')" class="detailBtn"></a>', row.id);
                        str += $.formatString('<a href="javascript:void(0)" onclick="replyFun(\'{0}\')" class="replyBtn"></a>', row.mail.id);
                        return str;
                    }
                }]],
                onLoadSuccess:function () {
                    $(".detailBtn").linkbutton({text: '详情', iconCls: 'icon-more', plain: true});
                    $(".replyBtn").linkbutton({text: '回复', iconCls: 'icon-redo', plain: true});
                }
            })
        });

        //回复邮件
        function replyFun(id) {
            parent.$.modalDialog({
                href:'${basePath}notice/replyMail.html?parentMailId='+id,
                modal:true,
                width:'50%',
                height:'60%',
                title:'回复邮件',
                buttons:[{
                    text:'关闭',
                    iconCls:'icon-cancel',
                    handler:function () {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                },{
                    text:'回复',
					iconCls:'icon-ok',
					handler:function () {
						parent.$.modalDialog.receiveGrid =  receiveGrid;
                        var f = parent.$.modalDialog.handler.find('#receiveMailForm');
                        f.submit();
                    }
				}]
            })
        }

        //邮件详情
        function detailFun(id) {
            parent.$.modalDialog({
                href:'${basePath}notice/receiveViewMail.html?mailId='+id,
                modal:true,
                width:'50%',
                height:'50%',
                title:'邮件详情',
                buttons:[{
                    text:'关闭',
                    iconCls:'icon-cancel',
                    handler:function () {
                        $("#recevieMailTable").datagrid('reload');
                        parent.$.modalDialog.handler.dialog('close');
                    }
                }]
            })
        }
	</script>

</head>
<body>
<%--<div class="alert alert-warning" role="alert">
	<button class="close" type="button" data-dismiss="alert">&times;</button>
	您当前没有收到任何消息！
</div>--%>

	<table id="recevieMailTable" style="height: 100%;"></table>



</body>
</html>


