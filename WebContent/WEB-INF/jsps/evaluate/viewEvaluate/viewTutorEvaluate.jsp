<%--
  Created by IntelliJ IDEA.
  User: zhan
  Date: 2016/6/5
  Time: 22:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="modal-header">
    <h4 class="modal-title" id="myModalLabel">
        题目名称：${graduateProject.title}
        <br>
        班级：${graduateProject.student.studentClass.description}&nbsp;&nbsp;学生姓名：${graduateProject.student.name}&nbsp;&nbsp;学号:${graduateProject.student.no}
    </h4>
</div>
<div class="modal-body">
    <c:set var="graduateProject" value="${graduateProject}"/>
    <table class="table" border="1">
        <tr height="30">
            <td>
                任务完成情况
            </td>
            <td>
                <c:choose>
                    <c:when test="${graduateProject.commentByTutor.tutorEvaluteHasCompleteProject}">
                        <span style="font-size: medium;" class="label label-success">已完成</span>
                    </c:when>
                    <c:otherwise>
                        <span style="font-size: medium;" class="label label-warning">未完成</span>
                    </c:otherwise>
                </c:choose>

            </td>
            <td>
                论文字数
            </td>
            <td>
                ${graduateProject.commentByTutor.tutorEvaluteDissertationWordCount}

            </td>
        </tr>

        <tr height="30">
            <td>
                中期检查报告
            </td>
            <td>
                <c:choose>
                    <c:when test="${graduateProject.commentByTutor.tutorEvaluteHasMiddleExam}">
                        <span style="font-size: medium;" class="label label-success">有</span>
                    </c:when>
                    <c:otherwise>
                        <span style="font-size: medium;" class="label label-warning">无</span>
                    </c:otherwise>
                </c:choose>

            </td>
            <td>
                外文资料翻译
            </td>
            <td>
                <c:choose>
                    <c:when test="${graduateProject.commentByTutor.tutorEvaluteHasTranslationMaterail}">
                        <span style="font-size: medium;" class="label label-success">有</span>
                    </c:when>
                    <c:otherwise>
                        <span style="font-size: medium;" class="label label-warning">无</span>
                    </c:otherwise>
                </c:choose>

            </td>
        </tr>
        <tr height="30">
            <td>
                外文资料翻译字数
            </td>
            <td>
                ${graduateProject.commentByTutor.tutorEvaluteHasTranslationWordCount}

            </td>
            <td>
                中、英文摘要
            </td>
            <td>
                <c:choose>
                    <c:when test="${graduateProject.commentByTutor.tutorEvaluteHasTwoAbstract}">
                        <span style="font-size: medium;" class="label label-success">有</span>
                    </c:when>
                    <c:otherwise>
                        <span style="font-size: medium;" class="label label-warning">无</span>
                    </c:otherwise>
                </c:choose>

            </td>
        </tr>

        <tr height="30">
            <td colspan="2">
                基本理论、基本知识、基本技能和外语水平
            </td>
            <td colspan="2"> <%--path 对应 commandName所代表的对象的一个属性 --%>
                ${graduateProject.commentByTutor.basicAblityScore}

            </td>
        </tr>
        <tr height="30">
            <td colspan="2">
                工作量、工作态度
            </td>
            <td colspan="2"> <%--path 对应 commandName所代表的对象的一个属性 --%>
                ${graduateProject.commentByTutor.workLoadScore}

            </td>
        </tr>

        <tr height="30">
            <td colspan="2">
                独立工作能力、分析与解决问题的能力
            </td>
            <td colspan="2"> <%--path 对应 commandName所代表的对象的一个属性 --%>
                ${graduateProject.commentByTutor.workAblityScore}

            </td>
        </tr>

        <tr>
            <td colspan="2">
                完成任务情况及水平
            </td>
            <td colspan="2"> <%--path 对应 commandName所代表的对象的一个属性 --%>
                ${graduateProject.commentByTutor.achievementLevelScore}

            </td>
        </tr>
        <tr>
            <td colspan="1">指导老师的评语</td>
            <td colspan="3">
                <textarea class="form-control" readonly>${graduateProject.commentByTutor.remark}</textarea>
            </td>
        </tr>
    </table>
    </table>
</div>

