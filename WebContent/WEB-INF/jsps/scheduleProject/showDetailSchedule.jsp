<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
    <script type="text/javascript">
        var showDetailScheduleGrid,url;
        function getTimeByMillions(millions) {
            var date = new Date(millions);
            var year = date.getFullYear() + '年';
            var month = date.getMonth() + '月';
            var day = date.getDay() + '日';
            return year + month + day;
        }

        $(function () {
            showDetailScheduleGrid = $("#showDetailSchedule").datagrid({
                url: '${basePath}process/DetailSchedulesList.html',
                striped: true,
                pagination:true,
                pageSize: 15,
                pageList: [10, 15, 20, 30, 40, 60],
                fit:true,
                idField:'id',
                singleSelect:true,
                columns: [[{
                        title: 'ID',
                        align:'center',
                        hidden:true,
                        field: 'id',

                    }, {
                    title: '开始时间',
                    align:'center',
                    width:'20%',
                    field: 'beginTime',
                    formatter: function (value, row, index) {
                       return getTimeByMillions(row.beginTime)
                    }

                }, {
                    title: '结束时间',
                    align:'center',
                    width:'20%',
                    field: 'endTime',
                    formatter: function (value, row, index) {
                        return getTimeByMillions(row.endTime)
                    }
                }, {
                    title: '完成的工作内容',
                    align:'center',
                    width:'20%',
                    field: 'content',
                }, {
                    title: '审核情况',
                    align:'center',
                    width:'20%',
                    field: 'audit',
                    formatter: function (value, row, index) {
                        if(row.audit==null)
                            return '尚未填写审核状况'
                        return row.audit.remark;
                    }
                }, {
                    title: '操作',
                    align:'center',
                    width:'20%',
                    field: 'schedules',
                    formatter: function (value, row, index) {
                        if(row.content=='请填写工作内容')
                            return '未提交工作内容暂不能审核'
                        if(row.audit==null)
                            return '<a onclick="openDialog()" ><button>填写评语并确认通过</button></a>'
                        if(row.audit.approve==true)
                            return '<a onclick="openDialog()"><button>修改</button></a> '
                    }
                }]],
                onSelect: function (rowIndex, rowData) {
                    var row1 = $("#showDetailSchedule").datagrid('getSelected');
                    if (row1){
                        url= "${basePath}process/addOrEditScheduleRemark.html?scheduleId="+row1.id
                    }
                    document.form.action=url
                }
            })
        });
        function openDialog() {

            $('#mydialog').dialog({
                title : '填写评价内容',
                width : '70%',
                height : '70%',
                closed : false,
                cache : false,
                modal : true,


            });

        }
        function checkText() {
            var text = $("#evaluateText").val();
            if (text.length > 80) {
                myAlert("字数在40字以内！");
                return false;
            } else {
                window.wxc.xcConfirm("确认提交？", "confirm", {
                    onOk: function () {
                        $("#submitEvaluate").submit();
                        $('#mydialog').dialog('closed');
                    }
                })
            }
        }
    </script>

</head>
<body>

<hr>
<a href="<%=basePath%>process/checkStudentSchedule.html" class="btn btn-warning"><i class="icon-backward"></i>返回 </a>
<hr>
<table id ="showDetailSchedule"style="height: 100%"></table>

<div id="mydialog" >
    <form id="submitEvaluate"  name="form" method=post>
        <div >
            <div>
                <%--<input name="scheduleId" type="hidden" value="${schedule.id}"/>--%>
                <p style="float: left">填写评价内容</p><br><br><br><br>
                <p style="color: #808080;float: left">(40字以内)</p>
                <textarea name="content" id="evaluateText" rows="10" cols="70">${addorEditScheduleRemark}</textarea>
            </div>
        </div>
        <div >
            <br><br>
            <button onclick="checkText()" style="float: right">提交更改</button>
        </div>
    </form>
</div>

</body>
</html>




