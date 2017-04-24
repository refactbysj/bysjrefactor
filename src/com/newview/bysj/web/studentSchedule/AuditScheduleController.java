package com.newview.bysj.web.studentSchedule;

import com.newview.bysj.domain.Audit;
import com.newview.bysj.domain.GraduateProject;
import com.newview.bysj.domain.Schedule;
import com.newview.bysj.domain.Tutor;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.util.PageInfo;
import com.newview.bysj.web.baseController.BaseController;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class AuditScheduleController extends BaseController {
    Integer graduateProjectId=null;
    Integer scheduleId=null;

    //转到毕业设计审核工作进程表的页面
    @RequestMapping("/process/checkStudentSchedule.html")
    public String showScheduleProject(){
        return "scheduleProject/scheduleOfProject";
    }
    //审核工作进程表的信息
    @RequestMapping("/process/scheduleProjectList.html")
    @ResponseBody
    public PageInfo scheduleProject(HttpSession httpSession, HttpServletRequest httpServletRequest, ModelMap modelMap, Integer page, Integer rows) {
        PageInfo pageInfo = new PageInfo();
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentActor(httpSession).getId());
        Page<GraduateProject> graduateProject = graduateProjectService.getPageByMainTutorage(tutor, page, rows);
        pageInfo.setRows(graduateProject.getContent());
        pageInfo.setTotal((int)graduateProject.getTotalElements());
        modelMap.put("actionUrl", httpServletRequest.getRequestURI());
        //CommonHelper.pagingHelp(modelMap, graduateProject, "graduateProjects", CommonHelper.getRequestUrl(httpServletRequest), graduateProject.getTotalElements());
        return pageInfo;
    }


    //调到显示需要审核的工作进程表细节页面
    @RequestMapping("/process/showDetailSchedules.html")
    public String toDetailSchedule(Integer graduateProjectId) {

        this.graduateProjectId = graduateProjectId;
        return "scheduleProject/showDetailSchedule";
    }
    @RequestMapping("/process/DetailSchedulesList.html")
    @ResponseBody
    public PageInfo showDetailSchedule(ModelMap modelMap, HttpServletRequest httpServletRequest, Integer page, Integer rows) {
        PageInfo pageInfo = new PageInfo();
        //获取需要审核的工作进程表
        Page<Schedule> schedule = scheduleService.getPageByGraduateProject(graduateProjectId, page, rows);
        pageInfo.setRows(schedule.getContent());
        pageInfo.setTotal((int)schedule.getTotalElements());
        modelMap.put("actionUrl", httpServletRequest.getRequestURI());
        //CommonHelper.pagingHelp(modelMap, schedule, "schedules", CommonHelper.getRequestUrl(httpServletRequest), schedule.getTotalElements());
        return pageInfo;
    }


    /**
     * 添加或修改工作进程表的post方法
     *
     * @param scheduleId 修改的进程表的id
     * @param content    评价的内容
     */
    @RequestMapping(value = "process/addOrEditScheduleRemark.html", method = RequestMethod.POST)
    public String addOrEditScheduleRemark(ModelMap modelMap, HttpSession httpSession,Integer scheduleId, String content) {
        Tutor auditor = tutorService.findById(CommonHelper.getCurrentActor(httpSession).getId());
        Schedule schedule = scheduleService.findById(scheduleId);
        //添加审核对象
        if (schedule.getAudit() == null) {
            Audit audit = new Audit();
            audit.setAuditor(auditor);
            schedule.setAudit(audit);
            //更新schedule
            scheduleService.update(schedule);
            //对更新状态进行保存
            scheduleService.save(schedule);
        }

        Audit audit = schedule.getAudit();
        audit.setApprove(null);
        audit.setRemark(null);
        audit.setAuditDate(null);
        audit.setApprove(true);
        audit.setRemark(content);
        audit.setAuditDate(CommonHelper.getNow());
        //更新audit
        auditService.update(audit);
        //对更新后的状态进行保存
        auditService.save(audit);
        //CommonHelper.buildSimpleJson(httpServletResponse);
        return "redirect:/process/checkStudentSchedule.html";
    }
}
