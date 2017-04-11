<%--
  Created by IntelliJ IDEA.
  User: zhan
  Date: 2016/4/5
  Time: 9:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<script type="text/javascript">
    function cancelAllocate(graduateProjectId, trId) {
        $.messager.confirm('询问', '确认取消？', function (t) {
            if (t) {
                $.ajax({
                    url: '/bysj3/process/cancelGraduateProject.html',
                    data: {"graduateProjectId": graduateProjectId},
                    dataType: 'json',
                    type: 'POST',
                    success: function (result) {
                        if (result.success) {
                            $("#" + trId).remove();
                            $.messager.alert('提示', result.msg, 'info');
                        } else {
                            $.messager.alert('警告', result.msg, 'warning');
                        }
                        return true;
                    },
                    error: function () {
                        $.messager.alert('错误', '网络错误，请联系管理员', 'error');
                        return false;
                    }
                });
            }
        })
    }
</script>
<table class="table table-striped table-bordered table-hover datatable">
    <thead>
    <tr>
        <th>班级</th>
        <th>学号</th>
        <th>姓名</th>
        <th>课题名称</th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <c:choose>
        <c:when test="${graduateProjectSize==null}">

        </c:when>
        <c:otherwise>
            <c:forEach items="${graduateProjectList}" var="graduateProject">
                <tr id="allocatedStudentTr${graduateProject.id}">
                    <td>${graduateProject.student.studentClass.description}</td>
                    <td>${graduateProject.student.no}</td>
                    <td>${graduateProject.student.name}</td>
                    <td>${graduateProject.title}</td>
                    <td>
                        <button onclick="cancelAllocate('${graduateProject.id}','allocatedStudentTr${graduateProject.id}')"
                                class="btn btn-warning">
                            <i class="icon-remove"></i> 取消匹配
                        </button>
                    </td>
                </tr>
            </c:forEach>
        </c:otherwise>
    </c:choose>
    </tbody>
</table>
<c:choose>
    <c:when test="${graduateProjectSize==null}">
        <div class="alert alert-warning alert-dismissable" role="alert">
            <button class="close" type="button" data-dismiss="alert">&times;</button>
            没有已分配的学生
        </div>
    </c:when>
</c:choose>

