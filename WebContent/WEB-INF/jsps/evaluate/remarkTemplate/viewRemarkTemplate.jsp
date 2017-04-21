<%--
  Created by IntelliJ IDEA.
  User: zhan
  Date: 2016/3/31
  Time: 16:48
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<div class="modal-header">
    <span style="color: grey;font-weight: bold;font-size: large">模版名称：（${remarkTemplate.title}）</span>
</div>
<div class="modal-body">
    <form>
        <c:choose>
            <c:when test="${remarkTemplate==null}">
                <div class="alert alert-warning alert-dismissable" role="alert">
                    <button class="close" type="button" data-dismiss="alert">&times;</button>
                    没有可以显示的模版评语选项
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach items="${remarkTemplate.remarkTemplateItems}" var="remarkTemplateItem">
                    <span style="width: auto;font-size:18px;line-height: 20px">${remarkTemplateItem.preText}</span>
                    <select style="width: auto">
                        <c:forEach items="${remarkTemplateItem.remarkTemplateItemsOption}"
                                   var="remarkTemplateItemsOption">
                            <option value="${remarkTemplateItemsOption.no}">${remarkTemplateItemsOption.itemOption}</option>
                        </c:forEach>
                    </select>
                    <span style="width: auto;font-size:18px;line-height: 20px">${remarkTemplateItem.postText}</span>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </form>
</div>

