<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
<script type="text/javascript">
    function deleteFinalDraft(graduateProjectId) {
        $.messager.confirm('询问', '确认删除？', function (t) {
            if (t) {
                $.ajax({
                    url: '${basePath}student/deleteFinalDraft.html',
                    type: 'GET',
                    dataType: 'json',
                    data: {
                        "graduateProjectId": graduateProjectId
                    },
                    success: function () {
                        window.location = "${basePath}student/finalDraft.html";
                        return true;
                    },
                    error: function () {
                        $.messager.alert('错误', '网络错误，请联系管理员', 'error');
                    }
                });
            }
        })
    }

    //上传终稿
    function uploadFinalDraft() {
        var isValid = $("#updateFinal").form('validate');
        if (!isValid) {
            $.messager.alert('提示', '请选择文件', 'warning');
            return false;
        }
        $.messager.confirm('询问', '确认提交？', function (t) {
            if (t) {
                $("#updateFinal").submit();
            }
        })
    }

    //显示课题细节
    function showDetail(id) {
        var url = '${basePath}process/showDetail.html?graduateProjectId=' + id;
        showProjectDetail(url);
    }
</script>
<div class="container-fluid" style="width: 100%">

    <c:choose>
        <c:when test="${not empty message}">
            <h3 style="color: red">${message}</h3>
        </c:when>
        <c:otherwise>
            <div id="uploadFileTest" name="test" class="row-fluid" style="margin-bottom: 10px">
                <c:url value="/student/uploadFinalDraft.html" var="actionUrl"/>
                <c:if test="${graduateProject.finalDraft == null}">
                    <div class="col-md-1">
                        <label>上传终稿:</label>
                    </div>
                    <form action="${actionUrl}" method="post" id="updateFinal" enctype="multipart/form-data">
                        <input type="hidden" name="graduateProjectId"
                               value="${graduateProject.id}">
                        <input class="easyui-filebox" style="width: 20%;" data-options="buttonText:'选择文件',required:true"
                               name="finalDraftFile" id="final" required>
                        <a href="javascript:void(0)" onclick="uploadFinalDraft()" class="easyui-linkbutton">上传</a>
                    </form>
                </c:if>
            </div>
            <div class="row">
                <table
                        class="table table-striped table-bordered table-hover datatable">
                    <thead>
                    <tr>
                        <th>题目名称</th>
                        <th>副标题</th>
                        <th>班级</th>
                        <th>学生姓名</th>
                        <th>学号</th>
                        <th>指导老师</th>
                        <th>操作</th>
                        <th>详情</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>${graduateProject.title }</td>
                        <c:choose>
                            <c:when test="${empty graduateProject.subTitle}">
                                <td></td>
                            </c:when>
                            <c:otherwise>
                                <td>${graduateProject.subTitle }</td>
                            </c:otherwise>
                        </c:choose>
                        <td>${graduateProject.student.studentClass.description }</td>
                        <td>${graduateProject.student.name }</td>
                        <td>${graduateProject.student.no }</td>
                        <td>${graduateProject.mainTutorage.tutor.name }</td>
                        <td id="status${graduateProject.id}">
                            <c:if test="${graduateProject.finalDraft != null}">
                                <div>
                                    <a class="easyui-linkbutton"
                                       href="<%=basePath%>student/download/finalDraft.html?graduateProjectId=${graduateProject.id}">下载</a>
                                    <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel',disabled:true"
                                       onclick="deleteFinalDraft(${graduateProject.id})"><span>删除</span></a>
                                </div>
                            </c:if>
                            <c:if test="${graduateProject.finalDraft == null}">
                                未上传
                            </c:if></td>
                        <td><a class="easyui-linkbutton" data-options="iconCls:'icon-more'"
                               href="javascript:void(0)" onclick="showDetail(${graduateProject.id})">显示细节 </a></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>
</div>
