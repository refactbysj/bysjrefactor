package com.newview.bysj.web.taskDocManage;

import com.newview.bysj.domain.Student;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.web.baseController.BaseController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;

@Controller
public class StudentTaskDocController extends BaseController {
    //学生查看任务书
    @RequestMapping("student/lookUpTaskDoc")
    public String lookUpTaskDoc(HttpSession httpSession, ModelMap modelMap) {
        //获得当前用户
        Student student = studentService.findById(((Student) CommonHelper.getCurrentActor(httpSession)).getId());
        if (student.getGraduateProject() == null) {
            modelMap.addAttribute("message", "未选择课题，请联系指导老师");
        } else if (student.getGraduateProject().getTaskDoc() != null) {
            modelMap.addAttribute("graduateProject", student.getGraduateProject());
            modelMap.addAttribute("studentClass", student.getStudentClass());
        } else {
            modelMap.addAttribute("message", "未下达任务书，请联系指导老师");
            return "student/openningReport/noOpenningReport";
        }
        return "student/taskDoc/lookUpTaskDoc";
    }


}
