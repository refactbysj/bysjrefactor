<%--
  Created by IntelliJ IDEA.
  User: 张战
  Date: 2016/2/14
  Time: 16:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<script type="text/javascript">
	$(document).ready(
			function() {
				function sendMail() {
					$.ajax();
				}
				;
				$('input').iCheck({
					labelHover : false,
					cursor : true,
					checkboxClass : 'icheckbox_square-blue',
					radioClass : 'iradio_square-blue',
					increaseArea : '20%'
				});

				$(".addresseeLi").on(
						"ifClicked",
						function() {
							var addressesCheckbox = $(this).find(
									"input[name='addressee']");
							$(addressesCheckbox).iCheck('toggle');
							/*执行方法*/
							setAddressee();
						});


				/*点击我的学生全选*/
				$(".myStudent").on(
						"ifClicked",
						function() {

							var myStudentCheckbox = $(this).find(
									"input[name='myStudent']");
							var addresseeCheckbox = $(this).parent().find(
									"input[name='addressee']");
							$(myStudentCheckbox).iCheck('toggle');
							$(addresseeCheckbox).iCheck('toggle');
							//$(myStudentCheckbox).iCheck('toggle');
							setAddressee();
						});
				/*点击学院全选*/

				$(".schoolSelectAll").on(
						"ifClicked",
						function() {
                                /*  schoolCheckbox学院对象*/
							var schoolCheckbox = $(this).find("school");
							/*获取该复选框下所有的子复选框*/
							/*  departmentCheckbox教研室对象 */
							var departmentCheckbox = $(this).parent().find(
									"input[name='department']");
							/*  studentClazzCheckbox班级对象*/
							var studentClazzCheckbox = $(this).parent().find(
									"input[name='clazz']");
							/*  addressee学生对象*/
							var addressee = $(this).parent().find(
									"input[name='addressee']");
							$(schoolCheckbox).iCheck('toggle');
							$(departmentCheckbox).iCheck('toggle');
							$(studentClazzCheckbox).iCheck('toggle');
							$(addressee).iCheck('toggle');
							setAddressee();	
						});
				/*点击教研室选*/
				$(".departSelectAll").on(
						"ifClicked",
						function() {
							var departmentCheckbox = $(this).find(
									"input[name='department']");
							/*选择该复选框下的所有子复选框*/
							var studentClazzCheckbox = $(this).parent().find(
									"input[name='clazz']");
							var address = $(this).parent().find(
									"input[name='addressee']");
							$(departmentCheckbox).iCheck('toggle');
							$(studentClazzCheckbox).iCheck('toggle');
							$(address).iCheck('toggle');
							setAddressee(); 
							
						});

                //  点击学生选
				$(".clazzSelectAll").on(
						"ifClicked",
						function() {
							var studentClazzCheckbox = $(this).find(
									"input[name='clazz']");
							/*选择此复选框下的所有子复选框*/
							var address = $(this).parent().find(
									"input[name='addressee']");
							$(studentClazzCheckbox).iCheck('toggle');
							$(address).iCheck('toggle');
							setAddressee();
						});
                /* 判断是否为空的选项  函数*/
				function setAddressee() {
					/*判断是否有选中的复选框，没有则将表单置为空*/
					if ($("input[name='addressee']:checked").size() != 0) {
						var str = "{addressees:[";
						$("input[name='addressee']:checked").each(function(i) {
							str += $(this).val();
							str += ",";
						});
						/*去除最后一个逗号,加圆括号的目的是强制使括号内的表达式转化为对象*/
						str = str.substring(0, str.length - 1) + "]}";
						/*生成json*/
						var addresseeJson = eval("(" + str + ")");
						/*获取json数据中的名字和id*/
						var addresseeId = "";
						var addresseeName = "";
						$.each(addresseeJson.addressees, function(i, item) {
							addresseeId += item.id + ",";
							addresseeName += item.name + ";";
						});
						/*去除最后一个逗号*/
						addresseeId = addresseeId.substring(0,
								addresseeId.length - 1);
						addresseeName = addresseeName.substring(0,
								addresseeName.length - 1);
						/*设置表单中的内容*/
						$("input[name='addressee.id']").attr("value",
								addresseeId);
						//$("#addresseeName").attr("value", addresseeName);
						$("#addresseeName").text(addresseeName);
						//$("#addresseeName").setAttribute("value",addresseeName);
					} else {
						$("input[name='addressee.id']").attr("value", "");
						$("#addresseeName"). text("");
					}
				}
			});

	$(function () {
		$("#sendMailForm").form({
			url:'<%=basePath%>notice/sendMail.html',
			onSubmit:function () {
			    progressLoad();
                var isValid = $(this).form('validate');
				if(!isValid) {
					progressClose();
                    return isValid;
                }
                var mailTitleLength = $("#mailTitle").val().length;
                if (mailTitleLength > 30) {
                    progressClose();
                    $.messager.alert('提示', '标题的字数应在30字以内', 'info');
                    return false;
                }
                var mailContentLength = $("#mailContent").val().length;
                if (mailContentLength > 200) {
                    progressClose();
                    $.messager.alert('提示', '内容的字数应在200字以内', 'info');
                    return false;
                }
            },
			success:function (result) {
				progressClose();
                result = $.parseJSON(result);
                if(result.success) {
                    parent.$.modalDialog.mailGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                    $.messager.alert('提示', result.msg, 'info');
                }else{
                    $.messager.alert('提示', result.msg, 'warning');
				}
            },
			error:function () {
                $.messager.alert('错误', '网络错误，请联系管理员', 'error');
                return false;
            }
		})
    });

	function clean(){
		/*清空收件人的文本框*/
       document.getElementById("addresseeName").innerHTML="";
		/*先判断复选框是否被选中*/
		$("input[type='checkbox']:checked").each(function(i) {
			/*若有被选中的复选框，则清空被选中的效果*/
			$(this).iCheck('toggle');
		});
	}
</script>



	<form:form cssClass="easyui-layout" id="sendMailForm" cssStyle="height: 100%;width: 100%;" commandName="mail"
			   enctype="multipart/form-data">

		<div data-options="region:'west',title:'邮件',split:true" style="width: 70%;height: 100%;padding: 10px;">
			<dl>
				<dt>收件人：</dt>
				<dd>
					<input type="hidden" name="addressee.id" value="">
					<textarea class="form-control required textInput valid"
							  id="addresseeName" name="addressee.name" cols="63" rows="3"
							  readonly="readonly" ></textarea>

					<a class="btn btn-warning btn-sm" id="emptyAddresses" onclick="clean()">清空</a>
						<%--<button class="btn btn-default" id="emptyAddresses" onclick="clean()">清空</button>--%>
					<p class="text-muted" style="color: red">(请从右侧列表中选择接收人，不可手动输入!)</p>
				</dd>
				<dt>标题：<span style="color: #808080;font-size: smaller">(30字以内)</span></dt>
				<dd>
					<input name="title" value="" type="text" id="mailTitle" class="form-control"
						   required="required" min="2"/>
				</dd>

				<dt>内容：<span style="color: #808080;font-size: smaller">(200字以内)</span></dt>

				<dd>
					<form:textarea path="content" id="mailContent" class="form-control" rows="3"
								   cols="63" />
				</dd>

				<dt>附件：</dt>
				<dd>
					<input name="mailAttachment" type="file" class="form-control">
				</dd>
			</dl>

		</div>
		<div data-options="region:'center',title:'收件人',split:true">
				<div class="easyui-tabs" style="height: 100%;">
					<div title="学生">
						<ul class="nav nav-pills nav-stacked">
							<li><a class="myStudent" href="#myStudents"
								   data-toggle="collapse"><input type="checkbox"
																 name="myStudent">&nbsp;我的学生<!-- <span
									class="glyphicon glyphicon-chevron-up"></span> -->
								<i class=" icon-angle-left"
								   style="font-size: 15px; float: right"></i></a>

								<div id="myStudents" class="panel-collapse collapse">
									<ul>
										<c:forEach items="${myStudent}" var="myStudent">
											<li class="addresseeLi"><span><input
													type="checkbox" name="addressee"
													value="{'id':'${myStudent.id}','name':'${myStudent.name}'}">&nbsp;${myStudent.name}</span>
											</li>
										</c:forEach>
									</ul>
								</div></li>
							<!--  列出每个学院-->
							<c:forEach items="${schoolList}" var="school">
								<li><a class="schoolSelectAll" data-toggle="collapse"
									   href="#schoolList${school.id}"><input type="checkbox"
																			 name="school">&nbsp;${school.description}<i class=" icon-angle-left"
																														 style="font-size: 15px; float: right"></i> </a>

									<div class="panel-collapse collapse"
										 id="schoolList${school.id}">
										<ul class="nav nav-pills nav-stacked">
											<!-- 列出每个教研室 -->
											<c:forEach items="${school.department}" var="department">
												<li><a data-toggle="collapse" class="departSelectAll"
													   href="#departmentList${department.id}">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input
														type="checkbox" name="department">&nbsp;${department.description}教研室<i class=" icon-angle-left"
																															   style="font-size: 15px; float: right"></i>
												</a>

													<div class="panel-collapse collapse"
														 id="departmentList${department.id}">
														<ul class="nav nav-pills nav-stacked">
															<c:forEach items="${department.major}" var="major">
																<ul class="nav nav-pills nav-stacked">
																	<!-- 列出所有班级 -->
																	<c:forEach items="${major.studentClass}"
																			   var="studentClass">
																		<li><a class="clazzSelectAll"
																			   data-toggle="collapse"
																			   href="#clazzList${studentClass.id}">
																			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
																			<input type="checkbox" name="clazz">&nbsp;${studentClass.description}<i class=" icon-angle-left"
																																					style="font-size: 15px; float: right"></i>
																		</a>

																			<div class="panel-collapse collapse"
																				 id="clazzList${studentClass.id}">
																				<ul>
																					<!--列出每个学生  -->
																					<c:forEach items="${studentClass.student}"
																							   var="student">
																						<c:if test="${student != user.actor}">
																							<li class="addresseeLi"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input
																									type="checkbox" name="addressee"
																									value="{'id':'${student.id}','name':'${student.name}'}">&nbsp;${student.name}
																							</span></li>

																						</c:if>
																					</c:forEach>
																				</ul>
																			</div></li>
																	</c:forEach>
																</ul>

															</c:forEach>
														</ul>
													</div></li>
											</c:forEach>
										</ul>
									</div></li>
							</c:forEach>
						</ul>
					</div>
					<div title="老师">
						<ul class="nav nav-pills nav-stacked">
								<%--列出所有的学院--%>
							<c:forEach items="${schoolList}" var="school">
								<li><a class="schoolSelectAll" data-toggle="collapse"
									   href="#teacherSchoolList${school.id}"><input
										type="checkbox" name="school">&nbsp;${school.description}<i class=" icon-angle-left"
																									style="font-size: 15px; float: right"></i></a>

									<div class="panel-collapse collapse"
										 id="teacherSchoolList${school.id}">
										<ul class="nav nav-pills nav-stacked">
												<%--列出所有的教研室--%>
											<c:forEach items="${school.department}" var="department">
												<li><a class="departSelectAll" data-toggle="collapse"
													   href="#tutorList${department.id}"><input
														type="checkbox" name="department">&nbsp;${department.description}<i class=" icon-angle-left"
																															style="font-size: 15px; float: right"></i> </a>

													<div class="panel-collapse collapse"
														 id="tutorList${department.id}">
														<ul>
															<c:forEach items="${department.tutor}" var="tutor">
																<c:if test="${tutor != user.actor}">
																	<li class="addresseeLi"><span><input
																			type="checkbox"
																			value="{'id':'${tutor.id}','name':'${tutor.name}'}"
																			name="addressee">&nbsp;${tutor.name}</span></li>
																</c:if>
															</c:forEach>
														</ul>
													</div></li>
											</c:forEach>
										</ul>
									</div></li>
							</c:forEach>
						</ul>

					</div>
				</div>

		</div>

	</form:form>


