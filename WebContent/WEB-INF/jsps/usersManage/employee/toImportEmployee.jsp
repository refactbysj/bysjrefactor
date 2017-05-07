<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<script type="text/javascript">
	$(function () {
		$("#importForm").form({
			url:'<%=basePath%>import/importEmployeesFromExcel.html',
			onSubmit:function () {
			    progressLoad();
                var isValidate = $(this).form('validate');
                if(!isValidate) {
                    progressClose();
                    $.messager.alert('提示', '请选择文件', 'warning');
                    return isValidate;
                }
                var fileName = $("#updateFile").textbox('getText');
				var extendName = fileName.substring(fileName.lastIndexOf('.')+1,fileName.length);
				if(extendName!='xls'&&extendName!='xlsx') {
				    progressClose();
                    $.messager.alert('提示', '请选择Excel文件', 'warning');
                    return false;
                }


            },
			success:function (result) {
				progressClose();
                result = $.parseJSON(result);
                if(result.success) {
                    parent.$.modalDialog.employeeGrid.datagrid('load');
                    parent.$.modalDialog.handler.dialog('close');
                    $.messager.alert('提示', result.msg, 'info');
                }else{
                    $.messager.alert('提示', result.msg, 'warning');
				}
            },
			error:function () {
				progressClose();
                $.messager.alert('错误', '网络错误，请联系管理员', 'error');
            }
		})
    })
</script>
<form enctype="multipart/form-data" id="importForm" method="post" style="margin-left: 2%;margin-top: 3%">
			<input style="width: 90%;" name="file" id="updateFile" class="easyui-filebox" data-options="required:true">
			<p class="help-block">请选择要导入的教师EXCEL表</p>
			<p class="help-block" style="color:red">数据导入过程时间较长，请耐心等待</p>

</form>