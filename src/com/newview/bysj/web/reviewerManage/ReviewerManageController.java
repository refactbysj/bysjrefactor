package com.newview.bysj.web.reviewerManage;

import com.newview.bysj.domain.*;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.util.PageInfo;
import com.newview.bysj.util.Result;
import com.newview.bysj.web.baseController.BaseController;
import org.apache.log4j.Logger;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * Created 2016/3/1,14:06.
 * Author 张战.
 */
@Controller
@RequestMapping("process")
public class ReviewerManageController extends BaseController {

    private static final Logger logger = Logger.getLogger(ReviewerManageController.class);


    /**
     * 跳转到指定评阅人页面
     */
    @RequestMapping(value = "/reviewerManage.html", method = RequestMethod.GET)
    public String reviewer(HttpSession httpSession, Model model) {
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentTutor(httpSession).getId());
        //获取本教研室下所有的老师
        List<Tutor> tutorList = tutor.getDepartment().getTutor();
        //移除自己,指定评阅人不能指定自己
        tutorList.remove(tutor);
        model.addAttribute("tutors", tutorList);
        return "reviewerManage/reviewerList";
    }

    /**
     * 列出当前用户所在教研室的所有课题
     */
    @RequestMapping("/getReviewerData.html")
    @ResponseBody
    public PageInfo getReviewerData(HttpSession httpSession, Integer page, Integer rows, String reviewerName, String point, String title) {
        PageInfo pageInfo = new PageInfo();
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentTutor(httpSession).getId());
        Page<GraduateProject> graduateProjectPage = graduateProjectService.getPageByTitleAndReviewer(title, reviewerName, point, tutor.getDepartment().getId(), page, rows);
        if (graduateProjectPage != null && graduateProjectPage.getSize() > 0) {
            pageInfo.setRows(graduateProjectPage.getContent());
            pageInfo.setTotal((int) graduateProjectPage.getTotalElements());
        }
        return pageInfo;
    }

    /**
     * 添加或修改评阅人的方法
     *
     * @param reviewerId        指定的评阅人的id,用于获取评阅人
     * @param graduateProjectId 课题的id,用于获取课题
     */
    @RequestMapping(value = "/addOrEditReviewer.html", method = RequestMethod.POST)
    @ResponseBody
    public Result addOrEditReviewer(Integer reviewerId, Integer graduateProjectId) {
        Result result = new Result();
        try {
            Tutor tutor = tutorService.findById(reviewerId);
            GraduateProject graduateProject = graduateProjectService.findById(graduateProjectId);
            //给课题设置评阅人
            graduateProject.setReviewer(tutor);
            graduateProjectService.update(graduateProject);
            User user = tutor.getUser();
            Role role = roleService.uniqueResult("description", "评阅人");
            UserRole userRole = new UserRole();
            //设置当前用户的角色
            userRole.setRole(role);
            userRole.setUser(user);
            userRoleService.saveOrUpdate(userRole);
            result.setSuccess(true);
            result.setMsg("指定成功");
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("指定失败" + e);
            result.setMsg("指定失败");
        }
        return result;
    }

    /**
     * 批量指定评阅人
     */
    @RequestMapping(value = "/batchAddOrEditReviewer", method = RequestMethod.POST)
    @ResponseBody
    public Result setBatchAddOrEditReviewer(Integer reviewerId, String projectIds) {
        Result result = new Result();
        try {
            String[] ids = projectIds.split(",");
            if (ids.length > 0) {
                for (String id : ids) {
                    this.addOrEditReviewer(reviewerId, Integer.valueOf(id));
                }
            }

            result.setSuccess(true);
            result.setMsg("批量指定成功");
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("批量指定评阅人失败" + e);
            result.setMsg("批量指定评阅人失败");
        }
        return result;
    }

    /**
     * 根据课题的id删除课题对应的评阅人
     *
     * @param graduateProjectId   要删除评阅人的课题的id
     * @param httpServletResponse 用于给浏览器返回响应信息
     */
    @RequestMapping(value = "/delReviewerByProjectId.html", method = RequestMethod.POST)
    @ResponseBody
    public Result delReviewer(Integer graduateProjectId, HttpServletResponse httpServletResponse) {
        Result result = new Result();
        try {
            GraduateProject graduateProject = graduateProjectService.findById(graduateProjectId);
            //将课题对应的评阅人置为空
            graduateProject.setReviewer(null);
            graduateProjectService.saveOrUpdate(graduateProject);
            result.setSuccess(true);
            result.setMsg("删除成功");

        } catch (Exception e) {
            e.printStackTrace();
            logger.error("删除失败" + e);
            result.setMsg("删除失败");
        }
        return result;
    }

}
