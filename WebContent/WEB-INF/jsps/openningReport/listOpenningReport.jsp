<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<html>
<head>
    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
    <script type="text/javascript">
        /*//教研室主任和院长角色的确认对话框-通过功能
         function approveOpenningReportByDirectorAndDean(openningReportId) {
         //xcconfirm插件确认对话框
         window.wxc.xcConfirm("确认通过？", "confirm", {
         onOk: function () {
         $.ajax({
         url: 'approveOpenningReportByDirectorAndDean.html',
         type: 'GET',
         dateType: 'json',
         data: {"openningReportId": openningReportId},
         success: function (data) {
         $("#tutorOfTutorAndDirectior" + openningReportId).html("<p>通过</p>");
         $("#directorOfTutorAndDirector" + openningReportId).html("<p>通过</p>");
         $("#btn" + openningReportId).html("<a id='rejectOfTutorAndDirector${openningReport.id}' class='btn btn-danger btn-xs' onclick='rejectOpenningReportByDirectorAndDean(" + openningReportId + ")'>退回</a>");
         addDownload(openningReportId);
         myAlert("修改成功");
         return true;
         },
         error: function () {
         myAlert("修改失败，请稍后再试");
         return false;
         }
         });
         }
         });

         }

         //下载按钮取消显示
         function cancelDownload() {
         var load = $("#downloadReport");
         load.html("")
         }

         //显示下载按钮
         function addDownload(reportId) {
         var load = $("#downloadReport");
         load.html("<a id='downloadReport' href='downloadOpenningReport.html?openningReportId=" + reportId + "'class='btn btn-xs'><span><i class='icon icon-download'></i> 下载</span></a>");
         }

         //教研室主任和院长角色的确认对话框-退回功能
         function rejectOpenningReportByDirectorAndDean(openningReportId) {
         window.wxc.xcConfirm("确认退回？", "confirm", {
         onOk: function () {
         $.ajax({
         url: 'rejectOpenningReportByDirectorAndDean.html',
         type: 'GET',
         dateType: 'json',
         data: {"openningReportId": openningReportId},
         success: function (data) {
         $("#tutorOfTutorAndDirectior" + openningReportId).html("<p>退回</p>");
         $("#directorOfTutorAndDirector" + openningReportId).html("<p>退回</p>");
         $("#btn" + openningReportId).html("<a id='approveOfTutorAndDirector${openningReport.id}' class='btn btn-success btn-xs' onclick='approveOpenningReportByDirectorAndDean(" + openningReportId + ")'>通过</a>");
         cancelDownload();
         myAlert("修改成功");
         return true;
         },
         error: function () {
         myAlert("修改失败，请稍后再试");
         return false;
         }
         });
         }

         });

         }*/


        function approveOpennginReport(id) {

            var url = '';
            <!-- 拥有教师角色，但不拥有教研室主任角色 -->
            <sec:authorize ifAllGranted="ROLE_TUTOR" ifNotGranted="ROLE_DEPARTMENT_DIRECTOR">
            url = 'auditOpenningReportByTutor.html?approve=true';
            </sec:authorize>
            <!-- 拥有教研室主任角色，但不拥有教师角色 -->
            <sec:authorize ifAllGranted="ROLE_DEPARTMENT_DIRECTOR" ifNotGranted="ROLE_TUTOR">
            url = 'auditOpenningReportByDirector.html?approve=true';
            </sec:authorize>
            <!-- 同时拥有教师和教研室主任角色 -->
            <sec:authorize ifAllGranted="ROLE_TUTOR,ROLE_DEPARTMENT_DIRECTOR">
            url = 'auditOpenningReportByDirectorAndDean.html?approve=true';
            </sec:authorize>

            $.messager.confirm('询问', '确认通过？', function (t) {
                if (t) {
                    progressLoad();
                    $.ajax({
                        url: url,
                        type: 'GET',
                        dateType: 'json',
                        data: {"openningReportId": id},
                        success: function (result) {
                            progressClose();
                            result = $.parseJSON(result);
                            if (result.success) {
                                $.messager.alert('提示', result.msg, 'info');
                                $("#openningGrid").datagrid('reload');
                            } else {
                                $.messager.alert('警告', result.msg, 'warning');
                            }
                            return true;
                        },
                        error: function () {
                            progressClose();
                            $.messager.alert('错误', '网络错误，请联系管理员', 'error');
                            return false;
                        }
                    });
                }
            })
        }

        function rejectOpenningReport(id) {
            var url = '';
            <!-- 拥有教师角色，但不拥有教研室主任角色 -->
            <sec:authorize ifAllGranted="ROLE_TUTOR" ifNotGranted="ROLE_DEPARTMENT_DIRECTOR">
            url = 'auditOpenningReportByTutor.html?approve=false';
            </sec:authorize>
            <!-- 拥有教研室主任角色，但不拥有教师角色 -->
            <sec:authorize ifAllGranted="ROLE_DEPARTMENT_DIRECTOR" ifNotGranted="ROLE_TUTOR">
            url = 'auditOpenningReportByDirector.html?approve=false';
            </sec:authorize>
            <!-- 同时拥有教师和教研室主任角色 -->
            <sec:authorize ifAllGranted="ROLE_TUTOR,ROLE_DEPARTMENT_DIRECTOR">
            url = 'auditOpenningReportByDirectorAndDean.html?approve=false';
            </sec:authorize>

            $.messager.confirm('询问', '是否退回？', function (t) {
                if (t) {
                    $.ajax({
                        url: url,
                        type: 'GET',
                        dataType: 'json',
                        data: {'openningReportId': id},
                        success: function (result) {
                            if (result.success) {
                                $.messager.alert('提示', result.msg, 'info');
                                $("#openningGrid").datagrid('reload');
                            } else {
                                $.messager.alert('警告', result.msg, 'warning');
                            }
                            return true;
                        },
                        error: function () {
                            $.messager.alert('错误', '发生网络错误，请联系管理员', 'error');
                        }
                    });
                }
            })

        }


        /*//教研室主任唯一角色登录时的确认对话框-通过功能
         function approveOpenningReportByDirector(openningReportId) {
         window.wxc.xcConfirm("确认通过？", "confirm", {
         onOk: function () {
         $.ajax({
         url: 'approveOpenningReportByDirector.html',
         type: 'GET',
         dateType: 'json',
         data: {"openningReportId": openningReportId},
         success: function (data) {
         $("#statusOfDirector" + openningReportId).html("<p>通过</p>");
         $("#director" + openningReportId).html("<a id='rejectOfDirector${openningReport.id}' class='btn btn-danger btn-xs' onclick='rejectOpenningReportByDirector(" + openningReportId + ")'>退回</a>");
         addDownload(openningReportId);
         myAlert("修改成功");
         return true;
         },
         error: function () {
         myAlert("修改失败，请稍后再试");
         return false;
         }
         });
         }
         });
         }
         //教研室主任唯一角色登录时的确认对话框-退回功能
         function rejectOpenningReportByDirector(openningReportId) {
         window.wxc.xcConfirm("确认退回？", "confirm", {
         onOk: function () {
         $.ajax({
         url: 'rejectOpenningReportByDirector.html',
         type: 'GET',
         dateType: 'json',
         data: {"openningReportId": openningReportId},
         success: function (data) {
         $("#statusOfDirector" + openningReportId).html("<p>退回</p>");
         $("#director" + openningReportId).html("<a id='approveOfDirector${openningReport.id}' class='btn btn-success btn-xs' onclick='approveOpenningReportByDirector(" + openningReportId + ")'>通过</a>");
         cancelDownload();
         myAlert("修改成功");
         return true;
         },
         error: function () {
         myAlert("修改失败，请稍后再试");
         return false;
         }
         });
         }
         });

         }
         //教师角色登录时的确认对话框-通过功能
         function approveOpenningReportByTutor(openningReportId) {
         window.wxc.xcConfirm("确认通过？", "confirm", {
         onOk: function () {
         $.ajax({
         url: 'approveOpenningReportByTutor.html',
         type: 'GET',
         dateType: 'json',
         data: {"openningReportId": openningReportId},
         success: function (data) {
         $("#statusOfTutor" + openningReportId).html("<p>通过</p>");
         $("#tutor" + openningReportId).html("<a id='rejectOfTutor${openningReport.id}' class='btn btn-danger btn-xs' onclick='rejectOpenningReportByTutor(" + openningReportId + ")'>退回</a>");
         addDownload(openningReportId);
         myAlert("修改成功");
         return true;
         },
         error: function () {
         myAlert("修改失败，请稍后再试");
         return false;
         }
         });
         }
         });
         }
         //教师角色登录时的确认对话框-退回功能
         function rejectOpenningReportByTutor(openningReportId) {
         window.wxc.xcConfirm("确认退回？", "confirm", {
         onOk: function () {
         $.ajax({
         url: 'rejectOpenningReportByTutor.html',
         type: 'GET',
         dateType: 'json',
         data: {"openningReportId": openningReportId},
         success: function (data) {
         $("#statusOfTutor" + openningReportId).html("<p>退回</p>");
         //$("#tutor" + openningReportId).html("<a id='approveOfTutor${openningReport.id}' class='btn btn-success btn-xs' onclick='approveOpenningReportByTutor(" + openningReportId + ")'>通过</a>");
         $("#tutor" + openningReportId).html("");
         $("#download" + openningReportId).html("");
         //cancelDownload();
         myAlert("修改成功");
         return true;
         },
         error: function () {
         myAlert("修改失败，请稍后再试");
         return false;
         }
         });
         }
         });

         }
         */
        //显示详情
        function showDetail(id) {
            var url = '${basePath}process/showDetail.html?graduateProjectId=' + id;
            showProjectDetail(url);
        }

        $(function () {
            var url = '';
            <!-- 拥有教师角色，但不拥有教研室主任角色 -->
            <sec:authorize ifAllGranted="ROLE_TUTOR" ifNotGranted="ROLE_DEPARTMENT_DIRECTOR">
            url = 'getOpenningReportsByTutor.html';
            </sec:authorize>
            <!-- 拥有教研室主任角色，但不拥有教师角色 -->
            <sec:authorize ifAllGranted="ROLE_DEPARTMENT_DIRECTOR" ifNotGranted="ROLE_TUTOR">
            url = 'getOpenningReportsByDirector.html';
            </sec:authorize>
            <!-- 同时拥有教师和教研室主任角色 -->
            <sec:authorize ifAllGranted="ROLE_TUTOR,ROLE_DEPARTMENT_DIRECTOR">
            url = 'getOpenningReportsByTutorAndDirector.html';
            </sec:authorize>
            $("#openningGrid").datagrid({
                url: url,
                striped: true,
                pagination: true,
                singleSelect: true,
                fit: true,
                idField: 'id',
                columns: [[{
                    title: '标题(副标题)',
                    field: 'title',
                    width: '40%',
                    formatter: function (value, row) {
                        if (row.subTitle == null || row.subTitle == '') {
                            return value;
                        } else {
                            return value + "——" + row.subTitle;
                        }
                    }
                }, {
                    title: '主指导姓名',
                    field: 'tutorName',
                    formatter: function (value, row) {
                        return row.mainTutorage.tutor.name;
                    }
                }, {
                    title: '学生姓名',
                    field: 'studentName',
                    formatter: function (value, row) {
                        return row.student.name;
                    }
                }, {
                    title: '学生学号',
                    field: 'studentNo',
                    formatter: function (value, row) {
                        return row.student.no;
                    }
                },
                    <sec:authorize ifAnyGranted="ROLE_TUTOR">
                    {
                        title: '主指导审核状态',
                        field: 'tutorStatus',
                        formatter: function (value, row) {
                            if (row.openningReport == null) {
                                return '';
                            } else {
                                if (row.openningReport.auditByTutor.approve) {
                                    return '<span style="color: green">通过</span>';
                                } else {
                                    return '<span style="color: red">退回</span>';
                                }
                            }
                        }
                    },
                    </sec:authorize>
                    <sec:authorize ifAnyGranted="ROLE_DEPARTMENT_DIRECTOR">
                    {
                        title: '教研室主任审核状态',
                        field: 'departStatus',
                        formatter: function (value, row) {
                            if (row.openningReport == null) {
                                return '';
                            } else {
                                if (row.openningReport.auditByDepartmentDirector.approve) {
                                    return '<span style="color:green">通过</span>';
                                } else {
                                    return '<span style="color: red;">退回 </span>';
                                }
                            }
                        }
                    },
                    {
                        title: '查看开题报告',
                        field: 'view',
                        formatter: function (value, row) {
                            var str = '';
                            if (row.openningReport == null) {
                                str = '未提交';
                            } else {
                                //主指导角色
                                <sec:authorize ifAllGranted="ROLE_TUTOR" ifNotGranted="ROLE_DEPARTMENT_DIRECTOR">
                                if (row.openningReport.auditByTutor.approve) {
                                    str += $.formatString('<a href="javascript:void(0)" class="downBtn" onclick="downLoad(\'{0}\')"></a>', row.openningReport.id);
                                } else {
                                    str += $.formatString('<a href="javascript:void(0)" class="downBtn" data-options="disabled:true" onclick="downLoad(\'{0}\')"></a>', row.id);

                                }
                                </sec:authorize>
                                //拥有教研室角色，但不拥有主指导教师角色
                                <sec:authorize ifAllGranted="ROLE_DEPARTMENT_DIRECTOR" ifNotGranted="ROLE_TUTOR">
                                if (row.openningReport.auditByDepartmentDirector.approve) {
                                    str += $.formatString('<a href="javascript:void(0)" class="downBtn" onclick="downLoad(\'{0}\')"></a>', row.openningReport.id);
                                } else {
                                    str += $.formatString('<a href="javascript:void(0)" class="downBtn" data-options="disabled:true" onclick="downLoad(\'{0}\')"></a>', row.id);
                                }
                                </sec:authorize>
                                //同时拥有主指导教师和教研室主任角色
                                <sec:authorize ifAllGranted="ROLE_TUTOR,ROLE_DEPARTMENT_DIRECTOR">
                                if (row.openningReport.auditByTutor.approve && row.openningReport.auditByDepartmentDirector.approve) {
                                    str += $.formatString('<a href="javascript:void(0)" class="downBtn" onclick="downLoad(\'{0}\')"></a>', row.openningReport.id);
                                } else {
                                    str += $.formatString('<a href="javascript:void(0)" class="downBtn" data-options="disabled:true" onclick="downLoad(\'{0}\')"></a>', row.id);
                                }
                                </sec:authorize>
                            }

                            return str;
                        }
                    },
                    </sec:authorize>

                    {
                        title: '操作',
                        width: '20%',
                        field: 'action',
                        formatter: function (value, row) {
                            var str = '';
                            if (row.openningReport == null) {
                                str = '<span style="color: red;">未提交</span>';
                            } else {
                                //判断是否在审核时间内
                                if (${isAudit}) {
                                    <sec:authorize ifAllGranted="ROLE_TUTOR" ifNotGranted="ROLE_DEPARTMENT_DIRECTOR">
                                    if (row.openningReport.auditByTutor.approve) {
                                        str += $.formatString('<a href="javascript:void(0)" onclick="rejectOpenningReport(\'{0}\')" class="rejectBtn" data-options="iconCls:\'icon-back\'"></a>', row.openningReport.id);
                                    } else {
                                        str += $.formatString('<a href="javascript:void(0)" onclick="approveOpennginReport(\'{0}\')" class="approveBtn" data-options="iconCls:\'icon-ok\'"></a>', row.openningReport.id);
                                    }
                                    </sec:authorize>
                                    //只拥有教研室主任的角色的操作
                                    <sec:authorize ifAllGranted="ROLE_DEPARTMENT_DIRECTOR" ifNotGranted="ROLE_TUTOR">
                                    if (row.openningReport.auditByDepartmentDirector.approve) {
                                        str += $.formatString('<a href="javascript:void(0)" onclick="rejectOpenningReport(\'{0}\')" class="rejectBtn" data-options="iconCls:\'icon-back\'"></a>', row.openningReport.id);
                                    } else {
                                        str += $.formatString('<a href="javascript:void(0)" onclick="approveOpennginReport(\'{0}\')" class="approveBtn" data-options="iconCls:\'icon-ok\'"></a>', row.openningReport.id);
                                    }
                                    </sec:authorize>
                                    //同时拥有指导老师和教研室主任两个角色的操作
                                    <sec:authorize ifAllGranted="ROLE_TUTOR,ROLE_DEPARTMENT_DIRECTOR">
                                    if (row.openningReport.auditByDepartmentDirector.approve && row.openningReport.auditByTutor.approve) {
                                        str += $.formatString('<a href="javascript:void(0)" onclick="rejectOpenningReport(\'{0}\')" class="rejectBtn" data-options="iconCls:\'icon-back\'"></a>', row.openningReport.id);
                                    } else {
                                        str += $.formatString('<a href="javascript:void(0)" onclick="approveOpennginReport(\'{0}\')" class="approveBtn" data-options="iconCls:\'icon-ok\'"></a>', row.openningReport.id);
                                    }
                                    </sec:authorize>
                                } else {
                                    str += '<span style="color: red;">不在审核时间内</span>';
                                }

                                str += $.formatString('<a href="javascript:void(0)" class="detailBtn" data-options="iconCls:\'icon-more\'" onclick="showDetail(\'{0}\')"></a>', row.id);
                            }
                            return str;
                        }
                    }]],
                onLoadSuccess: function () {
                    $(".rejectBtn").linkbutton({text: '退回', iconCls: 'icon-back', plain: true});
                    $(".approveBtn").linkbutton({text: '通过', iconCls: 'icon-ok', plain: true});
                    $(".detailBtn").linkbutton({text: '显示细节', iconCls: 'icon-more', plain: true});
                    $(".downBtn").linkbutton({text: '下载', iconCls: 'icon-blank', plain: true});
                }
            })
        });

        //下载
        function downLoad(id) {
            window.location.href = '${basePath}downloadOpenningReport.html?openningReportId=' + id;
        }

        function searchFun() {
            $("#openningGrid").datagrid('load', $.serializeObject($("#searchForm")));
        }

        function clearFun() {
            $("input[name=title]").val('');
            $("input[name=approve]").attr('checked', false);
            $("#openningGrid").datagrid('load', {});
        }
    </script>

</head>
<body>
<div style="width: 100%;height: 100%">
    <div style="position: absolute;top: 10px;right:50px">
        <form id="searchForm">
            题目 <input type="text" class="easyui-textbox" name="title">
            <input type="radio" value="${true}" name="approve">通过
            <input type="radio" value="${false}" name="approve">未通过
            <input type="radio" value="${null}" name="approve">全部
            <a href="javascript:void(0)" onclick="searchFun()" class="easyui-linkbutton"
               data-options="iconCls:'icon-search'">查询</a>
            <a href="javascript:void(0)" onclick="clearFun()" class="easyui-linkbutton"
               data-options="iconCls:'icon-clear'">清空</a>
        </form>

    </div>

    <%-- <div>
         <a href="${actionUrl}" class="btn btn-primary" title="审核开题报告"><span>全部论文课题</span></a>
         <a href="${queryReport}?approve=true" class="btn btn-success"
            title="审核开题报告"><span>已通过</span></a> <a
             href="${queryReport}?approve=false" class="btn btn-warning"
             title="审核开题报告"><span>未通过</span></a>
     </div>--%>


    <table id="openningGrid"></table>

    <%-- <table
             class="table table-striped table-bordered table-hover datatable">
         <thead>
         <tr>
             <th>操作</th>
             <!-- 拥有主指导教师角色，但不拥有教研室主任角色 -->
             <sec:authorize ifAllGranted="ROLE_TUTOR"
                            ifNotGranted="ROLE_DEPARTMENT_DIRECTOR">
                 <th>主指导审核状态</th>
             </sec:authorize>
             <!-- 拥有教研室角色，但不拥有主指导教师角色 -->
             <sec:authorize ifAllGranted="ROLE_DEPARTMENT_DIRECTOR"
                            ifNotGranted="ROLE_TUTOR">
                 <th>教研室主任审核状态</th>
             </sec:authorize>
             <!-- 同时拥有主指导教师和教研室主任角色 -->
             <sec:authorize ifAllGranted="ROLE_TUTOR,ROLE_DEPARTMENT_DIRECTOR">
                 <th>主指导审核状态</th>
                 <th>教研室主任审核状态</th>
             </sec:authorize>

             <th>主指导姓名</th>
             <th>题目名称</th>
             <th>副标题</th>
             <th>学生姓名</th>
             <th>学生学号</th>
             <th>查看开题报告</th>
             <th>详情</th>
         </tr>
         </thead>
         <tbody>
         <c:choose>
             <c:when test="${empty openningReports}">
                 <c:choose>
                     <c:when test="${empty paperProjects}">
                         <div class="alert alert-warning alert-dismissable" role="alert">
                             <button class="close" type="button" data-dismiss="alert">&times;</button>
                             没有可以显示的数据
                         </div>
                     </c:when>
                     <c:otherwise>
                         &lt;%&ndash;openningReport&ndash;%&gt;
                         <c:forEach items="${paperProjects}" var="paperProject">
                             <c:choose>
                                 <c:when test="${empty paperProject.openningReport}">
                                     <tr class="openningReportRow${paperProject.id}">
                                         <!-- 只拥有指导老师的角色 的操作-->
                                         <sec:authorize ifAllGranted="ROLE_TUTOR"
                                                        ifNotGranted="ROLE_DEPARTMENT_DIRECTOR">
                                             <td><label class="label label-warning">未提交</label></td>
                                         </sec:authorize>
                                         <!-- 只拥有教研室主任的角色的操作 -->
                                         <sec:authorize ifAllGranted="ROLE_DEPARTMENT_DIRECTOR"
                                                        ifNotGranted="ROLE_TUTOR">
                                             <td><label class="label label-warning">未提交</label></td>
                                         </sec:authorize>
                                         <!--同时拥有指导老师和教研室主任两个角色的操作 -->
                                         <sec:authorize
                                                 ifAllGranted="ROLE_TUTOR,ROLE_DEPARTMENT_DIRECTOR">
                                             <td><label class="label label-warning">未提交</label></td>
                                         </sec:authorize>

                                         <!-- 只拥有指导老师的角色 的状态-->
                                         <sec:authorize ifAllGranted="ROLE_TUTOR"
                                                        ifNotGranted="ROLE_DEPARTMENT_DIRECTOR">
                                             <td></td>
                                         </sec:authorize>
                                         <!-- 只拥有教研室主任的角色的状态 -->
                                         <sec:authorize ifAllGranted="ROLE_DEPARTMENT_DIRECTOR"
                                                        ifNotGranted="ROLE_TUTOR">
                                             <td></td>
                                         </sec:authorize>
                                         <!--同时拥有指导老师和教研室主任两个角色的状态 -->
                                         <sec:authorize
                                                 ifAllGranted="ROLE_TUTOR,ROLE_DEPARTMENT_DIRECTOR">
                                             <td></td>
                                             <td></td>
                                         </sec:authorize>

                                         <td class="openningReportMainTutorageName${paperProject.id}">${paperProject.mainTutorage.tutor.name}</td>
                                         <td class="openningReportTitle${paperProject.id}">${paperProject.title}</td>
                                         <td class="openningReportSubTitle${paperProject.id}">${paperProject.subTitle}</td>
                                         <td class="studentName${paperProject.id}">${paperProject.student.name}</td>
                                         <td class="studentNo${paperProject.id }">${paperProject.student.no}</td>


                                         <td>未提交</td>
                                         <td><a class="btn btn-primary btn-xs"
                                                href="/bysj3/process/showDetail.html?graduateProjectId=${paperProject.id}"
                                                data-toggle="modal" data-target="#showDetail">显示细节 </a></td>
                                     </tr>

                                 </c:when>
                                 <c:otherwise>
                                     <c:set value="${paperProject.openningReport}" var="openningReport"/>
                                     <tr class="openningReportRow${openningReport.id}">
                                         <!-- 只拥有指导老师的角色 的操作-->
                                         <sec:authorize ifAllGranted="ROLE_TUTOR"
                                                        ifNotGranted="ROLE_DEPARTMENT_DIRECTOR">
                                             <td id="tutor${openningReport.id}"><c:if
                                                     test="${openningReport.auditByTutor.approve==null}">
                                                 &lt;%&ndash; <a class="btn btn-danger btn-xs" href="approveOpenningReportByTutor.html?openningReportId=${openningReport.id}">通过</a> &ndash;%&gt;
                                                 <a id="approveOfTutor${openningReport.id}"
                                                    class="btn btn-success btn-xs"
                                                    onclick="approveOpenningReportByTutor(${openningReport.id})">通过</a>
                                             </c:if> <c:if test="${openningReport.auditByTutor.approve==true}">
                                                 &lt;%&ndash; <a class="btn btn-danger btn-xs" href="rejectOpenningReportByTutor.html?openningReportId=${openningReport.id}">退回</a> &ndash;%&gt;
                                                 <a id="rejectOfTutor${openningReport.id}"
                                                    class="btn btn-danger btn-xs"
                                                    onclick="rejectOpenningReportByTutor(${openningReport.id})">退回</a>
                                             </c:if></td>
                                         </sec:authorize>
                                         <!-- 只拥有教研室主任的角色的操作 -->
                                         <sec:authorize ifAllGranted="ROLE_DEPARTMENT_DIRECTOR"
                                                        ifNotGranted="ROLE_TUTOR">
                                             <td id="director${openningReport.id }"><c:if
                                                     test="${openningReport.auditByDepartmentDirector.approve==false}">
                                                 &lt;%&ndash; <a class="btn btn-danger btn-xs" href="approveOpenningReportByDirector.html?openningReportId=${openningReport.id}">通过</a> &ndash;%&gt;
                                                 <a id="approveOfDirector${openningReport.id}"
                                                    class="btn btn-success btn-xs"
                                                    onclick="approveOpenningReportByDirector(${openningReport.id})">通过</a>
                                             </c:if> <c:if
                                                     test="${openningReport.auditByDepartmentDirector.approve==true}">
                                                 &lt;%&ndash; <a class="btn btn-danger btn-xs" href="rejectOpenningReportByDirector.html?openningReportId=${openningReport.id}">退回</a> &ndash;%&gt;
                                                 <a id="rejectOfDirector${openningReport.id}"
                                                    class="btn btn-danger btn-xs"
                                                    onclick="rejectOpenningReportByDirector(${openningReport.id})">退回</a>
                                             </c:if></td>
                                         </sec:authorize>
                                         <!--同时拥有指导老师和教研室主任两个角色的操作 -->
                                         <sec:authorize
                                                 ifAllGranted="ROLE_TUTOR,ROLE_DEPARTMENT_DIRECTOR">
                                             <td id="btn${openningReport.id}"><c:if
                                                     test="${openningReport.auditByDepartmentDirector.approve==false&&openningReport.auditByTutor.approve==false}">
                                                 &lt;%&ndash; <a class="btn btn-danger btn-xs"  href="approveOpenningReportByDirectorAndDean.html?openningReportId=${openningReport.id}"><span>通过</span></a> &ndash;%&gt;
                                                 <a id="approveOfTutorAndDirector${openningReport.id}"
                                                    class="btn btn-success btn-xs"
                                                    onclick="approveOpenningReportByDirectorAndDean(${openningReport.id})">通过</a>
                                             </c:if> <c:if
                                                     test="${openningReport.auditByDepartmentDirector.approve==true&&openningReport.auditByTutor.approve==true}">
                                                 &lt;%&ndash; <a class="btn btn-danger btn-xs"  href="rejectOpenningReportByDirectorAndDean.html?openningReportId=${openningReport.id}"><span>退回</span></a> &ndash;%&gt;
                                                 <a id="rejectOfTutorAndDirector${openningReport.id}"
                                                    class="btn btn-danger btn-xs"
                                                    onclick="rejectOpenningReportByDirectorAndDean(${openningReport.id})">退回</a>
                                             </c:if></td>
                                         </sec:authorize>

                                         <!-- 只拥有指导老师的角色 的状态-->
                                         <sec:authorize ifAllGranted="ROLE_TUTOR"
                                                        ifNotGranted="ROLE_DEPARTMENT_DIRECTOR">
                                             <td id="statusOfTutor${openningReport.id}"><c:if
                                                     test="${openningReport.auditByTutor.approve==false}">退回</c:if>
                                                 <c:if test="${openningReport.auditByTutor.approve==true}">通过</c:if>
                                             </td>
                                         </sec:authorize>
                                         <!-- 只拥有教研室主任的角色的状态 -->
                                         <sec:authorize ifAllGranted="ROLE_DEPARTMENT_DIRECTOR"
                                                        ifNotGranted="ROLE_TUTOR">
                                             <td id="statusOfDirector${openningReport.id }"><c:if
                                                     test="${openningReport.auditByDepartmentDirector.approve==false}">退回</c:if>
                                                 <c:if
                                                         test="${openningReport.auditByDepartmentDirector.approve==true}">通过</c:if>
                                             </td>
                                         </sec:authorize>
                                         <!--同时拥有指导老师和教研室主任两个角色的状态 -->
                                         <sec:authorize
                                                 ifAllGranted="ROLE_TUTOR,ROLE_DEPARTMENT_DIRECTOR">
                                             <td id="tutorOfTutorAndDirectior${openningReport.id}"><c:if
                                                     test="${openningReport.auditByTutor.approve==false}">退回</c:if>
                                                 <c:if test="${openningReport.auditByTutor.approve==true}">通过</c:if>
                                             </td>
                                             <td id="directorOfTutorAndDirector${openningReport.id}"><c:if
                                                     test="${openningReport.auditByDepartmentDirector.approve==false}">退回</c:if>
                                                 <c:if
                                                         test="${openningReport.auditByDepartmentDirector.approve==true}">通过</c:if>
                                             </td>
                                         </sec:authorize>

                                         <td class="openningReportMainTutorageName${openningReport.id}">${openningReport.paperProject.mainTutorage.tutor.name}</td>
                                         <td class="openningReportTitle${openningReport.id}">${openningReport.paperProject.title}</td>
                                         <td class="openningReportSubTitle${openningReport.id}">${openningReport.paperProject.subTitle}</td>
                                         <td class="studentName${openningReport.id}">${openningReport.paperProject.student.name}</td>
                                         <td class="studentNo${openningReport.id }">${openningReport.paperProject.student.no}</td>


                                         <td id="download${openningReport.id}"><a id="downloadReport1"
                                                                                  href="downloadOpenningReport.html?openningReportId=${openningReport.id}"
                                                                                  class="btn btn-xs">

                                                 &lt;%&ndash;auditByDepartmentDirector    auditByTutor   approve&ndash;%&gt;
                                                 &lt;%&ndash;根据不同的角色，显示不同的按钮&ndash;%&gt;
                                                 &lt;%&ndash;主指导角色&ndash;%&gt;
                                             <sec:authorize ifAllGranted="ROLE_TUTOR"
                                                            ifNotGranted="ROLE_DEPARTMENT_DIRECTOR">
                                                 <c:if test="${openningReport.auditByTutor.approve}">
                                                     <span><i class="icon icon-download"></i> 下载</span>
                                                 </c:if>
                                             </sec:authorize>
                                             <!-- 拥有教研室角色，但不拥有主指导教师角色 -->
                                             <sec:authorize ifAllGranted="ROLE_DEPARTMENT_DIRECTOR"
                                                            ifNotGranted="ROLE_TUTOR">
                                                 <c:if test="${openningReport.auditByDepartmentDirector.approve}">
                                                     <span><i class="icon icon-download"></i> 下载</span>
                                                 </c:if>
                                             </sec:authorize>
                                             <!-- 同时拥有主指导教师和教研室主任角色 -->
                                             <sec:authorize ifAllGranted="ROLE_TUTOR,ROLE_DEPARTMENT_DIRECTOR">
                                                 <c:if test="${openningReport.auditByTutor.approve&&openningReport.auditByDepartmentDirector.approve}">
                                                     <span><i class="icon icon-download"></i> 下载</span>
                                                 </c:if>
                                             </sec:authorize>

                                         </a></td>
                                         <td><a class="btn btn-primary btn-xs"
                                                href="/bysj3/process/showDetail.html?graduateProjectId=${openningReport.paperProject.id}"
                                                data-toggle="modal" data-target="#showDetail">显示细节 </a></td>
                                     </tr>
                                 </c:otherwise>
                             </c:choose>
                         </c:forEach>
                     </c:otherwise>
                 </c:choose>
             </c:when>
             <c:otherwise>
                 <c:forEach items="${openningReports}" var="openningReport">
                     <tr class="openningReportRow${openningReport.id}">
                         <!-- 只拥有指导老师的角色 的操作-->
                         <sec:authorize ifAllGranted="ROLE_TUTOR"
                                        ifNotGranted="ROLE_DEPARTMENT_DIRECTOR">
                             <td id="tutor${openningReport.id}"><c:if
                                     test="${openningReport.auditByTutor.approve==false}">
                                 &lt;%&ndash; <a class="btn btn-danger btn-xs" href="approveOpenningReportByTutor.html?openningReportId=${openningReport.id}">通过</a> &ndash;%&gt;
                                 <a id="approveOfTutor${openningReport.id}"
                                    class="btn btn-success btn-xs"
                                    onclick="approveOpenningReportByTutor(${openningReport.id})">通过</a>
                             </c:if> <c:if test="${openningReport.auditByTutor.approve==true}">
                                 &lt;%&ndash; <a class="btn btn-danger btn-xs" href="rejectOpenningReportByTutor.html?openningReportId=${openningReport.id}">退回</a> &ndash;%&gt;
                                 <a id="rejectOfTutor${openningReport.id}"
                                    class="btn btn-danger btn-xs"
                                    onclick="rejectOpenningReportByTutor(${openningReport.id})">退回</a>
                             </c:if></td>
                         </sec:authorize>
                         <!-- 只拥有教研室主任的角色的操作 -->
                         <sec:authorize ifAllGranted="ROLE_DEPARTMENT_DIRECTOR"
                                        ifNotGranted="ROLE_TUTOR">
                             <td id="director${openningReport.id }"><c:if
                                     test="${openningReport.auditByDepartmentDirector.approve==false}">
                                 &lt;%&ndash; <a class="btn btn-danger btn-xs" href="approveOpenningReportByDirector.html?openningReportId=${openningReport.id}">通过</a> &ndash;%&gt;
                                 <a id="approveOfDirector${openningReport.id}"
                                    class="btn btn-success btn-xs"
                                    onclick="approveOpenningReportByDirector(${openningReport.id})">通过</a>
                             </c:if> <c:if
                                     test="${openningReport.auditByDepartmentDirector.approve==true}">
                                 &lt;%&ndash; <a class="btn btn-danger btn-xs" href="rejectOpenningReportByDirector.html?openningReportId=${openningReport.id}">退回</a> &ndash;%&gt;
                                 <a id="rejectOfDirector${openningReport.id}"
                                    class="btn btn-danger btn-xs"
                                    onclick="rejectOpenningReportByDirector(${openningReport.id})">退回</a>
                             </c:if></td>
                         </sec:authorize>
                         <!--同时拥有指导老师和教研室主任两个角色的操作 -->
                         <sec:authorize
                                 ifAllGranted="ROLE_TUTOR,ROLE_DEPARTMENT_DIRECTOR">
                             <td id="btn${openningReport.id}"><c:if
                                     test="${openningReport.auditByDepartmentDirector.approve==false&&openningReport.auditByTutor.approve==false}">
                                 &lt;%&ndash; <a class="btn btn-danger btn-xs"  href="approveOpenningReportByDirectorAndDean.html?openningReportId=${openningReport.id}"><span>通过</span></a> &ndash;%&gt;
                                 <a id="approveOfTutorAndDirector${openningReport.id}"
                                    class="btn btn-success btn-xs"
                                    onclick="approveOpenningReportByDirectorAndDean(${openningReport.id})">通过</a>
                             </c:if> <c:if
                                     test="${openningReport.auditByDepartmentDirector.approve==true&&openningReport.auditByTutor.approve==true}">
                                 &lt;%&ndash; <a class="btn btn-danger btn-xs"  href="rejectOpenningReportByDirectorAndDean.html?openningReportId=${openningReport.id}"><span>退回</span></a> &ndash;%&gt;
                                 <a id="rejectOfTutorAndDirector${openningReport.id}"
                                    class="btn btn-danger btn-xs"
                                    onclick="rejectOpenningReportByDirectorAndDean(${openningReport.id})">退回</a>
                             </c:if></td>
                         </sec:authorize>

                         <!-- 只拥有指导老师的角色 的状态-->
                         <sec:authorize ifAllGranted="ROLE_TUTOR"
                                        ifNotGranted="ROLE_DEPARTMENT_DIRECTOR">
                             <td id="statusOfTutor${openningReport.id}"><c:if
                                     test="${openningReport.auditByTutor.approve==false}">退回</c:if>
                                 <c:if test="${openningReport.auditByTutor.approve==true}">通过</c:if>
                             </td>
                         </sec:authorize>
                         <!-- 只拥有教研室主任的角色的状态 -->
                         <sec:authorize ifAllGranted="ROLE_DEPARTMENT_DIRECTOR"
                                        ifNotGranted="ROLE_TUTOR">
                             <td id="statusOfDirector${openningReport.id }"><c:if
                                     test="${openningReport.auditByDepartmentDirector.approve==false}">退回</c:if>
                                 <c:if
                                         test="${openningReport.auditByDepartmentDirector.approve==true}">通过</c:if>
                             </td>
                         </sec:authorize>
                         <!--同时拥有指导老师和教研室主任两个角色的状态 -->
                         <sec:authorize
                                 ifAllGranted="ROLE_TUTOR,ROLE_DEPARTMENT_DIRECTOR">
                             <td id="tutorOfTutorAndDirectior${openningReport.id}"><c:if
                                     test="${openningReport.auditByTutor.approve==false}">退回</c:if>
                                 <c:if test="${openningReport.auditByTutor.approve==true}">通过</c:if>
                             </td>
                             <td id="directorOfTutorAndDirector${openningReport.id}"><c:if
                                     test="${openningReport.auditByDepartmentDirector.approve==false}">退回</c:if>
                                 <c:if
                                         test="${openningReport.auditByDepartmentDirector.approve==true}">通过</c:if>
                             </td>
                         </sec:authorize>

                         <td class="openningReportMainTutorageName${openningReport.id}">${openningReport.paperProject.mainTutorage.tutor.name}</td>
                         <td class="openningReportTitle${openningReport.id}">${openningReport.paperProject.title}</td>
                         <td class="openningReportSubTitle${openningReport.id}">${openningReport.paperProject.subTitle}</td>
                         <td class="studentName${openningReport.id}">${openningReport.paperProject.student.name}</td>
                         <td class="studentNo${openningReport.id }">${openningReport.paperProject.student.no}</td>


                         <td id="download${openningReport.id}"><a id="downloadReport2"
                                                                  href="downloadOpenningReport.html?openningReportId=${openningReport.id}"
                                                                  class="btn btn-xs">

                                 &lt;%&ndash;auditByDepartmentDirector    auditByTutor   approve&ndash;%&gt;
                                 &lt;%&ndash;根据不同的角色，显示不同的按钮&ndash;%&gt;
                                 &lt;%&ndash;主指导角色&ndash;%&gt;
                             <sec:authorize ifAllGranted="ROLE_TUTOR"
                                            ifNotGranted="ROLE_DEPARTMENT_DIRECTOR">
                                 <c:if test="${openningReport.auditByTutor.approve}">
                                     <span><i class="icon icon-download"></i> 下载</span>
                                 </c:if>
                             </sec:authorize>
                             <!-- 拥有教研室角色，但不拥有主指导教师角色 -->
                             <sec:authorize ifAllGranted="ROLE_DEPARTMENT_DIRECTOR"
                                            ifNotGranted="ROLE_TUTOR">
                                 <c:if test="${openningReport.auditByDepartmentDirector.approve}">
                                     <span><i class="icon icon-download"></i> 下载</span>
                                 </c:if>
                             </sec:authorize>
                             <!-- 同时拥有主指导教师和教研室主任角色 -->
                             <sec:authorize ifAllGranted="ROLE_TUTOR,ROLE_DEPARTMENT_DIRECTOR">
                                 <c:if test="${openningReport.auditByTutor.approve&&openningReport.auditByDepartmentDirector.approve}">
                                     <span><i class="icon icon-download"></i> 下载</span>
                                 </c:if>
                             </sec:authorize>

                         </a></td>
                         <td><a class="btn btn-primary btn-xs"
                                href="/bysj3/process/showDetail.html?graduateProjectId=${openningReport.paperProject.id}"
                                data-toggle="modal" data-target="#showDetail">显示细节 </a></td>
                     </tr>
                 </c:forEach>
             </c:otherwise>
         </c:choose>

         </tbody>
     </table>--%>

</div>
</body>
</html>


