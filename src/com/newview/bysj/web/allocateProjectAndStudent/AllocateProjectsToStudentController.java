package com.newview.bysj.web.allocateProjectAndStudent;

import com.newview.bysj.domain.GraduateProject;
import com.newview.bysj.domain.MainTutorage;
import com.newview.bysj.domain.Student;
import com.newview.bysj.domain.Tutor;
import com.newview.bysj.exception.MessageException;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.util.Result;
import com.newview.bysj.web.baseController.BaseController;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 给学生分配课题
 * Created 2016/3/1,13:24.
 * Author 张战.
 */
@Controller
@RequestMapping("process")
public class AllocateProjectsToStudentController extends BaseController {

    private static final Logger logger = Logger.getLogger(AllocateProjectsToStudentController.class);

    /**
     * 本方法有两个功能，给学生分配题目和获取已分配的学生
     *
     * @param modelMap       map集合，用于存储需要在jsp中获取的数据
     */
    @RequestMapping(value = "/allocateProjectsToStudents.html", method = RequestMethod.GET)
    public String allocateProjects(ModelMap modelMap, HttpServletRequest httpServletRequest) {

        modelMap.put("actionUrl", httpServletRequest.getRequestURI());
        //根据是否选择课题来跳转到不同的路径
        return "allocate/allocateProjectsToStudent";
    }


    /**
     * 获取已分配的课题
     */
    @RequestMapping("/getAllocatedProject.html")
    public String getAllocatedProjects(Model model, HttpSession httpSession) {
        Tutor tutor = CommonHelper.getCurrentTutor(httpSession);
        List<GraduateProject> graduateProjects = graduateProjectService.getAllProjectsByProposerIfStuentSelected(tutor, true);
        model.addAttribute("graduateProjectList", graduateProjects);
        model.addAttribute("graduateProjectSize", graduateProjects.size());
        return "allocate/allocatedProjectsToStudent";
    }


    /**
     * 获取未分配的课题
     */
    @RequestMapping(value = "/getProjects.html", method = RequestMethod.POST)
    @ResponseBody
    public List<GraduateProject> getAllocateProject(HttpSession httpSession) {
        Tutor tutor = CommonHelper.getCurrentTutor(httpSession);
        //根据学生是否已选择课题来获取相应的课题
        return graduateProjectService.getAllProjectsByProposerIfStuentSelected(tutor, false);
    }

    /**
     * 获取未分配的学生
     */
    @RequestMapping(value = "/getStudents.html", method = RequestMethod.POST)
    @ResponseBody
    public List<Student> getAllocateStudent(HttpSession httpSession, String ifSelected, QueryCondition queryCondition, String no, String name) {
        Tutor tutor = CommonHelper.getCurrentTutor(httpSession);
        Boolean selected = (ifSelected != null);
        //根据学生是否已经选择课题来获得对应的学生
        return studentService.getPagesByTutor(tutor, selected, queryCondition.getQuery(no, name));
        //modelMap.put("actionUrl", httpServletRequest.getRequestURI());
    }


    /**
     * 给学生分配题目的提交方法
     *
     * @param studentId           需要分配的学生的id
     * @param graduateProjectId   需要分配的题目的id
     */
    @RequestMapping(value = "/allocateProjectsToStudents.html", method = RequestMethod.POST)
    @ResponseBody
    public Result allocateProjects(Integer studentId, Integer graduateProjectId) {
        Result result = new Result();
        try {
            //获取对应的学生
            Student student = studentService.findById(studentId);
            //如果学生已经选择了课题，则抛出异常
            //建议对该异常进行处理，不应该让用户看到错误的详细信息。只让用户看到一个错误提示框或是友好的错误页面就可以
            if (student.getGraduateProject() != null) {
                throw new MessageException("该学生已经选择课题，不能重复选题");
            }
            //获取对应的课题
            GraduateProject graduateProject = graduateProjectService.findById(graduateProjectId);
            //学生和课题进行双向关联
            graduateProject.setStudent(student);
            graduateProjectService.update(graduateProject);
            //对更新状态进行保存
            graduateProjectService.save(graduateProject);
            student.setGraduateProject(graduateProject);
            studentService.update(student);
            //对更新状态进行保存
            studentService.save(student);
            //判断该课题是否有主指导，没有设置为题目的申报者
            if (graduateProject.getMainTutorage() == null) {
                MainTutorage mainTutorage = new MainTutorage();
                //关联课题
                mainTutorage.setGraduateProject(graduateProject);
                mainTutorage.setTutor(graduateProject.getProposer());
                mainTutorageService.save(mainTutorage);
                //获取唯一的结果
                //建议对方法语句进行异常处理
                mainTutorage = mainTutorageService.uniqueResult("graduateProject", GraduateProject.class, graduateProject);
                //对当前课题设置主指导
                graduateProject.setMainTutorage(mainTutorage);
                //更新数据库的信息
                graduateProjectService.update(graduateProject);
                //对更新状态进行保存
                graduateProjectService.save(graduateProject);
            }
            result.setMsg("分配题目成功");
            result.setSuccess(true);
            return result;
        } catch (Exception e) {
            logger.error("学生分配题目失败：" + e);
            result.setMsg("分配题目失败");
            return result;
        }
    }

    /**
     * 取消学生和课题的关联
     *
     * @param graduateProjectId   需要被需要取消的课题的id
     */
    @RequestMapping(value = "/cancelGraduateProject.html", method = RequestMethod.POST)
    @ResponseBody
    public Result cancelAllocatedProject(Integer graduateProjectId) {
        Result result = new Result();
        try {
            //根据id获取要取消匹配的课题
            GraduateProject cancelGraduateProject = graduateProjectService.findById(graduateProjectId);
            //获取与课题匹配的学生
            Student student = cancelGraduateProject.getStudent();
            //取消学生与课题的关联
            student.setGraduateProject(null);
            //更新数据库
            studentService.saveOrUpdate(student);
            //取消课题与学生的关联
            cancelGraduateProject.setStudent(null);
            //更新数据库
            graduateProjectService.saveOrUpdate(cancelGraduateProject);
            result.setMsg("取消关联成功");
            result.setSuccess(true);
            return result;
        } catch (Exception e) {
            logger.error("取消关联失败：" + e);
            e.printStackTrace();
            result.setMsg("取消关联失败");
            return result;
        }
    }
}
