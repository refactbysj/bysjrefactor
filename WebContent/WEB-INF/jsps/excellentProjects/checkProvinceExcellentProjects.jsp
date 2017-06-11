
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
                            return row.graudateProject.student.no;
                        }
                    },
                    {
                        title: '姓名',
                        align:'center',
                        width:'7%',
                        field: 'name',
                        formatter: function (value, row, index) {
                            return row.graudateProject.student.name;
                        }
                    },
                    {
                        title: '班级',
                        align:'center',
                        width:'7%',
                        field: 'class',
                        formatter: function (value, row, index) {
                            return row.graudateProject.student.studentClass.description;
                        }
                    },
                    {
                        title: '专业',
                        align:'center',
                        width:'10%',
                        field: 'major1',
                        formatter: function (value, row, index) {
                            return row.graudateProject.major.description;

                        }
                    },

                    {
                        title: '成绩',
                        align:'center',
                        width:'7%',
                        field: 'score',
                        formatter: function (value, row, index) {
                            if(row.graudateProject.commentByTutor!=null&&row.graudateProject.commentByReviewer!=null&&row.graudateProject.commentByGroup!=null) {
                                if(row.graudateProject.commentByTutor.basicAblityScore!=null&&
                                    row.graudateProject.commentByTutor.workLoadScore!=null&&
                                    row.graudateProject.commentByTutor.workAblityScore!=null&&
                                    row.graudateProject.commentByTutor.achievementLevelScore!=null&&
                                    row.graudateProject.commentByReviewer.qualityScore!=null&&
                                    row.graudateProject.commentByReviewer.achievementScore!=null&&
                                    row.graudateProject.commentByReviewer.qualityScore!=0.0&&
                                    row.graudateProject.commentByGroup.completenessScore!=0.0&&
                                    row.graudateProject.commentByGroup.replyScore!=0.0&&
                                    row.graudateProject.commentByGroup.correctnessSocre!=0.0) {
                                    sum[row.id] = row.graudateProject.commentByTutor.basicAblityScore + row.graudateProject.commentByTutor.workLoadScore + row.graudateProject.commentByTutor.workAblityScore + row.graudateProject.commentByTutor.achievementLevelScore
                                        + row.graudateProject.commentByReviewer.qualityScore + row.graudateProject.commentByReviewer.achievementScore
                                        + row.graudateProject.commentByGroup.qualityScore + row.graudateProject.commentByGroup.completenessScore + row.graudateProject.commentByGroup.replyScore + row.graudateProject.commentByGroup.correctnessSocre;
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
                            if(row.graudateProject.subTitle==null)
                                return row.graudateProject.title;
                            return row.graudateProject.title+'——'+row.graudateProject.subTitle;
                        }
                    },
                    {
                        title: '类别',
                        align:'center',
                        width:'9%',
                        field: 'category',
                        formatter: function (value, row, index) {
                            return row.graudateProject.category;
                        }
                    },
					{
                        title: '教师姓名',
                        align:'center',
                        width:'10%',
                        field: 'proposer',
                        formatter: function (value, row, index) {
                            return row.graudateProject.proposer.name;
                        }
                    },
                    {
                        title: '职称/学位',
                        align:'center',
                        width:'12%',
                        field: 'proTitle',
                        formatter: function (value, row, index) {
                            if(row.graudateProject.proposer.proTitle==null) {
                                if (row.graudateProject.proposer.degree == null)
                                    return '无/无';
                                else
                                    return '无/' + row.graudateProject.proposer.degree.description;
                            }else {
                                if (row.graudateProject.proposer.degree == null)
                                    return row.graudateProject.proposer.proTitle.description + '/无';
                                else
                                    return row.graudateProject.proposer.proTitle.description + '/' + row.graudateProject.proposer.degree.description;
                            }
                        }
                    },
                    {
                        title: '详情',
                        align:'center',
                        width:'10%',
                        field: 'detail',
                        formatter: function (value, row, index) {
                            var url= "<a onclick='openWindow("+row.graudateProject.id+")'><button>显示细节</button></a>"
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
		<%--引用外部html文件--%>
	</div>
</div>
</body>
</html>



