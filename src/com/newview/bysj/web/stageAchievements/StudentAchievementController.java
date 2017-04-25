package com.newview.bysj.web.stageAchievements;

import com.newview.bysj.domain.GraduateProject;
import com.newview.bysj.domain.StageAchievement;
import com.newview.bysj.domain.Student;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.util.PageInfo;
import com.newview.bysj.util.Result;
import com.newview.bysj.web.baseController.BaseController;
import org.apache.log4j.Logger;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;


@Controller
public class StudentAchievementController extends BaseController {
    private static final Logger LOGGER = Logger.getLogger(StudentAchievementController.class);
    private static Integer num = 0;

    private Integer addNum() {
        num = num + 1;
        return num;
    }


    //上传阶段成果的方法
    @RequestMapping(value = "student/stageAchievements.html", method = RequestMethod.GET)
    public String uploadTaskDoc(HttpSession httpSession, ModelMap modelMap) {
        //当前学生
        Student student = studentService.findById(CommonHelper.getCurrentActor(httpSession).getId());
        //获取学生课题
        GraduateProject graduateProject = student.getGraduateProject();
        if (graduateProject == null) {
            modelMap.put("message", "未选择课题，请联系指导老师");
        }
        return "student/stageAchievement/stageAchievements";
    }

    @RequestMapping("student/getStageAchievementsData")
    //将内容或对象作为 HTTP 响应正文返回，并调用适合HttpMessageConverter的Adapter转换对象，写入输出流。
    @ResponseBody
    public PageInfo getUploadStudentAchievementData(HttpSession httpSession, ModelMap modelMap, Integer page, Integer rows, HttpServletRequest httpServletRequest) {
        PageInfo pageInfo = new PageInfo();
        //当前学生
        Student student = studentService.findById(CommonHelper.getCurrentActor(httpSession).getId());
        //获取学生课题
        GraduateProject graduateProject = student.getGraduateProject();
        //筛选阶段成果
        Page<StageAchievement> stageAchievements = stageAchievementService.getPageByGraduateProjects(graduateProject, page, rows);
        if (stageAchievements != null && stageAchievements.getSize() > 0) {
            pageInfo.setRows(stageAchievements.getContent());
            pageInfo.setTotal((int) stageAchievements.getTotalElements());
        }
        return pageInfo;
    }
     //上传调转页面
    @RequestMapping("student/toUploadStageAchievement.html")
    public String toUploadStageAchievement() {
        return "student/stageAchievement/upLoadStageAchievement";
    }

    //上传阶段成果
    @RequestMapping(value = "student/uploadStageAchievement.html", method = RequestMethod.POST)
    @ResponseBody
    public Result uploadStudentAchievement(HttpSession httpSession, HttpServletResponse httpServletResponse, MultipartFile stageAchievementFile) {
        Result result = new Result();
        try {
            //当前学生
            Student student = studentService.findById(CommonHelper.getCurrentActor(httpSession).getId());
            //获取课题
            GraduateProject graduateProject = student.getGraduateProject();
            String fileNameExtension = stageAchievementFile.getOriginalFilename().substring(stageAchievementFile.getOriginalFilename().lastIndexOf("."));
            String fileName = "阶段成果-" + student.getName() + student.getNo() +"-" + CommonHelper.getCurrentDateByPatter("yyyyMMdd") + fileNameExtension;
            String url = CommonHelper.fileUpload(stageAchievementFile, httpSession, "stageAchievement", "阶段成果-" + student.getName() + student.getNo() + CommonHelper.getCurrentDateByPatter("yyyyMMdd") + fileNameExtension);
            //新建阶段成果
            StageAchievement achievement = new StageAchievement();
            //设置基本信息
            achievement.setIssuedDate(CommonHelper.getNow());
            achievement.setGraduateProject(graduateProject);
            achievement.setNum(this.addNum());
            achievement.setFileName(fileName);
            achievement.setUrl(url);
            //更新
            stageAchievementService.saveOrUpdate(achievement);
            result.setSuccess(true);
            result.setMsg("上传阶段成果成功");
        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.error("上传阶段成果失败" + e);
            result.setMsg("上传阶段成果失败");
        }
        return result;
    }

    //删除阶段成果
    @RequestMapping(value = "student/deleteStageAchievement")
    @ResponseBody
    public Result delete(HttpSession httpSession, HttpServletResponse httpServletResponse, Integer stageAchievementId) {
        Result result = new Result();
        try{
            StageAchievement stageAchievement = stageAchievementService.findById(stageAchievementId);
            CommonHelper.delete(httpSession, stageAchievement.getUrl());
            stageAchievementService.deleteById(stageAchievementId);
            result.setSuccess(true);
            result.setMsg("删除阶段成果成功");
        } catch (Exception e) {
            LOGGER.error("删除阶段成果失败" + e);
            e.printStackTrace();
            result.setMsg("删除阶段成果失败");
        }
        return result;
    }

    //下载阶段成果
    @RequestMapping(value = "student/download/stageAchievement")
    public ResponseEntity<byte[]> download(Integer stageAchievementId, HttpSession httpSession) throws IOException {

        StageAchievement stageAchievement = stageAchievementService.findById(stageAchievementId);
        Student student = stageAchievement.getGraduateProject().getStudent();
        String extendName = stageAchievement.getFileName().substring(stageAchievement.getFileName().lastIndexOf("."));
        String fileName = "阶段成果" + student.getName() +"-"+ student.getNo() + extendName;
        return CommonHelper.download(httpSession, stageAchievement.getUrl(), fileName);
    }
}
