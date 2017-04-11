package com.newview.bysj.web.allocateProjectAndStudent;

import com.newview.bysj.domain.Student;
import com.newview.bysj.domain.Tutor;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.util.PageInfo;
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
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * 分配学生的controller
 * Created 2016/3/1,13:29.
 * Author 张战.
 */

@Controller
@RequestMapping("process")
public class AllocateStudentsController extends BaseController {

    private static final Logger logger = Logger.getLogger(AllocateStudentsController.class);

    /**
     * 教研室主任分配学生
     *
     * @param httpSession 当前会话，用于获取当月用户
     * @param modelMap    map集合，用于存放数据
     * @param queryMap    查询的集合条件
     * @param no          学生的学号
     * @param name        学生的姓名
     * @return jsp
     */
    @RequestMapping(value = "/allocateStudents.html", method = RequestMethod.GET)
    public String allocateStudent(HttpSession httpSession, Boolean hasTutor, ModelMap modelMap, QueryCondition queryMap, String no, String name, HttpServletRequest httpServletRequest) {
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentTutor(httpSession).getId());
        //此句多余，建议删除后测试一下。以确保没有问题
        hasTutor = (hasTutor != null);

        //将对应的查询条件添加到map中，便于在jsp的搜索框中显示搜索的信息
        /*if (no != null) {
            modelMap.put("no", no);
        }
        if (name != null) {
            modelMap.put("name", name);
        }*/
        //获取所有未分配或是已分配的学生
        //Collection<Student> studentList = studentService.getStudentsByDepartmentWithoutTutor(tutor.getDepartment(), hasTutor, queryMap.getQuery(no, name));
        //获取该教研室下所有的老师
        //Collection<Tutor> tutorList = tutor.getDepartment().getTutor();

        //将相应的信息添加到map集合中，便于在jsp获取
        //modelMap.put("studentList", studentList);
        //modelMap.put("tutorList", tutorList);
        //modelMap.put("studentCount", studentList.size());
        //modelMap.put("tutorCount", tutorList.size());
        modelMap.put("actionUrl", httpServletRequest.getRequestURI());
        return hasTutor ? "allocate/allocatedStudents" : "allocate/allocateStudents";
    }

    /**
     * 获取教研室所有未分配学生
     */
    @RequestMapping(value = "/getDepartStu.html", method = RequestMethod.POST)
    @ResponseBody
    public PageInfo getDepartmentStudent(HttpSession httpSession, Boolean hasTutor, QueryCondition queryMap, String no, String name) {
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentTutor(httpSession).getId());
        //获取所有未分配学生
        List<Student> studentList = studentService.getStudentsByDepartmentWithoutTutor(tutor.getDepartment(), hasTutor, queryMap.getQuery(no, name));
        PageInfo pageInfo = new PageInfo();
        if (studentList != null && studentList.size() > 0) {
            pageInfo.setRows(studentList);
            pageInfo.setTotal(studentList.size());
        }
        return pageInfo;
    }

    /**
     * 获取教研室所有已分配学生
     */
    @RequestMapping("/getDepartAllocatedStu.html")
    public String getDepartAllocatedStu(HttpSession httpSession, Model model) {
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentTutor(httpSession).getId());
        //获取所有未分配学生
        List<Student> studentList = studentService.getStudentsByDepartmentWithoutTutor(tutor.getDepartment(), true, null);
        List<Tutor> tutorList = tutor.getDepartment().getTutor();
        model.addAttribute("studentList", studentList);
        model.addAttribute("tutorList", tutorList);
        model.addAttribute("studentCount", studentList.size());
        return "allocate/allocatedStudents";
    }



    /**
     * 获取该教研室的老师
     */
    @RequestMapping(value = "getDepartmentTeacher.html", method = RequestMethod.POST)
    @ResponseBody
    public PageInfo getDepartTeacher(HttpSession httpSession) {
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentTutor(httpSession).getId());
        List<Tutor> tutorList = tutor.getDepartment().getTutor();
        PageInfo pageInfo = new PageInfo();
        if (tutorList != null && tutorList.size() > 0) {
            pageInfo.setRows(tutorList);
            pageInfo.setTotal(tutorList.size());
        }
        return pageInfo;
    }

    /**
     * 教研室主任分配学生提交的方法
     *
     * @param stuIds              需要分配的学生的id集合
     * @param tutorId             需要分配给老师的id
     * @param httpServletResponse 存储服务器对浏览器的响应消息，用于传递json数据
     */
    @RequestMapping(value = "/allocateStudents.html", method = RequestMethod.POST)
    public void allocateStudent(String stuIds, Integer tutorId, HttpServletResponse httpServletResponse) {
        //获取将学生分配给的哪一位老师
        Tutor tutor = tutorService.findById(tutorId);
        //获取分配学生的id的集合
        String[] ids = stuIds.split(",");
        //用于存放分配的学生
        List<Student> studentList = new ArrayList<>();
        Student student;
        for (String str : ids) {
            student = studentService.findById(Integer.parseInt(str));
            student.setTutor(tutor);
            studentService.saveOrUpdate(student);
            studentList.add(student);
        }
        tutor.setStudent(studentList);
        tutorService.saveOrUpdate(tutor);
        CommonHelper.buildSimpleJson(httpServletResponse);
    }

    /*public String allocatedStudent(ModelMap modelMap, HttpSession httpSession) {
        Tutor tutor = CommonHelper.getCurrentTutor(httpSession);
        return null;

    }
*/

    /**
     * 根据老师的id，得到老师对应的学生
     *
     * @param tutorId  需要列出学生的老师id
     * @param modelMap map集合，用于存储数据
     * @return jsp
     */
    @RequestMapping(value = "/getTutorOfStudent.html", method = RequestMethod.GET)
    public String getTutorStudent(Integer tutorId, ModelMap modelMap) {
        //用于在jsp页面中显示当前老师的所有学生中有几个已选择了课题
        Integer selectProject = 0;
        //获取对应的老师
        Tutor tutor = tutorService.findById(tutorId);
        //获取老师对应的学生
        List<Student> studentList = tutor.getStudent();
        modelMap.put("studentList", studentList);
        //用于在jsp中显示该老师有多少位学生
        modelMap.put("count", studentList.size());
        //判断学生是否已经选择了课题
        for (Student student : studentList) {
            if (student.getGraduateProject() != null) {
                selectProject++;
            }
        }
        modelMap.put("selectProject", selectProject);
        modelMap.put("tutor", tutor);
        return "allocate/showTutorStudent";
    }

    /**
     * 根据需要删除的多个学生的id字符串形式来删除学生
     *
     * @param stuIds 需要删除的学生的id集合
     */
    @RequestMapping(value = "/delStudents.html", method = RequestMethod.POST)
    @ResponseBody
    public Result delStudent(String stuIds) {
        Result result = new Result();
        try {
            //将字符串分隔成字符数组
            String[] strIds = stuIds.split(",");
            Student delStu;
            StringBuilder cannotDel = new StringBuilder();
            //遍历所有需要删除的学生
            for (String strId : strIds) {
                //获取需要取消匹配的学生
                delStu = studentService.findById(Integer.parseInt(strId));
                //如果学生已选择课题则不能删除
                if (delStu.getGraduateProject() != null) {
                    cannotDel.append(delStu.getName()).append(",");
                    continue;
                }
                //移除要删除的学生的集合
                delStu.getTutor().getStudent().remove(delStu);
                //将删除的学生的tutor置为空
                delStu.setTutor(null);
                //更新数据库
                studentService.saveOrUpdate(delStu);
            }
            result.setSuccess(true);
            //判断是否有 没有删除的学生
            if (Objects.equals("", cannotDel.toString())) {
                result.setMsg("删除成功");
            } else {
                String info = cannotDel.toString().substring(0, cannotDel.toString().length());
                result.setMsg("以下学生已分配课题，删除失败：" + info);
            }
            return result;
        } catch (Exception e) {
            logger.error("删除学生失败" + e);
            result.setMsg("删除失败");
            result.setSuccess(false);
            return result;
        }
    }
}
