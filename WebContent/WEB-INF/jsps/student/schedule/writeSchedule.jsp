<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<head>
    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>

<script>
    var scheduleGrid;
    $(function () {
        scheduleGrid = $("#schedule").datagrid({
            url: '${basePath}/displayAllSchedule.html',
            singleSelect: true,
            columns: [[
                {field:'id',title:'id',hidden:true},
                {field:'beginTime',title:'开始时间',hidden:false,align:'center',width:'20%',
                    formatter:function (value) {
                        return formatString(value);
                    }

                },
                {field:'endTime',title:'结束时间',hidden:false,align:'center',width:'20%',
                    formatter:function (value) {
                        return formatString(value);
                    }
                },
                {field:'content',title:'应完成的工作内容',hidden:false,align:'center',width:'30%',

                },
                {field:'audit',title:'检查情况',hidden:false,align:'center',width:'10%',
                    formatter: function (value, rec) {
                        if(rec.audit== null){
                            return '无';
                        }
                        else {
                            return rec.audit.auditor.name;
                        }
                    }


                },
                {
                    title: '操作',
                    field:'action',
                    width: '10%',
                    formatter: function (value, row) {

                        return  $.formatString('<a href="javascript:void(0)" class="addOrEditBtn" onclick="writeWorkContent(\'{0}\')"></a>', row.id);

                    }

                }

            ]],
            onLoadSuccess:function () {
                $(".addOrEditBtn").linkbutton({text: '填写工作内容', plain: true, iconCls: 'icon-edit'});
            }
        })

    })
    function writeWorkContent(id) {
        parent.$.modalDialog({
            href: '${basePath}student/addScheduleContent.html?scheduleId='+id,
            width: 700,
            height: 500,
            modal: true,
            title: '填写工作内容',
            buttons: [{
                text: '取消',
                iconCls: 'icon-cancel',
                handler: function () {
                    parent.$.modalDialog.handler.dialog('close');
                }
            }, {
                text: '提交',
                iconCls: 'icon-ok',
                handler: function () {
                    parent.$.modalDialog.scheduleGrid = scheduleGrid;
                    var f = parent.$.modalDialog.handler.find("#schedulerForm");
                    f.submit();
                }
            }]

        })

    }

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
<c:if test="${not empty message}">
    <h3 style="color: red">${message}</h3>
</c:if>
<c:choose>
    <c:when test="${ifShowSchedule==0}">
        <div class="row">
            <div class="alert alert-warning alert-dismissable" role="alert">
                <button class="close" type="button" data-dismiss="alert">&times;</button>
                您尚未提交工作进程表！
            </div>
        </div>
        <div class="row">

            <c:if test="${hasTimeSpan==0}">
                <h2 style="color: red;">教研室主任未设置毕业设计时间，不能提交工作进程表</h2>
            </c:if>
            <c:if test="${hasTimeSpan==1}">
                <c:if test="${inTime}">
                    <a class="btn btn-default" href="<%=basePath%>student/addSchedule.html">添加工作进程表</a>
                </c:if>
                <c:if test="${!inTime}">
                    <h3 style="color: red">当前时间不允许填写工作进程表</h3>

                    <h3 style="color: red">教研室主任设计的毕业设计时间：${beginTime}-----${endTime}</h3>
                </c:if>
            </c:if>
        </div>
    </c:when>
    <c:when test="${ifShowSchedule==1}">
        <div style="height: 100%;">
            <table id="schedule" style="width: 100%;height: 100%;"></table>
        </div>
    </c:when>
</c:choose>

</body>