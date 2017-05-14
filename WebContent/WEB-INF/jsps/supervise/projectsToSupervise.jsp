<%@ page import="com.newview.bysj.domain.PaperProject" %>
<%@ page import="java.awt.print.Paper" %>
<%--
  Created by IntelliJ IDEA.
  User: zhan
  Date: 2016/4/9
  Time: 16:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<head>
    <%@include file="/WEB-INF/jsps/includeURL.jsp"%>
    <style>
        .textbox{
            height:20px;
            margin:0;
            padding:0 2px;
            box-sizing:content-box;
        }
    </style>
    <script>

        $(function () {
            $("#projectToSupervise").datagrid({
                url:'${basePath}process/getProjectsData.html',
                singleSelect: true,
                toolbar:'#toolbar',
                pagination:true,
                pageSize: 10,
                pageList: [10, 15, 20, 25, 30, 40],
                columns:[[
                    {field:'id',hidden:true},
                    {title:'学号',field:'student_no',width:'15%',
                        formatter: function (value, rec) {
                            if(rec.student == null){
                                return '未分配学生';
                            }else {
                                return rec.student.no;
                            }
                        },
                    },
                    {title:'姓名',field:'student_name',width:'10%',
                        formatter: function (value, rec) {
                            if(rec.student==null){
                                return '未分配学生';
                            }
                            else if (rec.student.name == null) {
                                return '无';
                            }
                            else {
                                return rec.student.name;
                            }
                        }
                    },
                    {title:'课题',field:'title',width:'10%'},
                    {title:'类别',field:'category',width:'10%'},
                    {title:'任务书',field:'taskDoc',width:'10%',align:'center',
                        formatter: function (value, row) {
                            if (row.taskDoc == null){
                                return '无';
                            }else {
                                return  $.formatString('<a href="javascript:void(0)" class="downloadBtn" onclick="downLoadTaskDoc(\'{0}\')"></a>', row.id);
                            }
                        }
                    },

                    {title:'开题报告',	field:'action1',width:'10%',align:'center',
                        formatter:function (value, row) {
                            if(row.category=="设计题目"){
                                return '<p style="color:red;margin: auto">设计无开题报告</p>';
                            }else
                                return $.formatString('<a href="javascript:void(0)" class="downloadBtn" onclick="downLoadOpenningReport(\'{0}\')"></a>', row.id);
                        }
                    },
                    {title:'工作进程表',field:'action2',width:'10%',align:'center',
                        formatter:function (value,row) {
                            return $.formatString('<a href="javascript:void(0)" class="checkBtn" onclick="checkWorkSchedules(\'{0}\')"></a>', row.id);
                        }
                    },


                    {title:'指导老师评审表',field:'commentByTutor',width:'15%',align:'center',
                        formatter:function (value,row) {
                            if (row.commentByTutor == null){
                                return '无';
                            }else{
                                var str='';
                                str += $.formatString('<a href="javascript:void(0)" class="checkBtn" onclick="checkCommentByTutor(\'{0}\')"></a>', row.id);
                                str +=  $.formatString('<a href="javascript:void(0)" class="writeBtn" onclick="downLoadCommentByTutor(\'{0}\')"></a>', row.id);
                                return str;
                            }
                        }
                    },
                    {title: '评阅人评审表',field: 'commentByReviewer',width:'10%',align:'center',
                        formatter: function (value, row) {
                            if (row.commentByReviewer == null) {
                                return '无';
                            } else {
                                return $.formatString('<a href="javascript:void(0)" class="checkBtn" onclick="downLoadCommentByReviewer(\'{0}\')"></a>', row.id);
                            }
                        }
                    },
                    {title:'答辩小组意见',field:'action3',width:'10%',align:'center',
                        formatter:function (value,row) {
                            if (row.commentByGroup == null){
                                return '无';
                            }else{
                                return $.formatString('<a href="javascript:void(0)" class="checkBtn" onclick="checkCommentByGroup(\'{0}\')"></a>', row.id);
                            }
                        }
                    },
                    {title:'指导记录表',field:'action4',width:'10%',align:'center',
                        formatter:function (value,row) {
                            if (row.guideRecord == null){
                                return '无';
                            }else{
                                return $.formatString('<a href="javascript:void(0)" class="checkBtn" onclick="checkGuideRecord(\'{0}\')"></a>', row.id);
                            }
                        }
                    },
                    {title:'详情',field:'action5',width:'10%',align:'center',
                        formatter:function (value,row) {
                            return $.formatString('<a href="javascript:void(0)" class="showBtn" onclick="showMessages(\'{0}\')"></a>', row.id);
                        }
                    },
                    {title:'终稿',field:'action6',width:'10%',align:'center',
                        formatter:function (value,row) {
                            return $.formatString('<a href="javascript:void(0)" class="downloadBtn" onclick="downLoadFinalWork(\'{0}\')"></a>', row.id);
                        }
                    }
                ]],
                onLoadSuccess: function(){
                    $('.downloadBtn').linkbutton({plain:false, text:'下载',align:'center',width:40,height:20});
                    $('.checkBtn').linkbutton({plain:false,  text:'查看',align:'center',width:40,height:20});
                    $('.writeBtn').linkbutton({plain:false,  text:'打印',align:'center',width:40,height:20});
                    $('.showBtn').linkbutton({plain:false,  text:'显示细节',align:'center',width:60,height:20});
                },
            });
            //工作进程表
            $("#viewStudentSchedule").datagrid({
                singleSelect: true,
                model:true,
                fit:true,
                columns: [[
                    {field:'id',title:'id',hidden:true},
                    {field:'beginTime',width:'25%',title:'开始时间',hidden:false,align:'center',width:'20%',
                        formatter:function (value) {
                            return formatString(value);
                        }

                    },
                    {field:'endTime',width:'25%',title:'结束时间',hidden:false,align:'center',width:'20%',
                        formatter:function (value) {
                            return formatString(value);
                        }
                    },
                    {field:'content',width:'25%',title:'应完成的工作内容',hidden:false,align:'center',width:'30%',

                    },
                    {field:'audit',width:'25%',title:'检查情况',hidden:false,align:'center',width:'10%',
                        formatter: function (value, rec) {
                            if(rec.audit== null){
                                return '无';
                            }
                            else {
                                return rec.audit.auditor.name;
                            }
                        }

                    }
                ]],
        });
        });


        //下载任务书
        function downLoadTaskDoc(id) {
            window.location.href = '${basePath}tutor/downLoadTaskDoc.html?projectId=' + id;
        }
        //下载开题报告
        function downLoadOpenningReport(id){
            window.location.href = '${basePath}student/openningReport/downloadOpenningReport.html?paperProjectId=' + id;
        }
        //查看工作进程表
        function checkWorkSchedules(id) {
            $('#viewStudentSchedule_dialog').dialog({
                title:"查看工作进程表",
                width:'70%',
                height:'60%',
                modal:true,
                buttons: [{
                    text: '关闭',
                    iconCls: 'icon-cancel',
                    handler: function () {
                        $('#viewStudentSchedule_dialog').dialog('close');
                    }
                }]
            });
            $('#viewStudentSchedule').datagrid('load','${basePath}supervisor/school/viewStudentSchedule.html?projectId='+ id);
        }
        //查看指导老师评审表
        function checkCommentByTutor(id) {
            var url = '${basePath}evaluate/chiefTutor/viewTutorEvaluate.html?projectId=' + id;
            viewEvaluate(url, '查看指导老师评审表');

        }
        //打印指导老师评审表
        function downLoadCommentByTutor(id) {
            <c:if test="${EVALUATE_DISP=='REPLY_ADMIN'}">
                window.open('${basePath}evaluate/replyGroup/printReport.html?reportId=' + id, '_blank');
            </c:if>
            <c:if test="${EVALUATE_DISP=='REPLY_REVIEWER'}">
            window.open('${basePath}evaluate/reviewer/printReport.html?reportId=' + id, '_blank');
            </c:if>
            <c:if test="${EVALUATE_DISP=='REPLY_TUTOR'}">
            window.open('${basePath}evaluate/chiefTutor/printReport.html?reportId=' + id, '_blank');
            </c:if>
        }
        //查看评阅人评审表
        function downLoadCommentByReviewer(id) {
            var url = '${basePath}evaluate/reviewer/reviewerViewTutorEvaluate.html?projectId=' + id;
            viewEvaluate(url, '查看评阅评审表');

        }
        //查看答辩小组意见
        function checkCommentByGroup(id) {
            var url = '${basePath}evaluate/replyGroupTutor/viewReplyGroupTutorEvaluate.html?projectId=' + id;
            viewEvaluate(url, '查看答辩小组意见');
        }
        //查看指导记录表
        function checkGuideRecord(id) {
            window.location.href = ''
        }
        //查看详情
        function showMessages(id) {
            var url = '${basePath}process/showDetail.html?graduateProjectId=' + id;
            showProjectDetail(url);

        }
        //下载终稿
        function downLoadFinalWork(id){
            window.location.href = '${basePath}student/download/finalDraft.html?projectId='+id;
        }
        //查找题目
        function research() {
            $('#projectToSupervise').datagrid('load',{
                title: $.trim($('input[name="projectName"]').val())
            })
        }
        //查看所有题目
        function allProjects() {
            $('#projectToSupervise').datagrid('load',{});
        }
        //查看设计类题目
        function designProjects() {
            $('#projectToSupervise').datagrid('load',{
                category: "设计题目"
            })
        }
        //查看论文类题目
        function thesisProjects() {
            $('#projectToSupervise').datagrid('load',{
                category:"论文题目"
            })
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
        //时间的格式化控制
        function formatString(value) {
            if (value != null && value != '') {
                var beginDate = new Date(value);
                var year = beginDate.getFullYear() + '年';
                var month = beginDate.getMonth() + 1 + '月';
                var day = beginDate.getDate() + '日';
                return year + month + day;
            } else {
                return '';
            }

        }


    </script>
</head>
<body>
<c:choose>
    <c:when test="${empty graduateProjectList}">
        <div class="alert alert-warning alert-dismissable" role="alert">
            <button class="close" type="button" data-dismiss="alert">&times;</button>
            没有任何学生选择课题
        </div>
    </c:when>
    <c:otherwise>
        <div style="width:100%; height:100% ;">
            <table id="projectToSupervise" style="width: 100%;height:100%"></table>
        </div>
        <div id = 'toolbar' style="padding: 5px;">
            <div style="padding-bottom: 5px;">
                <a href="#" class="easyui-linkbutton" onclick="allProjects()">全部题目</a>
                <a href="#" class="easyui-linkbutton" onclick="designProjects()">设计题目</a>
                <a href="#" class="easyui-linkbutton" onclick="thesisProjects()">论文题目</a>
            </div>
            <div style="padding-left: 15%;color:#333" >
                课题名称：<input type="text" class="textbox" name="projectName" style="width: 110px;height: 24px"/>
                <a href="#" class="easyui-linkbutton" iconCls="icon-search" name="checkTitle" onclick="research()">查询</a>
            </div>
        </div>
    </c:otherwise>
</c:choose>
<%--工作进程表--%>
<div id="viewStudentSchedule_dialog">
    <table id="viewStudentSchedule" style="height: 100%;width: 100%"></table>
</div>
<%--答辩小组意见--%>
<div id="viewCommentByGroup_dialog">
    <table id="viewCommentByGroup" style="height: 100%;width: 100%"></table>
</div>
<%--指导老师评审表--%>
<div id="viewCommentByTutor_dialog">
    <table id="viewCommentByTutor" style="height: 100%;width: 100%"></table>
</div>
<%--评阅人评审表--%>
<div id="viewCommentByReviewer_dialog">
    <table id="viewCommentByReviewer" style="height: 100%;width: 100%"></table>
</div>
</body>

