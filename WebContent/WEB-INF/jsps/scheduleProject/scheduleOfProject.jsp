<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
    <script type="text/javascript">
        var scheduleGrid;
        $(function () {
            scheduleGrid = $("#scheduleOfProject").datagrid({
                url: '${basePath}process/scheduleProjectList.html',
                striped: true,
                pagination:true,
                pageSize: 15,
                pageList: [10, 15, 20, 30, 40, 60],
                fit:true,
                idField:'id',
                singleSelect:true,
                columns: [[
                    {
                        title: 'ID',
                        field: 'id',
                        hidden:true

                    },
                    {
                    title: '题目',
                    align:'center',
                    width:'20%',
                    field: 'title',
                }, {
                    title: '学生学号',
                    align:'center',
                    width:'20%',
                    field: 'students',
                    formatter: function (value, row, index) {
                        return row.student.no;
                    }
                }, {
                    title: '学生姓名',
                    align:'center',
                    width:'20%',
                    field: 'student',
                    formatter: function (value, row, index) {
                        return row.student.name;
                    }
                }, {
                    title: '审核',
                    align:'center',
                    width:'20%',
                    field: 'schedule',
                    formatter: function (value, row, index) {
                        if (row.schedules == null||row.schedules== '') {
                            return '未提交';
                        } else {
                            var url= "<a href=${basePath}process/showDetailSchedules.html?graduateProjectId="+row.id+"><button>审核</button></a>"
                            return url;
                        }
                    }
                }, {
                    title: '审核条数',
                    align:'center',
                    width:'20%',
                    field: 'schedules',
                    formatter: function (value, row, index) {
                        return row.schedules.length;
                    }
                }]],
            })
        });
    </script>

</head>
<body>
    <table id ="scheduleOfProject"style="height: 100%"></table>
</body>
</html>
