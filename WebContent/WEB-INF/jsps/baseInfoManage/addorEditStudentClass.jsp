<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<form class="form-horizontal" role="form" action="${postActionUrl}"
      method="post">
    <input type="hidden" id="studentClassId" name="editId" value="${studentClass.id}"/>
    <div class="form-group">
        <label>专业：</label>
        <input type="text" id="majorDescription" name="majorDescription" value="${major.description}">
        <input type="hidden" id="majorId" name="majorId" value="${major.id }"/>
    </div>
    <div class="form-group">
        <label for="inputName" class="col-sm-2">班级名称：</label>
        <div class="col-sm-4">
            <input type="text" class="form-control" id="inputName"
                   name="description" value="${studentClass.description}">
        </div>
    </div>

</form>

