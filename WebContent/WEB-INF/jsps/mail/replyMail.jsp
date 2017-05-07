<%--
  Created by IntelliJ IDEA.
  User: 张战
  Date: 2016/5/5
  Time: 21:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<script type="text/javascript">


    $(function () {
        $("#receiveMailForm").form({
            url:'<%=basePath%>notice/replyMail.html',
            onSubmit:function () {
                progressLoad();
                if ($("#mailContent").val().length > 200) {
                    progressClose();
                    $.messager.alert('提示', '字数不超过200字', 'info');
                    return false;
                }
            },
            success:function (result) {
                progressClose();
                result = $.parseJSON(result);
                if(result.success) {
                    parent.$.modalDialog.receiveGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                    $.messager.alert('提示', result.msg, 'info');
                }else{
                    $.messager.alert('提示', result.msg, 'warning');
                }
            },
            error:function () {
                progressClose();
                $.messager.alert('错误', '网络错误，请联系管理员', 'error');
                return false;
            }
        })
    })
</script>

<div class="modal-body">

    <form:form  id="receiveMailForm" commandName="replyMail">
        <input type="hidden" name="parentMailId" value="${mail.id}">
        <dt>内容：<span style="color: #808080;font-size: smaller">(200字以内)</span></dt>

        <dd>

        <form:textarea path="content" id="mailContent" class="form-control" rows="3"
                  cols="63"></form:textarea>
        </dd>
        <br>
        <span style="font-weight: bold;font-size: large;color: grey;">${mail.addressor.name}发送的邮件：</span>
        <table class="table">
            <tr>
                <td>标题</td>
                <td colspan="3">${mail.title}</td>
            </tr>
            <tr>
                <td>发送时间：</td>
                <td>
                    <fmt:formatDate value="${mail.addressTime.time}" pattern="yyyy-MM-dd HH:mm:ss"/>

                </td>
                <td>发件人：</td>
                <td>
                    ${mail.addressor.name}
                </td>
            </tr>
            <tr>
                <td>内容：</td>
                <td colspan="3">
                    ${mail.content}
                </td>

            </tr>
        </table>
    </form:form>

</div>
