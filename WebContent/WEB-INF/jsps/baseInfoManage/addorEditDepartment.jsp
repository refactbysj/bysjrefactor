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
                    $.messager.alert('提示', '请输入教研室名称', 'warning');
                    return isValid;
                }
            },
			success:function (result) {
			    progressClose();
                result = $.parseJSON(result);
                if(result.success) {
                    parent.$.modalDialog.departmentGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                    $.messager.alert('提示', result.msg, 'info');
                }else{
                    $.messager.alert('提示', result.msg, 'warning');
				}
            }
		})
    })
</script>
	<form id="editForm" style="padding: 10px;"  method="post">
		<input type="hidden" id="departmentId" name="editId" value="${department.id}">
			学院：
		<span>${school.description}</span>
			<input type="hidden" id="schoolId" name="schoolId" value="${school.id}"/>
		<br>
			教研室：
				<input type="text" class="easyui-textbox easyui-validatebox" data-options="required:true" id="inputName" name="description" value="${department.description}">
	</form>

