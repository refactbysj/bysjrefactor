<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<h4 class="modal-title" id="myModalLabel">
    ${description},总数：${fn:length(graduateProjectList)}
</h4>
<table id="graduateProjectDetail"  class="table table-striped table-bordered table-hover datatable">
    <thead>
    <tr>
        <th></th>
        <th>课题名称</th>
        <th>指导老师</th>
        <th>学号</th>
        <th>姓名</th>
        <th>班级</th>
    </tr>
    </thead>
    <tbody>
    <c:choose>
        <c:when test="${empty graduateProjectList}">
            <div class="alert alert-warning alert-dismissable" role="alert">
                <button class="close" type="button" data-dismiss="alert">&times;</button>
                没有可以显示的信息
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach items="${graduateProjectList}" var="graduateProject" varStatus="status">
                <tr>
                    <td>${status.index+1}</td>
                    <td>
                        <c:choose>
                            <c:when test="${graduateProject.subTitle==null||graduateProject.subTitle==''}">
                                ${graduateProject.title}
                            </c:when>
                            <c:otherwise>
                                ${graduateProject.title}——${graduateProject.subTitle}
                            </c:otherwise>
                        </c:choose>
                            </td>
                    <td>${graduateProject.mainTutorage.tutor.name}</td>
                    <td>${graduateProject.student.no}</td>
                    <td>${graduateProject.student.name}</td>
                    <td>${graduateProject.student.studentClass.description}</td>
                </tr>
            </c:forEach>
        </c:otherwise>
    </c:choose>
    </tbody>
</table>
