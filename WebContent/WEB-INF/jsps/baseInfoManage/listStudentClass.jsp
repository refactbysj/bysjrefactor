<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
	<%@ include file="/WEB-INF/jsps/includeURL.jsp"%>
<script type="text/javascript">

    var studentClassGrid;

    $(function () {
        var url = '';
        if(${majorId!=null&&majorId!=''}) {
            url = '${basePath}usersManage/studentClass/getData.html?majorId=${majorId}';
        }else{
            url = '${basePath}usersManage/studentClass/getData.html';
        }
        studentClassGrid = $("#studentClassTable").datagrid({
            url:url,
            pagination:true,
            fit:true,
            striped:true,
            singleSelect:true,
            columns:[[{
                title:'班级',
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
                    return str;
                }
            }]],
            onLoadSuccess:function () {
                $(".delBtn").linkbutton({text: '删除', iconCls: 'icon-cancel', plain: true});
                $(".editBtn").linkbutton({text: '修改', iconCls: 'icon-edit', plain: true});
            }
        })
    });

    function delFun(id) {
        $.messager.confirm('询问','确认删除？',function (t) {
            if(t) {
                progressLoad();
                $.ajax({
                    url:'${basePath}usersManage/deleteStudentClass.html',
                    type:'GET',
                    dataType:'json',
                    data:{"studentClassId":id},
                    success:function(result){
                        progressClose();
                        if(result.success) {
                            $("#studentClassTable").datagrid('reload');
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
            title = '添加班级';
            url = '${basePath}usersManage/addStudentClass.html?majorId=${majorId}';
        }else{
            title='修改班级';
            url = '${basePath}usersManage/editStudentClass.html?studentClassId='+id;
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
                    parent.$.modalDialog.studentClassGrid = studentClassGrid;
                    var f = parent.$.modalDialog.handler.find('#editForm');
                    f.submit();
                }
            }]
        })
    }

</script>
</head>
<body>
<div style="position: absolute;top: 10px;left: 2%;">
	<a class="easyui-linkbutton" onclick="editFun()"  data-options="iconCls:'icon-add'" style="left: 5%;"
	   href="javascript:void(0)"> 添加班级
	</a>
</div>

<div style="height: 100%;">
	<table id="studentClassTable" style="height: 100%;"></table>
</div>
</body>
</html>

<div class="container-fluid" style="width: 100%">

	<div class="row">
		<a class="easyui-linkbutton" data-options="iconCls:'icon-edit'" href="javascript:void(0)"
			 onclick="addOrEdit()">
			<i class="icon-external-link"></i> 添加班级
		</a>
	</div>
	<div class="row-fluid">
		<table
			class="table table-striped table-bordered table-hover datatable">
			<thead>
				<tr>
					<th>班级</th>
					<th>操作</th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
					<c:when test="${empty studentClasses}">
						<div class="alert alert-warning alert-dismissable" role="alert">
							<button class="close" type="button" data-dismiss="alert">&times;</button>
							没有数据
						</div>
					</c:when>
					<c:otherwise>
						<c:forEach items="${studentClasses}" var="studentClass">
							<tr id="studentClassRow${studentClass.id}">
								<td>${studentClass.description}</td>
								<td><a class="btn btn-danger btn-xs" onclick="deleteStudentClass(${studentClass.id})"> <i
										class="icon-remove "></i> 删除
								</a>
									<a class="btn btn-warning btn-xs"  href="/bysj3/usersManage/editStudentClass.html?studentClassId=${studentClass.id}&&majorId=${majorId}"
										data-toggle="modal" data-target="#addorEditStudentClass">
										<i class="icon-edit"></i> 修改
									</a>
							</tr>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
	</div>

	
</div>