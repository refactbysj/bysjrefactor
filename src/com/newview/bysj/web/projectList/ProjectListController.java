package com.newview.bysj.web.projectList;

import com.newview.bysj.domain.DesignProject;
import com.newview.bysj.domain.GraduateProject;
import com.newview.bysj.domain.PaperProject;
import com.newview.bysj.domain.Tutor;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.util.PageInfo;
import com.newview.bysj.web.baseController.BaseController;
import com.newview.bysj.web.projectHelper.GraduateProjectHelper;
import com.newview.bysj.web.projectOfTime.ProjectOfTimeController;
import org.apache.log4j.Logger;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;

/**
 * 列出所有的课题
 * Created 2016/2/19,20:56.
 * Author 张战.
 */

@Controller
@RequestMapping("process")
public class ProjectListController extends BaseController {

    private static final Logger logger = Logger.getLogger(ProjectOfTimeController.class);


    //跳转到课题列表页面
    @RequestMapping(value = "/listProjects.html", method = RequestMethod.GET)
    public String listAllProjectsByGet( ModelMap modelMap, String title, Integer pageNo, Integer pageSize, HttpServletRequest httpServletRequest) {
        GraduateProjectHelper.viewDesignOrPaper(modelMap, GraduateProjectHelper.VIEW_ALL);
        GraduateProjectHelper.display(modelMap, 1);
        return "projectList/projectList";
    }

    /**
     * 通过post请求获取所有的课题
     *
     * @param httpSession        当前会话
     * @param modelMap           map集合，用来存储需要传递到jsp中的数据
     * @param title              查询的题目
     * @param page             当前页
     * @param rows           每页的条数
     * @param httpServletRequest 获取请求的路径
     * @return 所有的课题
     */
    @RequestMapping(value = "/getProjectsData.html", method = RequestMethod.POST)
    @ResponseBody
    public PageInfo listAllProjectsByPost(HttpSession httpSession, ModelMap modelMap, String title, Integer page,Integer rows, HttpServletRequest httpServletRequest) {
        PageInfo pageInfo = new PageInfo();
        Tutor tutor = CommonHelper.getCurrentTutor(httpSession);
        //用于存放模糊查询的条件,键为属性名，值为属性值
        HashMap<String, String> condition = new HashMap<>();
        if (title != null) {
            condition.put("title", title);
            modelMap.put("title", title);
        }
        Page<GraduateProject> graduateProjectsByPage = graduateProjectService.getPageByLimit(tutor, page, rows, condition);
        /*CommonHelper.pagingHelp(modelMap, graduateProjectsByPage, "listProjects", httpServletRequest.getRequestURI(), graduateProjectsByPage.getTotalElements());
        GraduateProjectHelper.addProjectPageNumToModel(modelMap, graduateProjectsByPage);*/
        pageInfo.setRows(graduateProjectsByPage.getContent());
        pageInfo.setTotal((int)graduateProjectsByPage.getTotalElements());
        modelMap.put("actionUrl", httpServletRequest.getRequestURI());
        //modelMap.put("gradateProjectNum", graduateProjectsByPage.getContent().size());
        //用于判断当前显示的是哪个功能，以便对应功能的标签高亮显示
        GraduateProjectHelper.viewDesignOrPaper(modelMap, GraduateProjectHelper.VIEW_ALL);
        GraduateProjectHelper.display(modelMap, 1);
        return pageInfo;
    }




    //获取设计类型的课题
    @RequestMapping("/listDesignProjects.html")
    public String listAllDesignProjects(HttpSession httpSession, ModelMap modelMap, Integer pageNo, Integer pageSize, HttpServletRequest httpServletRequest) {
        Tutor tutor = CommonHelper.getCurrentTutor(httpSession);
        Page<DesignProject> designProjectPage = designProjectService.getDesignProjectByDepartment(tutor, pageNo, pageSize);
        CommonHelper.pagingHelp(modelMap, designProjectPage, "listProjects", httpServletRequest.getRequestURI(), designProjectPage.getTotalElements());
        GraduateProjectHelper.addDesignPageNumToModel(modelMap, designProjectPage);
        GraduateProjectHelper.viewDesignOrPaper(modelMap, GraduateProjectHelper.VIEW_DESIGN);
        GraduateProjectHelper.display(modelMap, 1);
        return "projectTitle/listAllProjects";
    }

    //获取论文类型的课题
    @RequestMapping("/listPaperProjects.html")
    public String listAllPaperProjects(HttpSession httpSession, ModelMap modelMap, Integer pageNo, Integer pageSize, HttpServletRequest httpServletRequest) {
        Tutor tutor = CommonHelper.getCurrentTutor(httpSession);
        Page<PaperProject> paperProjectPage = paperProjectService.getPaperProjectByDepartment(tutor, pageNo, pageSize);
        CommonHelper.pagingHelp(modelMap, paperProjectPage, "listProjects", httpServletRequest.getRequestURI(), paperProjectPage.getTotalElements());
        GraduateProjectHelper.addPaperPageNumToModel(modelMap, paperProjectPage);
        GraduateProjectHelper.viewDesignOrPaper(modelMap, GraduateProjectHelper.VIEW_PAPAER);
        GraduateProjectHelper.display(modelMap, 1);
        return "projectTitle/listAllProjects";
    }


}
