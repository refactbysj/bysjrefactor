<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<script type="text/javascript">
    $(function () {
        $("#schedulerForm").form({
            url:'${actionUrl}',
            onSubmit:function(){
                progressLoad();
                var contentLength = $("#scheduleContent").val().length;
                if (contentLength > 200) {
                    $.messager.alert("提示","字数不应该超过200字",'info');
                    progressClose();
                    return false;
                }

                var isValid = $(this).form('validate');
                if (!isValid) {
                    progressClose();
                }
                return isValid;
            },
            success: function (result) {
                result = $.parseJSON(result);
                progressClose();
                if (result.success) {
                    $.messager.alert("提示", result.msg, 'info');
                    parent.$.modalDialog.scheduleGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    $.messager.alert("警告", result.msg, 'warning');
                }
            }
        });

        $("#scheduleContent").click(function () {
            $(this).select();
        })

    });

</script>
<form method="post" id="schedulerForm">
    <input name="scheduleId" id="scheduleId" type="hidden" value="${schedule.id }"/>

    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal"
                aria-hidden="true">×
        </button>
        <h4 class="modal-title" id="myModalLabel">
            填写工作内容<span style="color: #808080;font-size: smaller">(200字以内)</span>
        </h4>
    </div>
    <div class="modal-body">
        <textarea class="form-control" name="content" rows="10" cols="70" placeholder="请填写工作内容"
                  id="scheduleContent">${content}</textarea>
    </div>
</form>