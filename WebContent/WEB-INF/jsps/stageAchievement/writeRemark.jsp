<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script type="text/javascript">
    $(function () {
        var word = $("#remark").text();
        var wordCount = word.length;
        $("#wordCount").text(wordCount);

        $('#addOrEidtRemarkForm').form({
            url : '${basePath}editRemark.html?stageAchievementId=${stageAchievementId}',
            onSubmit : function() {
                progressLoad();
                var s = $('#remark').val().length;
                if (s > 200) {
                    myAlert("字数不能大于200字");
                 }
                    progressClose();
                },
            success : function(result) {
            progressClose();
            result = $.parseJSON(result);
            if (result.success) {
                parent.$.modalDialog.openner_grid.datagrid('reload');
                parent.$.modalDialog.handler.dialog('close');
            } else {
                parent.$.messager.alert('错误', result.msg, 'error');
            }
        }
    })
});
function checkCount() {
var word = $("#remark").val();
var count = word.length;
$("#wordCount").text(count);
if(count>200){
    word = word.substring(0, 199);
    $("#remark").val(word);
}
}
</script>
<form id="addOrEidtRemarkForm" method="post">
<span style="color: grey;">(200字以内，字数：<span id="wordCount">0</span>/200)</span>
<textarea class="form-control"onkeyup="checkCount()" id="remark" rows="10"  cols="63" name="remark"
      required="required">${remark}</textarea>
</form>