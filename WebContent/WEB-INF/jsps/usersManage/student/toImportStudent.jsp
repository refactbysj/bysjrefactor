<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<script type="text/javascript">
	$(function () {
		$("#importForm").form({
			url:'<%=basePath%>import/importStudentsFromExcel.html',
			onSubmit:function () {
				progressLoad();
                var isValide = $(this).form('validate');
                if(!isValide) {
					progressClose();
                    $.messager.alert('提示', '请选择文件', 'warning');
                    return isValide;
                }
                var fileName = $("#inputfile").textbox('getText');
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
                    parent.$.modalDialog.studentGrid.datagrid('load');
                    parent.$.modalDialog.handler.dialog('close');
                    $.messager.alert('提示', result.msg, 'info');
                }else{
                    $.messager.alert('提示', result.msg, 'warning');
				}
            },
			error:function () {
                $.messager.alert('错误', '网络错误，请联系管理员', 'error');
                return false;
            }
		})
    })
</script>
<form enctype="multipart/form-data" id="importForm"
	method=post>

	<div class="modal-body">
		<div class="form-group">
			<input id="inputfile" style="width: 90%;" name="file" class="easyui-filebox" data-options="required:true">
			<p class="help-block">请选择要导入的学生EXCEL表</p>
			<p class="help-block" style="color:red">导入时间较长，请耐心等待</p>
		</div>
	</div>

</form>