package com.newview.bysj.web.addEditProject;

import com.newview.bysj.domain.PaperProject;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.util.Result;
import com.newview.bysj.web.baseController.BaseController;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.UnsupportedEncodingException;
/**
 * Created 2016/2/24,15:32.
 * Author 张战.
 */
@Controller
@RequestMapping("process")
public class PaperProjectController extends BaseController {

    private static final Logger LOGGER = Logger.getLogger(PaperProjectController.class);

    /**
     * 跳转到课题编辑页面
     */
    @RequestMapping(value = "/addOrEditPaperProject.html", method = RequestMethod.GET)
    public String addOrEditPaperProject(ModelMap modelMap, HttpSession httpSession, Integer editId, HttpServletRequest httpServletRequest) throws UnsupportedEncodingException {
        if (editId == null) {
            PaperProject paperProject = new PaperProject();
            paperProject.setYear(CommonHelper.getYear());
            modelMap.put("project", paperProject);
            graduateProjectService.toAddOrUpdateProject(httpSession, modelMap, null);
        } else {
            graduateProjectService.toAddOrUpdateProject(httpSession, modelMap, editId);
        }
        httpServletRequest.setCharacterEncoding("GBK");
        modelMap.put("actionUrl", httpServletRequest.getRequestURI());
        modelMap.put("schoolList", schoolService.findAll());
        return "addEditProject/addEditProject";
    }

    /**
     * 修改课题post方法
     */
    @RequestMapping(value = "/addOrEditPaperProject.html", method = RequestMethod.POST)
    @ResponseBody
    public Result addOrEditPaperProject(HttpSession httpSession, Integer year, Integer majorId, @ModelAttribute("toEditProject") PaperProject paperProject) {
        Result result = new Result();
        try {
            graduateProjectService.addOrUpdateProject(paperProject, httpSession, year, majorId);
            result.setMsg("修改成功");
            result.setSuccess(true);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.error("修改失败" + e);
            result.setMsg("修改失败");
            return result;
        }
    }
}
