package com.newview.bysj.web.remarkTemplate;

import com.newview.bysj.domain.RemarkTemplateForDesignReviewer;
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
 * 评阅人设计课题的评语模版
 * Created 2016/3/27,22:29.
 * Author 张战.
 */
@Controller
@RequestMapping("evaluate")
public class DesignRemarkTemplateForReviewer extends BaseRemarkTemplate {

    private static final Logger LOGGER = Logger.getLogger(DesignRemarkTemplateForReviewer.class);

    /**
     * 设置评语模版的get方法
     *
     * @param modelMap           将数据添加到map集合中，用于在jsp中获取
     * @param httpServletRequest 当前请求，用于获取请求的url
     * @return jsp
     */
    @RequestMapping(value = "/setDesignRemarkForReviewer.html", method = RequestMethod.GET)
    public String setRemarkTemplate(ModelMap modelMap, HttpServletRequest httpServletRequest) {
        modelMap.put("actionURL", httpServletRequest.getRequestURI());
        modelMap.put("remarkTemplate", new RemarkTemplateForDesignReviewer());
        return super.folderName + "saveRemarkTemplate";
    }

    /**
     * 设置评语模版的post方法
     *
     * @param title              评语模版的标题
     * @param lineNumber         评语选项的行数
     * @param httpSession        当前会话
     * @param httpServletRequest 当前请求
     * @return jsp
     */
    @RequestMapping(value = "/setDesignRemarkForReviewer.html", method = RequestMethod.POST)
    @ResponseBody
    public Result setRemarTemplate(String title, Integer lineNumber, HttpSession httpSession, HttpServletRequest httpServletRequest) {
        Result result = new Result();
        try {
            //创建一个评审模版的对象
            RemarkTemplateForDesignReviewer remarkTemplateForDesignReviewer = new RemarkTemplateForDesignReviewer();
            //获取当前tutor
            Tutor tutor = CommonHelper.getCurrentTutor(httpSession);
            //设置所属的教研室
            remarkTemplateForDesignReviewer.setDepartment(tutor.getDepartment());
            //保存到数据库
            return super.saveRemarkTemplate(httpSession, httpServletRequest, title, lineNumber, remarkTemplateForDesignReviewer);
        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.error("评阅人设计课题的评语模版失败" + e);
            result.setMsg("设置评语模版失败");
        }
        return result;
    }
}
