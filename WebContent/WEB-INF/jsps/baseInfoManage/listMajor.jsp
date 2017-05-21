<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
	<%@ include file="/WEB-INF/jsps/includeURL.jsp"%>
	<script type="text/javascript">




        var majorGrid;

        $(function () {
            var url = '';
            if(${departmentId!=null&&departmentId!=''}) {
                url = '${basePath}usersManage/department/getData.html?departmentId=${departmentId}';
            }else{
                url = '${basePath}usersManage/department/getData.html';
            }
            majorGrid = $("#majorTable").datagrid({
                url:url,
                pagination:true,
                fit:true,
                striped:true,
                singleSelect:true,
                columns:[[{
                    title:'专业',
                    field:'description',
                    width:'40%'
                },{
                    title:'操作',
                    field:'action',
                    width:'40%',
                    formatter:function (value,row) {
                        var str = '';
                        str += $.formatString('<a href="javascript:void(0)" class="delBtn" onclick="delFun(\'{0}\')"></a>', row.id);
                        str += $.formatString('<a href="javascript:void(0)" class="editBtn" onclick="editFun(\'{0}\')"></a>', row.id);
                        str += $.formatString('<a href="javascript:void(0)" class="viewBtn" onclick="viewMajor(\'{0}\')"></a>', row.id);
                        return str;
                    }
                }]],
                onLoadSuccess:function () {
                    $(".delBtn").linkbutton({text: '删除', iconCls: 'icon-cancel', plain: true});
                    $(".editBtn").linkbutton({text: '修改', iconCls: 'icon-edit', plain: true});
                    $(".viewBtn").linkbutton({text: '查看班级', iconCls: 'icon-more', plain: true});
                }
            })
        });

        function delFun(id) {
            $.messager.confirm('询问','确认删除？',function (t) {
                if(t) {
                    progressLoad();
                    $.ajax({
                        url:'${basePath}usersManage/deleteMajor.html',
                        type:'GET',
                        dataType:'json',
                        data:{"majorId":id},
                        success:function(result){
                            progressClose();
                            if(result.success) {
                                $("#majorTable").datagrid('reload');
                                $.messager.alert('提示', result.msg, 'info');
                            }else{
                                $.messager.alert('提示', result.msg, 'warning');
                            }
                            return true;
                        },
                        error:function(data){
                            progressClose();
                            $.messager.alert('错误', '网络错误，请联系管理员', 'error');
                            return false;
                        }
                    })
                }
            })
        }

        function editFun(id) {
            var title = '';
            var url = '';
            if(id==null||id=='') {
                title = '添加专业';
                url = '${basePath}usersManage/addMajor.html?departmentId=${departmentId}';
            }else{
                title='修改专业';
                url = '${basePath}usersManage/editMajor.html?majorId='+id;
            }
            parent.$.modalDialog({
                href:url,
                modal:true,
                width:'30%',
                height:'25%',
                title:title,
                buttons:[{
                    text:'取消',
                    iconCls:'icon-cancel',
                    handler:function () {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                },{
                    text:'提交',
                    iconCls:'icon-ok',
                    handler:function () {
                        parent.$.modalDialog.majorGrid = majorGrid;
                        var f = parent.$.modalDialog.handler.find('#editForm');
                        f.submit();
                    }
                }]
            })
        }

        function viewMajor(id) {
            window.location.href = '${basePath}usersManage/listStudentClass.html?majorId=' + id;
        }
	</script>

</head>
<body>
<div style="position: absolute;top: 10px;left: 2%;">
	<a class="easyui-linkbutton" onclick="editFun()"  data-options="iconCls:'icon-add'" style="left: 5%;"
	   href="javascript:void(0)"> 添加专业
	</a>
</div>

<div style="height: 100%;">
	<table id="majorTable" style="height: 100%;"></table>
</div>
</body>
</html>
