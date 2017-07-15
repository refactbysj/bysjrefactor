<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="zh-CN">
<head>

    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
    <script type="text/javascript">
        var sum=new Array();
        function ajax() {
            $.ajax({
                url : "${basePath}new/scheduleOfGraduateProjectList.html",
                type : "get",
                dataType : "json",
                success : function(value) {
                    var obj = [];
                    $.each(value.rows, function (i, d) {

                        obj.push(d);
                    });
                    $('#scheduleGraduateProjectList').bootstrapTable('load',obj);
                }
            })

        }
        /*点击驳回的函数*/
        <%--function backSchoolExcellent(projectId) {--%>
            <%--$.messager.confirm("提示","确认驳回？", function(r){--%>
                <%--if(r){--%>
                    <%--$.ajax({--%>
                        <%--url: '${basePath}new/backProject.html',--%>
                        <%--data: {"projectId": projectId},--%>
                        <%--dataType: 'json',--%>
                        <%--type: 'post',--%>
                        <%--success: function () {--%>
                            <%--ajax();--%>
                            <%--$.messager.alert("提示","驳回成功！");--%>
                        <%--},--%>
                        <%--error: function () {--%>
                            <%--$.messager.alert("提示","驳回失败！");--%>
                        <%--}--%>
                    <%--});--%>
                <%--}--%>
            <%--})--%>
        <%--}--%>

        /*点击推优的函数*/
        <%--function passSchoolExcellent(projectId) {--%>
            <%--$.messager.confirm("提示","确认推优？", function(r){--%>
                <%--if(r){--%>
                    <%--$.ajax({--%>
                        <%--url: '${basePath}new/passProject.html',--%>
                        <%--data: {"projectId": projectId},--%>
                        <%--dataType: 'json',--%>
                        <%--type: 'post',--%>
                        <%--success: function () {--%>
                            <%--ajax();--%>
                            <%--$.messager.alert("提示","推优成功！");--%>
                        <%--},--%>
                        <%--error: function () {--%>
                            <%--$.messager.alert("提示","推优失败！");--%>
                        <%--}--%>
                    <%--});--%>
                <%--}--%>
            <%--});--%>
        <%--}--%>

        /*bootstrap点击驳回的函数*/
        function backSchoolExcellent(projectId) {
            window.wxc.xcConfirm("确认驳回？", "confirm", {
                onOk: function () {
                    $.ajax({
                        url: '${basePath}new/backProject.html',
                        data: {"projectId": projectId},
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

        /*bootstrap点击推优的函数*/
        function passSchoolExcellent(projectId) {
            window.wxc.xcConfirm("确认推优？", "confirm", {
                onOk: function () {
                    $.ajax({
                        url: '${basePath}new/passProject.html',
                        data: {"projectId": projectId},
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
        function queryParams(params) {
            return {
                limit: params.limit,
                offset: params.offset+1,
            };
        }

        $(function () {
            $.ajax({
                url : "${basePath}new/scheduleOfGraduateProjectList.html",
                type : "get",
                dataType : "json",
                success : function(value) {

                    var obj = [];
                    $.each(value.rows, function(i, d) {

                        obj.push(d);
                    });

                    $("#scheduleGraduateProjectList").bootstrapTable({
                        url: "${basePath}new/scheduleOfGraduateProjectList.html",
                        <%--dataType: 'json',--%>
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
                                field: 'id',
                                title: 'ID',
                                visible:false,//隐藏
//                                rowStyle:function(row,index) {
//                                     return 'class="table table-bordered"'
//                                }
                            },
                            {
                                field: 'no',
                                title: '学号',
                                align:'center',
//                                width:'9%',
                                formatter: function (value, row, index) {
                                    if(row.student!=null) {
                                        return row.student.no;

                                    }
                                }
                            },
                            {
                                field: 'name',
                                title: '姓名',
                                align:'center',
                                width:'5%',
                                formatter: function (value, row, index) {
                                    if(row.student!=null) {
                                        return row.student.name;

                                    }
                                }
                            },
                            {
                                title: '班级',
                                align:'center',
                                width:'5%',
                                field: 'class',
                                formatter: function (value, row, index) {
                                    if(row.student!=null) {
                                        return row.student.studentClass.description;

                                    }
                                }
                            },
                            {
                                title: '专业',
                                align:'center',
                                width:'7%',
                                field: 'major1',
                                formatter: function (value, row, index) {
                                    // return row.student.studentClass.major.description
                                    if(row.major!=null) {
                                        return row.major.description;
                                    }

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
                                title: '毕业设计题目',
                                align:'center',
                                width:'12%',
                                field: 'title',
                                formatter: function (value, row, index) {
                                    var isRepeat = false;
                                    $.ajax({
                                        url: '${basePath}process/isRepeatProject.html',
                                        data: {title: value},
                                        async: false,
                                        success: function (result) {
                                            if(result=='true'){
                                                isRepeat=true;
                                            }
                                        }
                                    });
                                    if(isRepeat) {
                                        if(row.subTitle==null)
                                            return '<span style="color: red;">'+row.title+'</span>';
                                        return '<span style="color: red;">'+row.title+'---'+row.subTitle+'</span>';
                                    }else{
                                        if(row.subTitle==null)
                                            return row.title;
                                        return row.title+'---'+row.subTitle;
                                    }

                                }
                            },
                            {
                                title: '类别',
                                align:'center',
                                width:'5%',
                                field: 'category'
                            },
                            {
                                title: '题目类型',
                                align:'center',
                                width:'5%',
                                field: 'projectType',
                                formatter: function (value, row, index) {
                                    if(row.projectType!=null) {
                                        return row.projectType.description;
                                    }
                                }
                            },
                            {
                                title: '题目性质',
                                align:'center',
                                width:'6%',
                                field: 'projectFidelity',
                                formatter: function (value, row, index) {
                                    if(row.projectFidelity!=null) {
                                        return row.projectFidelity.description;
                                    }
                                }
                            },
                            {
                                title: '题目来源',
                                align:'center',
                                width:'6%',
                                field: 'projectFrom',
                                formatter: function (value, row, index) {
                                    if(row.projectFrom!=null) {
                                        return row.projectFrom.description;
                                    }
                                }
                            },
                            {
                                title: '教师姓名',
                                align:'center',
                                width:'5%',
                                field: 'proposer',
                                formatter: function (value, row, index) {
                                    if(row.proposer!=null) {
                                        return row.proposer.name;
                                    }
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
                                title: '校优秀候选状态',
                                align:'center',
                                width:'8%',
                                field: 'recommended',
                                formatter: function (value, row, index) {
                                    if(row.recommended==true)
                                        return '<p id=projectRecommended'+row.id+'>优秀</p>';
                                    return '<p id=projectRecommended'+row.id+'>无</p>';
                                }
                            },
                            {
                                title: '操作',
                                align:'center',
                                width:'7%',
                                field: 'option',
                                formatter: function (value, row, index) {
                                    if(row.schoolExcellentProject!=null)
                                        return '校优';
                                    if(sum[row.id]>=90) {
                                        if (row.recommended == true && row.schoolExcellentProject == null) {
                                            return '<a id=projectOperation' + row.id + ' onclick=backSchoolExcellent(' + row.id + ')><button class="btn btn-warning">驳回</button></a>';
                                        }
                                        return '<a id=projectOperation' + row.id + ' onclick=passSchoolExcellent(' + row.id + ')><button class="btn btn-primary">推优</button></a>';
                                    }

                                    return '<p style="color: red">条件不符合</p>';
                                }

                            },
                            {
                                title: '详情',
                                align:'center',
                                width:'7%',
                                field: 'detail',
                                formatter: function (value, row, index) {
                                    <%--return "<a class='btn btn-primary' href='<%=basePath%>process/showDetail.html?graduateProjectId="+row.id+"' data-toggle='modal' data-target='#viewProjectModal'><i class='icon-coffee'></i>显示详情</a>"--%>
                                    return "<a href='<%=basePath%>new/show.html?graduateProjectId="+row.id+"' data-toggle='modal' data-target='#myModal'><button class='btn btn-info'>显示详情</button></a>"

                                }
                            }
                        ]],
                    })
                }
            })

        })

    </script>

</head>
<body>
<div>
    <ol class="breadcrumb">
        <li><a href="#">论文管理</a></li>
        <li><a href="#">毕业论文明细表</a></li>
    </ol>
</div>
<div class="row-fluid">
    <table id ="scheduleGraduateProjectList" class="table table-bordered table-condensed"></table>
</div>
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