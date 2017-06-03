<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script type="text/javascript">
	$(function () {
		$("#editForm").form({
			url:'${postActionUrl}',
			onSubmit:function () {
			    progressLoad();
                var isValid = $("#editForm").form("validate");
                if(!isValid) {
					progressClose();
                    $.messager.alert('提示', '请输入必选项', 'warning');
                    return isValid;
                }
                var departmentId = $("#departmentSelectModal option:selected").val();
                if(departmentId==null||departmentId=='') {
					progressClose();
                    $.messager.alert('提示', '请选择教研室', 'warning');
                    return false;
                }
            },
			success:function (result) {
				progressClose();
                result = $.parseJSON(result);
                if(result.success) {
                    parent.$.modalDialog.visitingGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                    $.messager.alert('提示', result.msg, 'info');
                }else{
                    $.messager.alert('提示', result.msg, 'warning');
                }
            }
		})
    })
</script>
	<form:form commandName="visitingEmployee" id="editForm" method="post" role="form" cssStyle="height: 90%;">
		<form:input type="hidden" path="id" value="${visitingEmployee.id}"/>
		<table class="table table-bordered" style="height: 100%;width: 100%;">
			<tr>
				<td>姓名：</td>
				<td>
					<form:input type="text" class="easyui-validatebox easyui-textbox" data-options="required:true" id="inputName" path="name"/>
				</td>
				<td>职工号：</td>
				<td>
					<form:input type="text" class="easyui-validatebox easyui-textbox" data-options="required:true" id="inputNum" path="no"/>

				</td>
			</tr>
			<tr>
				<td>性别：</td>
				<td>
					<form:radiobutton path="sex" value="男" name="sex" id="sex"/>男
					<form:radiobutton path="sex" value="女" name="sex" id="sex"/>女
				</td>
				<td>职位：</td>
				<td>
					<select name="proTitle">
						<option value="0">--请选择职位--</option>
						<c:forEach items="${proTitle}" var="proTitle">
							<option value="${proTitle.description}" <c:if test="${proTitle.description==visitingEmployee.proTitle.description}">selected</c:if>>${proTitle.description}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td>学位：</td>
				<td>
					<select name="degree">
						<option value="0">--请选择学位--</option>
						<c:forEach items="${degree}" var="degree">
							<option value="${degree.description}" <c:if test="${degree.description==visitingEmployee.degree.description}">selected</c:if>>${degree.description}</option>
						</c:forEach>
					</select>
				</td>
				<td>邮箱：</td>
				<td>
					<form:input type="email" class="easyui-textbox" path="contact.email" />
				</td>
			</tr>
			<tr>
				<td>教研室：</td>
				<td colspan="3">
					<select id="schoolSelectModal"
							onchange="schoolOnSelectModal()"  required>
						<option value="0">--请选择学院--</option>
						<c:forEach items="${schoolList}" var="school">
							<option value="${school.id}" class="selectSchool" <c:if test="${school.id==visitingEmployee.department.school.id}">selected</c:if>>${school.description}</option>
						</c:forEach>
					</select>
					<select id="departmentSelectModal"
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
				<td>公司：</td>
				<td>
					<form:input type="text" class="easyui-textbox" path="company"/>
				</td>
				<td>小语种：</td>
				<td>
					<form:input type="text" class="easyui-textbox" path="foreignLanguage" />

				</td>
			</tr>
			<tr>
				<td>毕业院校：</td>
				<td>
					<form:input type="text" class="easyui-textbox" path="graduateFrom" />

				</td>
				<td>工作经验：</td>
				<td>
					<form:input type="text" class="easyui-textbox" path="experience" />
				</td>
			</tr>
			<tr>
				<td>专业：</td>
				<td>
					<form:input type="text" class="easyui-textbox" path="speciality" />
				</td>
				<td>计划：</td>
				<td>
					<form:input type="text" class="easyui-textbox" path="plan" />
				</td>
			</tr>
			<tr>
				<td>联系电话：</td>
				<td>
					<form:input type="text" class="easyui-textbox" path="contact.moblie" />
				</td>
				<td>QQ：</td>
				<td>
					<form:input type="text" class="easyui-textbox" path="contact.qq" />
				</td>
			</tr>

		</table>
	</form:form>
