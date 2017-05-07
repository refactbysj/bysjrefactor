<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>


<div class="modal-body" id="mail">
    <table class="table table-bordered table-striped">
        <tbody>
        <tr>
            <th>发布时间</th>
            <td><fmt:formatDate value="${mail.addressTime.time}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
        </tr>
        <tr>
            <th>发布者</th>
            <td>${mail.addressor.name} </td>
        </tr>
        <tr>
            <th>内容</th>
            <td width="auto">${mail.content}</td>
        </tr>
        <tr>

            <th>附件</th>
            <c:choose>
                <c:when test="${empty mail.attachment}">
                    <td>无附件</td>
                </c:when>
                <c:otherwise>
                    <td><a class="easyui-linkbutton" href="<%=basePath%>notice/downloadMail.html?mailId=${mail.id}">下载附件</a></td>
                </c:otherwise>
            </c:choose>

        </tr>
        </tbody>
    </table>
</div>
