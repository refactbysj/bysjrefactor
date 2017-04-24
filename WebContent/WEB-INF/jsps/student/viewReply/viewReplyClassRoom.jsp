<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsps/includeURL.jsp" %>

<script type="text/javascript">
    function showDetail(id) {
        var url = '${basePath}process/showDetail.html?graduateProjectId=' + id;
        showProjectDetail(url);
    }
</script>

<div class="row-fluid">
    <table class="table table-striped table-bordered table-hover datatable">
        <thead>
        <tr>
            <th align="center" width="20%">题目名称</th>
            <th align="center">副标题</th>
            <th align="center">年份</th>
            <th align="center">类别</th>
            <th align="center">答辩开始时间</th>
            <th align="center">答辩结束时间</th>
            <th align="center">答辩地点</th>
            <th align="center">课题详情</th>
        </tr>
        </thead>
        <tbody>

        <tr>
            <td>${graduateProject.title}</td>
            <c:choose>
                <c:when test="${empty graduateProject.subTitle}">
                    <td></td>
                </c:when>
                <c:otherwise>
                    <td>${graduateProject.subTitle}</td>
                </c:otherwise>
            </c:choose>
            <td>${graduateProject.year}</td>
            <td>${graduateProject.category}</td>
            <td><fmt:formatDate
                    value="${graduateProject.replyGroup.replyTime.beginTime.time}"
                    pattern="yyyy-MM-dd"/></td>
            <td><fmt:formatDate
                    value="${graduateProject.replyGroup.replyTime.endTime.time}"
                    pattern="yyyy-MM-dd"/></td>
            <td>${graduateProject.replyGroup.classRoom.description}</td>
            <td><a class="easyui-linkbutton" data-options="iconCls:'icon-more'"
                   href="javascript:void(0)" onclick="showDetail('${graduateProject.id}')">显示详情
            </a></td>
        </tr>
        </tbody>
    </table>
</div>

