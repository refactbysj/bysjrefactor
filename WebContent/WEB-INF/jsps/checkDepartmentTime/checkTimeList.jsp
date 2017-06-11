<%--
  Created by IntelliJ IDEA.
  User: apple
  Date: 17/6/3
  Time: 下午3:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
    <script type="text/javascript">
        var checkTimeTableGrid;
        function getTimeByMillions(millions) {
            var date = new Date(millions);
            var year = date.getFullYear() + '年';
            var month = date.getMonth() + '月';
            var day = date.getDay() + '日';
            return year + month + day;
        }
        $(function () {
            checkTimeTableGrid = $("#checkTimeTable").datagrid({
                url: '${basePath}process/getCheckTimeList.html',
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
                    field: 'id',
                    hidden:true
                }, {
                    title: '教研室',
                    width:'15%',
                    align:'center',
                    field: 'description'
                }, {
                    title: '学院',
                    align:'center',
                    field: 'school',
                    width:'15%',
                    formatter: function (value, row, index) {
                        return row.school.description;
                    }
                },{
                    title: '教师申请题目的时间',
                    align:'center',
                    field: 'constraintOfProposeProject',
                    width:'20%',
                    formatter: function (value, row, index) {
                        if (row.constraintOfProposeProject!=null) {
                            return getTimeByMillions(row.constraintOfProposeProject.startTime)+'---'+getTimeByMillions(row.constraintOfProposeProject.endTime)
                        } else {
                            return "尚未设置教师申请题目的时间";
                        }
                    }
                }, {
                    title: '审核开题报告的时间',
                    align:'center',
                    field: 'constraintOfApproveOpenningReport',
                    width: '20%',
                    formatter: function (value, row, index) {
                        if (row.constraintOfApproveOpenningReport!=null) {
                            return getTimeByMillions(row.constraintOfApproveOpenningReport.startTime)+'---'+getTimeByMillions(row.constraintOfApproveOpenningReport.endTime)
                        } else {
                            return "尚未设置审核开题报告时间";
                        }
                    }
                }, {
                    title: '教研室毕业设计时间',
                    align:'center',
                    field: 'projectTimeSpan',
                    width: '20%',
                    formatter: function (value, row, index) {
                        if (row.projectTimeSpan!=null) {
                            return getTimeByMillions(row.projectTimeSpan.beginTime)+'---'+getTimeByMillions(row.projectTimeSpan.endTime);
                        } else {
                            return "尚未设置毕业时间";
                        }
                    }
                }]]
            })
        });

    </script>

</head>
<body>
<table id="checkTimeTable" style="height: 100%"></table>

</body>
</html>
