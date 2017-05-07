<%--
  Created by IntelliJ IDEA.
  User: 张战
  Date: 2016/2/16
  Time: 22:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<script type="text/javascript">
    $(function () {
        $("#editForm").form({
            url:'${actionUrl}',
            onSubmit:function () {
                progressLoad();
                var isValid = $(this).form('validate');
                if(!isValid) {
                    progressClose();
                }
                return isValid;
            },
            success:function (result) {
                progressClose();
                result = $.parseJSON(result);
                if(result.success) {
                    parent.$.modalDialog.mailGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                    $.messager.alert('提示', result.msg, 'info');
                }else{
                    $.messager.alert('提示', result.msg, 'warning');
                }
            },
            error:function () {
                progressClose();
                $.messager.alert('提示', '网络错误，请联系管理员', 'error');
                return false;
            }
        })
    })
</script>
<form:form enctype="multipart/form-data" commandName="mail" id="editForm" cssStyle="padding: 10px;">
    <input type="hidden" value="${mailIdToEdit}" name="mailIdToEdit"/>
    <dl>
        <dt>标题</dt>
        <dd>
            <form:input cssClass="easyui-textbox" cssStyle="width: 100%;" data-options="requried:true" type="text" path="title"/>
        </dd>
        <dt>内容</dt>
        <dd>
            <form:textarea path="content" rows="5" cols="63" cssStyle="width: 100%;"  data-options="required:true"/>
        </dd>
        <dt>附件</dt>
        <dd>
            <input type="file" class="form-control" name="mailAttachment">
        </dd>
    </dl>
</form:form>
