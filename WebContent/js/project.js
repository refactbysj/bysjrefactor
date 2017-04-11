/**
 * Created by zhan on 2017/4/9 0009.
 */
//查看课题详情
function showProjectDetail(url) {
    parent.$.modalDialog({
        href: url,
        title: '课题详细',
        width: 800,
        height: 500,
        modal: true,
        buttons: [{
            text: '关闭',
            handler: function () {
                parent.$.modalDialog.handler.dialog('close');
            }
        }]
    })
}
