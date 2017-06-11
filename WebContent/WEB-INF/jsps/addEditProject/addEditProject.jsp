<%--
  Created by IntelliJ IDEA.
  User: zhan
  Date: 2017/4/9 0009
  Time: 20:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<script type="text/javascript">

    $(function () {
        $("#editProject").form({
            url: '${actionUrl}',
            onSubmit: function () {
                progressLoad();
                var tlenght = $("#title").val().length;
                if(tlenght==0) {
                    progressClose();
                    $.messager.alert('提示', '请输入课题名称', 'warning');
                    return false;
                }
                var isValid = $(this).form('validate');
                if (!isValid) {
                    progressClose();
                }
                return isValid;

            },
            success: function (result) {
                result = $.parseJSON(result);
                progressClose();
                if (result.success) {
                    $.messager.alert("提示", result.msg, 'info');
                    parent.$.modalDialog.project_Grid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    $.messager.alert("警告", result.msg, 'warning');
                }
            }
        });
    });

    function showSelectPanel() {
        $("#showSelectMajorPanel").hide(300);
        $("#hideSelectMajorPanel").show(600);
        $("#majorSelectPanel").show(900);
    }

    function hideSelectPanel() {
        $("#majorSelectPanel").hide(300);
        $("#hideSelectMajorPanel").hide(600);
        $("#showSelectMajorPanel").show(900);
    }

    function majorChange() {
        var majorSelect = $("#majorModal").text();
        var majorSelectId = $("#majorModal").val();
        $("#selectMajorDescription").val(majorSelect);
        $("#majorId").val(majorSelectId);
    }


</script>
<div style="padding: 10px;">
    <form:form commandName="toEditProject" id="editProject"
               method="post">

        <input type="hidden" name="id" value="${toEditProject.id}">
        <dl>
            <dt>课题名称：</dt>
            <dd>
                <div class="row">
                    <div class="col-sm-10">
                        <form:input id="title" path="title" type="text" cssClass="form-control" maxlength="60"/>
                    </div>
                    <div class="col-sm-2">
                        <span style="color: red;"> *</span>
                    </div>
                </div>
            </dd>
            <dt>副标题：</dt>
            <dd>
                <div class="row">
                    <div class="col-sm-10">
                        <form:input id="subTitle" path="subTitle" type="text" size="40" maxlength="40"
                                    cssClass="form-control"/>
                    </div>
                </div>

            </dd>


            <dt>题目类型：</dt>
            <dd>
                <form:select path="projectType.id">
                    <form:options cssClass="form-control" items="${projectTypeList}" itemLabel="description"
                                  itemValue="id"/>
                </form:select>
            </dd>
            <dt>题目性质：</dt>
            <dd>
                <form:select path="projectFidelity.id" name="projectFidelity" id="fidelity">
                    <form:options items="${projectFidelityList}" itemValue="id" itemLabel="description"
                                  cssClass="form-control"/>
                </form:select>
            </dd>
            <dt>题目来源：</dt>

            <dd>
                <form:select path="projectFrom.id" name="projectFrom" id="projectFromSelect">
                    <form:options items="${projectFromList}" itemValue="id" itemLabel="description"/>
                </form:select>
            </dd>
            <dt>年份：</dt>
            <dd>
                <form:input class="form-control" path="year" readonly="true"/>
            </dd>
            <dt>适用的专业：</dt>
            <dd>
                <input type="hidden" id="majorId" name="majorId" value="${selectedMajor.id}">
                <input type="text" class="form-control" id="selectMajorDescription"
                       value="${selectedMajor.description}" readonly>
                <br>
                <input class="btn btn-default" type="button" value="其它专业？" onclick="showSelectPanel()"
                       id="showSelectMajorPanel"/>

                <p style="font-size: small;color: red">因为技术问题，目前选择其它专业时，需要在相应的专业上点击一下</p>
                <input class="btn btn-warning" type="button" value="隐藏" id="hideSelectMajorPanel"
                       onclick="hideSelectPanel()" style="display: none"/>
            </dd>
        </dl>

        <div class="row" id="majorSelectPanel" style="display: none">
            <div class="col-md-4">
                    <%--需要从后台传递一个schoolList的参数，里面存放了所有的学院--%>
                <select class="form-control" id="schoolSelectModal" name="schoolSelect"
                        onchange="schoolOnSelectModal()">
                    <option value="0">--请选择学院--</option>
                    <c:forEach items="${schoolList}" var="school">
                        <option value="${school.id }"
                                class="selectSchool">${school.description}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="col-md-4">
                <select class="form-control " id="departmentSelectModal" name="departmentSelect"
                        onchange="departmentOnSelectToMajorModal()">
                    <option value="0">--请选择教研室--</option>
                </select>
            </div>
            <div class="col-md-4">
                <select class="form-control" id="majorModal" name="majorSelect" onclick="majorChange()">
                    <option value="0">--请选择专业--</option>
                </select>
            </div>
        </div>
        <br>
        <dl>
            <dt>设计（论文）工作内容</dt>
            <dd>
                    <textarea name="content" maxlength="500" rows="5" cols="80"
                              class="form-control">${toEditProject.content}</textarea>
            </dd>
            <dt>设计（论文）基本要求</dt>
            <dd>
                    <textarea name="basicRequirement" maxlength="500" rows="5" cols="80"
                              class="form-control">${toEditProject.basicRequirement}</textarea>
            </dd>
            <dt>所需基本技能</dt>
            <dd>
                    <textarea name="basicSkill" maxlength="500" rows="5" cols="80"
                              class="form-control">${toEditProject.basicSkill}</textarea>
            </dd>
            <dt>主要参考资料及参考文献</dt>
            <dd>
                    <textarea name="reference" maxlength="500" rows="5" cols="80"
                              class="form-control">${toEditProject.reference}</textarea>
            </dd>
        </dl>
    </form:form>
</div>
