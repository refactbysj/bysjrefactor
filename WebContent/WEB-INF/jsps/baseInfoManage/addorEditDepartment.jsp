<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


	<form class="form-horizontal" role="form" action="${postActionUrl}" method="post">
		<input type="hidden" id="departmentId" name="editId" value="${department.id}">
		<div class="form-group">
			<label for="inputEmail3" class="col-sm-2">学院：</label>
			<input type="text" id="schoolDescription" name="schoolDescription" value="${school.description}" disabled>
			<input type="hidden" id="schoolId" name="schoolId" value="${school.id}"/>
		</div>
		<div class="form-group">
			<label for="inputName" class="col-sm-2">教研室名称：</label>
			<div class="col-sm-4">
				<input type="text" class="form-control" id="inputName" name="description" value="${department.description}">
			</div>
		</div>
	</form>

