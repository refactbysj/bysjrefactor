<%--
  Created by IntelliJ IDEA.
  User: zhan
  Date: 2016/3/15
  Time: 16:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


<script type="text/javascript">
    /*显示当前老师的学生*/
    function getStudents(tutorId) {
        $("input[name='tutorIds']").each(function () {
            $("#replyStudents" + tutorId).hide();
            if ($("#tutorInput" + tutorId).prop("checked") == true) {
                $("#replyStudents" + tutorId).show();
            } else {
                $(".replyStudents" + tutorId).each(function () {
                    $(this).attr("checked", false);
                    $("input[name='replyStudentIds']").change();
                });
            }
        });
    }

    $(document).ready(function () {
        getStudents();

        /*当复选框发生变化时，显示当前已经选择的学生的个数*/
        $("input[name='studentIds']").change(function () {
            var selectStudentCount = $("input[name='studentIds']:checked").length;
            $("#selectStudent").html("(已选择" + selectStudentCount + "个)")
        });

        /*点击老师下的全选*/
        $("input[name='tutorCheckbox']").change(function () {
            if ($(this).prop("checked")) {
                $(this).parent().find($("input[name='studentIds']")).prop("checked", true);
            } else {
                $(this).parent().find($("input[name='studentIds']")).prop("checked", false);
            }
            /*用于重新计算当前已选择的学生的个数*/
            $("input[name='studentIds']").change();
        });

        $("#editReplyGroupForm").form({
            url: '${actionURL}',
            onSubmit: function () {
                if ($("#description").val()==null||$("#description").val()=='') {
                    $.messager.alert('提示', '请输入小组名称', 'warning');
                    return false;
                } else if ($("select[name='leaderId'] option:selected").attr("value") == 0) {
                    $.messager.alert('提示', '请选择小组组长', 'warning');
                    return false;
                }

                else if ($("input[name='tutorIds']:checked").length == 0) {
                    $.messager.alert('提示', '请选择老师', 'warning');
                    return false;
                } else if ($("input[name='tutorIds']:checked").length > 6) {
                    $.messager.alert('提示', '选择的老师不能多于6人', 'warning');
                    return false;
                }
                /*else if ($("input[name='studentIds']:checked").length == 0 && $("input[name='cancelStuIds']:checked").length == 0) {
                    $.messager.alert('提示', '请选择学生', 'wanring');
                    return false;
                 }*/
            },
            success: function (result) {
                result = $.parseJSON(result);
                if (result.success) {
                    $.messager.alert('提示', result.msg, 'info');
                    parent.$.modalDialog.replyGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    $.messager.alert('提示', result.msg, 'warning');
                }
            }
        })
    });


</script>

<form method="post" id="editReplyGroupForm">

    <input type="hidden" name="replyGroupId" value="${replyGroup.id}">

    <div class="modal-body">
        <input type="hidden" name="replyGroupId" value="${replyGroup.id}">
        <dl>
            <dt>答辩小组名称：</dt>
            <dd>
                <input value="${replyGroup.description}" name="replyGroupName" id="description" class="form-control"
                       required/>
            </dd>
            <dt>小组组长：</dt>
            <dd>
                <%--<form:select path="leader.name" items="${tutors}"/>--%>
                <select id="leadIds" required="required" name="leaderId" class="form-control " required>
                    <option value="0">请选择组长</option>
                    <c:forEach items="${tutors}" var="tutor">
                        <option value="${tutor.id}" label="${tutor.name}"
                                <c:if test="${replyGroup.leader==tutor}">selected="selected" </c:if>></option>
                    </c:forEach>
                </select>
            </dd>
            <dt>答辩老师：<span style="color: grey;">（答辩老师最多可选6人）</span></dt>
            <dd>
                <span style="color: grey;">本教研室老师</span><br/>
                <c:forEach items="${tutors}" var="tutor">
                    <%--列出可供选择的学生的个数--%>
                    <c:set var="studentsCount" value="0"/>
                    <%--对老师的所有学生进行遍历--%>
                    <c:forEach items="${tutor.student}" var="student">
                        <%--给学生分配答辩小组的条件：学生的课题不为空，之前没有选择答辩小组，评阅人和指导老师都允许答辩或是学生所在的答辩小组为当前的答辩小组 --%>
                        <c:if test="${student.graduateProject!=null&&student.graduateProject.replyGroup==null&&student.graduateProject.commentByReviewer.qualifiedByReviewer&&student.graduateProject.commentByTutor.qualifiedByTutor}">
                            <c:set var="studentsCount" value="${studentsCount+1}"/>
                        </c:if>
                    </c:forEach>
                    <%--如果没有可以选择的学生，则不能选中--%>
                    <label style="width: auto">
                        <input type="checkbox" id="tutorInput${tutor.id}" value="${tutor.id}"
                               studentsCount="${studentsCount}" name="tutorIds"
                               onclick="getStudents(${tutor.id})"
                        <c:forEach items="${replyGroup.members}" var="members">
                               <c:if test="${members.id==tutor.id}">checked </c:if>
                        </c:forEach>  >${tutor.name}(<span id="checkBoxByGroup${tutor.id}">${studentsCount}</span>)
                    </label>
                </c:forEach><br/>
                <span style="color:grey">其它教研室老师</span><br/>
                <c:forEach items="${otherTutors}" var="otherTutor">
                    <label style="width: auto;">
                        <input type="checkbox"
                                <c:forEach items="${replyGroup.members}" var="members">
                                    <c:if test="${members.id==otherTutor.id}">checked </c:if>
                                </c:forEach>
                               id="tutorInput${otherTutor.id}" value="${otherTutor.id}"
                               name="tutorIds"/>${otherTutor.name}

                    </label>
                </c:forEach>
            </dd>
            <%--用于列出所选老师下的学生--%>
            <dt>
                答辩学生：<span style="color: grey">(选中提交可删除对应学生)</span><c:choose>
                <c:when test="${students !=null}">
                    <c:forEach items="${students}" var="student">
                        <input type="checkbox" name="cancelStuIds" value="${student.id}">
                        ${student.name}&nbsp;&nbsp;
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <span class="label label-default" id="selectStudent">请先选择答辩老师</span>
                </c:otherwise>
            </c:choose>
            </dt>
            <dd>
                <c:forEach items="${tutors}" var="tutor">
                    <c:if test="${fn:length(tutor.student) != 0}">
                        <div id="replyStudents${tutor.id}" style="display: none">
                                ${tutor.name}老师所带的学生:<input type="checkbox" id="tutorCheckBox${tutor.id}"
                                                            name="tutorCheckbox">全选&nbsp;&nbsp;
                            <c:forEach items="${tutor.student}" var="student">
                                <c:if test="${student.graduateProject!=null&&student.graduateProject.replyGroup==null&&student.graduateProject.commentByReviewer.qualifiedByReviewer&&student.graduateProject.commentByTutor.qualifiedByTutor}">
                                    <input type="checkbox" id="replyStudents${student.id}"
                                           name="studentIds"
                                           value="${student.id}">${student.name}&nbsp;
                                </c:if>
                            </c:forEach>
                        </div>
                    </c:if>
                </c:forEach>
            </dd>
        </dl>
    </div>

</form>


