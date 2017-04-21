package com.newview.bysj.web.remarkTemplate;

import com.newview.bysj.domain.RemarkTemplateForPaperReviewer;
import com.newview.bysj.domain.Tutor;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.util.Result;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * 评阅人论文课题的评语模版
 * Created 2016/3/27,22:57.
 * Author 张战.
 */

@Controller
@RequestMapping("evaluate")
public class PaperRemarkTemplateForReviewer extends BaseRemarkTemplate {

    private static final Logger LOGGER = Logger.getLogger(PaperRemarkTemplateForReviewer.class);

    /**
     * 设置评语模版的get方法
     *
     * @param modelMap           将数据添加到map集合中，用于在jsp中获取
     * @param httpServletRequest 当前请求，用于获取请求的url
     * @return 设置评语模版的界面
     */
    @RequestMapping(value = "/setPaperRemarkForReviewer.html", method = RequestMethod.GET)
    public String setRemarkTemplate(ModelMap modelMap, HttpServletRequest httpServletRequest) {
        modelMap.put("actionURL", httpServletRequest.getRequestURI());
        modelMap.put("remarkTemplate", new RemarkTemplateForPaperReviewer());
        return super.folderName + "saveRemarkTemplate";
    }

    /**
     * 设置评语模版的post方法
     *
     * @param title              评语的标题
     * @param lineNumber         评语选项的条数
     * @param httpSession        当前会话
     * @param httpServletRequest 当前请求
     * @return jsp
     */
    @RequestMapping(value = "/setPaperRemarkForReviewer.html", method = RequestMethod.POST)
    @ResponseBody
    public Result setRemarkTemplate(String title, Integer lineNumber, HttpSession httpSession, HttpServletRequest httpServletRequest) {
        Result result = new Result();
        try {
            //创建一个评语模版对象
            RemarkTemplateForPaperReviewer remarkTemplateForPaperReviewer = new RemarkTemplateForPaperReviewer();
            //得到当前的tutor
            Tutor tutor = CommonHelper.getCurrentTutor(httpSession);
            //设置所属教研室
            remarkTemplateForPaperReviewer.setDepartment(tutor.getDepartment());
            //保存到数据库
            return super.saveRemarkTemplate(httpSession, httpServletRequest, title, lineNumber, remarkTemplateForPaperReviewer);
        } catch (Exception e) {
            LOGGER.error("评阅人论文课题的评语模版设置失败" + e);
            e.printStackTrace();
            result.setMsg("设置评语模版失败");
        }

        return result;
    }
}
