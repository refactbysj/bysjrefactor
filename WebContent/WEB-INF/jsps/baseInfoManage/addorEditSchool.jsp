<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<form class="form-horizontal" role="form" id="editSchoolForm" action="${postActionUrl}"
      method="post">
    <input type="hidden" id="schoolId" name="editId" value="${school.id}"/>

    <span style="color: grey;">名称：</span>
    <input type="text" class="easyui-textbox" id="inputName"
           name="description" value="${school.description}">
</form>

