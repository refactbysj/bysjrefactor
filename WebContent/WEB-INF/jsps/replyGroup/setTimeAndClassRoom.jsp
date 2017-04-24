<%--
  Created by IntelliJ IDEA.
  User: 张战
  Date: 2016/3/19
  Time: 19:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script type="text/javascript">
    $(function () {
        $("#setReplyForm").form({
            url: '${setReplyURL}',
            onSubmit: function () {
                var start = $("#startTime").val();
                var end = $("#endTime").val();
                if (start == null || start == '') {
                    $.messager.alert('提示', '请输入开始日期', 'warning');
                    return false;
                }
                if (end == null || end == '') {
                    $.messager.alert('提示', '请输入结束日期', 'warning');
                    return false;
                }
                var startYear = start.split("-")[0];
                var startMonth = start.split("-")[1];
                var startMonth_Day = start.split("-")[2];
                var endYear = end.split("-")[0];
                var endMonth = end.split("-")[1];
                var endMonth_Day = end.split("-")[2];
                if (isNaN(startYear) || isNaN(startMonth_Day) || isNaN(startMonth) || isNaN(endYear) ||
                    isNaN(endMonth_Day) || isNaN(endMonth)) {
                    $.messager.alert("提示", "输入字符不合法！", "warning");
                    return false;
                }
                var startNum = startYear + startMonth + startMonth_Day;
                var endNum = endYear + endMonth + endMonth_Day;
                if (startNum > endNum) {
                    $.messager.alert("提示", "结束时间应晚于开始时间", "warning");
                    return false;
                }
                return true;
            },
            success: function (result) {
                result = $.parseJSON(result);
                if (result.success) {
                    $.messager.alert('提示', result.msg, 'info');
                    parent.$.modalDialog.setGroupGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    $.messager.alert('提示', result.msg, 'warning');
                }
            }
        })
    })
</script>
<form action="${setReplyURL}" method="post" id="setReplyForm">

    <input type="hidden" value="${replyGroupId}" name="replyGroupId">

    <div style="padding: 10px">
        <span style="color:grey">答辩地点：</span>
        <select class="easyui-combobox" style="width: 40%;"
                name="classRoomId" id="classRoomId">
            <option label="请选择" value="0">--请选择--</option>
            <c:forEach items="${classList}" var="studentClass">
                <option value="${studentClass.id}"
                        <c:if test="${studentClass==replyGroup.classRoom}">selected="selected" </c:if>>${studentClass.description}</option>
            </c:forEach>
        </select>
    </div>

    <div style="padding: 10px;">
        <span style="color: grey;">开始时间：</span>
        <input class="Wdate" onclick="WdatePicker({maxDate:'#F{$dp.$D(\'endTime\')}'})" type="text"
               name="startTime" id="startTime" value="${startTime}" required="required">
    </div>
    <div style="padding: 10px;">
        <span style="color: grey;">结束时间：</span>
        <input class="Wdate" onclick="WdatePicker({minDate:'#F{$dp.$D(\'startTime\')}'})" type="text"
               name="endTime" id="endTime" value="${endTime}" required="required">

    </div>


</form>
