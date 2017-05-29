
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
	<%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
	<script type="text/javascript">
        var checkProvinceExcellentProjectsGrid, sum=new Array();
        //查询
        function searchFun() {
            $("#checkProvinceExcellentProjects").datagrid('load', $.serializeObject($("#form")));
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

        $(function () {
            checkProvinceExcellentProjectsGrid = $("#checkProvinceExcellentProjects").datagrid({
                url: '${basePath}projects/listProvenceExcellentProjectsList.html',
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
                        width:'10%',
                        field: 'no',
                        formatter: function (value, row, index) {
                            return row.student.no;
                        }
                    },
                    {
                        title: '姓名',
                        align:'center',
                        width:'7%',
                        field: 'name',
                        formatter: function (value, row, index) {
                            return row.student.name;
                        }
                    },
                    {
                        title: '班级',
                        align:'center',
                        width:'7%',
                        field: 'class',
                        formatter: function (value, row, index) {
                            return row.student.studentClass.description;
                        }
                    },
                    {
                        title: '专业',
                        align:'center',
                        width:'10%',
                        field: 'major1',
                        formatter: function (value, row, index) {
                            return row.major.description;

                        }
                    },

                    {
                        title: '成绩',
                        align:'center',
                        width:'7%',
                        field: 'score',
                        formatter: function (value, row, index) {
                            if(row.commentByTutor!=null&&row.commentByReviewer!=null&&row.commentByGroup!=null) {
                                if(row.commentByTutor.basicAblityScore!=null&&
                                    row.commentByTutor.workLoadScore!=null&&
                                    row.commentByTutor.workAblityScore!=null&&
                                    row.commentByTutor.achievementLevelScore!=null&&
                                    row.commentByReviewer.qualityScore!=null&&
                                    row.commentByReviewer.achievementScore!=null&&
                                    row.commentByReviewer.qualityScore!=0.0&&
                                    row.commentByGroup.completenessScore!=0.0&&
                                    row.commentByGroup.replyScore!=0.0&&
                                    row.commentByGroup.correctnessSocre!=0.0) {
                                    sum[row.id] = row.commentByTutor.basicAblityScore + row.commentByTutor.workLoadScore + row.commentByTutor.workAblityScore + row.commentByTutor.achievementLevelScore
                                        + row.commentByReviewer.qualityScore + row.commentByReviewer.achievementScore
                                        + row.commentByGroup.qualityScore + row.commentByGroup.completenessScore + row.commentByGroup.replyScore + row.commentByGroup.correctnessSocre;
                                    return sum[row.id];
                                }
                            }
                            return '<p title="指导老师、评阅人和答辩组长必须全部评分才能显示分数" style="color: red">未评分</p>'
                        }
                    },
                    {
                        title: '题目',
                        align:'center',
                        width:'20%',
                        field: 'title',
                        formatter: function (value, row, index) {
                            if(row.subTitle==null)
                                return row.title;
                            return row.title+'---'+row.subTitle;
                        }
                    },
                    {
                        title: '类别',
                        align:'center',
                        width:'9%',
                        field: 'category',
                        formatter: function (value, row, index) {
                            return row.category;
                        }
                    },
					{
                        title: '教师姓名',
                        align:'center',
                        width:'10%',
                        field: 'proposer',
                        formatter: function (value, row, index) {
                            return row.proposer.name;
                        }
                    },
                    {
                        title: '职称/学位',
                        align:'center',
                        width:'12%',
                        field: 'proTitle',
                        formatter: function (value, row, index) {
                            if(row.proposer.proTitle==null) {
                                if (row.proposer.degree == null)
                                    return '无/无';
                                else
                                    return '无/' + row.proposer.degree.description;
                            }else {
                                if (row.proposer.degree == null)
                                    return row.proposer.proTitle.description + '/无';
                                else
                                    return row.proposer.proTitle.description + '/' + row.proposer.degree.description;
                            }
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
<div id="search">
	<form id="form">
		题目名称：
		<input type="text" class="easyui-textbox"  name="title" id="title"/>
		教师姓名：
		<input type="text" class="easyui-textbox"  name="tutorName" id="tutorName"/>

		<a id="searchfun" class="easyui-linkbutton" onclick="searchFun()" data-options="iconCls:'icon-search'">查询</a>

	</form>
</div>
<table id ="checkProvinceExcellentProjects" style="height: 100%"></table>
<div id ="detailWindow">
	<div id="details" data-options="region:'center'" >
		引用外部html文件
	</div>
</div>
</body>
</html>



