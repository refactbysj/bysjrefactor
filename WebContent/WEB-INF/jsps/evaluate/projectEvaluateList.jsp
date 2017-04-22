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
                                    str += $.formatString('<a href="javascript:void(0)" class="editBtn" onclick="evalute(\'{0}\')"></a>', row.id);
                                    str += $.formatString('<a href="javascript:void(0)" class="printBtn" onclick="printFun(\'{0}\')"></a>', row.id);
                                    //获取评审总分
                                    var adminTotalScroe = row.commentByGroup.qualityScore +
                                        row.commentByGroup.completenessScore +
                                        row.commentByGroup.replyScore +
                                        row.commentByGroup.correctnessSocre;
                                    str += '<span class="label label-primary">总分：' + adminTotalScroe + '</span>';
                                    if (row.commentByGroup.qualifiedByGroup) {
                                        str += '<span style="color: green;">通过答辩</span>';
                                    } else {
                                        str += '<span style="color: red">未通过答辩</span>';
                                    }

                                } else {
                                    if (row.commentByTutor.qualifiedByTutor && row.commentByReviewer.qualifiedByReviewer) {
                                        str += $.formatString('<a href="javascript:void(0)" class="evaluateBtn" onclick="evalute(\'{0}\')"></a>', row.id);
                                    }
                                }
                            } else {
                                str += '<span style="color: red;">未提交终稿</span>';
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
                                str += '<span> 暂无评审</span>';
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
                                str += '<span>暂无评审</span>';
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
                                    str += $.formatString('<a href="javascript:void(0)" class="editBtn" onclick="evalute(\'{0}\')"></a>', row.id);
                                    str += $.formatString('<a href="javascript:void(0)" class="printBtn" onclick="printFun(\'{0}\')"></a>', row.id);
                                    var totalScore = row.commentByReviewer.achievementScore + row.commentByReviewer.qualityScore;
                                    str += '<span class="label label-info">总分：' + totalScore + '</span>';
                                    if (row.commentByReviewer.qualifiedByReviewer) {
                                        str += '<span style="color: green">允许答辩</span>';
                                    } else {
                                        str += '<span style="color: red">不允许答辩</span>';
                                    }
                                } else {
                                    //指导老师评审通过
                                    if (row.commentByTutor.qualifiedByTutor) {
                                        str += $.formatString('<a href="javascript:void(0)" class="evaluateBtn" onclick="evalute(\'{0}\')"></a>', row.id);
                                    }
                                }
                            } else {
                                str += '<span style="color: red">未提交终稿</span>';
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
                                str += '<span>暂无评审</span>';
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
                                str += '<span style="color: red">未提交终稿</span>';
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

        //下载
        function downLoadFinal(id) {
            window.location.href = '${basePath}student/download/finalDraft.html?graduateProjectId=' + id;
        }


        //打印
        function printFun(id) {
            window.open('${basePath}evaluate/chiefTutor/printReport.html?reportId=' + id, '_blank');
        }

        //评审或修改
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

        //查看
        function viewEvaluate(id) {

        }

        //搜索
        function searchFun() {
            $("#evaluateGrid").datagrid('load', $.serializeObject($("#searchForm")));
        }

        //清空
        function clearFun() {
            $("#searchForm input").val('');
            $("#evaluateGrid").datagrid('load', {});
        }
    </script>

</head>
<body>
<div style="position: absolute;top:10px;right:5% ;">
    <c:if test="${EVALUATE_DISP=='REPLY_ADMIN'}">
        <form id="searchForm">
            <label for="name">题目名称：</label> <input type="text" value="${title}" name="title" required
                                                   class="easyui-textbox " placeholder="请输入题目名称">
            <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
               onclick="searchFun()">搜索</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-clear'"
               onclick="clearFun()">清空</a>
        </form>
    </c:if>
    <c:if test="${EVALUATE_DISP=='REPLY_REVIEWER'}">
        <form id="searchForm">
            <label for="name">题目名称：</label> <input type="text" value="${title}" name="title" required
                                                   class="easyui-textbox " placeholder="请输入题目名称">
            <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
               onclick="searchFun()">搜索</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-clear'"
               onclick="clearFun()">清空</a>
        </form>
    </c:if>
    <c:if test="${EVALUATE_DISP=='REPLY_TUTOR'}">
        <form id="searchForm">
            <label for="name" style="color: grey">题目名称：</label> <input type="text" value="${title}" name="title"
                                                                       class="easyui-textbox " id="name">
            <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
               onclick="searchFun()">搜索</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-clear'"
               onclick="clearFun()">清空</a>
        </form>
    </c:if>
</div>
<div style="width: 100%;height: 100%;">
    <table id="evaluateGrid"></table>

</div>


</body>
</html>



