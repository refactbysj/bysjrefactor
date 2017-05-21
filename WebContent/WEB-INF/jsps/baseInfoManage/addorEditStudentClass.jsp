<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<script type="text/javascript">
    $(function () {
        $("#editForm").form({
            url: '${postActionUrl}',
            onSubmit: function () {
                progressLoad();
                var isValid = $("#editForm").form('validate');
                if (!isValid) {
                    progressClose();
                    $.messager.alert('提示', '请输入班级名称', 'warning');
                    return isValid;
                }
            },
            success: function (result) {
                result = $.parseJSON(result);
                progressClose();
                if (result.success) {
                    parent.$.modalDialog.studentClassGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                    $.messager.alert('提示', result.msg, 'info');
                } else {
                    $.messager.alert('提示', result.msg, 'warning');
                }
            }
        })
    })
</script>
<form id="editForm"
      method="post">
    <input type="hidden" id="studentClassId" name="editId" value="${studentClass.id}"/>
    专业：${major.description}
    <input type="hidden" id="majorId" name="majorId" value="${major.id }"/>
    <br>
    <label for="inputName" class="col-sm-2">班级名称：</label>
    <input type="text" class="easyui-textbox easyui-validatebox" data-options="required:true" id="inputName"
           name="description" value="${studentClass.description}">

</form>

