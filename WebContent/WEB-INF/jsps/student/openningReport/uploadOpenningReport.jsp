<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
<script type="text/javascript">
    function deleteOpenningReport() {
        $.messager.confirm('询问', '确认删除？', function (t) {
            if (t) {
                $.ajax({
                    url: '${basePath}openningReport/deleteOpenningReport.html',
                    type: 'GET',
                    dataType: 'json',
                    success: function (data) {
                        window.location = '${basePath}student/uploadOpenningReport.html';
                    },
                    error: function () {
                        $.messager.alert('错误', '删除失败,请稍后再试', 'error');
                    }
                });
            }
        })
    }

    function confirmFile() {
        //var updateFile = $("#openningReportFile").val();
        //var excuName = updateFile.substring(updateFile.indexOf(".") + 1, updateFile.length);
        $.messager.confirm('询问', '确认提交？', function (t) {
            if (t) {
                $("#checkvalue").submit();
            }
        })
    }

    //显示课题详情
    function showDetail(id) {
        var url = '${basePath}process/showDetail.html?graduateProjectId=' + id;
        showProjectDetail(url);
    }
</script>
<div class="container-fluid" style="width: 100%">

    <div class="row-fluid">


        <c:if test="${paperProject.openningReport.url==null}">
            <div class="col-md-1">
                <label>上传开题报告:</label>
            </div>
            <c:url value="/openningReport/openningReportuploaded.html" var="uploadOpenningReport"/>
            <form action="${uploadOpenningReport}" class="form-inline" id="checkvalue"
                  enctype="multipart/form-data" method="post">
                <div class="form-group">
                    <input type="hidden" name="paperProjectId" value="${paperProject.id}">
                    <input class="form-control" type="file" id="openningReportFile" name="openningReportFile" required>
                    <button type="button" onclick="confirmFile()" class="btn btn-default btn-sm">上传</button>
                </div>
            </form>
            <h4><font color="red"><span>上传既送审，驳回前不能修改</span></font></h4>
        </c:if>
    </div>
    <div class="row">
        <table
                class="table table-striped table-bordered table-hover datatable">
            <thead>
            <tr>
                <th>题目名称</th>
                <th>老师姓名</th>
                <th>指导老师审核状态</th>
                <th>教研室审核状态</th>
                <th>操作</th>
                <th>课题详情</th>

            </tr>
            </thead>
            <tbody>
            <tr>
                <c:choose>
                    <c:when test="${empty paperProject.subTitle}">
                        <td>${paperProject.title}</td>
                    </c:when>
                    <c:otherwise>
                        <td>${paperProject.title}——${paperProject.subTitle}</td>
                    </c:otherwise>
                </c:choose>
                <td>${paperProject.proposer.name}</td>
                <td><c:choose>
                    <c:when
                            test="${paperProject.openningReport.submittedByStudent==true}">
                        <c:if test="${paperProject.openningReport.auditByTutor==null}">审核中，请耐心等待</c:if>
                        <c:if test="${paperProject.openningReport.auditByTutor.approve==true}"><span
                                style="color: green;">通过</span></c:if>
                        <c:if test="${paperProject.openningReport.auditByTutor.approve==false}"><span style="color:red">驳回</span></c:if>
                    </c:when>
                    <c:otherwise>
                        未审核
                    </c:otherwise>
                </c:choose></td>
                <td><c:choose>
                    <c:when
                            test="${paperProject.openningReport.submittedByStudent==true&&paperProject.openningReport.auditByTutor.approve==true}">
                        <c:if
                                test="${paperProject.openningReport.auditByDepartmentDirector==null}">审核中，请耐心等待</c:if>
                        <c:if
                                test="${paperProject.openningReport.auditByDepartmentDirector.approve==true}"><span
                                style="color:green;">通过</span></c:if>
                        <c:if
                                test="${paperProject.openningReport.auditByDepartmentDirector.approve==false}"><span
                                style="color: red;">驳回</span></c:if>
                    </c:when>
                    <c:otherwise>
                        未审核
                    </c:otherwise>
                </c:choose></td>
                <td><c:choose>
                    <c:when test="${paperProject.openningReport.url==null }">
                        未上传
                    </c:when>
                    <c:otherwise>
                        <a class="easyui-linkbutton"
                           href="<c:url value="/student/openningReport/downloadOpenningReport.html?paperProjectId=${paperProject.id}"/>">下载</a>

                        <c:if test="${!paperProject.openningReport.auditByTutor.approve}">
                            <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'"
                               onclick="deleteOpenningReport()">删除</a>
                        </c:if>
                        <c:if test="${paperProject.openningReport.auditByTutor.approve}">
                            <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel',disabled:true"
                               onclick="deleteOpenningReport()">删除</a>
                        </c:if>
                    </c:otherwise>
                </c:choose></td>
                <td><a class="easyui-linkbutton" data-options="iconCls:'icon-more'"
                       href="javascript:void(0)" onclick="showDetail(${paperProject.id})">显示细节 </a>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
</div>
