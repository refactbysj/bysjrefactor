<%--
  Created by IntelliJ IDEA.
  User: zhan
  Date: 2017/4/4 0004
  Time: 12:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<script type="text/javascript">
    function checkvalue() {
        var start = $("#starttime").val();
        var end = $("#endtime").val();
        var startYear = start.split("-")[0];
        var startMonth = start.split("-")[1];
        var startMonth_Day = start.split("-")[2];
        var endYear = end.split("-")[0];
        var endMonth = end.split("-")[1];
        var endMonth_Day = end.split("-")[2];
        if (isNaN(startYear)||isNaN(startMonth_Day)||isNaN(startMonth)||isNaN(endYear)||
            isNaN(endMonth_Day)||isNaN(endMonth)) {
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
    }
</script>

<form action="${actionUrl}" id="editTimeForm" onsubmit="return checkvalue()" method="post">
    <div class="light-info" style="overflow: hidden;padding: 3px;">
        <div>结束时间应晚于开始时间</div>
    </div>
    <div style="padding: 10px">
        <span style="color: grey;">开始时间：</span>

        <input id="starttime" name="startTime" type="text"
               onClick="WdatePicker({maxDate:'#F{$dp.$D(\'endtime\')}',minDate:'%y-%M-%d'})"
               value="${projectTimeSpanStartTime}" required="required"
               class="Wdate"/>
        <input type="hidden" id="dtp_input1" value=""/>
    </div>
    <div style="padding: 10px">
        <span style="color: grey;">结束时间：</span>
        <input id="endtime" onclick="WdatePicker({minDate:'#F{$dp.$D(\'starttime\')}',maxDate:'{%y+1}-09-01'})"
               type="text" class="Wdate" required="required"
               value="${projectTimeSpanEndTime}" name="endTime">
    </div>
</form>
