package com.newview.bysj.web.addEditProject;

import com.newview.bysj.domain.DesignProject;
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

/**
 * Created 2016/2/24,15:32.
 * Author 张战.
 */

@Controller
@RequestMapping("process")
public class DesignProjectController extends BaseController {

    private static final Logger logger = Logger.getLogger(DesignProjectController.class);

    /**
     * 跳转到课题编辑页面
     */
    @RequestMapping(value = "/addOrEditDesignProject.html", method = RequestMethod.GET)
    public String addOrEditDesignProject(HttpSession httpSession, ModelMap modelMap, Integer editId, HttpServletRequest httpServletRequest) {
        if (editId == null) {
            DesignProject designProject = new DesignProject();
            designProject.setYear(CommonHelper.getYear());
            //添加到modelmap中，供graduateProjectService.toAddOrUpdateProject方法获取
            modelMap.put("project", designProject);
            //新增加的，没有id，所以传null
            graduateProjectService.toAddOrUpdateProject(httpSession, modelMap, null);
        } else {
            graduateProjectService.toAddOrUpdateProject(httpSession, modelMap, editId);
        }
        modelMap.put("actionUrl", httpServletRequest.getRequestURI());
        modelMap.put("schoolList", schoolService.findAll());
        return "addEditProject/addEditProject";
    }

    /**
     * 修改课题Post方法
     */
    @RequestMapping(value = "/addOrEditDesignProject.html", method = RequestMethod.POST)
    @ResponseBody
    public Result addOrEditDesignProject(@ModelAttribute("toEditProject") DesignProject toEditProject, HttpSession httpSession, Integer year, Integer majorId) {
        Result result = new Result();
        try {
            graduateProjectService.addOrUpdateProject(toEditProject, httpSession, year, majorId);
            result.setMsg("修改成功");
            result.setSuccess(true);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("课题修改失败" + e);
            result.setMsg("课题修改失败");
            return result;
        }
    }


}
