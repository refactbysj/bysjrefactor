<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
	<%--只能放在head里面--%>
	<%--样式文件和基础路径--%>
	<%@ include file="/WEB-INF/jsps/includeURL.jsp" %>

<script type="text/javascript">
    var stageAchievementGrid;
    $(function () {
        stageAchievementGrid = $("#stageAchievements").datagrid({
            url: '${basePath}showStageAchievements.html',
			//斑马线效果
            striped: true,
            fit: true,
            idField: 'id',
            pagination: true,
            singleSelect: true,
            columns: [[
                {
                    field: 'title',
                    formatter: function (value, rec) {
                        return rec.title;
                    }, title: '课题题目', width: '8%', align: 'center'
                },
                {
                    field: 'subTitle',
                    formatter: function (value, rec) {
                        return rec.subTitle;
                    }, title: '副标题', width: '10%', align: 'center'
                },
                {
                    field: 'year',
                    formatter: function (value, rec) {
                        return rec.year;
                    }, title: '年份', width: '10%', align: 'center'
                },
                {
                    field: 'category',
                    title: '类别', width: '10%', align: 'center'
                },
				{
                    title: '班级',
                    field: 'studentClass',
                    width: '10%',
                    formatter: function (value, rec) {
                        return rec.student.studentClass.description;
                    }
                },
				{
                    title: '学生姓名',
                    field: 'studentName',
                    width: '10%',
                    formatter: function (value, rec) {
                        return rec.student.name;
                    }
                },
				{
                    title: '学号',
                    field: 'studentNo',
                    width: '10%',
                    formatter: function (value, rec) {
                        return rec.student.no;
                    }
                },
                {
                    field: 'detail',
                    formatter: function (value, rec) {
                        //字符类型
                        var str = '';
                        //
                        str += $.formatString('<a href="javascript:void(0)" class="detailBtn" data-options="iconCls:\'icon-more\'" onclick="showDetail(\'{0}\')"></a>', rec.id);
                 		return str;
                    }, title: '详情', width: '10%', align: 'center'
                },
                {
                    field: 'stageAchievement',
                    formatter: function (value, rec) {
                        return rec.stageAchievement.length;//显示成果的条数
                    }, title: '成果', width: '10%', align: 'center'
                },
                {
                    field: 'action', title: '操作', width: '10%', align: 'center',
                    formatter: function (value, rec) {
                        if(rec.stageAchievement!=null){
							var url= "<a href=${basePath}showAuditStageAchievement.html?graduateProjectId="+rec.id+"><button>查看阶段成果</button></a>"
                            return url;
                        }
                        else{
                            var str = '';
							str += $.formatString('<a href="javascript:void(0)" class="btn btn-danger btn-xs" onclick="auditStageAchievement()">查看阶段成果</a>');
                            return str;
                        }
                    }
                }
            ]],
            onLoadSuccess: function () {
                $(".detailBtn").linkbutton({text: '显示详情', iconCls: 'icon-more', plain: true});
            }
    })
    });
    //显示详情
    function showDetail(id) {
        //获取对话框的内容
        var url = '${basePath}process/showDetail.html?graduateProjectId=' + id;
        //弹出对话框
        showProjectDetail(url);
    }
    //没有阶段成果
    function auditStageAchievement(){
        myAlert("没有阶段成果，暂不能审核")
    }

</script>
</head>
<body>
	<table id="stageAchievements" style="width: 100%;height: 100%;"></table>
</body>
</html>