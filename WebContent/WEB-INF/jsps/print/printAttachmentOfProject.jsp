<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<html>
<head>
    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
    <script type="text/javascript">

        //打印评阅人评审表
        function printReviewerEvaluate(id) {
            window.open('${basePath}evaluate/reviewer/printReport.html?reportId=' + id, '_blank');

        }


        //打印指导老师评审表
        function printTutorEvaluate(id) {
            window.open('${basePath}evaluate/chiefTutor/printReport.html?reportId=' + id, '_blank');

        }

        //打印答辩小组评审表
        function printGroupEvaluate(id) {
            window.open('${basePath}evaluate/replyGroup/printReport.html?reportId=' + id, '_blank');
        }

        //打印附件封面
        function printCover(id) {

        }

        //查看答辩小组评审表
        function viewGroupEvaluate(id) {
            var url = '${basePath}evaluate/replyGroup/viewReplyGroupEvaluate.html?projectId=' + id;
            viewEvaluate(url, '查看答辩小组评审表');
        }

        //查看指导老师评审表
        function viewTutorEvaluate(id) {
            var url = '${basePath}evaluate/chiefTutor/viewTutorEvaluate.html?projectId=' + id;
            viewEvaluate(url, '查看指导老师评审表');
        }

        //查看评阅人评审表
        function viewReviewerEvaluate(id) {
            var url = '${basePath}evaluate/reviewer/reviewerViewTutorEvaluate.html?projectId=' + id;
            viewEvaluate(url, '查看评阅评审表');
        }

        //查看工作进程表
        function viewSchedules(id) {

        }

        //下载终稿
        function finalDraftDown(id) {
            window.location.href = '${basePath}student/download/finalDraft.html?graduateProjectId=' + id;
        }

        //查看成绩
        function viewScore(id) {
            var url = '${basePath}tutor/viewScores.html?projectId=' + id;
            viewEvaluate(url, '查看成绩');
        }

        //下载任务书
        function taskDocDownload(id) {
            window.location.href = '${basePath}tutor/downLoadTaskDoc.html?projectId=' + id;
        }

        //下载开题报告
        function openningReportDownload(id) {
            window.location.href = '${basePath}student/openningReport/downloadOpenningReport.html?paperProjectId=' + id;
        }

        //显示细节
        function showDetail(id) {
            var url = '${basePath}process/showDetail.html?graduateProjectId=' + id;
            showProjectDetail(url);
        }

        function viewEvaluate(url, title) {
            parent.$.modalDialog({
                href: url,
                title: title,
                modal: true,
                width: '60%',
                height: '80%',
                buttons: [{
                    text: '关闭',
                    iconCls: 'icon-cancel',
                    handler: function () {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                }]
            })
        }

        $(function () {
            $("#attachGrid").datagrid({
                url: '${basePath}print/getPrintAttachData.html',
                striped: true,
                fit: true,
                pagination: true,
                singleSelect: true,
                columns: [[{
                    title: '学号',
                    field: 'studentNo',
                    width: '7%',
                    formatter: function (value, row) {
                        return row.student.no;
                    }
                }, {
                    title: '姓名',
                    width: '5%',
                    field: 'studentName',
                    formatter: function (value, row) {
                        return row.student.name;
                    }
                }, {
                    title: '成绩',
                    width: '4%',
                    field: 'viewGrade',
                    formatter: function (value, row) {
                        return $.formatString('<a href="javascript:void(0)" class="viewBtn" onclick="viewScore(\'{0}\')"></a>', row.id);
                    }
                }, {
                    title: '标题（副标题）',
                    field: 'title',
                    width: '20%',
                    formatter: function (value, row) {
                        if (row.subTitle == null || row.subTitle == '') {
                            return row.title;
                        } else {
                            return value + "——" + row.subTitle;
                        }
                    }
                }, {
                    title: '指导教师',
                    field: 'tutorName',
                    width: '5%',
                    formatter: function (value, row) {
                        if (row.mainTutorage == null || row.mainTutorage.tutor == null) {
                            return '无';
                        } else {
                            return row.mainTutorage.tutor.name;
                        }
                    }
                }, {
                    title: '任务书',
                    field: 'taskDoc',
                    formatter: function (value, row) {
                        if (row.taskDoc != null) {
                            //教研室主任和院长审核通过
                            if (row.taskDoc.auditByDepartmentDirector.approve && row.taskDoc.auditByBean.approve) {
                                return $.formatString('<a href="javascript:void(0)" class="downBtn" onclick="taskDocDownload(\'{0}\')"></a>', row.id);
                            } else {
                                return '<span style="color:red">已退回</span>';
                            }
                        } else {
                            return '无';
                        }
                    }
                }, {
                    title: '开题报告',
                    field: 'openningReport',
                    formatter: function (value, row) {
                        try {
                            if (row.openningReport != null) {
                                return $.formatString('<a href="javascript:void(0)" class="downBtn" onclick="openningReportDownload(\'{0}\')"></a>', row.id);
                            } else {
                                return '无';
                            }
                        } catch (err) {
                            return '无';
                        }
                    }
                }, {
                    title: '终稿',
                    width: '5%',
                    field: 'finalDraft',
                    formatter: function (value, row) {
                        if (row.finalDraft != null) {
                            return $.formatString('<a href="javascript:void(0)" class="downBtn" onclick="finalDraftDown(\'{0}\')"></a>', row.id)
                        } else {
                            return '无';
                        }
                    }
                }, {
                    title: '工作进程表',
                    field: 'schedules',
                    formatter: function (value, row) {
                        var schedules = row.schedules;
                        if (schedules.length > 0) {
                            return $.formatString('<a href="javascript:void(0)" class="viewBtn" onclick="viewSchedules(\'{0}\')"></a>', row.id);
                        } else {
                            return '无';
                        }
                    }
                },
                    <sec:authorize ifAnyGranted="ROLE_TUTOR">
                    {
                        title: '指导老师评审表',
                        width: '8%',
                        field: 'tutorEvaluate',
                        formatter: function (value, row) {
                            var str = '';
                            if (row.commentByTutor != null && row.commentByTutor.submittedByTutor) {
                                str += $.formatString('<a href="javascript:void(0)" class="viewBtn" onclick="viewTutorEvaluate(\'{0}\')"></a>', row.id);
                                str += $.formatString('<a href="javascript:void(0)" class="printBtn" onclick="printTutorEvaluate(\'{0}\')"></a>', row.id);
                            } else {
                                str += '无';
                            }
                            return str;
                        }
                    }, {
                        title: '评阅人评审表',
                        field: 'reviewerEvaluate',
                        width: '8%',
                        formatter: function (value, row) {
                            var str = '';
                            if (row.commentByReviewer != null && row.commentByReviewer.submittedByReviewer) {
                                str += $.formatString('<a href="javascript:void(0)" class="viewBtn" onclick="viewReviewerEvaluate(\'{0}\')"></a>', row.id);
                                str += $.formatString('<a href="javascript:void(0)" class="printBtn" onclick="printReviewerEvaluate(\'{0}\')"></a>', row.id);
                            } else {
                                str = '无';
                            }
                            return str;
                        }
                    }, {
                        title: '答辩小组意见表',
                        width: '8%',
                        field: 'groupEvaluate',
                        formatter: function (value, row) {
                            var str = '';
                            if (row.commentByGroup != null && row.commentByGroup.submittedByGroup) {
                                str += $.formatString('<a href="javascript:void(0)" class="viewBtn" onclick="viewGroupEvaluate(\'{0}\')"></a>', row.id);
                                str += $.formatString('<a href="javascript:void(0)" class="printBtn" onclick="printGroupEvaluate(\'{0}\')"></a>', row.id);
                            } else {
                                str = '无';
                            }
                            return str;
                        }
                    },
                    </sec:authorize>
                    {
                        title: '论文附件封面',
                        field: 'cover',
                        formatter: function (value, row) {
                            return $.formatString('<a href="javascript:void(0)" class="printBtn" onclick="printCover(\'{0}\')"></a>', row.id);
                        }
                    }, {
                        title: '详情',
                        field: 'detail',
                        width: '8%',
                        formatter: function (value, row) {
                            return $.formatString('<a href="javascript:void(0)" class="detailBtn" onclick="showDetail(\'{0}\')"></a>', row.id);
                        }
                    }
                ]],
                onLoadSuccess: function () {
                    $(".viewBtn").linkbutton({text: '查看', plain: true});
                    $(".downBtn").linkbutton({text: '下载', plain: true});
                    $(".printBtn").linkbutton({text: '打印', plain: true, iconCls: 'icon-print'});
                    $(".detailBtn").linkbutton({text: '详情', plain: true, iconCls: 'icon-more'});
                }

            })
        })

        function searchFun() {
            $("#attachGrid").datagrid('load', $.serializeObject($("#searchForm")));
        }

        function clearFun() {
            $("#title").val('');
            $("input[name='category']").attr('checked', false);
            $("#attachGrid").datagrid('load', {});
        }
    </script>
</head>
<body>
<sec:authorize ifAllGranted="ROLE_TUTOR">
    <div style="position: absolute;top: 10px;right: 5%;">
        <form id="searchForm">
            <span style="color: grey;">课题名称</span>
            <input title="题目名称" name="title" id="title" class="easyui-textbox">
            <input title="课题类型" type="radio" name="category" value="论文题目"/>论文
            <input title="课题类型" type="radio" name="category" value="设计题目"/>设计
            <input title="课题类型" type="radio" name="category" value="${null}"/>全部
            <a class="easyui-linkbutton" href="javascript:void(0)" onclick="searchFun()"
               data-options="iconCls:'icon-search'">查询</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="clearFun()"
               data-options="iconCls:'icon-cancel'">清空</a>
        </form>
    </div>

</sec:authorize>

<div style="width: 100%;height: 100%;">
    <table id="attachGrid" style="height: 100%;"></table>
</div>

</body>
</html>
