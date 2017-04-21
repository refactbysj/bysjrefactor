package com.newview.bysj.web.remarkTemplate;

import com.newview.bysj.domain.RemarkTemplateForDesignTutor;
import com.newview.bysj.domain.Tutor;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.util.Result;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * 指导老师设计课题的评语模版
 * Created 2016/3/27,22:00.
 * Author 张战.
 */

@Controller
@RequestMapping("evaluate")
public class DesignRemarkTemplateForTutor extends BaseRemarkTemplate {

//    private static final Logger logger = Logger.getLogger(DesignRemarkTemplateForTutor.class);

    /**
     * 设置评语模版的get方法
     *
     * @param model              将数据添加到map集合中，用于在jsp中获取
     * @param httpServletRequest 当前请求，用于获取请求的url
     * @return jsp
     */
    @RequestMapping(value = "/setDesignRemarkForTutor.html", method = RequestMethod.GET)
    public String setRemarkTemplate(Model model, HttpServletRequest httpServletRequest) {
        model.addAttribute("remarkTemplate", new RemarkTemplateForDesignTutor());
        model.addAttribute("actionURL", httpServletRequest.getRequestURI());
        return "evaluate/remarkTemplate/saveRemarkTemplate";
    }

    /**
     * 设置评语模版的post方法
     *
     * @param httpSession        当前会话
     * @param title              评语模版的标题
     * @param lineNumber         评语选项的行数
     * @param httpServletRequest 当前请求
     * @return jsp
     */
    @RequestMapping(value = "/setDesignRemarkForTutor.html", method = RequestMethod.POST)
    @ResponseBody
    public Result setRemarkTemplate(HttpSession httpSession, String title, Integer lineNumber, HttpServletRequest httpServletRequest) {

        Result result = new Result();
        try {
            //创建一个评语模版对象
            RemarkTemplateForDesignTutor remarkTemplateForDesignTutor = new RemarkTemplateForDesignTutor();
            Tutor tutor = CommonHelper.getCurrentTutor(httpSession);
            //设置所属的教研室
            remarkTemplateForDesignTutor.setDepartment(tutor.getDepartment());
            //保存到数据库
            return super.saveRemarkTemplate(httpSession, httpServletRequest, title, lineNumber, remarkTemplateForDesignTutor);
        } catch (Exception e) {
            result.setMsg("修改失败");
        }
        return result;
    }
}
