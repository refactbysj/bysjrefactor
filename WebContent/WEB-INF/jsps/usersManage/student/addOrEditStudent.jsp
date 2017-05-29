<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script type="text/javascript">
    $(function () {
        $("#editForm").form({
            url:'${postActionUrl}',
            onSubmit:function () {
                progressLoad();
                var isValide = $(this).form('validate');
                if(!isValide) {
                    progressClose();
                }
                return isValide;
            },
            success:function (result) {
                progressClose();
                result = $.parseJSON(result);
                if(result.success) {
                    parent.$.modalDialog.studentGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                    $.messager.alert('提示', result.msg, 'info');
                }else{
                    $.messager.alert('提示', result.msg, 'warning');
                }
            },
            error:function () {
                progressClose();
                $.messager.alert('错误', '网络错误，请联系管理员', 'error');
            }
        })
    })

</script>
<div>
    <form:form commandName="student" id="editForm"
               method="post">
        <form:input type="hidden" path="id" value="${student.id}"/>
        <table class="table table-bordered">
            <tr>
                <td>学号：</td>
                <td>
                    <form:input type="text" class="easyui-textbox easyui-validatebox" data-options="required:true" id="inputName"
                                path="no"/>
                </td>
                <td>姓名：</td>
                <td>
                    <form:input path="name" type="text" class="easyui-textbox easyui-validatebox" data-options="required:true" id="inputNum"/>
                </td>
            </tr>
            <tr>
                <td>班级：</td><%--school.id==student.studentClass.major.department.school.id--%>
                <td colspan="3">
                        <%--需要从后台传递一个schoolList的参数，里面存放了所有的学院--%>
                    <select id="schoolSelectModal"
                            name="schoolSelect" onchange="schoolOnSelectModal()">
                        <option value="0">--请选择学院(必填)--</option>
                        <c:forEach items="${schoolList}" var="school">
                            <option value="${school.id }" class="selectSchool"
                                    <c:if test="${school.id==student.studentClass.major.department.school.id}">selected</c:if>>${school.description}</option>
                        </c:forEach>
                    </select>
                    <select  id="departmentSelectModal"
                            name="departmentSelect" onchange="departmentOnSelectModal()">
                        <option value="0">--请选择教研室(必填)--</option>
                        <c:forEach items="${departmentList}" var="department">
                            <option value="${department.id}" <c:if test="${department.id==student.studentClass.major.department.id}">selected</c:if>>${department.description}</option>
                        </c:forEach>
                    </select>
                    <select  id="studentClassModal"
                            name="studentClassSelect">
                        <option value="0">--请选择班级(必填)--</option>
                        <c:forEach items="${studentClassList}" var="studentClass">
                            <option value="${studentClass.id}" <c:if test="${studentClass.id==student.studentClass.id}">selected</c:if>>${studentClass.description}</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <td>性别：</td>
                <td>
                    <form:radiobutton path="sex" value="男" name="sex"
                                      id="sex1"/>
                    男
                    <form:radiobutton path="sex" value="女" name="sex"
                                      id="sex2"/>
                    女
                </td>
                <td>联系电话：</td>
                <td>
                    <form:input type="text" class="easyui-numberbox" id="inputEmail3"
                                path="contact.moblie"/>
                </td>
            </tr>
            <tr>
                <td>QQ：</td>
                <td>
                    <form:input type="text" class="easyui-numberbox" id="inputEmail3"
                                path="contact.qq"/>
                </td>
                <td>邮箱: </td>
                <td>
                    <form:input type="email" class="easyui-validatebox textbox" data-options="validType:'email'" id="inputEmail3"
                                path="contact.email"/>
                </td>
            </tr>
        </table>
    </form:form>

</div>


