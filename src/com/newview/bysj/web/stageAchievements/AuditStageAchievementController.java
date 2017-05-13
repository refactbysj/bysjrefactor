package com.newview.bysj.web.stageAchievements;

        import com.newview.bysj.domain.GraduateProject;
        import com.newview.bysj.domain.StageAchievement;
        import com.newview.bysj.domain.Student;
        import com.newview.bysj.domain.Tutor;
        import com.newview.bysj.helper.CommonHelper;
        import com.newview.bysj.util.PageInfo;
        import com.newview.bysj.util.Result;
        import com.newview.bysj.web.baseController.BaseController;
        import org.springframework.data.domain.Page;
        import org.springframework.http.ResponseEntity;
        import org.springframework.stereotype.Controller;
        import org.springframework.ui.ModelMap;
        import org.springframework.web.bind.annotation.RequestMapping;
        import org.springframework.web.bind.annotation.RequestMethod;
        import org.springframework.web.bind.annotation.ResponseBody;

        import javax.servlet.http.HttpServletRequest;
        import javax.servlet.http.HttpSession;
        import java.io.File;
        import java.io.IOException;

@Controller
public class AuditStageAchievementController extends BaseController {

    Integer graduateProjectId=null;

    //审阅各阶段成果的初界面
    @RequestMapping(value = "stageAchievements.html")
    public String toStageAchievement(Integer graduateProjectId) {
        this.graduateProjectId = graduateProjectId;
        return "stageAchievement/stageAchievementList";
    }

    @RequestMapping(value = "showStageAchievements")
    @ResponseBody
    public PageInfo approveAchievements(HttpSession httpSession, Integer page, Integer rows) {
        PageInfo pageInfo = new PageInfo();
        //获取当前用户
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentActor(httpSession).getId());
        //获取作为主指导的课题
        Page<GraduateProject> graduateProjects = graduateProjectService.getPageByMainTutorage(tutor, page, rows);
        System.out.println(graduateProjects);
        if (graduateProjects != null && graduateProjects.getSize() > 0) {
            pageInfo.setRows(graduateProjects.getContent());
            pageInfo.setTotal((int) graduateProjects.getTotalElements());
        }
        return pageInfo;
    }

    //调到审核阶段成果的详细界面,获取头部信息
    @RequestMapping("showAuditStageAchievement.html")
    public String toAuditStageAchievement(Integer graduateProjectId, ModelMap modelMap) {
        this.graduateProjectId = graduateProjectId;
        GraduateProject graduateProject = graduateProjectService.findById(graduateProjectId);
        modelMap.addAttribute("graduateProject", graduateProject);
        return "stageAchievement/auditStageAchievement";
    }

    //审核阶段成果的详细界面，获取表格信息
    @RequestMapping(value = "auditStageAchievement")
    @ResponseBody
    public PageInfo auditStageAchievement(Integer pageNo) {
        PageInfo pageInfo = new PageInfo();
        GraduateProject graduateProject = graduateProjectService.findById(graduateProjectId);
        //根据课题获取要审核的阶段成果
        Page<StageAchievement> stageAchievements = stageAchievementService.getPageByGraduateProjects(graduateProject, pageNo, 100);
        if (stageAchievements != null && stageAchievements.getSize() > 0) {
            pageInfo.setRows(stageAchievements.getContent());
            pageInfo.setTotal((int) stageAchievements.getTotalElements());
        }
        return pageInfo;
    }

    //填写审核阶段成果的评语
    @RequestMapping(value = "writeRemark", method = RequestMethod.GET)
    public String toWriteRemark(Integer stageAchievementId, ModelMap modelMap, HttpServletRequest httpServletRequest) {
        StageAchievement stageAchievement = stageAchievementService.findById(stageAchievementId);
        modelMap.put("remark", stageAchievement.getRemark());
        modelMap.put("stageAchievementId", stageAchievementId);
        return "stageAchievement/writeRemark";
    }
    @RequestMapping(value = "writeRemark", method = RequestMethod.POST)
    @ResponseBody
    public Result WriteRemark(String remark, Integer stageAchievementId) {
        Result result=new Result();
        StageAchievement stageAchievement = stageAchievementService.findById(stageAchievementId);
        stageAchievement.setRemark(remark);
        stageAchievementService.update(stageAchievement);
        //对更新状态进行保存
        stageAchievementService.save(stageAchievement);
        result.setMsg("添加成功");
        result.setSuccess(true);
        return result;
    }
    //修改审核状态的评语
    @RequestMapping(value = "editRemark", method = RequestMethod.GET)
    public String editRemark(Integer stageAchievementId, ModelMap modelMap) {
        StageAchievement stageAchievement = stageAchievementService.findById(stageAchievementId);
        modelMap.put("remark", stageAchievement.getRemark());
        modelMap.put("stageAchievementId", stageAchievementId);
        return "stageAchievement/writeRemark";
    }

    @RequestMapping(value = "editRemark", method = RequestMethod.POST)
    @ResponseBody
    public Result editRemark(Integer stageAchievementId, String remark) {
        Result result=new Result();
        //通过id找到对应的阶段成果
        StageAchievement stageAchievement = stageAchievementService.findById(stageAchievementId);
        //为该阶段成果设置评语
        stageAchievement.setRemark(remark);
        //更新该阶段成果
        stageAchievementService.update(stageAchievement);
        //对更新状态进行保存
        stageAchievementService.save(stageAchievement);
        result.setMsg("添加成功");
        result.setSuccess(true);
        return result;
    }

    //下载阶段成果
    @RequestMapping("download/stageAchievement")
    public ResponseEntity<byte[]> download(Integer stageAchievementId, HttpSession httpSession) throws IOException {
        Student student;
        String name;
        StageAchievement stageAchievement = stageAchievementService.findById(stageAchievementId);
        File file = new File(stageAchievement.getUrl());
        if (stageAchievement.getGraduateProject() != null) {
            if (stageAchievement.getGraduateProject().getStudent() != null) {
                student = stageAchievement.getGraduateProject().getStudent();
                name = file.getName().substring(0, file.getName().lastIndexOf(".")) + "——" + student.getNo() + "-" + student.getName() + file.getName().substring(file.getName().lastIndexOf("."));
            } else {
                name = file.getName().substring(0, file.getName().lastIndexOf(".")) + "——" + "未获取" + file.getName().substring(file.getName().lastIndexOf("."));
            }
        } else {
            name = file.getName().substring(0, file.getName().lastIndexOf(".")) + "——" + "未获取" + file.getName().substring(file.getName().lastIndexOf("."));
        }
        return CommonHelper.download(httpSession, stageAchievement.getUrl(), name);
    }
}
