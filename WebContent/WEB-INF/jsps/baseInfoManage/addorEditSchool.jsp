<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<script type="text/javascript">
    $(function () {
        $("#editSchoolForm").form({
            url:'${postActionUrl}',
            onSubmit:function () {
                progressLoad();
                var isValid = $("#editSchoolForm").form('validate');
                if(!isValid) {
                    progressClose();
                    $.messager.alert('提示', '请输入学院名称', 'warning');
                    return isValid;
                }
            },
            success:function (result) {
                progressClose();
                result = $.parseJSON(result);
                if(result.success) {
                    parent.$.modalDialog.schoolGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                    $.messager.alert('提示', result.msg, 'info');
                }else{
                    $.messager.alert('提示', result.msg, 'warning');
                }
            }

        })
    })
</script>
<form class="form-horizontal" role="form" id="editSchoolForm" style="padding: 10px;"
      method="post">
    <input type="hidden" id="schoolId" name="editId" value="${school.id}"/>

    <span style="color: grey;">名称：</span>
    <input type="text" class="easyui-textbox easyui-validatebox" data-options="required:true" style="width: 80%;" id="inputName"
           name="description" value="${school.description}">
</form>

