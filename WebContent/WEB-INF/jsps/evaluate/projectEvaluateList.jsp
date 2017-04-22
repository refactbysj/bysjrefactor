<%--
  Created by IntelliJ IDEA.
  User: 张战
  Date: 2016/3/1
  Time: 14:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<html>
<head>
    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
    <script type="text/javascript">
        $("#viewEvaluate").on("hidden", function () {
            $(this).removeData("modal");
        });

        var evaluateGrid;

        $(function () {
            var url = '';
            <c:if test="${EVALUATE_DISP=='REPLY_ADMIN'}"></c:if>
            <c:if test="${EVALUATE_DISP=='REPLY_REVIEWER'}"></c:if>
            <c:if test="${EVALUATE_DISP=='REPLY_TUTOR'}">
            url = '${basePath}evaluate/chiefTutor/getTutorProjectsToEvaluateData.html';
            </c:if>
            evaluateGrid = $("#evaluateGrid").datagrid({
                url: url,
                fit: true,
                singleSelect: true,
                striped: true,
                pagination: true,
                idField: 'id',
                columns: [[{
                    title: '学号',
                    field: 'studentNo',
                    formatter: function (value, row) {
                        return row.student.no;
                    }
                }, {
                    title: '姓名',
                    field: 'studentName',
                    formatter: function (value, row) {
                        return row.student.name;
                    }
                }, {
                    title: '标题（副标题）',
                    width: '40%',
                    field: 'title',
                    formatter: function (value, row) {
                        if (row.subTitle != null && row.subTitle != '') {
                            return value + "——" + row.subTitle;
                        } else {
                            return value;
                        }
                    }
                }, {
                    title: '年份',
                    field: 'year'
                }, {
                    title: '类别',
                    field: 'category',
                    formatter: function (value, row) {
                        if (row.category == null) {
                            return '<span>未设置</span>';
                        } else {
                            return value;
                        }
                    }
                }, {
                    title: '论文终稿',
                    field: 'finalDraft',
                    formatter: function (value, row) {
                        var str = '';
                        if (row.finalDraft == null) {
                            str += '<span style="color: red;">未提交</span>';
                        } else {
                            str += $.formatString('<a href="javascript:void(0)" class="downBtn" onclick="downLoadFinal(\'{0}\')"></a>', row.id);
                        }
                        return str;
                    }
                },
                    //答辩组长角色
                    <c:if test="${EVALUATE_DISP=='REPLY_ADMIN'}">
                    {
                        title: '答辩小组评审',
                        field: 'replyAction',
                        formatter: function (value, row) {
                            var str = '';
                            //如果已经提交了终稿
                            if (row.finalDraft != null) {
                                //如果已经评审，则显示分数
                                if (row.commentByGroup != null && row.commentByGroup.submittedByGroup) {
                                    str += $.formatString('<a href="javascript:void(0)" class="editBtn" onclick="editFun(\'{0}\')"></a>', row.id);
                                    str += $.formatString('<a href="javascript:void(0)" class="printBtn" onclick="printFun(\'{0}\')"></a>', row.id);
                                    //获取评审总分
                                    var adminTotalScroe = row.commentByGroup.qualityScore +
                                        row.commentByGroup.completenessScore +
                                        row.commentByGroup.replyScore +
                                        row.commentByGroup.correctnessSocre;
                                    str += '<span class="label label-primary">总分：' + adminTotalScroe + '</span>';
                                    if (row.commentByGroup.qualifiedByGroup) {
                                        str += '<span class="label label-success">通过答辩</span>';
                                    } else {
                                        str += '<span class="label label-warning">未通过答辩</span>';
                                    }

                                } else {
                                    if (row.commentByTutor.qualifiedByTutor && row.commentByReviewer.qualifiedByReviewer) {
                                        str += $.formatString('<a href="javascript:void(0)" class="evaluateBtn" onclick="evalute(\'{0}\')"></a>', row.id);
                                    }
                                }
                            } else {
                                str += '<span class="label label-warning">未提交终稿</span>';
                            }
                            return str;
                        }
                    }, {
                        title: '指导教师评审表',
                        field: 'viewTutorEvalute',
                        formatter: function (value, row) {
                            var str = '';
                            //如果已经评审
                            if (row.commentByTutor != null) {
                                str += $.formatString('<a href="javascript:void(0)" class="viewBtn" onclick="viewEvaluate(\'{0}\')"></a>', row.id);
                            } else {
                                str += '<span class="label label-warning"> 暂无评审</span>';
                            }
                            return str;
                        }
                    }, {
                        title: '评阅人评审表',
                        field: 'reviewerEvalutate',
                        formatter: function (value, row) {
                            var str = '';
                            if (row.commentByReviewer != null) {
                                str += $.formatString('<a href="javascript:void(0)" class="viewBtn" onclick="viewEvaluate(\'{0}\')"></a>', row.id);
                            } else {
                                str += '<span class="label label-warning">暂无评审</span>';
                            }
                            return str;
                        }
                    }, {
                        title: '小组答辩老师评审表',
                        field: 'groupTutorEvaluate',
                        formatter: function (value, row) {
                            return $.formatString('<a href="javascript:void(0)" class="viewBtn" onclick="viewEvaluate(\'{0}\')"></a>', row.id);
                        }
                    }
                    </c:if>
                    //评阅人角色
                    <c:if test="${EVALUATE_DISP=='REPLY_REVIEWER'}">
                    {
                        title: '评阅人评审',
                        field: 'tutorEvaluate',
                        formatter: function (value, row) {
                            var str = '';
                            //如果已经提交了终稿
                            if (row.finalDraftAvailable != null) {
                                //如果已经进行了评审，则显示成绩
                                if (row.commentByReviewer != null && row.commentByReviewer.submittedByReviewer) {
                                    str += $.formatString('<a href="javascript:void(0)" class="editBtn" onclick="editFun(\'{0}\')"></a>', row.id);
                                    str += $.formatString('<a href="javascript:void(0)" class="printBtn" onclick="printFun(\'{0}\')"></a>', row.id);
                                    var totalScore = row.commentByReviewer.achievementScore + row.commentByReviewer.qualityScore;
                                    str += '<span class="label label-info">总分：' + totalScore + '</span>';
                                    if (row.commentByReviewer.qualifiedByReviewer) {
                                        str += '<span class="label label-success">允许答辩</span>';
                                    } else {
                                        str += '<span class="label label-warning">不允许答辩</span>';
                                    }
                                } else {
                                    //指导老师评审通过
                                    if (row.commentByTutor.qualifiedByTutor) {
                                        str += $.formatString('<a href="javascript:void(0)" class="evaluateBtn" onclick="evalute(\'{0}\')"></a>', row.id);
                                    }
                                }
                            } else {
                                str += '<span class="label label-warning">未提交终稿</span>';
                            }
                            return str;
                        }
                    }, {
                        title: '指导教师评审表',
                        field: 'tutorEvalutae',
                        formatter: function (value, row) {
                            var str = '';
                            //如果指导老师已经评审
                            if (row.commentByTutor != null) {
                                str += $.formatString('<a href="javascript:void(0)" class="viewBtn" onclick="viewEvaluate(\'{0}\')"></a>', row.id);
                            } else {
                                str += '<span class="label label-warning">暂无评审</span>';
                            }
                            return str;
                        }
                    }
                    </c:if>
                    //指导老师角色
                    <c:if test="${EVALUATE_DISP=='REPLY_TUTOR'}">
                    {
                        title: '指导教师评审',
                        field: 'tutorEvaluate',
                        width: '19%',
                        formatter: function (value, row) {
                            var str = '';
                            //如果已经提交了终稿
                            if (row.finalDraft != null) {
                                //是否已经进行了评审
                                if (row.commentByTutor != null && row.commentByTutor.qualifiedByTutor != null) {
                                    str += $.formatString('<a href="javascript:void(0)" class="editBtn" onclick="evalute(\'{0}\')"></a>', row.id);
                                    str += $.formatString('<a href="javascript:void(0)" class="printBtn" onclick="printFun(\'{0}\')"></a>', row.id);
                                    var tutorTotalScore = row.commentByTutor.basicAblityScore +
                                        row.commentByTutor.achievementLevelScore +
                                        row.commentByTutor.workLoadScore +
                                        row.commentByTutor.workAblityScore;
                                    str += '<span">总分:' + tutorTotalScore + ' </span>';
                                    //是否同意答辩
                                    if (row.commentByTutor.qualifiedByTutor) {
                                        str += '<span style="color: green;">同意答辩</span>';
                                    } else {
                                        str += '<span style="color: red;">不同意答辩</span>';
                                    }
                                } else {
                                    str += $.formatString('<a href="javascript:void(0)" class="evaluateBtn" onclick="evalute(\'{0}\')"></a>', row.id);
                                }
                            } else {
                                str += '<span class="label label-warning">未提交终稿</span>';
                            }
                            return str;
                        }
                    }
                    </c:if>
                ]],
                onLoadSuccess: function () {
                    $(".editBtn").linkbutton({text: '修改', iconCls: 'icon-edit', plain: true});
                    $(".printBtn").linkbutton({text: '打印', iconCls: 'icon-print', plain: true});
                    $(".evaluateBtn").linkbutton({text: '评审', iconCls: 'icon-pencil', plain: true});
                    $(".viewBtn").linkbutton({text: '查看', iconCls: 'icon-more', plain: true});
                    $(".downBtn").linkbutton({text: '下载', plain: true});
                }
            })
        });

        function downLoadFinal(id) {
            window.location.href = '${basePath}student/download/finalDraft.html?graduateProjectId=' + id;
        }

        function editFun(id) {

        }

        function printFun(id) {
            window.open('${basePath}evaluate/chiefTutor/printReport.html?reportId=' + id, '_blank');
        }

        function evalute(id) {
            var url = '';
            <c:if test="${EVALUATE_DISP=='REPLY_ADMIN'}">
            url = '${basePath}evaluate/replyGroup/evaluateProject.html?evaluateProjectId=' + id;
            </c:if>
            <c:if test="${EVALUATE_DISP=='REPLY_REVIEWER'}">
            url = '${basePath}evaluate/reviewer/evaluateProject.html?graduateProjectId=' + id;
            </c:if>
            <c:if test="${EVALUATE_DISP=='REPLY_TUTOR'}">
            url = '${basePath}evaluate/chiefTutor/evaluateProject.html?projectIdToEvaluate=' + id;
            </c:if>
            parent.$.modalDialog({
                href: url,
                modal: true,
                title: '评审',
                width: '60%',
                height: '90%',
                buttons: [{
                    text: '取消',
                    iconCls: 'icon-cancel',
                    handler: function () {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                }, {
                    text: '提交',
                    iconCls: 'icon-add',
                    handler: function () {
                        parent.$.modalDialog.evaluateGrid = evaluateGrid;
                        var f = parent.$.modalDialog.handler.find("#editEvaluate");
                        f.submit();
                    }
                }]
            })
        }

        function viewEvaluate(id) {

        }
    </script>

</head>
<body>
<div style="position: absolute;top:10px;right:5% ;">
    <c:if test="${EVALUATE_DISP=='REPLY_ADMIN'}">
        <form role="form" action="<%=basePath%>evaluate/replyGroup/projectsToEvaluate.html">
            <div class="form-group ">
                <label for="name">题目名称：</label> <input type="text" value="${title}" name="title" required
                                                       class="easyui-textbox " placeholder="请输入题目名称">
                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'">搜索</a>
                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-clear'">清空</a>
            </div>
        </form>
    </c:if>
    <c:if test="${EVALUATE_DISP=='REPLY_REVIEWER'}">
        <form class="form-inline" role="form" action="<%=basePath%>evaluate/reviewer/projectsToEvaluate.html">
            <div class="form-group ">
                <label for="name">题目名称：</label> <input type="text" value="${title}" name="title" required
                                                       class="easyui-textbox " placeholder="请输入题目名称">
                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'">搜索</a>
                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-clear'">清空</a>
            </div>
        </form>
    </c:if>
    <c:if test="${EVALUATE_DISP=='REPLY_TUTOR'}">
        <form class="form-inline" role="form" action="<%=basePath%>evaluate/chiefTutor/projectsToEvaluate.html">
            <div class="form-group ">
                <label for="name">题目名称：</label> <input type="text" value="${title}" name="title" required
                                                       class="easyui-textbox " id="name" placeholder="请输入题目名称">
                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'">搜索</a>
                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-clear'">清空</a>
            </div>
        </form>
    </c:if>
</div>
<div style="width: 100%;height: 100%;">
    <table id="evaluateGrid"></table>

</div>

<%-- <table
         class="table table-striped table-bordered table-hover datatable">
     <thead>
     <tr>
         <th>学号</th>
         <th>姓名</th>
         <th>题目名称</th>
         <th>年份</th>
         <th>类别</th>
         <th>论文终稿</th>
         <c:if test="${EVALUATE_DISP=='REPLY_ADMIN'}">
             <th>答辩小组评审</th>
             <th>指导教师评审表</th>
             <th>评阅人评审表</th>
             <th>小组答辩老师评审表</th>
         </c:if>
         <c:if test="${EVALUATE_DISP=='REPLY_REVIEWER'}">
             <th>评阅人评审</th>
             <th>指导教师评审表</th>
         </c:if>
         <c:if test="${EVALUATE_DISP=='REPLY_TUTOR'}">
             <th>指导教师评审</th>
         </c:if>
     </tr>
     </thead>
     <tbody>
     <c:choose>
         <c:when test="${empty graduateProjectEvaluate}">

         </c:when>
         <c:otherwise>
             <c:forEach items="${graduateProjectEvaluate}" var="graduateProjectEvaluate">
                 <tr>
                     <td>${graduateProjectEvaluate.student.no}</td>
                     <td>${graduateProjectEvaluate.student.name}</td>
                     <td>${graduateProjectEvaluate.title}</td>
                     <td>${graduateProjectEvaluate.year}</td>
                     <td>
                         <c:choose>
                             <c:when test="${graduateProjectEvaluate.category==null}">
                                 <span class="label label-default">未设置</span>
                             </c:when>
                             <c:otherwise>
                                 ${graduateProjectEvaluate.category}
                             </c:otherwise>
                         </c:choose>
                     </td>
                     <c:set var="finalDraftAvailable" value="${graduateProjectEvaluate.finalDraft}"/>
                     <td>
                         <c:choose>
                             <c:when test="${empty finalDraftAvailable}">
                                 <span class="label label-warning">未提交</span>
                             </c:when>
                             <c:otherwise>
                                 <a class="btn btn-default btn-xs"
                                    href="<%=basePath%>student/download/finalDraft.html?graduateProjectId=${graduateProjectEvaluate.id}"><i
                                         class="icon-download"></i>下载</a>
                             </c:otherwise>
                         </c:choose>
                     </td>
                         &lt;%&ndash;答辩组长的评审&ndash;%&gt;
                     <c:if test="${EVALUATE_DISP=='REPLY_ADMIN'}">
                         <td>
                             <c:choose>
                                 &lt;%&ndash;已经提交了终稿&ndash;%&gt;
                                 <c:when test="${not empty finalDraftAvailable}">
                                     <c:choose>
                                         &lt;%&ndash;如果已经提交，则显示总分数&ndash;%&gt;
                                         <c:when test="${graduateProjectEvaluate.commentByGroup.submittedByGroup}">
                                             <a class="btn btn-default btn-xs" data-toggle="modal"
                                                data-target="#addOrEditEvaluate"
                                                href="<%=basePath%>evaluate/replyGroup/evaluateProject.html?evaluateProjectId=${graduateProjectEvaluate.id}"><i
                                                     class="icon-edit"></i>修改</a>
                                             <a class="btn btn-default btn-xs" target="_blank"
                                                href="<%=basePath%>evaluate/replyGroup/getReport.html?projectId=${graduateProjectEvaluate.id}"><i
                                                     class="icon-print"></i>打印</a>
                                             <c:set var="adminTotleScore"
                                                    value="${graduateProjectEvaluate.commentByGroup.qualityScore+graduateProjectEvaluate.commentByGroup.completenessScore+graduateProjectEvaluate.commentByGroup.replyScore+graduateProjectEvaluate.commentByGroup.correctnessSocre}"/>
                                             <span class="label label-primary">总分：${adminTotleScore}</span>
                                             <c:choose>
                                                 <c:when test="${graduateProjectEvaluate.commentByGroup.qualifiedByGroup}">
                                                     <span class="label label-success">通过答辩</span>
                                                 </c:when>
                                                 <c:otherwise>
                                                     <span class="label label-warning">未通过答辩</span>
                                                 </c:otherwise>
                                             </c:choose>
                                         </c:when>
                                         <c:otherwise>
                                             &lt;%&ndash;指导老师和评阅人评审通过答辩组长才可进行评审&ndash;%&gt;
                                             <c:if test="${graduateProjectEvaluate.commentByTutor.qualifiedByTutor&&graduateProjectEvaluate.commentByReviewer.qualifiedByReviewer}">
                                                 <a class="btn btn-default btn-xs" data-toggle="modal"
                                                    data-target="#addOrEditEvaluate"
                                                    href="<%=basePath%>evaluate/replyGroup/evaluateProject.html?evaluateProjectId=${graduateProjectEvaluate.id}"><i
                                                         class="icon-edit"></i>评审</a>
                                             </c:if>

                                         </c:otherwise>
                                     </c:choose>
                                 </c:when>
                                 <c:otherwise>
                                     <span class="label label-warning">未提交终稿，不能执行评审操作</span>
                                 </c:otherwise>
                             </c:choose>
                         </td>
                         &lt;%&ndash;查看指导老师评审表&ndash;%&gt;
                         <td>
                             <c:choose>
                                 <c:when test="${graduateProjectEvaluate.commentByTutor!=null}">
                                     <a class="btn btn-default btn-xs" data-toggle="modal"
                                        href="<%=basePath%>replyGroupViewTutorEvaluate.html?projectId=${graduateProjectEvaluate.id}"
                                        data-target="#viewEvaluate"><i class="icon-coffee"></i>查看</a>
                                 </c:when>
                                 <c:otherwise>
                                     <span class="label label-warning"><i
                                             class="icon-check-empty"></i>暂无评审</span>
                                 </c:otherwise>
                             </c:choose>
                         </td>
                         &lt;%&ndash;查看评阅人评审表&ndash;%&gt;
                         <td>
                             <c:choose>
                                 <c:when test="${graduateProjectEvaluate.commentByReviewer!=null}">
                                     <a class="btn btn-default btn-xs"
                                        href="<%=basePath%>replyGroupViewReviewerEvaluate.html?projectId=${graduateProjectEvaluate.id}"
                                        data-toggle="modal" data-target="#viewEvaluate"><i
                                             class="icon-coffee"></i>查看</a>
                                 </c:when>
                                 <c:otherwise>
                                     <span class="label label-warning"><i
                                             class="icon-check-empty"></i>暂无评审 </span>
                                 </c:otherwise>
                             </c:choose>
                         </td>
                         &lt;%&ndash;各答辩老师评审表&ndash;%&gt;
                         <td>
                             <a class="btn btn-default btn-xs"
                                href="<%=basePath%>evaluate/replyGroupTutor/viewReplyGroupTutorEvaluate.html?projectId=${graduateProjectEvaluate.id}"><i
                                     class="icon icon-folder-open"></i> 查看</a>
                         </td>
                     </c:if>
                         &lt;%&ndash;最高角色是评阅人，不是答辩组长&ndash;%&gt;
                     <c:if test="${EVALUATE_DISP=='REPLY_REVIEWER'}">
                         <td>
                             <c:choose>
                                 &lt;%&ndash;如果已经提交了终稿&ndash;%&gt;
                                 <c:when test="${not empty finalDraftAvailable}">
                                     <c:choose>
                                         &lt;%&ndash;如果已经进行的评审，则显示成绩&ndash;%&gt;
                                         <c:when test="${graduateProjectEvaluate.commentByReviewer.submittedByReviewer}">
                                             <a class="btn btn-default btn-xs"
                                                href="<%=basePath%>evaluate/reviewer/evaluateProject.html?graduateProjectId=${graduateProjectEvaluate.id}"
                                                data-toggle="modal"
                                                data-target="#addOrEditEvaluate"><i class="icon-edit"></i>修改</a>
                                             <a class="btn btn-default btn-xs"
                                                href="<%=basePath%>evaluate/reviewer/getReport.html?projectId=${graduateProjectEvaluate.id}"
                                                target="_blank"><i
                                                     class="icon-print"></i>打印</a>
                                             <c:set var="totalScore"
                                                    value="${graduateProjectEvaluate.commentByReviewer.achievementScore+graduateProjectEvaluate.commentByReviewer.qualityScore}"/>
                                             <span class="label label-info">总分：${totalScore}</span>
                                             <c:choose>
                                                 <c:when test="${graduateProjectEvaluate.commentByReviewer.qualifiedByReviewer}">
                                                     <span class="label label-success">允许答辩</span>
                                                 </c:when>
                                                 <c:otherwise>
                                                     <span class="label label-warning">不允许答辩</span>
                                                 </c:otherwise>
                                             </c:choose>
                                         </c:when>
                                         <c:otherwise>
                                             &lt;%&ndash;指导老师评审通过评阅人才可评审&ndash;%&gt;
                                             <c:if test="${graduateProjectEvaluate.commentByTutor.qualifiedByTutor}">
                                                 <a class="btn btn-primary btn-xs"
                                                    href="<%=basePath%>evaluate/reviewer/evaluateProject.html?graduateProjectId=${graduateProjectEvaluate.id}"
                                                    data-toggle="modal" data-target="#addOrEditEvaluate"><i
                                                         class="icon-coffee"></i> 评审</a>
                                             </c:if>
                                             <c:if test="${!graduateProjectEvaluate.commentByTutor.qualifiedByTutor}">
                                                 <p style="color:red;"></p>
                                             </c:if>
                                         </c:otherwise>
                                     </c:choose>
                                 </c:when>
                                 <c:otherwise>
                                     <span class="label label-warning">未提交终稿，不能进行评审操作</span>
                                 </c:otherwise>
                             </c:choose>
                         </td>
                         <td>
                             <c:choose>
                                 &lt;%&ndash;如果指导教师已经提交了评审表，则显示&ndash;%&gt;
                                 <c:when test="${graduateProjectEvaluate.commentByTutor!=null}">
                                     <a class="btn btn-default btn-xs" data-toggle="modal"
                                        data-target="#viewEvaluate"
                                        href="<%=basePath%>reviewerViewTutorEvaluate.html?projectId=${graduateProjectEvaluate.id}"><i
                                             class="icon-check"></i>查看</a>
                                 </c:when>
                                 <c:otherwise>
                                     <span class="label label-warning"><i
                                             class="icon-check-empty"></i> 暂无评审</span>
                                 </c:otherwise>
                             </c:choose>
                         </td>
                     </c:if>
                         &lt;%&ndash;最高角色是指导老师的评审&ndash;%&gt;
                     <c:if test="${EVALUATE_DISP=='REPLY_TUTOR'}">
                         <td>
                             <c:choose>
                                 &lt;%&ndash;是否已经提交了终稿&ndash;%&gt;
                                 <c:when test="${not empty finalDraftAvailable}">
                                     <c:choose>
                                         &lt;%&ndash;是否已经提交了评审，如果已经提交，则显示成绩等相关信息&ndash;%&gt;
                                         <c:when test="${not empty graduateProjectEvaluate.commentByTutor.qualifiedByTutor}">
                                             <a class="btn btn-default btn-xs"
                                                href="<%=basePath%>evaluate/chiefTutor/evaluateProject.html?projectIdToEvaluate=${graduateProjectEvaluate.id}"
                                                data-toggle="modal" data-target="#addOrEditEvaluate"><i
                                                     class="icon-edit"></i>修改</a>
                                             <a class="btn btn-default btn-xs" target="_blank"
                                                href="<%=basePath%>evaluate/chiefTutor/printReport.html?reportId=${graduateProjectEvaluate.id}"><i
                                                     class="icon-print"></i>打印</a>
                                             <span class="label label-info">
                                                 <c:set var="tutorTotalScore"
                                                        value="${graduateProjectEvaluate.commentByTutor.basicAblityScore+graduateProjectEvaluate.commentByTutor.achievementLevelScore+graduateProjectEvaluate.commentByTutor.workLoadScore+graduateProjectEvaluate.commentByTutor.workAblityScore}"/>
                                                 总分：${tutorTotalScore}
                                             </span>
                                             <c:choose>
                                                 &lt;%&ndash;是否允许答辩&ndash;%&gt;
                                                 <c:when test="${graduateProjectEvaluate.commentByTutor.qualifiedByTutor}">
                                                     <span class="label label-success">同意答辩</span>
                                                 </c:when>
                                                 <c:otherwise>
                                                     <span class="label label-warning">不同意答辩</span>
                                                 </c:otherwise>
                                             </c:choose>
                                         </c:when>
                                         <c:otherwise>
                                             <a class="btn btn-default btn-xs" data-toggle="modal"
                                                data-target="#addOrEditEvaluate"
                                                href="<%=basePath%>evaluate/chiefTutor/evaluateProject.html?projectIdToEvaluate=${graduateProjectEvaluate.id}"><i
                                                     class="icon-coffee"></i>评审</a>
                                         </c:otherwise>
                                     </c:choose>
                                 </c:when>
                                 <c:otherwise>
                                     <span class="label label-warning">未提交终稿，不能执行评审操作</span>
                                 </c:otherwise>
                             </c:choose>
                         </td>
                     </c:if>
                 </tr>
             </c:forEach>
         </c:otherwise>
     </c:choose>
     </tbody>
 </table>--%>


</body>
</html>



