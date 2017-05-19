<%@ page import="com.newview.bysj.domain.PaperProject" %>
<%@ page import="java.awt.print.Paper" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<head>
    <%@include file="/WEB-INF/jsps/includeURL.jsp"%>
<script>
    var projectGrid;
   $(function () {
       projectGrid=$('#superviseReport').datagrid({
            url:'${basePath}/process/checkSuperviseReport.html',
            singleSelect: true,
            toolbar:'#toolbar',
            pagination:true,
            pageSize: 10,
            pageList: [10, 15, 20, 25, 30, 40],
            columns:[[
                {field:'id',hidden:true},
                {title:'发布者',width:'25%',field:'issuer',
                formatter:function (value,row) {
                    return row.issuer.name;
                }},
                {title:'学院',width:'25%',field:'school_description',
                formatter:function (value,row) {
                    return row.school.description;
                }},
                {title:'日期',field:'calendar',width:'25%',
                formatter:function (value) {
                    return formatString(value);
                }
                },
                {title:'操作',field:'action',width:'25%',
                    formatter:function (value,row) {
                        var str='';
                        str += $.formatString('<a href="javascript:void(0)" class="downloadBtn" onclick="downloadMessages(\'{0}\')"></a>', row.id);
                        str +=" ";
                        str += $.formatString('<a href="javascript:void(0)" class="deleteBtn" onclick="deleteMessages(\'{0}\')"></a>', row.id);
                        return str;
                    }}
            ]],
            onLoadSuccess:function() {
                $('.downloadBtn').linkbutton({plain:false, text:'下载',align:'center',width:40,height:20});
                $('.deleteBtn').linkbutton({plain:false,  text:'删除',align:'center',width:40,height:20});
        }

        })
    })
   //下载
   function downloadMessages(id){
        $.messager.confirm("确认对话框","你将下载该文件",function (r) {
            if(r){
                window.location.href = '${basePath}/process/downloadSupervisionReport.html?reportId='+id;
            }
        })
   }
   //删除
   function deleteMessages(id) {
       $.messager.confirm("确认对话框","你确定要删除吗？",function (r) {
           if(r){
               progressLoad();
               $.ajax({
                   url: '${basePath}/process/delSuperReport.html',
                   type: 'GET',
                   dateType: 'json',
                   data: {"reportId": id},
                   success: function (result) {
                       progressClose();
                       result = $.parseJSON(result);
                       if (result.success) {
                           $.messager.alert('提示', result.msg, 'info');
                           $('#superviseReport').datagrid('reload');
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
    //提交督导报告
    function submitReport() {
        parent.$.modalDialog({
            href: '${basePath}/process/touploadSupervisionReport.html',
            width: '40%',
            height: '50%',
            modal: true,
            title: '上传督导报告',
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
                    parent.$.modalDialog.stageAchGird = projectGrid;
                    var f = parent.$.modalDialog.handler.find("#upReportForm");
                    f.submit();
                }
            }]
        })
        }
</script>
</head>
<body>
<div style="height: 100%;width: 100%">
    <table id="superviseReport" style="height: 100%;width: 100%"></table>
</div>
<div id = 'toolbar' style="padding: 5px;">
        <div style="padding-left: 2%;color:#333" >
            <a href="javascript:void(0)"  onclick="submitReport()"
                       class="easyui-linkbutton" data-options="iconCls:'icon-add'">提交督导报告</a>
        </div>
</div>
</body>