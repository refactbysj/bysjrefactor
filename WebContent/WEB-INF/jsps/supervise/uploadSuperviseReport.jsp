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
        $("#upReportForm").form({
            url: '<%=basePath%>/process/uploadSupervisionReport.html',
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
        $('#superReportFile').filebox({
            onChange: function (newValue, oldValue) {
                //现在只督导》提交督导报告，修改显示路径问题
                //在mac下文件显示的路径不对，因此直接只显示文件名，不显示路径
                $('#superReportFile').filebox('setValue', newValue.replace("C:\\fakepath\\", ""));
            }
        });
    })
</script>
<form method="post" style="padding: 10px;"
      id="upReportForm"
      enctype="multipart/form-data">
    <input class="easyui-filebox" style="width: 70%;" data-options="buttonText:'选择文件',required:true"
           id="superReportFile" name="superReportFile"/>

</form>
