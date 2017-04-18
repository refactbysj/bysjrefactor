<%--
  Created by IntelliJ IDEA.
  User: zhan
  Date: 2017/4/18 0018
  Time: 10:26
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
        $("#updateTaskDocForm").form({
            url: '<%=basePath%>tutor/taskDocUpLoad.html',
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
                    parent.$.modalDialog.projectGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    $.messager.alert('提示', result.msg, 'warning');
                }
            }

        })
    })
</script>

<form method="post"
      id="updateTaskDocForm"
      enctype="multipart/form-data">
    <input type="hidden" name="graduateProjectId" value="${projectId}"/>

    <input type="file" class="form-control"
           id="taskDoc${projectId}" name="taskDocAttachment"
           required/>

</form>
