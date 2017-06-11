<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
	<%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
	<script type="text/javascript">
        var checkSchoolExcellentProjectsGrid, sum=new Array();
        //查询
        function searchFun() {
            $("#checkSchoolExcellentProjects").datagrid('load', $.serializeObject($("#form")));
        }
        //显示细节的弹出框
        function openWindow(id) {
            $('#detailWindow').window({
                title : '论文详情',
                width : '70%',
                height : '70%',
                closed : false,
                cache : false,
                modal : true,
            });

            var hrefs = "<iframe id='son'  src=${basePath}process/showDetail.html?graduateProjectId="+id+ " allowTransparency='true' style='border:0;width:99%;height:99%;padding-left:2px;' frameBorder='0'></iframe>";
            $("#details").html(hrefs);
        }
		/*点击推优的函数*/
        function passSchoolExcellent(graduateProjectId) {
            $.messager.confirm("提示","确认推优？", function(r){
                if(r){
                    $.ajax({
                        url: '${basePath}projects/approveProvinceExcellentProjectByDirector.html',
                        data: {"graduateProjectId": graduateProjectId},
                        dataType: 'json',
                        type: 'post',
                        success: function (data){
                            if(data) {
                                $.messager.alert('提示', "推优成功");
                                $('#checkSchoolExcellentProjects').datagrid('reload');
                            }else
                                $.messager.alert('提示', "推优失败");
                        },
                    });
                }
            });
        }
		/*点击驳回的函数*/
        function backSchoolExcellent(graduateProjectId) {
            $.messager.confirm("提示","确认驳回？", function(r){
                if(r){
                    $.ajax({
                        url: '${basePath}projects/cancelProvinceExcellentProjectByDirector.html',
                        data: {"graduateProjectId": graduateProjectId},
                        dataType: 'json',
                        type: 'post',
                        success: function (data) {
                            if(data) {
                                $.messager.alert('提示',"驳回成功");
                                $('#checkSchoolExcellentProjects').datagrid('reload');
                            }else
                                $.messager.alert('提示', "驳回失败");

                        }
                    });
                }
            })
        }

        $(function () {
            checkSchoolExcellentProjectsGrid = $("#checkSchoolExcellentProjects").datagrid({
                url: '${basePath}projects/listSchoolExcellentProjectsList.html',
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
                        title: '学号',
                        align:'center',
                        width:'9%',
                        field: 'no',
                        formatter: function (value, row, index) {
                            return row.graduateProject.student.no;
                        }
                    },
                    {
                        title: '姓名',
                        align:'center',
                        width:'7%',
                        field: 'name',
                        formatter: function (value, row, index) {
                            return row.graduateProject.student.name;
                        }
                    },
                    {
                        title: '班级',
                        align:'center',
                        width:'7%',
                        field: 'class',
                        formatter: function (value, row, index) {
                            return row.graduateProject.student.studentClass.description;
                        }
                    },
                    {
                        title: '专业',
                        align:'center',
                        width:'10%',
                        field: 'major1',
                        formatter: function (value, row, index) {
                            return row.graduateProject.major.description;

                        }
                    },

                {
                        title: '成绩',
                        align:'center',
                        width:'5%',
                        field: 'score',
                        formatter: function (value, row, index) {
                            if(row.graduateProject.commentByTutor!=null&&row.graduateProject.commentByReviewer!=null&&row.graduateProject.commentByGroup!=null) {
                                if(row.graduateProject.commentByTutor.basicAblityScore!=null&&
                                    row.graduateProject.commentByTutor.workLoadScore!=null&&
                                    row.graduateProject.commentByTutor.workAblityScore!=null&&
                                    row.graduateProject.commentByTutor.achievementLevelScore!=null&&
                                    row.graduateProject.commentByReviewer.qualityScore!=null&&
                                    row.graduateProject.commentByReviewer.achievementScore!=null&&
                                    row.graduateProject.commentByReviewer.qualityScore!=0.0&&
                                    row.graduateProject.commentByGroup.completenessScore!=0.0&&
                                    row.graduateProject.commentByGroup.replyScore!=0.0&&
                                    row.graduateProject.commentByGroup.correctnessSocre!=0.0) {
                                    sum[row.id] = row.graduateProject.commentByTutor.basicAblityScore + row.graduateProject.commentByTutor.workLoadScore + row.graduateProject.commentByTutor.workAblityScore + row.graduateProject.commentByTutor.achievementLevelScore
                                        + row.graduateProject.commentByReviewer.qualityScore + row.graduateProject.commentByReviewer.achievementScore
                                        + row.graduateProject.commentByGroup.qualityScore + row.graduateProject.commentByGroup.completenessScore + row.graduateProject.commentByGroup.replyScore + row.graduateProject.commentByGroup.correctnessSocre;
                                    return sum[row.id];
                                }
                            }
                            return '<p title="指导老师、评阅人和答辩组长必须全部评分才能显示分数" style="color: red">未评分</p>'
                        }
                    },
                    {
                        title: '题目',
                        align:'center',
                        width:'15%',
                        field: 'title',
                        formatter: function (value, row, index) {
                            if(row.graduateProject.subTitle==null)
                                return row.graduateProject.title;
                            return row.graduateProject.title+'——'+row.graduateProject.subTitle;
                        }
                    },
                    {
                        title: '类别',
                        align:'center',
                        width:'7%',
                        field: 'category',
                        formatter: function (value, row, index) {
                            return row.graduateProject.category;
                        }
                    },

                    {
                        title: '教师姓名',
                        align:'center',
                        width:'7%',
                        field: 'proposer',
                        formatter: function (value, row, index) {
                            return row.graduateProject.proposer.name;
                        }
                    },
                    {
                        title: '职称/学位',
                        align:'center',
                        width:'10%',
                        field: 'proTitle',
                        formatter: function (value, row, index) {
                            if(row.graduateProject.proposer.proTitle==null) {
                                if (row.graduateProject.proposer.degree == null)
                                    return '无/无';
                                else
                                    return '无/' + row.graduateProject.proposer.degree.description;
                            }else {
                                if (row.graduateProject.proposer.degree == null)
                                    return row.graduateProject.proposer.proTitle.description + '/无';
                                else
                                    return row.graduateProject.proposer.proTitle.description + '/' + row.graduateProject.proposer.degree.description;
                            }
                        }
                    },
                    {
                        title: '省优候选状态',
                        align:'center',
                        width:'8%',
                        field: 'recommended',
                        formatter: function (value, row, index) {
                            if(row.recommended==true)
                                return '<p id=projectRecommended'+row.id+'>优秀</p>';
                            return '<p id=projectRecommended'+row.id+'>否</p>';
                        }
                    },
                    {
                        title: '操作',
                        align:'center',
                        width:'7%',
                        field: 'option',
                        formatter: function (value, row, index) {
                            if (row.recommended==true) {
                                return '<a id=projectOperation' + row.id + ' onclick=backSchoolExcellent(' + row.id + ')><button>驳回</button></a>';
                            }
                            return '<a id=projectOperation' + row.id + ' onclick=passSchoolExcellent(' + row.id + ')><button>通过</button></a>';
                        }

                    },
                    {
                        title: '详情',
                        align:'center',
                        width:'10%',
                        field: 'detail',
                        formatter: function (value, row, index) {
                            var url= "<a onclick='openWindow("+row.id+")'><button>显示细节</button></a>"

                            return url;
                        }
                    },
                ]],
            })

        });
	</script>

</head>
<body>
<div id="search" style="position: absolute;top: 10px;left: 1%;">
	<form id="form">
		题目名称：
		<input type="text" class="easyui-textbox"  name="title" id="title"/>
		教师姓名：
		<input type="text" class="easyui-textbox"  name="tutorName" id="tutorName"/>

		<a id="searchfun" class="easyui-linkbutton" onclick="searchFun()" data-options="iconCls:'icon-search'">查询</a>

	</form>
</div>
<div style="height: 100%;">
	<table id ="checkSchoolExcellentProjects" style="height: 100%"></table>

</div>
<div id ="detailWindow">
	<div id="details" data-options="region:'center'" >
		<%--引用外部html文件--%>
	</div>
</div>
</body>
</html>



