package com.newview.bysj.web.taskDocManage;

import com.newview.bysj.domain.Audit;
import com.newview.bysj.domain.GraduateProject;
import com.newview.bysj.domain.TaskDoc;
import com.newview.bysj.domain.Tutor;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.util.PageInfo;
import com.newview.bysj.util.Result;
import com.newview.bysj.web.baseController.BaseController;
import org.apache.log4j.Logger;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Controller
public class ApproveTaskDocController extends BaseController {

    private static final Logger LOGGER = Logger.getLogger(ApproveTaskDocController.class);

    @RequestMapping("/approveTaskDoc")
    public String list() {

        return "taskDoc/approveTaskDoc";
    }

    //通过教研室主任获取任务书
    @RequestMapping("getTaskDocsByDirector")
    @ResponseBody
    public PageInfo getDocByDepartment(HttpSession httpSession, Integer page, Integer rows, Boolean approve, String title) {
        PageInfo pageInfo = new PageInfo();
        //获取当前用户
        Tutor director = tutorService.findById(CommonHelper.getCurrentActor(httpSession).getId());
        //获取教研室主任的任务书
        Page<TaskDoc> taskDoc = taskDocService.getAuditedTaskDocByDirector(director, approve, page, rows, title);
        pageInfo.setRows(this.getProjectByTask(taskDoc.getContent()));
        pageInfo.setTotal((int) taskDoc.getTotalElements());
        return pageInfo;
    }

    private List<GraduateProject> getProjectByTask(List<TaskDoc> taskDocList) {
        List<GraduateProject> graduateProjects = new ArrayList<>();
        if (taskDocList != null && taskDocList.size() > 0) {
            for (TaskDoc doc : taskDocList) {
                graduateProjects.add(doc.getGraduateProject());
            }
        }
        return graduateProjects;
    }

    //通过院长获取任务书
    @RequestMapping("getTaskDocsByDean")
    @ResponseBody
    public PageInfo getDocByDean(HttpSession httpSession, Integer page, Integer rows, Boolean approve, String title) {
        PageInfo pageInfo = new PageInfo();
        //获取当前用户
        Tutor Dean = tutorService.findById(CommonHelper.getCurrentActor(httpSession).getId());
        //获取院长的任务书
        Page<TaskDoc> taskDoc = taskDocService.getAuditedTaskDocByDean(Dean, approve, page, rows, title);
        pageInfo.setRows(this.getProjectByTask(taskDoc.getContent()));
        pageInfo.setTotal((int) taskDoc.getTotalElements());
        return pageInfo;
    }

    //通过院长，教研室主任获取任务书
    @RequestMapping("getTaskDocsByDirectorAndDean")
    @ResponseBody
    public PageInfo getDocByDepartmentandDean(HttpSession httpSession, Integer page, Integer rows, Boolean approve, String title) {
        PageInfo pageInfo = new PageInfo();
        //获取当前用户
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentActor(httpSession).getId());
        //获取院长教研室主任的任务书
        Page<TaskDoc> taskDoc = taskDocService.getAuditedTaskDocByDirectorAndDean(tutor, approve, page, rows, title);
        pageInfo.setRows(this.getProjectByTask(taskDoc.getContent()));
        pageInfo.setTotal((int) taskDoc.getTotalElements());
        return pageInfo;
    }

    //教研室主任审核通过
    @RequestMapping(value = "approveTaskDocByDepartment.html")
    @ResponseBody
    public Result approvedByDirector(HttpSession httpSession, Integer taskDocId) {
        Result result = new Result();
        try {
            //获取当前用户
            Tutor tutor = tutorService.findById(CommonHelper.getCurrentTutor(httpSession).getId());
            updateApprovedByDirector(taskDocId, tutor, true);
            result.setSuccess(true);
            result.setMsg("审核成功");
        } catch (Exception e) {
            result.setMsg("审核失败");
            e.printStackTrace();
            LOGGER.error("审核失败" + e);
        }
        return result;

    }

    //院长审核通过
    @RequestMapping(value = "approveTaskDocByDean.html")
    @ResponseBody
    public Result approvedByDean(HttpSession httpSession, Integer taskDocId) {
        Result result = new Result();
        try {
            //获取当前用户
            Tutor tutor = tutorService.findById(CommonHelper.getCurrentActor(httpSession).getId());
            updateApprovedByDean(taskDocId, tutor, true);
            result.setSuccess(true);
            result.setMsg("审核成功");
        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.error("审核失败" + e);
            result.setMsg("审核失败");
        }
        return result;

    }

    //教研室主任和院长审核通过
    @RequestMapping(value = "approveTaskDocByDirectorAndDean.html")
    @ResponseBody
    public Result approvedByDirectorAndDean(HttpSession httpSession, Integer taskDocId) {
        Result result = new Result();
        try {
            //获取当前用户
            Tutor tutor = tutorService.findById(CommonHelper.getCurrentActor(httpSession).getId());
            updateApprovedByDirector(taskDocId, tutor, true);
            updateApprovedByDean(taskDocId, tutor, true);
            result.setSuccess(true);
            result.setMsg("审核成功");
        } catch (Exception e) {
            result.setMsg("审核失败");
            e.printStackTrace();
            LOGGER.error("审核失败" + e);
        }
        return result;
    }

    //教研室主任退回
    @RequestMapping("rejectTaskDocByDepartment.html")
    @ResponseBody
    public Result rejectByDirector(HttpSession httpSession, Integer taskDocId) {
        Result result = new Result();
        try {
            //获取当前用户
            Tutor tutor = tutorService.findById(CommonHelper.getCurrentTutor(httpSession).getId());
            updateApprovedByDirector(taskDocId, tutor, false);
            result.setSuccess(true);
            result.setMsg("退回成功");
        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.error("教研室主任退回任务书失败" + e);
            result.setMsg("退回失败");

        }
        return result;

    }

    //院长退回
    @RequestMapping("rejectTaskDocByDean")
    public Result rejectByDean(HttpSession httpSession, Integer taskDocId) {
        Result result = new Result();
        try {
            //获取当前用户
            Tutor tutor = tutorService.findById(CommonHelper.getCurrentActor(httpSession).getId());
            updateApprovedByDean(taskDocId, tutor, false);
            result.setSuccess(true);
            result.setMsg("退回成功");
        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.error("院长退回任务书失败" + e);
            result.setMsg("退回失败");
        }
        return result;
    }

    //院长教研室主任退回
    @RequestMapping(value = "rejectTaskDocByDirectorAndDean.html")
    @ResponseBody
    public Result rejectByDirectorAndDean(HttpSession httpSession, Integer taskDocId) {
        Result result = new Result();
        try {
            //获取当前用户
            Tutor tutor = tutorService.findById(CommonHelper.getCurrentActor(httpSession).getId());
            updateApprovedByDirector(taskDocId, tutor, false);
            updateApprovedByDean(taskDocId, tutor, false);
            result.setSuccess(true);
            result.setMsg("退回成功");
        } catch (Exception e) {
            result.setMsg("退回失败");
            e.printStackTrace();
            LOGGER.error("院长退回任务书失败" + e);
        }
        return result;
    }

    //修改院长的audit
    private void updateApprovedByDean(Integer taskDocId, Tutor tutor, Boolean approve) {
        //获取要审核的任务书
        TaskDoc taskDoc = taskDocService.findById(taskDocId);
        Audit auditByDean = taskDoc.getAuditByBean();
        //修改审核状态
        auditByDean.setApprove(approve);
        //修改审核日期
        auditByDean.setAuditDate(CommonHelper.getNow());
        //修改审核人
        auditByDean.setAuditor(tutor);
        //更新审核状态
        auditService.update(auditByDean);
        //对更新状态进行保存
        auditService.save(auditByDean);
    }

    //修改教研室主任的audit
    private void updateApprovedByDirector(Integer taskDocId, Tutor tutor, Boolean approve) {
        //获取要审核的任务书
        TaskDoc taskDoc = taskDocService.findById(taskDocId);
        Audit auditByDirector = taskDoc.getAuditByDepartmentDirector();
        //修改审核状态
        auditByDirector.setApprove(approve);
        //设置审核日期
        auditByDirector.setAuditDate(CommonHelper.getNow());
        //设置审核人
        auditByDirector.setAuditor(tutor);
        //更新审核状态
        auditService.update(auditByDirector);
        //对更新的审核状态进行保存
        auditService.save(auditByDirector);
    }

}
