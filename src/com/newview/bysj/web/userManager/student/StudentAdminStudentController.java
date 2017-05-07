package com.newview.bysj.web.userManager.student;

import com.newview.bysj.domain.Contact;
import com.newview.bysj.domain.Employee;
import com.newview.bysj.domain.Student;
import com.newview.bysj.domain.User;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.util.PageInfo;
import com.newview.bysj.util.Result;
import com.newview.bysj.web.baseController.BaseController;
import org.apache.log4j.Logger;
import org.springframework.data.domain.Page;
import org.springframework.security.web.servletapi.SecurityContextHolderAwareRequestWrapper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("usersManage")
public class StudentAdminStudentController extends BaseController {

    private static final Logger LOGGER = Logger.getLogger(StudentAdminStudentController.class);

    @RequestMapping("/student")
    public String list(Model model, SecurityContextHolderAwareRequestWrapper wrapper, HttpSession httpSession) {
        //获取当前用户
        Employee employee = employeeService.findById((CommonHelper.getCurrentActor(httpSession)).getId());
        //最高角色是教研室主任
        if (wrapper.isUserInRole("ROLE_DEPARTMENT_DIRECTOR") &&
                !wrapper.isUserInRole("ROLE_SCHOOL_ADMIN") &&
                !wrapper.isUserInRole("ROLE_COLLEGE_ADMIN")) {
            model.addAttribute("majorList", employee.getDepartment().getMajor());
        }
        //最高角色是院级管理员
        else if (wrapper.isUserInRole("ROLE_SCHOOL_ADMIN") &&
                !wrapper.isUserInRole("ROLE_COLLEGE_ADMIN")) {
            model.addAttribute("departmentList", employee.getDepartment().getSchool().getDepartment());
        }
        //最高角色是校级管理员
        else if (wrapper.isUserInRole("ROLE_COLLEGE_ADMIN")) {
            model.addAttribute("schoolList", schoolService.findAll());
        }
        return "usersManage/student/studentList";
    }

    //最高角色是教研室主任
    @RequestMapping("/department/student")
    @ResponseBody
    public PageInfo departmentStudent(Integer page, Integer rows,
                                      String no, String name, Integer schoolId, Integer departmentId, Integer studentClassId) {
        PageInfo pageInfo = new PageInfo();
        //获取当前用户
        //Employee employee = employeeService.findById((CommonHelper.getCurrentActor(httpSession)).getId());
        //获取该用户教研室下的所有学生
        Page<Student> students = searchStudentList(no, name, schoolId, departmentId, studentClassId, page, rows);
        if (students != null && students.getSize() > 0) {
            pageInfo.setRows(students.getContent());
            pageInfo.setTotal((int) students.getTotalElements());
        }
        //为了列出查询所需的班级
        return pageInfo;
    }

    //最高角色是院级管理员
    @RequestMapping("/school/student")
    @ResponseBody
    public PageInfo schoolStudent(String no,
                                  String name, Integer schoolId, Integer departmentSelect, Integer studentClassSelect, Integer page, Integer rows) {
        PageInfo pageInfo = new PageInfo();
        //获取当前用户
        //Employee employee = employeeService.findById((CommonHelper.getCurrentActor(httpSession)).getId());
        //获取该用户学院下的所有学生
        Page<Student> students = searchStudentList(no, name, schoolId, departmentSelect, studentClassSelect, page, rows);
        if (students != null) {
            pageInfo.setRows(students.getContent());
            pageInfo.setTotal((int) students.getTotalElements());
        }
        return pageInfo;
    }

    //最高角色是校级管理员
    @RequestMapping("/college/student")
    @ResponseBody
    public PageInfo collegeStudent(Integer page, Integer rows, String no,
                                   String name, Integer schoolSelect, Integer departmentSelect, Integer studentClassSelect) {
        PageInfo pageInfo = new PageInfo();
        //Employee employee = employeeService.findById((CommonHelper.getCurrentActor(httpSession)).getId());
        //获取该用户学校的所有学生
        Page<Student> students = searchStudentList(no, name, schoolSelect, departmentSelect, studentClassSelect, page, rows);
        if (students != null) {
            pageInfo.setRows(students.getContent());
            pageInfo.setTotal((int) students.getTotalElements());
        }
        return pageInfo;
    }

    //教研室主任添加学生
    @RequestMapping(value = "/department/studentAdd.html", method = RequestMethod.GET)
    public String addStudentByDepartment(HttpServletRequest request, ModelMap modelMap) {
        //获取当前用户
        //Employee employee = employeeService.findById((CommonHelper.getCurrentActor(httpSession)).getId());
        prepareAddModel(request, modelMap);
        return "usersManage/student/addOrEditStudent";

    }

    //院级管理员添加
    @RequestMapping(value = "/school/studentAdd.html", method = RequestMethod.GET)
    public String addStudentBySchool(HttpServletRequest request, ModelMap modelMap) {
        //获取当前用户
        //Employee employee = employeeService.findById((CommonHelper.getCurrentActor(httpSession)).getId());
        prepareAddModel(request, modelMap);
        return "usersManage/student/addOrEditStudent";
    }

    //校级管理员添加
    @RequestMapping(value = "/college/studentAdd.html", method = RequestMethod.GET)
    public String addStudentByCollege(HttpServletRequest request, ModelMap modelMap) {
        //获取当前用户
        // Employee employee = employeeService.findById((CommonHelper.getCurrentActor(httpSession)).getId());
        prepareAddModel(request, modelMap);
        return "usersManage/student/addOrEditStudent";
    }

    //添加学生
    @RequestMapping(value = "/department/studentAdd.html", method = RequestMethod.POST)
    @ResponseBody
    public Result departmentAddStudent(@ModelAttribute("student") Student student, Integer studentClassSelect) {
        Result result = new Result();
        try {
            addOrEditStudent(student, studentClassSelect);
            result.setSuccess(true);
            result.setMsg("添加成功");
        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.error("添加失败");
            result.setMsg("添加失败");
        }

        return result;
    }

    //添加学生
    @RequestMapping(value = "/school/studentAdd.html", method = RequestMethod.POST)
    @ResponseBody
    public Result schoolAddStudent(@ModelAttribute("student") Student student, Integer studentClassSelect) {
        Result result = new Result();
        try {
            addOrEditStudent(student, studentClassSelect);
            result.setSuccess(true);
            result.setMsg("添加成功");
        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.error("添加失败" + e);
            result.setMsg("添加失败");
        }
        return result;
    }

    //添加学生
    @RequestMapping(value = "/college/studentAdd.html", method = RequestMethod.POST)
    @ResponseBody
    public Result collegeAddStudent(@ModelAttribute("student") Student student, Integer studentClassSelect) {
        Result result = new Result();
        try {
            addOrEditStudent(student, studentClassSelect);
            result.setSuccess(true);
            result.setMsg("添加成功");
        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.error("添加失败" + e);
            result.setMsg("添加失败");
        }
        return result;
    }

    //教研室主任修改学生
    @RequestMapping("/department/studentEdit.html")
    public String editStudentByDepartment(HttpServletRequest request, ModelMap modelMap, Integer studentId) {
        Student student = studentService.findById(studentId);
        prepareEditModel(request, modelMap, student);
        return "usersManage/student/addOrEditStudent";
    }

    //院级管理员修改学生
    @RequestMapping("/school/studentEdit.html")
    public String editStudentBySchool(HttpServletRequest request, ModelMap modelMap, Integer studentId) {
        Student student = studentService.findById(studentId);
        prepareEditModel(request, modelMap, student);
        return "usersManage/student/addOrEditStudent";
    }

    //校级管理员修改学生
    @RequestMapping("/college/studentEdit.html")
    public String editStudentByCollege(HttpServletRequest request, ModelMap modelMap, Integer studentId) {
        Student student = studentService.findById(studentId);
        prepareEditModel(request, modelMap, student);
        return "usersManage/student/addOrEditStudent";
    }

    //修改学生
    @RequestMapping(value = "/department/studentEdit.html", method = RequestMethod.POST)
    @ResponseBody
    public Result editStudentByDepartment(Student student, Integer studentClassSelect) {
        Result result = new Result();
        try {
            addOrEditStudent(student, studentClassSelect);
            result.setSuccess(true);
            result.setMsg("修改成功");
        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.error("修改失败" + e);
            result.setMsg("修改失败");
        }
        return result;

    }

    //修改学生
    @RequestMapping(value = "/school/studentEdit.html", method = RequestMethod.POST)
    @ResponseBody
    public Result editStudentBySchool(Student student, Integer studentClassSelect) {
        Result result = new Result();
        try {
            addOrEditStudent(student, studentClassSelect);
            result.setSuccess(true);
            result.setMsg("修改成功");
        } catch (Exception e) {
            e.printStackTrace();
            result.setMsg("修改失败");
            LOGGER.error("修改失败" + e);
        }
        return result;
    }

    //修改学生
    @RequestMapping(value = "/college/studentEdit.html", method = RequestMethod.POST)
    @ResponseBody
    public Result editStudentByCollege(Student student, Integer studentClassSelect) {
        Result result = new Result();
        try {
            addOrEditStudent(student, studentClassSelect);
            result.setSuccess(true);
            result.setMsg("修改成功");
        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.error("修改失败" + e);
            result.setMsg("修改失败");
        }
        return result;

    }

    private void prepareEditModel(HttpServletRequest request, ModelMap modelMap, Student student) {
        modelMap.addAttribute("student", student);
        modelMap.addAttribute("departmentList", departmentService.findAll());
        modelMap.addAttribute("studentClassList", studentClassService.findAll());
        modelMap.addAttribute("postActionUrl", CommonHelper.getRequestUrl(request));
        modelMap.addAttribute("schoolList", schoolService.findAll());
    }

    private void addOrEditStudent(Student student, Integer studentClassId) {
        Student studentReady;
        if (student.getId() == null) {
            studentReady = student;
            studentService.saveStudent(studentReady);
            //获取保存的studentReady否则更新studentReady会出错
            studentReady = studentService.uniqueResult("no", student.getNo());

        } else {
            studentReady = studentService.findById(student.getId());

            studentReady.setName(student.getName());
            studentReady.setNo(student.getNo());
            studentReady.setSex(student.getSex());

            if (studentReady.getContact() == null) {
                Contact contact = new Contact();
                contact.setEmail(student.getContact().getEmail());
                contact.setMoblie(student.getContact().getMoblie());
                contact.setQq(student.getContact().getQq());
                studentReady.setContact(contact);
            } else {
                studentReady.getContact().setEmail(student.getContact().getEmail());
                studentReady.getContact().setMoblie(student.getContact().getMoblie());
                studentReady.getContact().setQq(student.getContact().getQq());
            }
        }
        studentReady.setStudentClass(studentClassService.findById(studentClassId));
        studentService.saveOrUpdate(studentReady);
    }

    private void prepareAddModel(HttpServletRequest request, ModelMap modelMap) {
        modelMap.addAttribute("postActionUrl", CommonHelper.getRequestUrl(request));
        modelMap.addAttribute("schoolList", schoolService.findAll());
        modelMap.addAttribute("student", new Student());
    }

    private Page<Student> searchStudentList(String studentNo, String studentName, Integer schoolId, Integer departmentId, Integer classId, Integer pageNo, Integer pageSize) {
        Page<Student> students;
        if (schoolId == null || schoolId == 0) schoolId = 0;
        if (departmentId == null || departmentId == 0) departmentId = 0;
        //if(majorId == null||majorId ==0) majorId = 0;
        if (classId == null || classId == 0) classId = 0;
        if (schoolId == 0) {
            students = studentService.getStudents(studentNo, studentName, pageNo, pageSize);
        } else {
            if (classId != 0) {
                students = studentService.getStudentByStudentClass(studentNo, studentName, classId, pageNo, pageSize);
            } else {
                if (departmentId != 0) {
                    students = studentService.getStudentByDepartment(studentNo, studentName, departmentId, pageNo, pageSize);
                } else {
                    students = studentService.getStudentBySchool(studentNo, studentName, schoolId, pageNo, pageSize);
                }
            }
        }
        return students;
    }

    //删除学生
    @RequestMapping("/deleteStudent.html")
    @ResponseBody
    public Result deleteStudent(Integer studentId) {
        Result result = new Result();
        try {
            Student student = studentService.findById(studentId);
            studentService.deleteStudent(student);
            result.setSuccess(true);
            result.setMsg("删除成功");
        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.error("删除失败" + e);
            result.setMsg("删除失败");
        }

        return result;
    }

    //重置密码
    @RequestMapping("/resetPassword")
    @ResponseBody
    public Result resetPassword(Integer studentId) {
        Result result = new Result();
        try {
            Student student = studentService.findById(studentId);
            User user = student.getUser();
            user.setPassword(CommonHelper.makeMD5(student.getNo()));
            userService.saveOrUpdate(user);
            result.setSuccess(true);
            result.setMsg("重置成功");
        } catch (Exception e) {
            result.setMsg("重置失败");
            e.printStackTrace();
            LOGGER.error("重置失败" + e);
        }

        return result;
    }

}
