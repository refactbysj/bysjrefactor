<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
	<%@ include file="/WEB-INF/jsps/includeURL.jsp"%>
	<script type="text/javascript">

		var schoolGrid;
        $(function () {
            schoolGrid = $("#schoolTable").datagrid({
                url:'${basePath}usersManage/college/getData.html',
                fit:true,
                pagination:true,
                singleSelect:true,
                striped:true,
                columns:[[{
                    title:'学院',
                    width:'40%',
                    field:'description'
                },{
                    title:'操作',
                    width:'30%',
                    field:'action',
                    formatter:function (value,row) {
                        var str = '';
                        str += $.formatString('<a href="javascript:void(0)" class="delBtn" onclick="delFun(\'{0}\')"></a>', row.id);
                        str += $.formatString('<a href="javascript:void(0)" class="editBtn" onclick="editFun(\'{0}\')"></a>', row.id);
                        str += $.formatString('<a href="javascript:void(0)" class="viewBtn" onclick="viewDepartment(\'{0}\')"></a>', row.id);
                        return str;
                    }
                }]],
                onLoadSuccess:function () {
                    $(".delBtn").linkbutton({text: '删除', iconCls: 'icon-cancel', plain: true});
                    $(".editBtn").linkbutton({text: '修改', iconCls: 'icon-edit', plain: true});
                    $(".viewBtn").linkbutton({text: '查看教研室', iconCls: 'icon-more', plain: true});
                }
            })
        });

        function delFun(id) {

            $.messager.confirm('询问','确认删除？',function (t) {
				if(t) {
				    progressLoad();
                    $.ajax({
                        url:'${basePath}usersManage/deleteSchool.html',
                        type:'GET',
                        dataType:'json',
                        data:{"schoolId":id},
                        success:function(result){
                            progressClose();
                            if(result.success) {
                                $("#schoolTable").datagrid('reload');
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
                title = '添加学院';
                url = '${basePath}usersManage/addSchool.html';
            }else{
                title='修改学院';
                url = '${basePath}usersManage/editSchool.html?schoolId='+id;
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
						parent.$.modalDialog.schoolGrid = schoolGrid;
                        var f = parent.$.modalDialog.handler.find('#editSchoolForm');
                        f.submit();
                    }
				}]
			})
        }

        function viewDepartment(id) {
            window.location.href = '${basePath}usersManage/listDepartment.html?schoolId=' + id;
        }
	</script>

</head>
<body>
	<div style="position: absolute;top: 10px;left: 2%;">
			<a class="easyui-linkbutton" onclick="editFun()"  data-options="iconCls:'icon-add'" style="left: 5%;"
			   href="javascript:void(0)"> 添加学院
			</a>
	</div>
	<div style="position: absolute;top: 10px;right: 5%;">
		<form action="/bysj3/usersManage/selectSchool.html" style="right: 5%;" method="post" class="form-inline" >
			学院
			<input id="description" type="text" class="easyui-textbox " name="description" placeholder="请输入学院名称">
			<a href="javascript:void(0)" data-options="iconCls:'icon-search'" class="easyui-linkbutton">查询</a>
			<a href="javascript:void(0)" data-options="iconCls:'icon-clear'" class="easyui-linkbutton">清空</a>
		</form>
	</div>

	<div style="height: 100%;">
		<table id="schoolTable" style="height: 100%;"></table>
	</div>
</body>
</html>
