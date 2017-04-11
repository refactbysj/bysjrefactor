<%--
  Created by IntelliJ IDEA.
  User: zhan
  Date: 2016/4/13
  Time: 15:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="light-info" style="width: 100%;height: auto;">
    <h4>
        ${tutor.name}老师的学生
    </h4>
    <h5>共${count}个学生,已有${selectProject}人选择课题</h5>
</div>
<table class="table table-striped table-bordered table-hover datatable">
    <thead>
    <tr>
        <th>学号</th>
        <th>姓名</th>
        <th>班级</th>
        <th>课题</th>
    </tr>
    </thead>
    <tbody>
    <c:choose>
        <c:when test="${studentList==null}">
            <h4>未匹配学生</h4>
        </c:when>
        <c:otherwise>
            <c:forEach items="${studentList}" var="student">
                <tr>
                    <td>${student.no}</td>
                    <td>${student.name}</td>
                    <td>${student.studentClass.description}</td>
                    <td>
                        <c:choose>
                            <c:when test="${student.graduateProject==null}">
                                未选择课题
                            </c:when>
                            <c:otherwise>
                                ${student.graduateProject.title}
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </c:otherwise>
    </c:choose>
    </tbody>

</table>

