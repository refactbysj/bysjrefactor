<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>


<script type="text/javascript">
    /* 单项解除的函数 */
    function noRole() {
        if ($("#selectedRoleList").find("option:selected").text() == "") {
            $.messager.alert('提示', '请选择需要移除的角色', 'warning');
            return false;
        }
        var ownRoleId = $("#selectedRoleList").find("option:selected").val();
        var ownRole = $("#selectedRoleList").find("option:selected").text();
        $("#selectedRoleList").find("option:selected").remove();
        $("select[name='unSelectedRoleList']").append(
            "<option value='" + ownRoleId + "'>" + ownRole
            + "</option>");
    }

    /* 解除全部 */
    function allNoRole() {
        $("#selectedRoleList option").each(
            function () {
                $("select[name='unSelectedRoleList']").append(
                    "<option value='" + $(this).val()
                    + "'>" + $(this).text()
                    + "</option>");
                $(this).remove();
            });
    }

    /* 单项添加的函数 */
    function ownRole() {
        if ($("#unSelectedRoleList").find("option:selected").text() == "") {
            $.messager.alert('提示', '请选择需要添加的角色', 'warning');
            return false;
        }
        var selectId = $("#unSelectedRoleList option:selected")
            .val();
        var noRoled = $("#unSelectedRoleList option:selected")
            .text();
        $("#unSelectedRoleList option:selected").remove();
        $("#selectedRoleList").append(
            "<option value='" + selectId + "'>" + noRoled
            + "</option>");
    }

    /* 分配全部 */
    function allOwnRole() {
        $("#unSelectedRoleList option").each(
            function () {
                $("select[name='selectedRoleList']").append(
                    "<option value='" + $(this).val()
                    + "'>" + $(this).text()
                    + "</option>");
                $(this).remove();
            });
    }

    $(function () {
        var selectRoleId = null;
        var employId = '${employeeId}';
        $("#roleForm").form({
            url: '<%=basePath%>authority/setEmployeeRole.html',
            onSubmit: function () {
                var i = 0;
                $("#selectedRoleList option").each(function () {
                    if (i == 0) {
                        selectRoleId = $(this).val();
                    } else {
                        selectRoleId = selectRoleId + "," + $(this).val();
                    }
                    i++;
                });
                $("#selectRoleId").val(selectRoleId);
                $("#employeeId").val(employId);
            },
            success: function (result) {
                result = $.parseJSON(result);
                if (result.success) {
                    parent.$.modalDialog.employeeGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                    $.messager.alert('提示', result.msg, 'info');
                } else {
                    $.messager.alert('提示', result.msg, 'warning');
                }
            }
        })
    });
</script>
<div class="easyui-layout" style="width:100%;height: 100%;">
    <div data-options="region:'west',title:'已拥有角色',width:'40%'">
        <form id="roleForm" method="get" style="width: 100%;height: 100%;">
            <input type="hidden" id="selectRoleId" name="selectRoleId">
            <input type="hidden" id="employeeId" name="employeeId">
            <select id="selectedRoleList" name="selectedRoleList" multiple style="width: 100%;height: 100%;">
                <c:forEach items="${ownRoles}" var="ownRole">
                    <option value="${ownRole.id}">${ownRole.description}</option>
                </c:forEach>
            </select>
        </form>
    </div>
    <div data-options="region:'east',title:'未拥有角色',width:'40%'">
        <select id="unSelectedRoleList" name="unSelectedRoleList" multiple style="width: 100%;height: 100%;">
            <c:forEach items="${noOwnRoles}" var="noOwnRole">
                <option value="${noOwnRole.id}">${noOwnRole.description}</option>
            </c:forEach>
        </select>
    </div>
    <div data-options="region:'center',title:'操作'" style="text-align: center">
        <button class="btn btn-primary btn-sm" onclick="ownRole()" style="margin-top: 10%">
            <i class=" icon-angle-left"></i> 单项分配
        </button>
        <br>
        <button class="btn btn-warning btn-sm" onclick="noRole()" style="margin-top: 20%">
            <i class=" icon-angle-right"> 单项解除</i>
        </button>
        <br>
        <button class="btn btn-primary btn-sm" onclick="allOwnRole()" style="margin-top: 20%">
            <i class=" icon-double-angle-left"> 分配全部</i>
        </button>
        <br>
        <button class="btn btn-warning btn-sm" onclick="allNoRole()" style="margin-top: 20%">
            <i class=" icon-double-angle-right"> 解除全部</i>
        </button>
    </div>
</div>


