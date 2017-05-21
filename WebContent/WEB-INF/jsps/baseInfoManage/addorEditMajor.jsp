<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<script type="text/javascript">
	$(function () {
		$("#editForm").form({
			url:'${postActionUrl}',
			onSubmit:function () {
				progressLoad();
                var isValid = $("#editForm").form('validate');
                if(!isValid) {
					progressClose();
                    $.messager.alert('提示', '请输入专业名称', 'warning');
                    return isValid;
                }
            },
			success:function (result) {
			    progressClose();
                result = $.parseJSON(result);
                if(result.success) {
                    parent.$.modalDialog.majorGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                    $.messager.alert('提示', result.msg, 'info');
                }else{
                    $.messager.alert('提示', result.msg, 'warning');
                }
            }
		})
    })
</script>
	<form id="editForm" style="padding: 10px;"
		method="post">
		<input type="hidden" id="majorId" name="editId" value="${major.id}"/>
		教研室：${department.description}
		<input type="hidden" id="departmentId" name="departmentId" value="${department.id}">
		<br>
			专业名称：
				<input type="text" class="easyui-textbox easyui-validatebox" data-options="required:true" id="inputName"
					name="description" value="${major.description}">
	</form>
