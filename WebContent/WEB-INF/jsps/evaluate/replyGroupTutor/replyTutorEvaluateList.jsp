<%--
  Created by IntelliJ IDEA.
  User: 张战
  Date: 2016/6/1
  Time: 20:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="/WEB-INF/jsps/includeURL.jsp" %>
</head>
<body class="easyui-layout" data-options="border:false" style="width: 100%;height: 100%;">
<div data-options="region:'north'" style="height: 10%;">
    <div class="light-info">
        <a class="easyui-linkbutton" style="float: left;" data-options="iconCls:'icon-back'"
           href="<%=basePath%> evaluate/replyGroup/projectsToEvaluate.html"> 返回</a>
        <span style="color: grey;margin-left: 2%">所在答辩小组名称：</span>&nbsp;${replyGroup.description}&nbsp;&nbsp;<span
            style="color: grey;">学生：</span>&nbsp;${graduateProject.student.name}&nbsp;&nbsp;<span
            style="color:grey">课题名称：</span>&nbsp;<c:choose><c:when
            test="${empty graduateProject.title}">空</c:when><c:otherwise>${graduateProject.title}</c:otherwise></c:choose>----<c:choose><c:when
            test="${empty graduateProject.subTitle}"></c:when><c:otherwise>${graduateProject.subTitle}</c:otherwise></c:choose>
    </div>
</div>
<div data-options="region:'west',title:'答辩老师评审'" style="width: 50%;">
    <table class="table table-hover">
        <thead>
        <tr>
            <th>答辩老师</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${empty graduateProject.replyGroup}">
                <div class="alert alert-warning alert-dismissable" role="alert">
                    <button class="close" type="button" data-dismiss="alert">&times;</button>
                    没有可以显示的信息
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach items="${graduateProject.replyGroup.members}" var="tutor">
                    <tr>
                            <%--答辩老师和评审之前要对应--%>
                        <td>
                                ${tutor.name}
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${empty graduateProject.replyGroupMemberScores}">
                                    <p style="color: red">未评审</p>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${graduateProject.replyGroupMemberScores}"
                                               var="replyGroupMemberScore">
                                        <c:choose>
                                            <%--用来判断老师的姓名和答辩小组成员老师的姓名相等，则显示出来--%>
                                            <c:when test="${fn:startsWith(replyGroupMemberScore.tutor.name,tutor.name)&&fn:endsWith(replyGroupMemberScore.tutor.name,tutor.name)}">
                                                <a class="btn btn-default" data-toggle="modal" data-target="#showDetail"
                                                   href=""><i class="icon icon-coffee"></i> 查看</a>
                                            </c:when>
                                            <c:otherwise>
                                                <p style="color: red">未评审</p>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>

</div>
<div data-options="region:'center',title:'各答辩老师评审汇总'">

    <table class="table table-hover">
        <thead>
        <tr>
            <th>评分项</th>
            <th>分数</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td><i class="icon icon-forward"></i> 论文与实物的质量评分(0-10分)</td>
            <td>
                <c:choose>
                    <c:when test="${empty avgQualityScoreByGroupTutor}">
                        <p style="color: red">未生成</p>
                    </c:when>
                    <c:otherwise>
                        ${avgQualityScoreByGroupTutor}
                    </c:otherwise>
                </c:choose>
            </td>

        </tr>
        <tr>
            <td><i class="icon icon-forward"></i> 完成任务书规定的要求与水平评分(0-10分)</td>
            <td>
                <c:choose>
                    <c:when test="${empty avgCompletenessScoreByGroupTutor}">
                        <p style="color: red">未生成</p>
                    </c:when>
                    <c:otherwise>
                        ${avgCompletenessScoreByGroupTutor}
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
        <tr>
            <td><i class="icon icon-forward"></i> 论文内容的答辩陈述评分(0-10分)</td>
            <td>
                <c:choose>
                    <c:when test="${empty avgReplyScoreByGroupTutor}">
                        <p style="color: red">未生成</p>
                    </c:when>
                    <c:otherwise>
                        ${avgReplyScoreByGroupTutor}
                    </c:otherwise>
                </c:choose>
            </td>

        </tr>
        <tr>
            <td><i class="icon icon-forward"></i> 回答问题的正确性评分(0-10分)</td>
            <td>
                <c:choose>
                    <c:when test="${empty avgCorrectnessScoreByGroupTutor}">
                        <p style="color: red">未生成</p>
                    </c:when>
                    <c:otherwise>
                        ${avgCorrectnessScoreByGroupTutor}
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
        </tbody>

    </table>
    <span style="color: grey;margin-left: 10px;">* 以上分数为建议各项评分</span>
</div>


</body>
</html>

