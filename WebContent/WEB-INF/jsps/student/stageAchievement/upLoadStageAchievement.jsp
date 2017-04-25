<%--
  Created by IntelliJ IDEA.
  User: 慧
  Date: 2017/4/23
  Time: 12:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<script type="text/javascript">
    $(function () {
        $("#updateStageAchievementForm").form({
            url: '<%=basePath%>student/uploadStageAchievement.html',
            onSubmit: function () {
                progressLoad();
                var isValid = $(this).form('validate');
                if (!isValid) {
                    progressClose();
                }
                return isValid;
            },
            success: function (result) {
                progressClose();
                result = $.parseJSON(result);
                if (result.success) {
                    $.messager.alert('提示', result.msg, 'info');
                    parent.$.modalDialog.stageAchGird.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    $.messager.alert('提示', result.msg, 'warning');
                }
            }

        })
    })
</script>
<form method="post" style="padding: 10px;"
      id="updateStageAchievementForm"
      enctype="multipart/form-data">
    <input class="easyui-filebox" style="width: 70%;" data-options="buttonText:'选择文件',required:true"
           name="stageAchievementFile"/>

</form>

