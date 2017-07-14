package com.newview.bysj.web.newTechnology;

import com.newview.bysj.domain.GraduateProject;
import com.newview.bysj.exception.MessageException;
import com.newview.bysj.web.baseController.BaseController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Created by apple on 17/7/14.
 */
@Controller
@RequestMapping("new")
public class Detail extends BaseController {
    @RequestMapping("/show.html")
    public String detail(Integer graduateProjectId, ModelMap modelMap){
        GraduateProject graduateProject = graduateProjectService.findById(graduateProjectId);
        if (graduateProject == null) {
            throw new MessageException("对应的课题不存在");
        }
        modelMap.put("graduateProject", graduateProject);
        return "newTechnology/detailForProject";
    }
}
