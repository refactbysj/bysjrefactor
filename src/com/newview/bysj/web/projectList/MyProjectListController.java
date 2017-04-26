package com.newview.bysj.web.projectList;

import com.newview.bysj.domain.GraduateProject;
import com.newview.bysj.domain.Tutor;
import com.newview.bysj.exception.MessageException;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.util.PageInfo;
import com.newview.bysj.util.Result;
import com.newview.bysj.web.baseController.BaseController;
import com.newview.bysj.web.projectHelper.GraduateProjectHelper;
import org.apache.log4j.Logger;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;

/**
 * Created 2016/2/21,10:44.
 * Author 张战.
 */

@Controller
@RequestMapping("process")
public class MyProjectListController extends BaseController {


    private static final Logger logger = Logger.getLogger(MyProjectListController.class);

    /**
     * 跳转到我申报的题目页面
     */
    @RequestMapping(value = "/myProjects.html", method = RequestMethod.GET)
    public String listMyProjectsGet(HttpSession httpSession, ModelMap modelMap) {
        Tutor tutor = CommonHelper.getCurrentTutor(httpSession);
        //return listMyProjectsPost(modelMap, httpSession, title, pageNo, pageSize, httpServletRequest);
        GraduateProjectHelper.viewDesignOrPaper(modelMap, GraduateProjectHelper.VIEW_ALL);
        //用于在jsp中根据不同的条件来设置不同的路径
        GraduateProjectHelper.display(modelMap, 0);
        //用于设置当前时间是否在允许的修改时间之间
        GraduateProjectHelper.setMyProjectDisplay(tutor, modelMap, constraintOfProposeProjectService);
        return "projectList/projectList";
    }

    /**
     * 获取我申报的题目
     *
     * @param modelMap           需要是jsp中获取的数据
     * @param httpSession        用于获取当前的用户
     * @param title              用于检索的题目的名称
     * @param page             当前页
     * @param rows           每页的条数
     * @param httpServletRequest 用于获取请求的路径
     */
    @RequestMapping(value = "/myProjects.html", method = RequestMethod.POST)
    @ResponseBody
    public PageInfo listMyProjectsPost(ModelMap modelMap, HttpSession httpSession, String title, Integer page, Integer rows, HttpServletRequest httpServletRequest, String category) {
        PageInfo pageInfo = new PageInfo();
        Tutor tutor = CommonHelper.getCurrentTutor(httpSession);
        HashMap<String, String> condition = new HashMap<>();
        if (title != null) {
            condition.put("title", title.trim());
        }
        Page<GraduateProject> graduateProjectPage = graduateProjectService.getPagesByProposerWithConditions(tutor, page, rows, condition, category);
        modelMap.put("actionUrl", httpServletRequest.getRequestURI());
        pageInfo.setTotal((int) graduateProjectPage.getTotalElements());
        pageInfo.setRows(graduateProjectPage.getContent());
        return pageInfo;
    }



    /**
     * 查看论文的详细情况
     *
     * @param viewId   需要查看的论文的id,用于获取对应的论文
     * @param modelMap 用于存储被查看的论文，在jsp中获取
     * @return jsp页面
     */
    @RequestMapping("/viewProject.html")
    public String viewProject(Integer viewId, ModelMap modelMap) {
        GraduateProject graduateProject = graduateProjectService.findById(viewId);
        //modelMap.put("graduateProject", graduateProject);
        GraduateProjectHelper.viewProjectAddToModel(modelMap, graduateProject);
        return "projectView/viewProject";
    }

    /**
     * 删除论文
     *
     * @param delId 需要删除的论文的id
     */
    @RequestMapping(value = "/delProject.html", method = RequestMethod.POST)
    @ResponseBody
    public Result delProject(Integer delId) {
        Result result = new Result();
        try {
            graduateProjectService.delete(delId);
            result.setMsg("删除成功");
            result.setSuccess(true);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("删除失败：" + e);
            result.setMsg("删除失败");
            return result;
        }
    }

    /**
     * 编辑课题
     */
    @RequestMapping(value = "/editProject.html", method = RequestMethod.GET)
    public String editProject(Integer editId, HttpSession httpSession, ModelMap modelMap, HttpServletRequest httpServletRequest) {
        GraduateProject graduateProject = graduateProjectService.findById(editId);
        if (graduateProject != null) {
            graduateProjectService.toAddOrUpdateProject(httpSession, modelMap, editId);
        } else {
            throw new MessageException("获取课题失败");
        }
        modelMap.put("actionUrl", httpServletRequest.getRequestURI());
        return "addEditProject/addEditProject";
    }

    /**
     * 编辑课题提交
     */
    @RequestMapping(value = "/editProject.html", method = RequestMethod.POST)
    @ResponseBody
    public Result editProject(HttpSession httpSession, Integer year, Integer majorId, @ModelAttribute("toEditProject") GraduateProject graduateProject) {
        Result result = new Result();
        try {
            graduateProjectService.addOrUpdateProject(graduateProject, httpSession, year, majorId);
            result.setSuccess(true);
            result.setMsg("修改课题成功");
        } catch (Exception e) {
            logger.error("修改课题失败" + e);
            e.printStackTrace();
            result.setMsg("修改课题失败");
        }

        return result;
    }

    /**
     * 克隆课题
     *
     * @param cloneId     需要克隆的课题的id
     * @param httpSession 给cloneProject方法传递参数
     */
    @RequestMapping(value = "/cloneProjectById.html")
    @ResponseBody
    public Result cloneProjectById(Integer cloneId, HttpSession httpSession) {
        Result result = new Result();
        try {
            graduateProjectService.cloneProject(httpSession, cloneId);
            result.setMsg("克隆成功");
            result.setSuccess(true);
            return result;
        } catch (Exception e) {
            logger.error("克隆题目失败" + e);
            result.setSuccess(false);
            result.setMsg("克隆题目失败");
            return result;
        }

    }

}
