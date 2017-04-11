<%--
  Created by IntelliJ IDEA.
  User: 张战
  Date: 2016/3/31
  Time: 9:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div id="detail" style="width:auto;">
    <table class="table table-striped table-bordered table-hover datatable">
        <tr>
            <td width="12%">课题名称：</td>
            <td width="40%">${graduateProject.title}</td>
            <td width="12%">副标题：</td>
            <c:choose>
                <c:when test="${empty graduateProject.subTitle}">
                    <td width="40%"></td>
                </c:when>
                <c:otherwise>
                    <td width="40%">${graduateProject.subTitle}</td>
                </c:otherwise>
            </c:choose>
        </tr>
        <tr>
            <td>指导老师：</td>
            <td>${graduateProject.proposer.name}</td>


            <td>职称/学位：</td>
            <td>
                <c:choose>
                    <c:when test="${graduateProject.proposer.proTitle.description==null}">
                        暂无
                    </c:when>
                    <c:otherwise>
                        ${graduateProject.proposer.proTitle.description}
                    </c:otherwise>
                </c:choose>
                /
                <c:choose>
                    <c:when test="${graduateProject.proposer.degree.description==null}">
                        暂无
                    </c:when>
                    <c:otherwise>
                        ${graduateProject.proposer.degree.description}
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
        <tr>
            <td>课题类别：</td>
            <td>${graduateProject.category}</td>

            <td>课题性质：</td>
            <td>${graduateProject.projectFidelity.description}</td>
        </tr>
        <tr>

            <td>课题类型：</td>
            <td>${graduateProject.projectType.description}</td>


            <td>题目来源：</td>
            <td>${graduateProject.projectFrom.description}</td>
        </tr>
        <tr>
            <td>限选专业：</td>
            <td>${graduateProject.major.description}</td>

            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>设计（论文）工作内容：</td>
            <td colspan="3"><textarea disabled style="width: 100%" rows="7">${graduateProject.content}</textarea></td>
        </tr>
        <tr>
            <td>设计（论文）基本要求：</td>
            <td colspan="3"><textarea disabled style="width: 100%"
                                      rows="7">${graduateProject.basicRequirement}</textarea></td>
        </tr>
        <tr>
            <td>所需基本技能：</td>
            <td colspan="3"><textarea disabled style="width: 100%" rows="7">${graduateProject.basicSkill}</textarea>
            </td>
        </tr>
        <tr>
            <td>主要参考资料及文献</td>
            <td colspan="3"><textarea disabled style="width: 100%" rows="7">${graduateProject.reference}</textarea></td>
        </tr>
    </table>
</div>

