<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
    <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
</head>
<body>
<span  style="color:red;width:100%;height:5%">点击对应的比例，可以查看未完成的课题汇总</span>
<table id="dataAccount" class="easyui-datagrid">
    <script  type="text/javascript">
        var dataAccountData,url='';
        <%--最高角色是院级管理员--%>

        <sec:authorize ifAllGranted="ROLE_SCHOOL_ADMIN" ifNotGranted="ROLE_DEPARTMENT_DIRECTOR">
        url='${basePath}dataAccount/checkDataAccountByDeanList.html';
        </sec:authorize>

        <%--最高角色是教研室主任--%>
        <sec:authorize ifAllGranted="ROLE_DEPARTMENT_DIRECTOR" ifNotGranted="ROLE_SCHOOL_ADMIN">
        url='${basePath}dataAccount/checkDataAccountByDepartmentList.html';
        </sec:authorize>

        <%--同时拥有院级管理员和教研室主任两个角色--%>
        <sec:authorize ifAllGranted="ROLE_SCHOOL_ADMIN,ROLE_DEPARTMENT_DIRECTOR">
        url='${basePath}dataAccount/checkDataAccountByDeanList.html';
        </sec:authorize>
        $(function () {
            dataAccountData= $('#dataAccount').datagrid({
                width:'100%',
                //设置高度，防止分页被覆盖
                height:'95%',
                border:2,
                fitColumns:true,
                pagination: true,
                rownumbers:true,
                url:url,
                frozenColumns:[[
                    {title:'教研室',field:'department', width:'8%',
                        formatter: function (value, rec) {
                            return rec.department.description;}
                            }
                ]],
                columns:[[
                    {title:'任务书',colspan:3,width:'15%'},
                    {title:'开题报告',colspan:3,width:'15%'},
                    {title:'工作进程表',colspan:3,width:'15%'},
                    {title:'指导老师进程表',colspan:3,width:'15%'},
                    {title:'评阅人评审表',colspan:3,width:'15%'},
                    {title:'答辩小组评审表',colspan:3,width:'15%'}
                ],[
                    //任务书
                    {
                        field: 'alreadyCompleteTaskDocData',
                        formatter: function (value, rec) {
                            return rec.taskDocData.alreadyCompleteCount;
                        }, title: '已完成', width: '5%', align: 'center',rowspan:1
                    },
                    {
                        field: 'shouldCompleteTaskDocData',
                        formatter: function (value, rec) {
                            return rec.taskDocData.shouldCompleteCount;
                        }, title: '应完成', width: '5%', align: 'center',rowspan:1
                    },
                    {
                        field: 'titleTaskDocData',
                        formatter: function (value, rec) {
                            var str = '';
                            str += $.formatString('<a href="javascript:void(0)" class="taskDocDataDetailBtn" data-options="iconCls:\'icon-more\'" onclick="showTaskDocDetail(\'{0}\')">'+rec.taskDocData.completionRate+'</a>', rec.department.id);
                            return str;
                        }, title: '完成比例', width: '5%', align: 'center',rowspan:1
                    },

                    //开题报告
                    {
                        field: 'alreadyComplete0penningReportData',
                        formatter: function (value, rec) {
                            return rec.openningReportData.alreadyCompleteCount;
                        }, title: '已完成', width: '5%', align: 'center'
                    },
                    {field:'shouldCompleteCount0penningReportData',title:'应完成',
                        formatter: function (value, rec) {
                            return rec.openningReportData.shouldCompleteCount;
                        },
                        rowspan:1,width:'5%'
                    },
                    {field:'completionRate0penningReportData',title:'完成比例',
                        formatter: function (value, rec) {
                            var str = '';
                            str += $.formatString('<a href="javascript:void(0)" class="openningReportDataDetailBtn" data-options="iconCls:\'icon-more\'" onclick="showOpenningReportDetail(\'{0}\')">'+rec.openningReportData.completionRate+'</a>', rec.department.id);
                            return str;
                        },rowspan:1,width:'5%',align: 'center',
                    },
                    //工作进程表
                    {
                        field: 'alreadyCompleteSchudelData',
                        formatter: function (value, rec) {
                            return rec.schudelData.alreadyCompleteCount;
                        }, title: '已完成', width: '5%', align: 'center',rowspan:1
                    },
                    {
                        field: 'shouldCompleteSchudelData',
                        formatter: function (value, rec) {
                            return rec.schudelData.shouldCompleteCount;
                        }, title: '应完成', width: '5%', align: 'center',rowspan:1
                    },
                    {
                        field: 'titleSchudelData',
                        formatter: function (value, rec) {
                            var str = '';
                            str += $.formatString('<a href="javascript:void(0)" class="schudelDataDetailBtn" data-options="iconCls:\'icon-more\'" onclick="showScheduleDetail(\'{0}\')">'+rec.schudelData.completionRate+'</a>', rec.department.id);
                            return str;
                        }, title: '完成比例', width: '5%', align: 'center',rowspan:1
                    },

                    //指导老师进程表
                    {
                        field: 'alreadyCompleteTutorEvaluate',
                        formatter: function (value, rec) {
                            return rec.tutorEvaluate.alreadyCompleteCount;
                        }, title: '已完成', width: '5%', align: 'center',rowspan:1
                    },
                    {
                        field: 'shouldCompleteTutorEvaluate',
                        formatter: function (value, rec) {
                            return rec.tutorEvaluate.shouldCompleteCount;
                        }, title: '应完成', width: '5%', align: 'center',rowspan:1
                    },
                    {
                        field: 'titleTutorEvaluate',
                        formatter: function (value, rec) {
                            var str = ''
                            str += $.formatString('<a href="javascript:void(0)" class="tutorEvaluateDetailBtn" data-options="iconCls:\'icon-more\'" onclick="showTutorEvaluateDetail(\'{0}\')">'+rec.tutorEvaluate.completionRate+'</a>', rec.department.id);
                            return str;
                        }, title: '完成比例', width: '5%', align: 'center',rowspan:1
                    },

                    //评阅人评审表
                    {
                        field: 'alreadyCompleteReviewerEvaluateData',
                        formatter: function (value, rec) {
                            return rec.reviewerEvaluateData.alreadyCompleteCount;
                        }, title: '已完成', width: '5%', align: 'center',rowspan:1
                    },
                    {
                        field: 'shouldCompleteReviewerEvaluateData',
                        formatter: function (value, rec) {
                            return rec.reviewerEvaluateData.shouldCompleteCount;
                        }, title: '应完成', width: '5%', align: 'center',rowspan:1
                    },
                    {
                        field: 'titleReviewerEvaluateData',
                        formatter: function (value, rec) {
                            var str = '';
                            str += $.formatString('<a href="javascript:void(0)" class="reviewerEvaluateDataDetailBtn" data-options="iconCls:\'icon-more\'" onclick="showReviewerEvaluateDetail(\'{0}\')">'+rec.reviewerEvaluateData.completionRate+'</a>', rec.department.id);
                            return str;
                        }, title: '完成比例', width: '5%', align: 'center',rowspan:1
                    },

                    //答辩小组评审表
                    {
                        field: 'alreadyCompleteReplyGroupEvaluateData',
                        formatter: function (value, rec) {
                            return rec.replyGroupEvaluateData.alreadyCompleteCount;
                        }, title: '已完成', width: '5%', align: 'center',rowspan:1
                    },
                    {
                        field: 'shouldCompleteReplyGroupEvaluateData',
                        formatter: function (value, rec) {
                            return rec.replyGroupEvaluateData.shouldCompleteCount;
                        }, title: '应完成', width: '5%', align: 'center',rowspan:1
                    },
                    {
                        field: 'titleReplyGroupEvaluateData',
                        formatter: function (value, rec) {
                            var str = '';
                            str += $.formatString('<a href="javascript:void(0)" class="replyGroupEvaluateDataDetailBtn" data-options="iconCls:\'icon-more\'" onclick="showGroupEvaluateDetail(\'{0}\')">'+rec.replyGroupEvaluateData.completionRate+'</a>', rec.department.id);
                            return str;
                        }, title: '完成比例', width: '5%', align: 'center',rowspan:1
                    }
                ]],
            })
        })

        //显示任务书详情
        function showTaskDocDetail(id) {
            var url = '${basePath}dataAccount/notCompletedTaskDoc.html?departmentId=' + id;
            graduateProjectDetail(url);
        }
        //显示开题报告详情
        function showOpenningReportDetail(id) {
            var url = '${basePath}dataAccount/notCompletedOpenningReport.html?departmentId=' + id;
            graduateProjectDetail(url);
        }
        //显示工作进程表详情
        function showScheduleDetail(id) {
            var url = '${basePath}dataAccount/notCompletedSchedule.html?departmentId=' + id;
            graduateProjectDetail(url);
        }
        //显示指导老师进程表详情
        function showTutorEvaluateDetail(id) {
            var url = '${basePath}dataAccount/notCompletedTutorEvaluate.html?departmentId=' + id;
            graduateProjectDetail(url);
        }
        //显示评阅人评审表详情
        function showReviewerEvaluateDetail(id) {
            var url = '${basePath}dataAccount/notCompletedReviewerEvaluate.html?departmentId=' + id;
            graduateProjectDetail(url);
        }
        //显示答辩小组评审表详情
        function showGroupEvaluateDetail(id) {
            var url = '${basePath}dataAccount/notCompletedGroupEvaluate.html?departmentId=' + id;
            graduateProjectDetail(url);
        }
        //详情界面
        function graduateProjectDetail(url) {
            parent.$.modalDialog({
                title:'详情',
                href:url,
                width:500,
                height:300,
                buttons:[{
                    text:'关闭',
                    iconCls:'icon-cancel',
                    handler:function () {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                }]
            })
        }
    </script>
</table>
</body>
</html>