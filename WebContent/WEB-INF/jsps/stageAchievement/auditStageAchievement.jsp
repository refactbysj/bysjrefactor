<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<%--只能放在head里面--%>
<%@ include file="/WEB-INF/jsps/includeURL.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script type="text/javascript">
    var stageAchievementDetailGrid;
    $(function () {
        stageAchievementDetailGrid = $("#stageAchievementDetail").datagrid({
            url: '${basePath}auditStageAchievement.html',
            striped: true,
            fit: true,
            idField: 'id',
            pagination: true,
            singleSelect: true,
            columns: [[
                {field: 'issueDate',
                formatter: function (value, rec) {
                //issuedDate返回的是毫秒数，Unix时间戳(Unix timestamp) → 普通时间
                    var unixTimestamp = new Date(rec.issuedDate);
                    return unixTimestamp.toLocaleString();
                }, title: '上传时间', width: '30%', align: 'center'
                },
                {field: 'remark',
                formatter: function (value, rec) {
                    if (rec.remark == null) {
                        var str = '';
                        str += $.formatString('<a href="javascript:void(0)" class="addLoadBtn" data-options="plain:true,iconCls:\'icon-add\'" onclick="writeRemark(\'{0}\')"></a>', rec.id);
                        return str;
                    }
                    else {
                        return rec.remark;
                    }
                }, title: '教师评语', width: '30%', align: 'center'
                },
                {title: '操作',
                field: 'action',
                width: '40%',
                formatter: function (value, rec) {
                    ids=rec.id;
                    var str = '';
                    str += $.formatString('<a href="javascript:void(0)" class="downLoadBtn" data-options="plain:true,iconCls:\'icon-more\'" onclick="downLoadStageAchievement(\'{0}\')"></a>', rec.id);
                    if (rec.remark != null) {
                        str += $.formatString('<a href="javascript:void(0)" class="editLoadBtn" data-options="plain:true,iconCls:\'icon-edit\'" onclick="editRemark(\'{0}\')"></a>', rec.id);
                    }
                    return str;
                }
                }
        ]],
        onLoadSuccess: function () {
            $(".addLoadBtn").linkbutton({plain: true, iconCls: 'icon-add', text: '添加评语'});
            $(".editLoadBtn").linkbutton({plain: true, iconCls: 'icon-edit', text: '编辑评语'});
            $(".downLoadBtn").linkbutton({plain: true, iconCls: 'icon-more', text: '下载'});
        }
    });
});
    //添加评语
    function writeRemark(stageAchievementId) {
        var url = 'writeRemark.html?stageAchievementId=' + stageAchievementId;
        editOrAddRemark(url, '添加评语');
    }
    //修改评语
    function editRemark(stageAchievementId) {
        var url = 'editRemark.html?stageAchievementId=' + stageAchievementId;
        editOrAddRemark(url, '修改评语');
    }
    //添加或修改评语
    function editOrAddRemark(url,title) {
        parent.$.modalDialog({
            title:title,
            href:url,
            width:500,
            height:300,
            buttons:[{
                text:'关闭',
                iconCls:'icon-cancel',
                handler:function () {
                    parent.$.modalDialog.handler.dialog('close');
                }
            },{
                text:'提交',
                iconCls:'icon-add',
                handler:function () {
                    parent.$.modalDialog.openner_grid = stageAchievementDetailGrid;
                    var f = parent.$.modalDialog.handler.find('#addOrEidtRemarkForm');
                    f.submit();
                }
            }]
        })
    }
    //下载阶段成果
    function downLoadStageAchievement(stageAchievementId) {
        window.location.href = '${basePath}download/stageAchievement.html?stageAchievementId='+stageAchievementId;
    }
	</script>
</head>
<body>
<%--头部显示的课题信息--%>
<div>
    <h3>
        <label>课题信息：标题--${graduateProject.title}，副标题--${empty (graduateProject.subTitle)?"":graduateProject.subTitle}</label>
    </h3>
    <div>
        <h3><label>学生信息：姓名--${graduateProject.student.name}，班级--${graduateProject.student.studentClass.description}，学号--${graduateProject.student.no}</label>
        </h3>
        <a class="btn btn-warning" href="stageAchievements.html" title="审阅各阶段成果"><i class="icon-backward"></i> 返回</a>
    </div>
</div>
<%--阶段成果细节表--%>
<table id="stageAchievementDetail" style="width: 100%;height: 100%;"></table>
</body>
</html>