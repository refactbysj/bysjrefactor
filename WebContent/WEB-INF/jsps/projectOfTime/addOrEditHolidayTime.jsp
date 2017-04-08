<%--
  Created by IntelliJ IDEA.
  User: zhan
  Date: 2017/4/4 0004
  Time: 14:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<script type="text/javascript">


    $(function () {
        var word = $("#description").text();
        var wordCount = word.length;
        $("#wordCount").text(wordCount);

        $('#holidayAddForm').form({
            url : '${basePath}addOrEditHolidayTime.html?editId=${editId}',
            onSubmit : function() {
                progressLoad();
                var isValid = $(this).form('validate');
                if (!isValid) {
                    progressClose();
                }
                return isValid;
            },
            success : function(result) {
                progressClose();
                result = $.parseJSON(result);
                if (result.success) {
                    parent.$.modalDialog.openner_grid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    parent.$.messager.alert('错误', result.msg, 'error');
                }
            }
        });
    });

    function checkCount() {
        var word = $("#description").val();
        var count = word.length;
        $("#wordCount").text(count);
        if(count>200){
            word = word.substring(0, 199);
            $("#description").val(word);
        }
    }



</script>


<form id="holidayAddForm"  onsubmit="return checkvalue()" method="post">
            <div style="padding: 10px;">
                <span style="color: grey;">开始时间：</span>
                <input id="starttime" class="Wdate" onclick="WdatePicker()" type="text" value="${holidayStartTime}" name="startTime" required="required">

            </div>
            <div style="padding: 10px;">
                <span style="color:grey;">结束时间：</span>
                <input id="endtime" class="Wdate" onclick="WdatePicker({minDate:'#F{$dp.$D(\'starttime\')}'})" type="text" value="${holidayEndTime}" name="endTime" required="required">
            </div>

    原因：<span style="color: grey;">(200字以内，字数：<span id="wordCount">0</span>/200)</span>
        <textarea class="form-control" onkeyup="checkCount()" id="description" rows="5"  cols="63" name="description"
                  required="required">${description}</textarea>


</form>
