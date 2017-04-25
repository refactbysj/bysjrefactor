<%--
  Created by IntelliJ IDEA.
  User: 张战
  Date: 2016/3/1
  Time: 14:16
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<html>
<head>
    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
    <script type="text/javascript">
        /*点击显示要执行的函数*/
        function toShow(graduateProjectId) {
            $("#showSelect" + graduateProjectId).hide();
            $("#delReviewer" + graduateProjectId).hide(150);
            $("#showUpdate" + graduateProjectId).hide(300);
            $("#hideSelect" + graduateProjectId).show(300);
            $("#selectReviewTutor" + graduateProjectId).show(600);
            $("#addReviewBtn" + graduateProjectId).show(900);
        }

        /*点击隐藏要执行的函数*/
        function toHide(graduateProjectId) {
            $("#addReviewBtn" + graduateProjectId).hide();
            $("#hideSelect" + graduateProjectId).hide();
            $("#selectReviewTutor" + graduateProjectId).hide(300);
            $("#showSelect" + graduateProjectId).show(300);
            $("#delReviewer" + graduateProjectId).show(600);
            $("#showUpdate" + graduateProjectId).show(900);


        }

        //    添加或修改评阅人的函数
        function addOrEditReviewer(graduateProjectId) {
            /*获取选择的评阅人的id*/
            var reviewerId = $("#selectReviewTutor" + graduateProjectId).val();
            /*获取选择的评阅人的名字*/
            var tutorName = $("#selectReviewTutor" + graduateProjectId).find("option:selected").text();
            $.messager.confirm('询问', '确认指定' + tutorName + '为评阅人？', function (t) {
                if (t) {
                    progressLoad();
                    $.ajax({
                        url: '${basePath}process/addOrEditReviewer.html',
                        data: {"reviewerId": reviewerId, "graduateProjectId": graduateProjectId},
                        dataType: 'json',
                        type: 'POST',
                        success: function (result) {
                            progressClose();
                            if (result.success) {
                                $("#reviewerTable").datagrid('reload');
                                $.messager.alert('提示', result.msg, 'info');
                            } else {
                                $.messager.alert('提示', result.msg, 'warning');
                            }
                            return true;
                        },
                        error: function () {
                            progressClose();
                            $.messager.alert('错误', '发生网络错误，请联系管理员', 'error');
                            return false;
                        }
                    });
                }
            });
        }


        //删除评阅人
        function delReview(graduateProjectId) {
            $.messager.confirm('询问', '确认删除指定的评阅人？', function (t) {
                if (t) {
                    progressLoad();
                    $.ajax({
                        url: '${basePath}process/delReviewerByProjectId.html',
                        data: {"graduateProjectId": graduateProjectId},
                        dataType: 'json',
                        type: 'post',
                        success: function (result) {
                            progressClose();
                            if (result.success) {
                                $("#reviewerTable").datagrid('reload');
                                $.messager.alert('提示', result.msg, 'info');
                            } else {
                                $.messager.alert('警告', result.msg, 'warning');
                            }
                            return true;
                        },
                        error: function () {
                            progressClose();
                            $.messager.alert('错误', '发生网络错误，请联系管理员', 'error');
                            return false;
                        }
                    });
                }
            });
        }

        function showDetail(id) {
            var url = '${basePath}process/showDetail.html?graduateProjectId=' + id;
            showProjectDetail(url);
        }

        $(function () {

            $("#reviewerTable").datagrid({
                url: '${basePath}process/getReviewerData.html',
                fit: true,
                pagination: true,
                singleSelect: false,
                striped: true,
                columns: [[{
                    title: '选择',
                    field: 'selectProject',
                    checkbox: true,
                    hidden: true
                }, {
                    title: '标题（副标题）',
                    field: 'title',
                    width: '40%',
                    formatter: function (value, row) {
                        if (row.subTitle != null) {
                            return value + '——' + row.subTitle;
                        } else {
                            return value;
                        }
                    }
                }, {
                    title: '出题者',
                    field: 'proposerName',
                    formatter: function (value, row) {
                        return row.proposer.name;
                    }
                }, {
                    title: '类型',
                    field: 'action1',
                    formatter: function (value, row) {
                        if (row.projectType != null) {
                            return row.projectType.description;
                        } else {
                            return '';
                        }

                    }
                }, {
                    title: '类别',
                    field: 'category'
                }, {
                    title: '性质',
                    field: 'projectFideliy',
                    formatter: function (value, row) {
                        return row.projectFidelity.description;
                    }
                }, {
                    title: '终稿状态',
                    field: 'hasDraft',
                    formatter: function (value, row) {
                        if (row.finalDraft == null) {
                            return '<span style="color:red">无</span>';
                        } else {
                            return '有';
                        }
                    }
                }, {
                    title: '评阅人',
                    field: 'reviewer',
                    formatter: function (value, row) {
                        if (row.reviewer == null) {
                            return '<span style="color: red">未指定</span>';
                        } else {
                            return row.reviewer.name;
                        }
                    }
                }, {
                    title: '指定评阅人',
                    field: 'setReviewer',
                    width: '18%',
                    formatter: function (value, row) {
                        var str = '';
                        if (row.reviewer == null) {
                            str += $.formatString('<a class="setBtn" id="showSelect{0}" href="javascript:void(0)" onclick="toShow(\'{1}\')"></a>', row.id, row.id);
                        } else {
                            str += $.formatString('<a class="delBtn" id="delReviewer{0}" href="javascript:void(0)" onclick="delReview(\'{1}\')"></a>', row.id, row.id);
                            str += $.formatString('<a class="editBtn" id="showUpdate{0}" href="javascript:void(0)" onclick="toShow(\'{1}\')"></a>', row.id, row.id);
                        }
                        str += $.formatString('<a style="display: none" id="hideSelect{0}" class="hideBtn" href="javascript:void(0)" onclick="toHide(\'{1}\')"></a>', row.id, row.id);
                        str += $.formatString('<select class="easyui-combobox" id="selectReviewTutor{0}" style="display: none"><option value="0">--请选择--</option><c:choose><c:when test="${tutors==null}">没有可以选择的评阅人</c:when><c:otherwise><c:forEach items="${tutors}" var="tutor"><option value="${tutor.id}">${tutor.name}</option></c:forEach></c:otherwise></c:choose></select>', row.id);
                        str += $.formatString('<a class="addOrEditBtn" id="addReviewBtn{0}" style="display: none;" href="javascript:void(0)" onclick="addOrEditReviewer(\'{1}\')"></a>', row.id, row.id);
                        return str;
                    }
                }, {
                    title: '详情',
                    field: 'action',
                    width: '10%',
                    formatter: function (value, row) {
                        return $.formatString('<a class="detailBtn" href="javascript:void(0)" onclick="showDetail(\'{0}\')"></a>', row.id);
                    }
                }]],
                onLoadSuccess: function () {
                    $(".setBtn").linkbutton({text: '设置', plain: true});
                    $(".delBtn").linkbutton({text: '删除', iconCls: 'icon-cancel', plain: true});
                    $(".editBtn").linkbutton({text: '修改', plain: true, iconCls: 'icon-edit'});
                    $(".hideBtn").linkbutton({text: '隐藏', plain: true});
                    $(".addOrEditBtn").linkbutton({text: '确定', plain: true, iconCls: 'icon-ok'});
                    $(".detailBtn").linkbutton({text: '显示详情', plain: true, iconCls: 'icon-more'});
                }
            });
        });

        function searchFun() {
            $("#reviewerTable").datagrid('load', $.serializeObject($("#searchForm")));
        }

        function clearFun() {
            $("#searchForm input").val('');
            $("#reviewerTable").datagrid('load', {});
        }

        //点击批量指定评阅人按钮
        function batchSetReviewer() {
            $("#reviewerTable").datagrid('showColumn', 'selectProject');
            $.messager.alert('操作提示', '选择评阅人和课题-->点击确定批量指定评阅人', 'info');
            $("#batchSetSelect").show(200);
            $("#batchSetOk").show(400);
            $("#batchSetCancel").show(600);
        }

        //批量指定评阅人
        function okBatchSet() {
            //获取需要指定评阅人的课题
            var projects = $("#reviewerTable").datagrid('getChecked');
            //获取指定的评阅人
            var reviewerId = $("#batchSetSelect").find("option:selected").val();
            var reviewerName = $("#batchSetSelect").find("option:selected").text();
            if (reviewerId == -1) {
                $.messager.alert('提示', '请选择需要指定的评阅人', 'warning');
                return false;
            }
            if (projects.length == 0) {
                $.messager.alert('提示', '请选择需要指定评阅人的课题', 'warning');
                return false;
            }
            var projectIds = '';
            for (i in projects) {
                projectIds += projects[i].id + ",";
            }
            //去除最后一个逗号
            projectIds = projectIds.substring(0, projectIds.length - 1);
            $.messager.confirm('询问', '确认指定' + reviewerName + '为评阅人？', function (t) {
                if (t) {
                    $.ajax({
                        url: '${basePath}process/batchAddOrEditReviewer.html',
                        method: 'post',
                        data: {'projectIds': projectIds, 'reviewerId': reviewerId},
                        dataType: 'json',
                        success: function (result) {
                            if (result.success) {
                                $("#reviewerTable").datagrid('reload');
                                $.messager.alert('提示', result.msg, 'info');
                                cancelBatchSet();
                            } else {
                                $.messager.alert('提示', result.msg, 'warning');
                            }
                        }
                    })
                }
            });

        }

        function cancelBatchSet() {
            $("#reviewerTable").datagrid('hideColumn', 'selectProject');
            $("#batchSetSelect").hide(600);
            $("#batchSetOk").hide(400);
            $("#batchSetCancel").hide(200);
        }


    </script>

</head>
<body>
<div style="width: 100%">

    <div style="position: absolute;top: 10px;left: 1%;">
        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'"
           onclick="batchSetReviewer()">批量指定评阅人</a>
        <select style="display: none" id="batchSetSelect" name="batchSet">
            <option value="-1">--请选择--</option>
            <c:choose>
                <c:when test="${empty tutors}">
                    <p style="color: red;">没有可以选择的评阅人</p>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${tutors}" var="tutor">
                        <option value="${tutor.id}">${tutor.name}</option>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </select>
        <a href="javascript:void(0)" id="batchSetOk" onclick="okBatchSet()" class="easyui-linkbutton"
           data-options="iconCls:'icon-ok'" style="display: none;">指定</a>
        <a href="javascript:void(0)" id="batchSetCancel" onclick="cancelBatchSet()" class="easyui-linkbutton"
           data-options="iconCls:'icon-cancel'" style="display: none;">取消</a>

    </div>
    <div style="position: absolute;top: 10px;right: 5%;">
        <form id="searchForm">
            题目：
            <input class="easyui-textbox" name="title"/>
            评阅人：
            <input class="easyui-textbox" name="reviewerName"/>
            <a href="javascript:void(0)" onclick="searchFun()" class="easyui-linkbutton"
               data-options="iconCls:'icon-search'">查询</a>
            <a href="javascript:void(0)" onclick="clearFun()" class="easyui-linkbutton"
               data-options="iconCls:'icon-clear'">清空</a>
        </form>
    </div>
    <div style="width: 100%;height: 100%;">
        <table id="reviewerTable"></table>

    </div>

    <%-- <table class="table table-striped table-bordered table-hover datatable">
         <thead>
         <tr>
             <th>题目</th>
             <th>副标题</th>
             <th>出题者</th>
             <th>类别</th>
             <th>类型</th>
             <th>性质</th>
             <th>终稿状态</th>
             <th>评阅人</th>
             <th>指定评阅人</th>
             <th>详情</th>
         </tr>
         </thead>
         <tbody>
         <c:choose>
             <c:when test="${pageCount>0}">
                 <c:forEach items="${graduateProjectList}" var="graduateProject">
                     <tr>
                         <td>${graduateProject.title}</td>
                         <c:choose>
                             <c:when test="${empty graduateProject.subTitle}">
                                 <td></td>
                             </c:when>
                             <c:otherwise>
                                 <td>${graduateProject.subTitle}</td>
                             </c:otherwise>
                         </c:choose>
                         <td>${graduateProject.proposer.name}</td>
                         <td>${graduateProject.projectType.description}</td>
                         <td>${graduateProject.category}</td>
                         <td>${graduateProject.projectFidelity.description}</td>
                         <td>
                             <c:choose>
                                 <c:when test="${empty graduateProject.finalDraft}">
                                     <span class="label label-warning">无</span>
                                 </c:when>
                                 <c:otherwise>
                                     <span class="label label-success">有</span>
                                 </c:otherwise>
                             </c:choose>
                         </td>
                         <td id="addOrEditReviewerName${graduateProject.id}">
                             <c:choose>
                                 <c:when test="${empty graduateProject.reviewer}">
                                     <span class="label label-warning">未指定</span>
                                 </c:when>
                                 <c:otherwise>
                                     ${graduateProject.reviewer.name}
                                 </c:otherwise>
                             </c:choose>
                         </td>
                         <td id="addOrEdit${graduateProject.id}">
                                 &lt;%&ndash;对按钮的名称进行判断，如果之前没有评阅人，则显示设置，如果已经选择的评阅人，则显示修改&ndash;%&gt;
                             <c:choose>
                                 <c:when test="${empty graduateProject.reviewer}">
                                     <button class="btn btn-default btn-xs" id="showSelect${graduateProject.id}"
                                             onclick="toShow(${graduateProject.id})">设置
                                     </button>
                                 </c:when>
                                 <c:otherwise>
                                     <button class="btn btn-default btn-xs" id="delReviewer${graduateProject.id}"
                                             onclick="delReview(${graduateProject.id})">删除
                                     </button>
                                     <button class="btn btn-default btn-xs" id="showUpdate${graduateProject.id}"
                                             onclick="toShow(${graduateProject.id})">修改
                                     </button>
                                 </c:otherwise>
                             </c:choose>
                                 &lt;%&ndash;隐藏按钮默认不显示&ndash;%&gt;
                             <button class="btn btn-warning btn-xs" id="hideSelect${graduateProject.id}"
                                     onclick="toHide(${graduateProject.id})" style="display: none">隐藏
                             </button>
                             <select id="selectReviewTutor${graduateProject.id}" name="selectReviewTutor"
                                     style="display: none">
                                 <option value="0">--请选择--</option>
                                 <c:choose>
                                     <c:when test="${empty tutorList}">
                                         <p style="color: red;">没有可以选择的评阅人</p>
                                     </c:when>
                                     <c:otherwise>
                                         <c:forEach items="${tutorList}" var="tutor">
                                             <option value="${tutor.id}">${tutor.name}</option>
                                         </c:forEach>
                                     </c:otherwise>
                                 </c:choose>
                             </select>
                             <button style="display: none" id="addReviewBtn${graduateProject.id}"
                                     class="btn btn-default btn-xs"
                                     onclick="addOrEditReviewer(${graduateProject.id})">指定
                             </button>
                         </td>
                         <td>
                             <a href="/bysj3/process/showDetail.html?graduateProjectId=${graduateProject.id}"
                                data-toggle="modal" data-target="#showProjectDetail"
                                class="btn btn-primary btn-xs"><i class="icon-coffee"></i>显示详情 </a>
                         </td>
                     </tr>
                 </c:forEach>
             </c:when>
             <c:otherwise>
                 <div class="alert alert-warning alert-dismissable" role="alert">
                     <button class="close" type="button" data-dismiss="alert">&times;</button>
                     没有学生选择课题！
                 </div>
             </c:otherwise>
         </c:choose>
         </tbody>
     </table>--%>

</div>

</body>
</html>

