<%--
  Created by IntelliJ IDEA.
  User: 张战
  Date: 2016/4/14
  Time: 17:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<script type="text/javascript">

    $(function () {
        $("#allocatedForm1").form({
            url:'/bysj3/process/delStudents.html',
            onSubmit:function () {
                progressLoad();
                var studentId = null;
                var i = 0;
                var count = $("input[type='checkbox']:checked").length;
                if (count == 0 || count == '') {
                    progressClose();
                    $.messager.alert("提示", "请选择学生", "warning");
                    return false;
                }
                $("input[type='checkbox']:checked").each(function () {
                    if (i == 0) {
                        studentId = $(this).val() + ",";
                    } else {
                        studentId += $(this).val();
                        studentId += ",";
                    }
                    i++;
                });
                //去掉最后一个逗号
                studentId = studentId.substring(0, studentId.length - 1);
                $("#stuIds").val(studentId);
            },
            success:function (result) {
                progressClose();
                result = $.parseJSON(result);
                if(result.success) {
                    parent.$.modalDialog.studentGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                    $.messager.alert('提示', result.msg, 'info');
                }else{
                    $.messager.alert('提示', result.msg, 'warning');
                }
            }
        })
    });
    function showStudentList(tutorId) {
        $("#showStudent" + tutorId).hide(300);
        $("#hideStudent" + tutorId).show(600);
        $("#tutorStudent" + tutorId).show(900);
    }

    function hideStudentList(tutorId) {
        $("#tutorStudent" + tutorId).hide(300);
        $("#hideStudent" + tutorId).hide(600);
        $("#showStudent" + tutorId).show(900);
    }

</script>
<h4 class="modal-title" id="myModalLabel">
    已分配学生，共${studentCount}个</h4>
<p style="color: red">(已分配课题的学生不能删除！)</p>

<span class="light-info" style="width: 100%;">请选择需要删除的学生</span> <br>
<form id="allocatedForm1">
    <input type="hidden" name="stuIds" id="stuIds">
    <c:choose>
        <c:when test="${studentCount>0}">
            <c:forEach items="${tutorList}" var="tutor">
                <c:if test="${not empty tutor.student}">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-md-3">
                                <c:set var="tutorStudent" value="0"/>
                                <c:forEach items="${tutor.student}" var="student">
                                    <c:set var="tutorStudent" value="${tutorStudent+1}"/>
                                </c:forEach>
                                    ${tutor.name}老师(${tutorStudent}个)
                            </div>
                            <div class="col-md-3">
                                <a class="easyui-linkbutton" id="showStudent${tutor.id}"
                                        onclick="showStudentList(${tutor.id})">显示
                                </a>
                                <a class="easyui-linkbutton" id="hideStudent${tutor.id}"
                                        onclick="hideStudentList(${tutor.id})" style="display: none">隐藏
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="tutorStudentList" id="tutorStudent${tutor.id}"
                         style="display: none">
                        <table class="table table-bordered table-condensed table-hover" >
                            <thead>
                            <tr>
                                <th width="1%"></th>
                                <th width="10%">学生姓名</th>
                                <th width="15%">学号</th>
                                <th width="9%">是否选题</th>
                                <th>课题名称</th>
                                <th width="10%">课题类型</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${tutor.student}" var="student">
                                <tr>
                                    <td>
                                        <input type="checkbox" value="${student.id}"
                                               id="studentCheckbox${student.id}">
                                    </td>
                                    <td>${student.name}</td>
                                    <th>${student.no}</th>
                                    <td>
                                        <c:choose>
                                            <c:when test="${empty student.graduateProject}">
                                                <span style="color: red;">未选</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span  style="color: green;">已选</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:if test="${not empty student.graduateProject}">
                                            ${student.graduateProject.title}
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:if test="${not empty student.graduateProject}">
                                            ${student.graduateProject.category}
                                        </c:if>
                                    </td>
                                </tr>

                            </c:forEach>
                            </tbody>
                        </table>

                    </div>
                    <br>
                </c:if>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="alert alert-warning alert-dismissable" role="alert">
                没有已分配的学生
        </c:otherwise>
    </c:choose>
</form>


