<%--
  Created by IntelliJ IDEA.
  User: 张战
  Date: 2016/3/28
  Time: 10:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


<script type="text/javascript">
    /*定义此变量的目的是在进行添加评语模版前，获取已有的评语模版的数量*/
    var trCount = 0;


    /*得到已有的评语模版的数量*/
    function getOldItems() {
        return $(".itemTr").length;
    }

    /*点击新建评语模版要执行的函数*/
    function addItem(itemCount) {
        $("#topId").remove();
        $("#tHead").attr('hidden', false);
        //得到已有的评语模版的条数
        trCount = getOldItems();
        //获取需要动态添加的元素
        var itemTr = $(".itemList");
        var index;
        for (var i = 0; i < itemCount; i++) {
            index = i + trCount;
            console.log('index:' + index);
            itemTr.append("<tr class='itemTr' id='remarkItemsIr" + index + "'>" + "<td><input class='form-control' id='delRemarkTemplateItem" + index + "' name='remarkTemplateItem[" + index + "]preText'></td>" + "<td><input type='hidden' name='remarkTemplateItem[" + index + "].id'><input class='form-control' required id='itemOptions" + index + "' type='text' name='remarkTemplateItem[" + index + "]itemOptions'></td>" + "<td><input name='remarkTemplateItem[" + index + "]postText' class='form-control'></td>" + "<td><button class='btn btn-warning' type='button' onclick='delItem(this)'><i class='icon-remove-sign'></i>删除</button></td>" + "</tr>");
        }
    }


    /*删除对应的评语模版*/
    function delItem(delThis) {
        $(delThis).parent().parent().remove();
    }


    $(function () {
        //如果为空，隐藏表头
        if (${remarkTemplate.remarkTemplateItems==null}) {
            $("#tHead").attr('hidden', 'hidden');
        }

        $("#setRemarkTemplate").form({
            url: '${actionURL}',
            onSubmit: function () {
                var title = $("#remarktitle").val().length;
                if (title == 0) {
                    $.messager.alert('提示', '请输入评语模版的名称', 'warning');
                    return false;
                }
                var lineNumber = $("input[name='lineNumber']");
                lineNumber.val($(".itemTr").length);
                progressLoad();
                var isValid = $(this).form('validate');
                if (!isValid) {
                    progressClose();
                    return false;
                }
                return isValid;
            },
            success: function (result) {
                result = $.parseJSON(result);
                progressClose();
                if (result.success) {
                    $.messager.alert('提示', result.msg, 'info');
                    parent.$.modalDialog.templateGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    $.messager.alert('警告', result.msg, 'warning');
                }
            }
        })
    });

</script>

<div style="width: 100%">
    <div>
        <form method="post" id="setRemarkTemplate">
            <input type="hidden" name="lineNumber" value=""> <input
                type="hidden" name="remarkTemplateId" value="${remarkTemplate.id}">

            <div style="margin-left: 10%;margin-top: 2%">
                <a href="javascript:void(0)" class="easyui-menubutton" style="width: 20%;"
                   data-options="menu:'#countSelect',iconCls:'icon-add'">创建评语模版</a>
                <div id="countSelect">
                    <div onclick="addItem(1)" data-options="iconCls:'icon-ok'">修建1个</div>
                    <div onclick="addItem(2)" data-options="iconCls:'icon-ok'">修建2个</div>
                    <div onclick="addItem(3)" data-options="iconCls:'icon-ok'">修建3个</div>
                    <div onclick="addItem(4)" data-options="iconCls:'icon-ok'">修建4个</div>
                    <div onclick="addItem(5)" data-options="iconCls:'icon-ok'">修建5个</div>
                    <div onclick="addItem(6)" data-options="iconCls:'icon-ok'">修建6个</div>
                    <div onclick="addItem(7)" data-options="iconCls:'icon-ok'">修建7个</div>
                    <div onclick="addItem(8)" data-options="iconCls:'icon-ok'">修建8个</div>
                    <div onclick="addItem(9)" data-options="iconCls:'icon-ok'">修建9个</div>
                    <div onclick="addItem(10)" data-options="iconCls:'icon-ok'">修建10个</div>
                </div>
                <span style="color: grey;font-size: large;margin-left: 20%">评语模版名称：</span>
                <input name="title" style="float: left;width: 25%;" id="remarktitle" class="easyui-textbox"
                       placeholder="请输入评语模版的名称" value="${remarkTemplate.title}"
                       required>
            </div>
            <hr/>
            <div>
                <span style="color: indianred;margin-left: 10px" id="tipId">(注意：多个评语选项之间以中文逗号分隔，非中文逗号分隔将被当成一个选项)</span>
                <br/>
                <table class="table">
                    <thead id="tHead">
                    <tr>
                        <th width="36%">选项前的文字</th>
                        <th width="20%">评语选项</th>
                        <th width="36%">选项后的文字</th>
                        <th width="8%">操作</th>
                    </tr>
                    </thead>
                    <tbody class="itemList">
                    <c:choose>
                        <c:when test="${remarkTemplate.remarkTemplateItems==null}">
                            <span id="topId"
                                  style="font-size: xx-large;color: grey;font-weight: bold;margin-left: 10px">无评语模版</span>
                        </c:when>
                        <c:otherwise>

                            <c:forEach items="${remarkTemplate.remarkTemplateItems}"
                                       var="remarkTemplateItem" varStatus="status">
                                <tr class="itemTr">
                                    <td nowrap="nowrap"><input
                                            name="remarkTemplateItem[${status.index}]preText"
                                            class="form-control" value="${remarkTemplateItem.preText}">
                                    </td>
                                    <td nowrap="nowrap"><input type="hidden" class="form-control"
                                                               name="remarkTemplateItem[${status.index}].id"> <c:set
                                            var="itemOptionStr" value=""/> <c:forEach
                                            items="${remarkTemplateItem.remarkTemplateItemsOption}"
                                            var="remarkTemplateItemsOption">
                                        <c:set var="itemOptionStr"
                                               value="${itemOptionStr}，${remarkTemplateItemsOption.itemOption}"/>
                                    </c:forEach> <%--去除第一个逗号--%> <c:set var="itemOptionStr"
                                                                        value="${fn:substring(itemOptionStr, 1, fn:length(itemOptionStr))}"/>
                                        <input class="form-control" id="itemOptions${status.index}"
                                               value="${itemOptionStr}" type="text"
                                               name="remarkTemplateItem[${status.index}]itemOptions">
                                    </td>
                                    <td nowrap="nowrap"><input name="remarkTemplateItem[${status.index}]postText"
                                                               value="${remarkTemplateItem.postText}"
                                                               class="form-control"
                                    ></td>
                                    <td nowrap="nowrap">
                                        <button class="btn btn-warning" onclick="delItem(this)"><i
                                                class="icon-remove-sign"></i>删除
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>

                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>

            </div>
        </form>
    </div>

</div>
