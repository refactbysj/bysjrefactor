<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsps/includeURL.jsp" %>

<script type="text/javascript">
    //显示细节
    function showDetail(id) {
        var url = '${basePath}process/showDetail.html?graduateProjectId=' + id;
        showProjectDetail(url);
    }

    //下载
    function downLoad(id) {
        window.location.href = '${basePath}tutor/downLoadTaskDoc.html?projectId=' + id;
    }
</script>

<div class="container-fluid" style="width: 100%">
    <div class="row">
        <c:choose>
            <c:when test="${not empty message}">
                <h3 style="color: red;">${message}</h3>
            </c:when>
            <c:otherwise>
                <table
                        class="table table-striped table-bordered table-hover datatable">
                    <thead>
                    <tr>
                        <th width="30%">题目名称</th>
                        <th width="10%">副标题</th>
                        <th>年份</th>
                        <th>类别</th>
                        <th>学生姓名</th>
                        <th>班级</th>
                        <th>学号</th>
                        <th>主指导</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${graduateProject==null}">
                            <div class="alert alert-warning alert-dismissable" role="alert">
                                <button class="close" type="button" data-dismiss="alert">&times;</button>
                                没有任务指导书，请及时联系老师！
                            </div>
                        </c:when>
                        <c:otherwise>
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
                                <td>${graduateProject.student.name}</td>
                                <td>${graduateProject.student.studentClass.description}</td>
                                <td>${graduateProject.student.no}</td>
                                <td>${graduateProject.mainTutorage.tutor.name}</td>

                                <td>
                                    <a class="easyui-linkbutton" onclick="showDetail(${graduateProject.id})"
                                       href="javascript:void(0)" data-options="iconCls:'icon-more',plain:true">显示细节 </a>
                                    <a class="easyui-linkbutton" onclick="downLoad(${graduateProject.id})"
                                       href="javascript:void(0)" data-options="iconCls:'icon-blank',plain:true">下载</a>
                                        <%--student/download/taskDoc.html?taskDocId=${graduateProject.taskDoc.id}--%>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>
