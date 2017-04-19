package com.newview.bysj.web.studentOpenningReport;

import com.newview.bysj.domain.*;
import com.newview.bysj.exception.MessageException;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.util.PageInfo;
import com.newview.bysj.util.Result;
import com.newview.bysj.web.baseController.BaseController;
import org.apache.log4j.Logger;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;

//开题报告
@Controller
public class OpenningReportManageController extends BaseController {

    private static final Logger logger = Logger.getLogger(OpenningReportManageController.class);

    //审核开题报告的方法
    @RequestMapping("openningReportList")
    public String openningReportList(Model model, HttpSession httpSession) {
        //获取当前用户
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentActor(httpSession).getId());
        Boolean isAudit = constraintOfApproveOpenningReportService.isAbleToUpdateOpenningReport(tutor);
        model.addAttribute("isAudit", isAudit);
        return "openningReport/listOpenningReport";
    }

    //获取主指导审核的开题报告
    @RequestMapping("getOpenningReportsByTutor")
    @ResponseBody
    public PageInfo getByMainTutorage(HttpSession httpSession, Integer page, Integer rows) {
        PageInfo pageInfo = new PageInfo();
        //获取当前用户
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentActor(httpSession).getId());
        //筛选开题报告
        Page<PaperProject> paperProjects = paperProjectService.getPaperProjectByMainTutorage(tutor, page, rows);
        if (paperProjects != null && paperProjects.getSize() > 0) {
            pageInfo.setRows(paperProjects.getContent());
            pageInfo.setTotal((int) paperProjects.getTotalElements());
        }
        return pageInfo;
    }



    //获取教研室主任审核开题报告的所有课题
    @RequestMapping("getOpenningReportsByDirector")
    @ResponseBody
    public PageInfo getByDirector(HttpSession httpSession, Integer page, Integer rows) {
        PageInfo pageInfo = new PageInfo();
        //获取当前用户
        Tutor director = tutorService.findById(CommonHelper.getCurrentActor(httpSession).getId());
        //筛选开题报告
        Page<PaperProject> paperProjects = paperProjectService.getPaperProjectByDepartment(director, page, rows);
        if (paperProjects != null && paperProjects.getSize() > 0) {
            pageInfo.setRows(paperProjects.getContent());
            pageInfo.setTotal((int) paperProjects.getTotalElements());
        }
        return pageInfo;
    }


    //有教研室主任和指导老师两个角色的所有论文课题
    @RequestMapping("getOpenningReportsByTutorAndDirector")
    @ResponseBody
    public PageInfo getByDirectorAndTutor(HttpSession httpSession, Integer page, Integer rows, String title, Boolean approve) {
        PageInfo pageInfo = new PageInfo();
        //获取当前用户
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentActor(httpSession).getId());
        //筛选开题报告
        Page<PaperProject> paperProjects = paperProjectService.getPaperProjectByMainTutorageAndDepartmentAndCondition(tutor, page, rows, title, approve);
        if (paperProjects != null && paperProjects.getSize() > 0) {
            pageInfo.setRows(paperProjects.getContent());
            pageInfo.setTotal((int) paperProjects.getTotalElements());
        }
        return pageInfo;
    }


    //主指导审核
    @RequestMapping("auditOpenningReportByTutor.html")
    @ResponseBody
    public Result approvedByMainTutor(HttpSession httpSession, Boolean approve, Integer openningReportId) {
        Result result = new Result();
        try {
            //获取当前用户
            Tutor currentTutor = tutorService.findById(CommonHelper.getCurrentTutor(httpSession).getId());
            approvedByMainTutorage(currentTutor, openningReportId, approve);
            result.setMsg("审核成功");
            result.setSuccess(true);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("主指导审核失败" + e);
            result.setMsg("审核失败");
        }
        return result;
    }

    //教研室主任审核
    @RequestMapping("auditOpenningReportByDirector.html")
    @ResponseBody
    public Result approvedByDepartment(HttpSession httpSession, Integer openningReportId, Boolean approve) {
        Result result = new Result();
        try {
            //获取当前用户
            Tutor currentTutor = tutorService.findById(CommonHelper.getCurrentActor(httpSession).getId());
            approvedByDirector(currentTutor, openningReportId, approve);
            result.setMsg("审核成功");
            result.setSuccess(true);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("教研室主任审核失败" + e);
            result.setMsg("审核失败");
        }
        return result;
    }

    //教研室主任与主指导审核
    @RequestMapping("auditOpenningReportByDirectorAndDean.html")
    @ResponseBody
    public Result approvedByDirectorAndTutor(HttpSession httpSession, Boolean approve, Integer openningReportId) {
        Result result = new Result();
        try {
            //获取当前用户
            Tutor currentTutor = tutorService.findById(CommonHelper.getCurrentActor(httpSession).getId());
            approvedByDirector(currentTutor, openningReportId, approve);
            approvedByMainTutorage(currentTutor, openningReportId, approve);
            result.setSuccess(true);
            result.setMsg("审核成功");
        } catch (Exception e) {
            result.setMsg("审核失败");
            e.printStackTrace();
            logger.error("教研室主任与主指导审核失败" + e);
        }
        return result;
    }


    //修改教研室主任的audit
    private void approvedByDirector(Tutor currentTutor, Integer openningReportId, Boolean approved) {
        OpenningReport openningReport = openningReportService.findById(openningReportId);
        Audit auditByDirector = openningReport.getAuditByDepartmentDirector();
        //修改审核状态
        auditByDirector.setApprove(approved);
        //设置审核日期
        auditByDirector.setAuditDate(CommonHelper.getNow());
        //设置审核人
        auditByDirector.setAuditor(currentTutor);
        //更新审核对象
        auditService.update(auditByDirector);
        //保存更新后的对象
        auditService.save(auditByDirector);

    }

    //修改主指导的audit
    private void approvedByMainTutorage(Tutor currentTutor, Integer openningReportId, Boolean approved) {
        OpenningReport openningReport = openningReportService.findById(openningReportId);
        Audit audit = openningReport.getAuditByTutor();
        //修改审核状态
        audit.setApprove(approved);
        //设置审核日期
        audit.setAuditDate(CommonHelper.getNow());
        //设置审核人
        audit.setAuditor(currentTutor);
        //更新审核对象
        auditService.update(audit);
        //保存更新后的审核对象
        auditService.save(audit);
    }

    //下载开题报告
    @RequestMapping("downloadOpenningReport")
    public ResponseEntity<byte[]> download(Integer openningReportId, HttpSession httpSession) throws IOException {
        OpenningReport openningReport = openningReportService.findById(openningReportId);
        File file = new File(openningReport.getUrl());
        Student student = openningReport.getPaperProject().getStudent();
        String fileName = "开题报告-" + student.getNo() + "-" + student.getName() + "-" + file.getName();
        return CommonHelper.download(httpSession, openningReport.getUrl(), fileName);
    }

    //根据课题的id来下载
    @RequestMapping("downloadOpenningReportByGraduateProjectId")
    public ResponseEntity<byte[]> downloadByGraduateProjectId(Integer projectId, HttpSession httpSession) throws IOException {
        GraduateProject graduateProject = graduateProjectService.findById(projectId);
        PaperProject paperProject;
        if (graduateProject instanceof PaperProject) {
            paperProject = (PaperProject) graduateProject;
        } else {
            throw new MessageException("类型转换失败！");
        }

        Integer openningReportId;
        if (paperProject.getOpenningReport() != null) {
            openningReportId = paperProject.getOpenningReport().getId();
        } else {
            return null;
        }
        return this.download(openningReportId, httpSession);
    }
}
