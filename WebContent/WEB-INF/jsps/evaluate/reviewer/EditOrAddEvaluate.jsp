<%--
  Created by IntelliJ IDEA.
  User: 张战
  Date: 2016/3/25
  Time: 9:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script type="text/javascript">
    function c() {
        //return window.confirm("确认提交？");
        window.wxc.xcConfirm("确认提交？", "confirm", {
            onOk: function () {
                $("#reviewerPost").submit();
            }
            /*onClose:function(){
             return false;
             }*/
        });
    }
</script>
<script type="text/javascript">
    $("#remarkTemplateSelect").change(function () {
        //清空
        $("#remarkByTutorTextareaToShow").html(" ");
        var remarkTemplateItem = $("#remarkTemplateItem" + $(this).val());
        /* 将选择的模板显示到textarea中 */
        $("#remarkByTutorTextareaToShow").html(remarkTemplateItem.html());
    });
    $("#submitButton").click(function () {

    });

    $(function () {
        $("#editEvaluate").form({
            url: '${actionURL}',
            onSubmit: function () {
                if ($("#commentByReviewerQualityScore").val() == "") {
                    $.messager.alert('提示', '请选择质量评分', 'info');
                    return false;
                } else if ($("#commentByReviewerAchivementScore").val() == "") {
                    $.messager.alert('提示', '请选择成果水平评分', 'info');
                    return false;
                } else if ($("input:radio[name='qualified']:checked").val() == null) {
                    $.messager.alert('提示', '请选择评审结论', 'info');
                    return false;
                }
                //替换模板div中的组件
                var remarkToShow = $("#remarkByTutorTextareaToShow");
                remarkToShow.find("select").each(function () {
                    $(this).replaceWith($(this).val());
                });
                remarkToShow.find("span").each(function () {
                    $(this).replaceWith($(this).html());
                });
                $("#remarkByTutor").val(remarkToShow.text());
            },
            success: function (result) {
                result = $.parseJSON(result);
                if (result.success) {
                    $.messager.alert('提示', result.msg, 'info');
                    parent.$.modalDialog.evaluateGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    $.messager.alert('提示', result.msg, 'warning');
                }
            }
        })
    })
</script>
<form:form commandName="graduateProject" id="editEvaluate" action="${actionURL}" method="post"
           class="pageForm required-validate">
    <div class="modal-header">
        <h4 class="modal-title" id="myModalLabel">
            附表8：
            山东建筑大学毕业设计（论文）评阅人评审表
            <br>
            题目名称：${graduateProject.title}
            <br>
            班级：${graduateProject.student.studentClass.description}&nbsp;&nbsp;学生姓名：${graduateProject.student.name}&nbsp;&nbsp;学号:${graduateProject.student.no}
        </h4>
    </div>
    <div class="modal-body">
        <div class="pageFormContent nowrap" layoutH="150">
            <input name="id" type="hidden" value="${graduateProject.id }"/>

            <table class="table" border="1" width="500px">
                <tr>
                    <td>
                        难易程度
                    </td>
                    <td>
                        <form:select
                                name="reviewerEvaluationDifficulty"
                                path="commentByReviewer.reviewerEvaluationDifficulty"
                                id="reviewerEvaluationDifficulty" class="combox">
                            <form:option value="2" label="适中"/>
                            <form:option value="1" label="偏难"/>
                            <form:option value="3" label="偏易"/>
                            <form:option value="4" label="过易"/>
                        </form:select>
                    </td>
                    <td>
                        工作量
                    </td>
                    <td>
                        <form:select
                                name=""
                                path="commentByReviewer.reviewerEvaluationWordload"
                                id="reviewerEvaluationWordload" class="combox">
                            <form:option value="2" label="适中"/>
                            <form:option value="1" label="偏大"/>
                            <form:option value="3" label="便少"/>
                            <form:option value="4" label="过少"/>
                        </form:select>
                    </td>
                </tr>
                <tr>
                    <td>
                        说明书（论文）</br>版面质量
                    </td>
                    <td>
                        <form:select
                                name=""
                                path="commentByReviewer.reviewerEvaluationPrintingQuality"
                                id="reviewerEvaluationPrintingQuality" class="combox">
                            <form:option value="2" label="良"/>
                            <form:option value="1" label="优"/>
                            <form:option value="3" label="中"/>
                            <form:option value="4" label="差"/>
                        </form:select>
                    </td>
                    <td>
                        图样质量
                    </td>
                    <td>
                        <form:select
                                name=""
                                path="commentByReviewer.reviewerEvaluationDiagramQuality"
                                id="reviewerEvaluationDiagramQuality" class="combox">
                            <form:option value="2" label="良"/>
                            <form:option value="1" label="优"/>
                            <form:option value="3" label="中"/>
                            <form:option value="4" label="差"/>
                        </form:select>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        实物性能
                    </td>
                    <td colspan="2">
                        <form:select
                                name=""
                                path="commentByReviewer.reviewerEvaluationProductQuality"
                                id="reviewerEvaluationProductQuality" class="combox">
                            <form:option value="1" label="符合指标要求"/>
                            <form:option value="2" label="基本符合指标要求"/>
                            <form:option value="3" label="较差"/>
                        </form:select>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        论文（设计）质量评分（正确性、条理性、规范性、</br>合理性、清晰、工作量）
                    </td>
                    <td colspan="2"> <%--path 对应 commandName所代表的对象的一个属性 --%>
                        <form:select
                                name="commentByReviewerQualityScore"
                                path="commentByReviewer.qualityScore"
                                id="commentByReviewerQualityScore" class="combox">
                            <form:options items="${defaultGrades}"/>
                        </form:select>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        成果的技术水平（应用性和创新性）
                    </td>
                    <td colspan="2"> <%--path 对应 commandName所代表的对象的一个属性 --%>
                        <form:select
                                name="commentByReviewerAchievementScore"
                                path="commentByReviewer.achievementScore"
                                id="commentByReviewerAchivementScore" class="combox">
                            <form:options items="${defaultGrades}"/>
                        </form:select>
                    </td>
                </tr>
            </table>
            <!-- 评语区 -->
            <dl>
                <dt>选择模板：
                    <select id="remarkTemplateSelect">
                        <option label="请选择评审模板" value="0" selected></option>
                        <c:forEach items="${remarkTemplates}" var="remarkTemplate">
                            <option label="${remarkTemplate.title }" value="${remarkTemplate.id }">
                            </option>
                        </c:forEach>
                    </select>
                </dt>
                <dd>
                    <!-- 用于表单提交的textarea -->
                    <textarea id="remarkByTutor" rows="10" cols="60" name="remark" style="display:none;">
					</textarea>
                    <!-- 用于显示的textarea -->
                    <div id="remarkByTutorTextareaToShow" contenteditable="true"
                         style="width:100%;height:156px;border:1px solid black;font-size:18px;overflow-y:scroll;overflow-x:hidden;">
                            ${graduateProject.commentByReviewer.remarkByReviewer}
                    </div>
                    <c:forEach items="${remarkTemplates }" var="remarkTemplate">
                        <!-- 评语内容 -->
                        <div id="remarkTemplateItem${remarkTemplate.id }" style="display:none">
                            <div style="font-size:18px;">
                                <c:forEach items="${remarkTemplate.remarkTemplateItems }" var="remarkTemplateItem">
                                    <span style="float:left;font-size:18px;line-height: 20px">${remarkTemplateItem.preText}</span>
                                    <select style="float: left;height: 20px">
                                        <c:forEach items="${remarkTemplateItem.remarkTemplateItemsOption }"
                                                   var="remarkTemplateItemOption">
                                        <option label="${remarkTemplateItemOption.itemOption }"
                                                value="${remarkTemplateItemOption.itemOption }">
                                            </c:forEach>
                                    </select>
                                    <span style="float:left;font-size:18px;line-height: 20px">${remarkTemplateItem.postText }</span>
                                </c:forEach>
                            </div>
                        </div>
                    </c:forEach>
                </dd>
            </dl>
            <!-- 评语区 -->
            <!-- 是否答辩区 -->
            <dl>
                <dd>评审结论:</dd>
                <dt style="width:300px">
                    <input type="radio" name="qualified" id="commentByReviewerQualified"
                           value="true"
                            <c:if test="${isQualified}">
                                checked
                            </c:if>
                    />同意参加答辩
                    <input type="radio" name="qualified" id="commentByReviewerQualified1"
                           value="false"
                            <c:if test="${!isQualified}">
                                checked
                            </c:if>
                    /><span style="color: red">不同意参加答辩</span>
                </dt>
            </dl>
        </div>
    </div>

</form:form>

