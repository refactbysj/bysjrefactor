<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@ include file="/WEB-INF/jsps/includeURL.jsp" %>

    <title>毕业管理系统</title>
    <script type="text/javascript">
        var receiveGrid;
        $(function () {
            receiveGrid = $("#recevieMailTable").datagrid({
                url:'${basePath}notice/getMailToMeData.html',
                pagination:true,
                fit:true,
                striped:true,
                singleSelect:true,
                columns:[[{
                    title:'标题',
                    field:'title',
                    width:'30%',
                    formatter:function (value, row) {
                        return row.mail.title;
                    }
                },{
                    title:'发布时间',
                    field:'time',
                    width:'15%',
                    formatter:function (value, row) {
                        var date = new Date();
                        date.setTime(row.mail.addressTime);
                        return date.toLocaleString();
                    }
                },{
                    title:'发件人',
                    width:'8%',
                    field:'addressor',
                    formatter:function (value, row) {
                        return row.mail.addressor.name;
                    }
                },{
                    title:'状态',
                    field:'status',
                    width:'5%',
                    formatter:function (value, row) {
                        if(row.isRead) {
                            return '<span style="color: green;">已读</span>';
                        }else{
                            return '未读';
                        }
                    }
                },{
                    title:'操作',
                    width:'20%',
                    field:'action',
                    formatter:function (value,row) {
                        var str = '';
                        str += $.formatString('<a href="javascript:void(0)" onclick="detailFun(\'{0}\')" class="detailBtn"></a>', row.id);
                        str += $.formatString('<a href="javascript:void(0)" onclick="replyFun(\'{0}\')" class="replyBtn"></a>', row.mail.id);
                        return str;
                    }
                }]],
                onLoadSuccess:function () {
                    $(".detailBtn").linkbutton({text: '详情', iconCls: 'icon-more', plain: true});
                    $(".replyBtn").linkbutton({text: '回复', iconCls: 'icon-redo', plain: true});
                }
            })
        });

        //回复邮件
        function replyFun(id) {
            parent.$.modalDialog({
                href:'${basePath}notice/replyMail.html?parentMailId='+id,
                modal:true,
                width:'50%',
                height:'60%',
                title:'回复邮件',
                buttons:[{
                    text:'关闭',
                    iconCls:'icon-cancel',
                    handler:function () {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                },{
                    text:'回复',
                    iconCls:'icon-ok',
                    handler:function () {
                        parent.$.modalDialog.receiveGrid =  receiveGrid;
                        var f = parent.$.modalDialog.handler.find('#receiveMailForm');
                        f.submit();
                    }
                }]
            })
        }

        //邮件详情
        function detailFun(id) {
            parent.$.modalDialog({
                href:'${basePath}notice/receiveViewMail.html?mailId='+id,
                modal:true,
                width:'50%',
                height:'50%',
                title:'邮件详情',
                buttons:[{
                    text:'关闭',
                    iconCls:'icon-cancel',
                    handler:function () {
                        $("#recevieMailTable").datagrid('reload');
                        parent.$.modalDialog.handler.dialog('close');
                    }
                }]
            })
        }
    </script>

    <script type="text/javascript">
        function logout() {
            $.messager.confirm('询问','确认退出登录？',function (t) {
                if(t) {
                    window.location.href = "login.html";
                }
            })
        }

        function checkPassword() {
            var oldpw = $("#oldPassword").val();
            var newpw = $("#newPassword").val();
            var confirmpw = $("#confirmNewPassword").val();
            if (newpw != confirmpw) {
                $.messager.alert('提示', '两次输入的新密码不一致', 'warning');
                return false;
            }
            window.wxc.xcConfirm("确认修改？", "confirm", {
                onOk: function () {
                    $.ajax({
                        url: '${basePath}updatePassword.html',
                        data: {"oldPassword": oldpw, "newPassword": newpw},
                        type: 'POST',
                        success: function (data) {
                            myAlert(data);
                            $("#myModal").hide(800);
                            location.reload();
                        },
                        error: function () {
                            myAlert("网络故障，请稍后再试");
                            location.reload();
                        }
                    });
                }
            });
        }

        function onloadTest(urlId) {
            var getUrl = $("#childUrl" + urlId).text();
            //$("#url"+urlId).attr("href",getUrl);
            $.ajax({
                beforeSend: function () {
                    //window.location=getUrl;
                    getContentSize();
                    var _PageHeight = document.documentElement.clientHeight, _PageWidth = document.documentElement.clientWidth;
                    //计算loading框距离顶部和左部的距离（loading框的宽度为215px，高度为61px）
                    var _LoadingTop = _PageHeight > 61 ? (_PageHeight - 61) / 2 : 0, _LoadingLeft = _PageWidth > 215 ? (_PageWidth - 215) / 2
                        : 0;
                    var _LoadingHtml = '<div id="loadingDiv" style="position:absolute;left:0;width:100%;height:'
                        + _PageHeight
                        + 'px;top:0;background:#f3f8ff;opacity:0.8;filter:alpha(opacity=80);z-index:10000;"><div style="position: absolute; cursor1: wait; left: '
                        + _LoadingLeft
                        + 'px; top:'
                        + _LoadingTop
                        + 'px; width: auto; height: 57px; line-height: 57px; padding-left: 50px; padding-right: 5px;  border: 2px solid #95B8E7; color: #696969; font-family:\'Microsoft YaHei\';"><i class="icon-spinner icon-spin"></i> 页面加载中，请等待...</div></div>';
                    $("#onLoadTest").html(_LoadingHtml);
                    $("#onLoadTest").show();

                },
                //发送请求的地址
                url: getUrl,
                //请求完成后的处理
                success: function (data) {
                    $("#demoTest").attr("srcdoc", data);
                    $("#onLoadTest").hide();
                    return true;
                }
            });
        }

        function openTab(url, text) {
            addTab({
                url:url,
                title:text
            })
        }

        //打开新的Table
        function addTab(params) {
            var iframe = '<iframe src="' + params.url + '" frameborder="0" style="border:0;width:100%;height:100%;"></iframe>';
            var t = $('#index_tabs');
            var opts = {
                title: params.title,
                closable: true,
                iconCls: params.iconCls,
                content: iframe,
                border: false,
                fit: true
            };
            if (t.tabs('exists', opts.title)) {
                t.tabs('select', opts.title);
            } else {
                t.tabs('add', opts);
            }
        }

        function changBackgroundWhite(id1,id2) {
            $("#"+id1).css("background-color", "white");
            $("#"+id2).css("background-color", "white");
        }

        function changBackgroundGrey(id1,id2) {
            $("#"+id1).css("background-color", "lightgrey");
            $("#"+id2).css("background-color", "lightgrey");
        }
    </script>

</head>
<body>

<%--easyui布局--%>
<div class="easyui-layout" data-options="fit:true" style="width: 100%;height: 100%;">
    <%--顶部导航栏--%>
    <div data-options="region:'north',"
         style="height:14%;background:url(<%=basePath%>img/banner3.png) no-repeat right #337ab7;overflow: hidden">
        <div style="float: left;width: 40%;">
            <span style="color: whitesmoke;font-size: xx-large;margin-left: 20%;line-height: 300%;height: 100%">毕业论文管理系统</span>
            
        </div>
        <div style="float: right;margin-right: 20px;">
            <ul class="list-inline" style="font-size: 15px;margin-top: 13%">
                <li>
                    <a href="javascript:void(0)">
                     <span style="color: whitesmoke;">
                   <i class="icon-user icon-large"></i>欢迎登录：${user.username},${user.actor.name}
                     </span>
                    </a>
                </li>
                <li>
                    <a data-toggle="modal" href="javascript:void(0)" data-target="#myModal">
                        <span style="color: whitesmoke;">
                        <i class=" icon-lock"></i> 修改密码
                    </span>
                    </a>
                </li>
                <sec:authorize ifNotGranted="ROLE_STUDENT">
                    <li>
                        <a href="${basePath}updateInfo.html" data-toggle="modal" data-target="#updateInfo">
                          <span style="color: whitesmoke;">
                            <i class="icon-edit"></i> 修改个人信息
                          </span>
                        </a>
                    </li>
                </sec:authorize>
                <li>
                    <a onclick="logout()" href="javascript:void(0)">
                    <span style="color: whitesmoke;">
                        <i class="icon-desktop"></i> 退出
                        </span>
                    </a>
                </li>
            </ul>
        </div>

    </div>
    <%--页面底部状态栏--%>
    <div data-options="region:'south'" style="height:6%;background: #ecf0f5">
        <div style="text-align: center;line-height: 300%;height: 100%;">
            信管开发团队 and <a href="http://ryanfait.com/sticky-footer/"
                          style="color: #666666">
            techjoy</a>
        </div>

    </div>
    <%--页面左侧菜单栏--%>
    <div data-options="region:'west',title:'菜单',split:true" style="width:15%;overflow-x: hidden">
        <div class="bs-docs-sidebar">
            <ul class="nav nav-list bs-docs-sidenav" id="navb" style="width: 100%;margin-top: 0">
                <!-- 全部的导航栏就这一个foreach，,你需要在这里更改样式 -->
                <c:forEach items="${parentResourceList}" var="parentResource">
                    <li><a data-toggle="collapse" data-parent="#accordion"
                           style="color: dodgerblue;background-color:ghostwhite;width: 100%;font-size: medium"
                           href="#collapse${parentResource.id }">
                        <c:choose>
                        <c:when test="${parentResource.id == 1}">
                            <span class="glyphicon glyphicon-bell">${parentResource.description}</span>
                        </c:when>
                        <c:when test="${parentResource.id == 4}">
                            <span class="glyphicon glyphicon-book">${parentResource.description}</span>
                        </c:when>
                        <c:when test="${parentResource.id == 12}">
                            <span class="glyphicon glyphicon-check">${parentResource.description}</span>
                        </c:when>
                        <c:when test="${parentResource.id == 19}">
                            <span class="glyphicon glyphicon-pencil">${parentResource.description}</span>
                        </c:when>
                        <c:when test="${parentResource.id == 27}">
                            <span class="glyphicon glyphicon-file">${parentResource.description}</span>
                        </c:when>
                        <c:when test="${parentResource.id == 44}">
                            <span class="glyphicon glyphicon-user">${parentResource.description}</span>
                        </c:when>
                        <c:when test="${parentResource.id == 33}">
                            <span class="glyphicon glyphicon-list-alt">${parentResource.description}</span>
                        </c:when>
                        <c:when test="${parentResource.id == 53}">
                            <span class="glyphicon glyphicon-eye-open">${parentResource.description}</span>
                        </c:when>
                        <c:when test="${parentResource.id == 40}">
                            <span class="glyphicon glyphicon-list">${parentResource.description}</span>
                        </c:when>
                        <c:when test="${parentResource.id == 51}">
                            <span class="glyphicon glyphicon-stats">${parentResource.description}</span>
                        </c:when>
                            <c:when test="${parentResource.id == 62}">
                                <span class="glyphicon glyphicon-tree-deciduous">${parentResource.description}</span>
                            </c:when>
                    </c:choose>
                        <i class=" icon-angle-left"
                                   style="font-size: 10px; float: right"></i>
                    </a>

                        <div id="collapse${parentResource.id}"
                             class="panel-collapse collapse">
                            <c:forEach items="${childResourceList}" var="childResource">
                                <c:if test="${childResource.parent == parentResource}">
                                    <div id="div${childResource.id}" onmouseover="changBackgroundGrey('div${childResource.id}','url${childResource.id}')"
                                         onmouseout="changBackgroundWhite('div${childResource.id}','url${childResource.id}')" class="panel-body" style="padding: 5px;">
                                        <a style="display: none"
                                           id="childUrl${childResource.id}">${childResource.url}</a>
                                        <a href="javascript:void(0)"
                                           onclick="openTab('${childResource.url}','${childResource.description}')"
                                           id="url${childResource.id}"
                                           style="border-left: 3px;background-color: white;color: dodgerblue;font-size: medium ">
                                            <span style=""></span><i class=" icon-circle-blank "></i>&nbsp&nbsp&nbsp${childResource.description}
                                        </a>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </li>
                </c:forEach>
            </ul>

        </div>
    </div>
    <%--页面正文区--%>
    <div data-options="region:'center',fig:true" id="index_tabs" class="easyui-tabs" style="background:#eee;">
        <div title="首页">
            <table id="recevieMailTable" style="height: 100%;"></table>
        </div>
    </div>
</div>


<%--模态框--%>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
     aria-hidden="true" aria-labelledby="modelOpeningReportTime">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${basePath}updatePassword.html" method="post" onsubmit="return checkPassword()">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"
                            aria-hidden="true">×
                    </button>
                    <h4 class="modal-title" id="myModalLabel">
                        修改密码
                    </h4>
                </div>
                <div class="modal-body">
                    原密码：<input type="password" id="oldPassword" required class="form-control"
                               name="oldPassword">
                    新密码：<input type="password" id="newPassword" required class="form-control"
                               name="newPassword">
                    确认密码：<input type="password" id="confirmNewPassword" required class="form-control"
                                name="confirmNewPassword">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default"
                            data-dismiss="modal">关闭
                    </button>
                    <button type="button" onclick="checkPassword()" class="btn btn-primary">
                        提交更改
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="updateInfo" tabindex="-1" role="dialog"
     aria-hidden="true" aria-labelledby="modelOpeningReportTime">
    <div class="modal-dialog">
        <div class="modal-content">


        </div>
    </div>
</div>
</body>
</html>