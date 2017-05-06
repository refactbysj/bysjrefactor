<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<script type="text/javascript">
    $(function () {
        $("#editForm").form({
            url:'${postActionUrl}',
            onSubmit:function () {
                progressLoad();
                var isValid = $(this).form('validate');
                if(!isValid) {
                    progressClose();
                    $.messager.alert('警告', '输入不合法', 'warning');
                }
                return isValid;
            },
            success:function (result) {
                progressClose();
                result = $.parseJSON(result);
                if(result.success) {
                    parent.$.modalDialog.employeeGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                    $.messager.alert('提示', result.msg, 'info');
                }else{
                    $.messager.alert('提示', result.msg, 'warning');
                }
            }
        })
    })

</script>

<div class="modal-body">
    <form:form commandName="employee" id="editForm"
               method="post" >
        <form:input path="id" type="hidden" value="${employee.id}"/>
        <table style="width: 100%;height: 100%;" class="table table-bordered">
            <tr>
                <td>姓名：
                </td>
                <td>
                    <form:input type="text" class="easyui-textbox" data-options="required:true" id="inputName"
                                path="name"/>
                </td>
                <td>
                    职工号：
                </td>
                <td>
                    <form:input type="text" class="easyui-textbox" data-options="required:true" id="inputNum" path="no"/>
                </td>
            </tr>
            <tr>
                <td>
                    性别：

                </td>
                <td>
                    <form:radiobutton path="sex" value="男" name="sex"
                                      id="sex1"/>
                    男
                    <form:radiobutton path="sex" value="女" name="sex"
                                      id="sex2"/>
                    女
                </td>
                <td>
                    职位：
                </td>
                <td>
                    <select name="proTitle">
                        <option value="0">--请选择职位--</option>
                        <c:forEach items="${proTitle}" var="proTitle">
                            <option value="${proTitle.description}"
                                    <c:if test="${proTitle.description==employee.proTitle.description}">selected</c:if>>${proTitle.description}</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <td colspan="1">
                    教研室：
                </td>
                <td colspan="3">
                    <select id="schoolSelectModal"
                            onchange="schoolOnSelectModal()" required>
                        <option value="0">--请选择学院(必填)--</option>
                        <c:forEach items="${schoolList}" var="school">
                            <option value="${school.id}" class="selectSchool"
                                    <c:if test="${school.id==employee.department.school.id}">selected</c:if>>${school.description}</option>
                        </c:forEach>
                    </select>
                    <select  id="departmentSelectModal"
                             name="departmentId" required>
                        <c:if test="${edited}">
                            <c:forEach items="${departmentList}" var="department">
                                <option value="${department.id }"
                                        <c:if test='${currentDepartment.id==department.id}'>selected</c:if>>${department.description}</option>
                            </c:forEach>
                        </c:if>
                    </select>
                </td>
            </tr>
            <tr>
                <td>
                    学位：
                </td>
                <td>
                    <select name="degree">
                        <option value="0">--请选择学位--</option>
                        <c:forEach items="${degree}" var="degree">
                            <option value="${degree.description}"
                                    <c:if test="${degree.description==employee.degree.description}">selected</c:if>>${degree.description}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>
                    联系电话：
                </td>
                <td>
                    <form:input type="text" class="easyui-numberbox"  path="contact.moblie"/>
                </td>
            </tr>
            <tr>
                <td>
                    QQ：
                </td>
                <td>
                    <form:input type="text" class="easyui-numberbox" path="contact.qq"/>
                </td>
                <td>
                    邮箱：
                </td>
                <td>
                    <form:input type="email" class="easyui-validatebox textbox" data-options="validType:'email'" path="contact.email"/>
                </td>
            </tr>
        </table>
    </form:form>
</div>


