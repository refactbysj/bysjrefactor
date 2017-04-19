package com.newview.bysj.web.approveProject;

import com.newview.bysj.domain.Audit;
import com.newview.bysj.domain.GraduateProject;
import com.newview.bysj.domain.Tutor;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.util.PageInfo;
import com.newview.bysj.util.Result;
import com.newview.bysj.web.baseController.BaseController;
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
import java.util.Objects;

/**
 * 审核教师题目有关的controller
 * Created 2016/3/1,13:16. Author 张战.
 */
@Controller
@RequestMapping("process")
public class ApproveProjectController extends BaseController {

    private static final Logger logger = Logger.getLogger(ApproveProjectController.class);


    /**
     * 根据老师的名字和题目名称来获取课题
     *
     * @param httpSession        当前会话
     * @param tutorName          老师的名字
     * @param title              题目的名称
     * @param modelMap           map集合，存放需要在jsp中获取的数据
     * @param httpServletRequest 对浏览器的响应
     * @return approveProjects/approveProjectOfTutor.jsp
     */
    @RequestMapping(value = "/searchProjectByNameAndTitle.html", method = RequestMethod.POST)
    public String getGraduateProjectByLimit(HttpSession httpSession, String tutorName, String title, ModelMap modelMap, HttpServletRequest httpServletRequest, String category) {
        //获取当前tutor
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentTutor(httpSession).getId());
        //用于存放查询条件
        HashMap<String, String> conditionMap = new HashMap<>();
        if (title != null) {
            conditionMap.put("title", title);
        }
        if (tutorName != null) {
            Tutor conditionTutor = tutorService.uniqueResult("name", tutorName);
            conditionMap.put("proposer", conditionTutor.toString());
        }
        Page<GraduateProject> graduateProjectPage = graduateProjectService.getPageByLimit(tutor, null, null, conditionMap, category);
        //添加在Map中
        CommonHelper.pagingHelp(modelMap, graduateProjectPage, "graduateProjectEvaluate", httpServletRequest.getRequestURI(), graduateProjectPage.getTotalElements());
        modelMap.put("contentSize", graduateProjectPage.getContent().size());
        return "approveProjects/approveProjectOfTutor";
    }

    /**
     * 根据是否通过来获取当前用户所在教研室的课题
     *
     * @param httpSession 当前会话
     * @param modelMap    map集合，用于存放在jsp中需要取出的数据
     * @param page        当前页
     * @param rows        每页的数据
     * @param approve     是否通过,页面中的已通过和未通过都执行该方法
     * @return approveProjects/approveProjectOfTutor.jsp
     */
    @RequestMapping(value = "/approveProjectsOfTutor.html", method = RequestMethod.GET)
    public String approveProjectByTutor(String title, String tutorName, HttpSession httpSession, ModelMap modelMap, Integer page, Integer rows,
                                        Boolean approve, HttpServletRequest httpServletRequest) {


        /*// 获取当前的用户
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentTutor(httpSession).getId());
        //logger.error("department:" + tutor.getDepartment().getDescription());
        Page<GraduateProject> graduateProject;

        //用于存放查询条件
        HashMap<String, String> conditionMap = new HashMap<>();
        if (title != null) {
            conditionMap.put("title", title);
        }
        if (tutorName != null) {
            Tutor conditionTutor = tutorService.uniqueResult("name", tutorName);
            conditionMap.put("proposer", conditionTutor.toString());
        }
        // 根据当前的用户所在的教研室课题是否通过来获取教研室所有教师的课题

        graduateProject = graduateProjectService.getPageByAuditedDirectorAndCondition(conditionMap,tutor,
                    tutor.getDepartment(), page, rows, approve);*/

        /*// 调用帮助类中的方法将分页有关的属性添加到model中
        CommonHelper.pagingHelp(modelMap, graduateProject, "graduateProjectEvaluate", httpServletRequest.getRequestURI(), graduateProject.getTotalElements());
        // 用来判断当前页是否有数据
        modelMap.put("contentSize", graduateProject.getContent().size());*/
        return "approveProjects/approveProjectOfTutor";
    }

    /**
     * 获取需要审核的课题
     */
    @RequestMapping(value = "/approveProjectsOfTutorData.html", method = RequestMethod.POST)
    @ResponseBody
    public PageInfo getApproveProjectsData(String title, String tutorName, HttpSession httpSession, Integer page, Integer rows,
                                           Boolean approve) {

        PageInfo pageInfo = new PageInfo();

        try {
            // 获取当前的用户
            Tutor tutor = tutorService.findById(CommonHelper.getCurrentTutor(httpSession).getId());
            //logger.error("department:" + tutor.getDepartment().getDescription());
            Page<GraduateProject> graduateProject;

            //用于存放查询条件
            HashMap<String, String> conditionMap = new HashMap<>();
            if (title != null && !Objects.equals("", title)) {
                conditionMap.put("title", title);
            }
            if (tutorName != null) {
                Tutor conditionTutor = tutorService.uniqueResult("name", tutorName);
                if (conditionTutor != null) {
                    conditionMap.put("proposer", conditionTutor.toString());
                }
            }
            // 根据当前的用户所在的教研室课题是否通过来获取教研室所有教师的课题

            graduateProject = graduateProjectService.getPageByAuditedDirectorAndCondition(conditionMap, tutor,
                    tutor.getDepartment(), page, rows, approve);
            pageInfo.setRows(graduateProject.getContent());
            pageInfo.setTotal((int) graduateProject.getTotalElements());

        } catch (Exception e) {
            logger.error("获取需要审核的题目失败" + e);
            e.printStackTrace();
        }
        return pageInfo;
    }

    /**
     * 设置课题通过或退回的方法
     *
     * @param projectId   需要通过或退回的id
     * @param httpSession 当前会话，用于获取当前用户
     * @param ifApprove   是否通过
     */
    @RequestMapping(value = "/approveOrBack.html", method = RequestMethod.POST)
    @ResponseBody
    public Result approveOrBack(Integer projectId, HttpSession httpSession, Boolean ifApprove) {
        Result result = new Result();
        try {
            Tutor tutor = CommonHelper.getCurrentTutor(httpSession);
            // 获取通过或者退回的课题
            GraduateProject graduateProject = graduateProjectService.findById(projectId);
            // 得到当前课题的审核老师，如果没有则创建
            Audit audit = graduateProject.getAuditByDirector() == null ? new Audit() : graduateProject.getAuditByDirector();
            // 设置是否通过
            audit.setApprove(ifApprove);
            // 设置审核日期
            audit.setAuditDate(CommonHelper.getNow());
            // 设置审核者
            audit.setAuditor(tutor);
            // 因为当前的audit对象不确定是创建还是获取的，所以增加saveOrUpdate方法
            auditService.saveOrUpdate(audit);
            graduateProject.setAuditByDirector(audit);
            graduateProjectService.saveOrUpdate(graduateProject);
            if (ifApprove) {
                result.setMsg("课题已通过");
            } else {
                result.setMsg("课题已退回");
            }
            result.setSuccess(true);
            return result;
        } catch (Exception e) {
            if (ifApprove) {
                result.setMsg("课题通过失败");
            } else {
                result.setMsg("课题通过失败");
            }
            logger.error("课题通过或退回失败" + e);
            e.printStackTrace();
        }
        return result;

    }

    /**
     * 一键通过所有的课题
     *
     * @param httpSession 当前会话
     * @return 重定向到approveProjectByTutor方法
     */
    @RequestMapping(value = "/allApproveProject.html", method = RequestMethod.GET)
    public Result allApprove(HttpSession httpSession) {
        Result result = new Result();
        try {
            Tutor tutor = CommonHelper.getCurrentTutor(httpSession);
            // 获取当前用户所在教研室所有没有通过的课题
            Page<GraduateProject> graduateProjectPage = graduateProjectService.getPageByAuditedDirector(tutor,
                    tutor.getDepartment(), 1, Integer.MAX_VALUE, false);
            for (GraduateProject graduateProject : graduateProjectPage.getContent()) {
                Audit audit = null;
                //当前课题没有被审核
                if (graduateProject.getAuditByDirector() == null) {
                    audit = new Audit();
                    audit.setApprove(true);
                    audit.setAuditDate(CommonHelper.getNow());
                    audit.setAuditor(tutor);
                } else {
                    //当前课题已经被审核，但是未通过
                    audit = graduateProject.getAuditByDirector();
                    audit.setApprove(true);
                    audit.setAuditDate(CommonHelper.getNow());
                    audit.setAuditor(tutor);
                }
                //保存更新
                auditService.saveOrUpdate(audit);
                //关联审核的结果
                graduateProject.setAuditByDirector(audit);
                //更新数据
                graduateProjectService.update(graduateProject);
            }
            result.setMsg("一键通过成功");
            result.setSuccess(true);
            return result;
        } catch (Exception e) {
            logger.error("一键通过课题失败" + e);
            result.setMsg("一键通过课题失败");
            return result;
        }
    }
}
