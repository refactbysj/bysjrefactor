<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
	<%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
	<script type="text/javascript">
		var sum=new Array();
        //查询
        $(function () {
            $('#searchBtn').click(function () {
                var title=$('#title').val();
                var tutorName=$('#tutorName').val();
                $.ajax({
                    url : "${basePath}project/schoolExcellentProjects.html?title="+title+"&tutorName="+tutorName,
                    type : "get",
                    dataType : "json",
                    success : function(value) {
                        var obj = [];
                        $.each(value.rows, function (i, d) {

                            obj.push(d);
                        });
                        $('#newAssginSchoolExcellentProjects').bootstrapTable('load',obj);
                    }
                })
            })
        })
        function ajax() {
            $.ajax({
                url : "${basePath}project/schoolExcellentProjects.html",
                type : "get",
                dataType : "json",
                success : function(value) {
                    var obj = [];
                    $.each(value.rows, function (i, d) {

                        obj.push(d);
                    });
                    $('#newAssginSchoolExcellentProjects').bootstrapTable('load',obj);
                }
            })
        }
        /*点击推优的函数*/
        function passSchoolExcellent(graduateProjectId) {
            window.wxc.xcConfirm("确认推优？", "confirm", {
                onOk: function () {
                    $.ajax({
                        url: '${basePath}project/approveSchoolExcellentProject.html',
                        data: {"graduateProjectId": graduateProjectId},
                        dataType: 'json',
                        type: 'post',
                        success: function () {
                            ajax();
                            window.wxc.xcConfirm("推优成功！", "success");
                            return true;
                        },
                        error: function () {
                            window.wxc.xcConfirm("推优失败", "error");
                            return false;
                        }
                    });
                }
            });
        }
        /*点击驳回的函数*/
        function backSchoolExcellent(graduateProjectId) {
            window.wxc.xcConfirm("确认驳回？", "confirm", {
                onOk: function () {
                    $.ajax({
                        url: '${basePath}project/cancelSchoolExcellentProject.html',
                        data: {"graduateProjectId": graduateProjectId},
                        dataType: 'json',
                        type: 'post',
                        success: function () {
                            ajax();
                            window.wxc.xcConfirm("驳回成功！", "success");
                        },
                        error: function () {
                            window.wxc.xcConfirm("驳回失败！", "error");
                        }
                    });
                }
            })
        }

        function queryParams(params) {
            return {
                limit: params.limit,
                offset: params.offset+1,
            };
        }
		$(function () {
            $.ajax({
                url : "${basePath}project/schoolExcellentProjects.html",
                type : "get",
                dataType : "json",
                success : function(value) {

                    var obj = [];
                    $.each(value.rows, function(i, d) {

                        obj.push(d);
                    });
		    $("#newAssginSchoolExcellentProjects").bootstrapTable({
				data:obj,
                striped: true,
                cache: false,
                pagination:true,
//                        showPaginationSwitch:true,
                pageList:[0,1,2,3],
                pageSize : 2,
//                        pageNumber:1,
                singleSelect:true,
                queryParams: queryParams,
				columns: [[
					{
						title: 'ID',
						field: 'id',
						visible:false
					},
					{
						title: '学号',
						align:'center',
						width:'9%',
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
						width:'5%',
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
						width:'15%',
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
						width:'7%',
						field: 'category',
					},

					{
						title: '教师姓名',
						align:'center',
						width:'7%',
						field: 'proposer',
						formatter: function (value, row, index) {
							return row.proposer.name;
						}
					},
					{
						title: '职称/学位',
						align:'center',
						width:'10%',
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
						title: '指定校级优秀',
						align:'center',
						width:'10%',
						field: 'recommended',
						formatter: function (value, row, index) {
							if(row.recommended&&row.schoolExcellentPro)
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
//                            if(row.provinceExcellentPro)
//                                return '校优';
                            if (row.recommended&&row.schoolExcellentPro) {
                                return '<a id=projectOperation' + row.id + ' onclick=backSchoolExcellent(' + row.id + ')><button>驳回</button></a>';
                            }
                            return '<a id=projectOperation' + row.id + ' onclick=passSchoolExcellent(' + row.id + ')><button>通过</button></a>';
                        }

					},
					{
						title: '详情',
						align:'center',
						width:'7%',
						field: 'detail',
						formatter: function (value, row, index) {
                            return "<a href='<%=basePath%>new/show.html?graduateProjectId="+row.id+"' data-toggle='modal' data-target='#myModal'><button class='btn btn-info'>显示详情</button></a>"

                        }
					},
				]],
			})
                }
		});
        })
	</script>

</head>
<body>
<div>
    <div class="input-group input-group-sm">
        <span class="input-group-addon">题目名称：</span>
        <input id="title" type="text" class="form-control" />
        <span class="input-group-addon">教师姓名：</span>
        <input id="tutorName" type="text" class="form-control" />
    </div>
    <button id="searchBtn" class="btn btn-info btn-sm" >查询</button>
</div>
<table id ="newAssginSchoolExcellentProjects"></table>
<!-- 模态框（Modal） -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <%--加载另一个页面jsp内容--%>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
</div>
</body>
</html>
