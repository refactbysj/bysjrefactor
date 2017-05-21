package com.newview.bysj.web.baseInfoManage;

import com.newview.bysj.domain.*;
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
import java.util.List;
import java.util.Objects;

@Controller
@RequestMapping("usersManage")
public class UsersManageController extends BaseController {

    private static final Logger logger = Logger.getLogger(UsersManageController.class);

    @RequestMapping("/universityAdmin/role")
    public String list(ModelMap modelMap, Integer pageNo, Integer pageSize) {
        modelMap.put("pageNo", pageNo);
        modelMap.put("pageSize", pageSize);
        //跳转到相应的jsp进行角色判断
        return "baseInfoManage/redirectUniversityAdminToRole";
    }

    //根据教研室主任获取专业
    @RequestMapping("/department/getTitle")
    public String getTitleByDepartment() {
        return "baseInfoManage/listMajor";
    }

    @RequestMapping("/department/getData")
    @ResponseBody
    public PageInfo getMajorsByDepartment(HttpSession httpSession, Integer page, Integer rows,String departmentId) {
        PageInfo pageInfo = new PageInfo();

        if (departmentId != null && !Objects.equals("", departmentId)) {
            Department department = departmentService.findById(Integer.valueOf(departmentId));
            List<Major> majors =  department.getMajor();
            pageInfo.setRows(majors);
            pageInfo.setTotal(majors.size());
        }else{
            Employee employee = employeeService.findById(( CommonHelper.getCurrentActor(httpSession)).getId());
            Page<Major> majors = majorService.getMajorByDepartment(employee.getDepartment(), page, rows);
            if (majors != null) {
                pageInfo.setRows(majors.getContent());
                pageInfo.setTotal((int) majors.getTotalElements());
            }
        }

        return pageInfo;
    }

    //根据院级管理员获取教研室
    @RequestMapping("/school/getTitle")
    public String getTitleBySchool() {
        return "baseInfoManage/listDepartment";
    }

    //根据学院获取教研室
    @RequestMapping("/school/getData")
    @ResponseBody
    public PageInfo getDepartmentsBySchool(HttpSession httpSession, Integer page, Integer rows,String schoolId) {
        PageInfo pageInfo = new PageInfo();
        if (schoolId != null && !Objects.equals("", schoolId)) {
            School school = schoolService.findById(Integer.valueOf(schoolId));
            if (school != null) {
                List<Department> departments = school.getDepartment();
                pageInfo.setTotal(departments.size());
                pageInfo.setRows(departments);
            }
        }else{
            Employee employee = employeeService.findById(( CommonHelper.getCurrentActor(httpSession)).getId());
            Page<Department> departments = departmentService.getDepartmentBySchool(employee.getDepartment().getSchool(), page, rows);
            if (departments != null) {
                pageInfo.setTotal((int) departments.getTotalElements());
                pageInfo.setRows(departments.getContent());
            }
        }

        return pageInfo;
    }

    //根据校级管理员获取学院
    @RequestMapping("/college/getTitle")
    public String getTitleByCollege() {
        return "baseInfoManage/listSchool";
    }

    @RequestMapping(value = "/college/getData",method = RequestMethod.POST)
    @ResponseBody
    public PageInfo getCollege(Integer page, Integer rows) {
        PageInfo pageInfo = new PageInfo();
        Page<School> school = schoolService.pageQuery(page, rows);
        if (school != null) {
            pageInfo.setRows(school.getContent());
            pageInfo.setTotal((int) school.getTotalElements());
        }
        return pageInfo;
    }

    //添加学院
    @RequestMapping(value = "/addSchool.html", method = RequestMethod.GET)
    public String addSchool(HttpServletRequest httpServletRequest, ModelMap modelMap) {
        modelMap.addAttribute("postActionUrl", CommonHelper.getRequestUrl(httpServletRequest));
        return "baseInfoManage/addorEditSchool";
    }

    @RequestMapping(value = "/addSchool", method = RequestMethod.POST)
    @ResponseBody
    public Result addSchool(String description) {
        Result result = new Result();
        try {
            School school = new School();
            school.setDescription(description);
            schoolService.save(school);
            result.setSuccess(true);
            result.setMsg("添加成功");
        } catch (Exception e) {
            e.printStackTrace();
            result.setMsg("添加失败");
            logger.error("添加失败" + e);
        }
        return result;
    }

    //添加教研室
    @RequestMapping(value = "/addDepartment", method = RequestMethod.GET)
    public String addDepartment(HttpServletRequest httpServletRequest, ModelMap modelMap, Integer schoolId) {
        modelMap.addAttribute("school", schoolService.findById(schoolId));
        modelMap.addAttribute("postActionUrl", CommonHelper.getRequestUrl(httpServletRequest));
        return "baseInfoManage/addorEditDepartment";
    }

    @RequestMapping(value = "/addDepartment", method = RequestMethod.POST)
    @ResponseBody
    public Result addDepartment( String description, Integer schoolId) {
        Result result = new Result();
        try {
            School school = schoolService.findById(schoolId);
            Department department = new Department();
            department.setDescription(description);
            department.setSchool(school);
            departmentService.save(department);
            result.setSuccess(true);
            result.setMsg("添加成功");
        } catch (Exception e) {
            e.printStackTrace();
            result.setMsg("添加失败");
            logger.error("添加失败" + e);
        }
        return result;
    }

    //添加专业
    @RequestMapping(value = "/addMajor", method = RequestMethod.GET)
    public String addMajor(HttpServletRequest httpServletRequest, ModelMap modelMap, Integer departmentId,HttpSession httpSession) {
        if (departmentId != null && !Objects.equals("", departmentId)) {
            modelMap.addAttribute("department", departmentService.findById(departmentId));
        }else{
            Employee employee = employeeService.findById(( CommonHelper.getCurrentActor(httpSession)).getId());
            modelMap.addAttribute("department", employee.getDepartment());
        }

        modelMap.addAttribute("postActionUrl", CommonHelper.getRequestUrl(httpServletRequest));
        return "baseInfoManage/addorEditMajor";
    }

    @RequestMapping(value = "/addMajor", method = RequestMethod.POST)
    @ResponseBody
    public Result addMajor(String description, Integer departmentId) {
        Result result = new Result();
        try {
            Major major = new Major();
            major.setDescription(description);
            major.setDepartment(departmentService.findById(departmentId));
            majorService.save(major);
            result.setSuccess(true);
            result.setMsg("添加成功");
        } catch (Exception e) {
            result.setMsg("添加失败");
            e.printStackTrace();
            logger.error("添加失败" + e);
        }

        return result;
    }

    @RequestMapping(value = "studentClass/getData",method = RequestMethod.POST)
    @ResponseBody
    public PageInfo getStudentClassData(Integer majorId,Integer page,Integer rows) {
        PageInfo pageInfo = new PageInfo();
        Major major = majorService.findById(majorId);
        Page<StudentClass> studentClass = studentClassService.getStudentClassByMajor(major, page,rows);
        if (studentClass != null) {
            pageInfo.setRows(studentClass.getContent());
            pageInfo.setTotal((int) studentClass.getTotalElements());
        }
        return pageInfo;
    }

    //添加班级
    @RequestMapping(value = "/addStudentClass", method = RequestMethod.GET)
    public String addClass(HttpServletRequest httpServletRequest, ModelMap modelMap, Integer majorId) {
        modelMap.addAttribute("major", majorService.findById(majorId));
        modelMap.addAttribute("postActionUrl", CommonHelper.getRequestUrl(httpServletRequest));
        return "baseInfoManage/addorEditStudentClass";
    }

    @RequestMapping(value = "/addStudentClass", method = RequestMethod.POST)
    @ResponseBody
    public Result addStudentClass( String description, Integer majorId) {
        Result result = new Result();
        try {
            StudentClass studentClass = new StudentClass();
            studentClass.setDescription(description);
            studentClass.setMajor(majorService.findById(majorId));
            studentClassService.save(studentClass);
            result.setSuccess(true);
            result.setMsg("添加成功");
        } catch (Exception e) {
            result.setMsg("添加失败");
            e.printStackTrace();
            logger.error("添加失败" + e);
        }
        return result;
    }

    //修改学院
    @RequestMapping(value = "/editSchool", method = RequestMethod.GET)
    public String editSchool(HttpServletRequest httpServletRequest, ModelMap modelMap, Integer schoolId) {
        School school = schoolService.findById(schoolId);
        modelMap.addAttribute("school", school);
        modelMap.addAttribute("postActionUrl", CommonHelper.getRequestUrl(httpServletRequest));
        return "baseInfoManage/addorEditSchool";
    }

    @RequestMapping(value = "/editSchool", method = RequestMethod.POST)
    @ResponseBody
    public Result editSchool( Integer editId, String description) {
        Result result = new Result();
        try {
            School school = schoolService.findById(editId);
            school.setDescription(description);
            schoolService.saveOrUpdate(school);
            result.setSuccess(true);
            result.setMsg("修改成功");
        } catch (Exception e) {
            result.setMsg("修改失败");
            e.printStackTrace();
            logger.error("修改失败"+e);
        }
        return result;
    }

    //修改教研室
    @RequestMapping(value = "/editDepartment", method = RequestMethod.GET)
    public String editDepartment(HttpServletRequest httpServletRequest, ModelMap modelMap, Integer departmentId) {
        Department department = departmentService.findById(departmentId);
        modelMap.addAttribute("school", department.getSchool());
        modelMap.addAttribute("department", department);
        modelMap.addAttribute("postActionUrl", CommonHelper.getRequestUrl(httpServletRequest));
        return "baseInfoManage/addorEditDepartment";
    }

    @RequestMapping(value = "/editDepartment", method = RequestMethod.POST)
    @ResponseBody
    public Result editDepartment( Integer editId, String description) {
        Result result = new Result();
        try {
            Department department = departmentService.findById(editId);
            department.setDescription(description);
            departmentService.saveOrUpdate(department);
            result.setSuccess(true);
            result.setMsg("修改成功");
        } catch (Exception e) {
            e.printStackTrace();
            result.setMsg("修改失败");
            logger.error("修改失败" + e);
        }
        return result;
    }

    //修改专业
    @RequestMapping(value = "/editMajor", method = RequestMethod.GET)
    public String editMajor(HttpServletRequest httpServletRequest, ModelMap modelMap, Integer majorId) {
        Major major = majorService.findById(majorId);
        modelMap.addAttribute("major", major);
        modelMap.addAttribute("department",major.getDepartment());
        modelMap.addAttribute("postActionUrl", CommonHelper.getRequestUrl(httpServletRequest));

        return "baseInfoManage/addorEditMajor";
    }

    @RequestMapping(value = "/editMajor", method = RequestMethod.POST)
    @ResponseBody
    public Result editMajor( Integer editId, String description) {

        Result result = new Result();
        try {
            Major major = majorService.findById(editId);
            major.setDescription(description);
            majorService.update(major);
            //对更新状态进行保存
            majorService.save(major);
            result.setSuccess(true);
            result.setMsg("修改成功");
        } catch (Exception e) {
            e.printStackTrace();
            result.setMsg("修改失败");
            logger.error("修改失败"+e);
        }
        return result;
    }

    //修改班级
    @RequestMapping(value = "/editStudentClass", method = RequestMethod.GET)
    public String editStudentClass(HttpServletRequest httpServletRequest, ModelMap modelMap, Integer studentClassId) {
        StudentClass studentClass = studentClassService.findById(studentClassId);
        modelMap.addAttribute("studentClass", studentClass);
        modelMap.addAttribute("major", studentClass.getMajor());
        modelMap.addAttribute("postActionUrl", CommonHelper.getRequestUrl(httpServletRequest));
        return "baseInfoManage/addorEditStudentClass";
    }

    @RequestMapping(value = "/editStudentClass", method = RequestMethod.POST)
    @ResponseBody
    public Result editStudentClass(Integer editId, String description) {
        Result result = new Result();
        try {
            StudentClass studentClass = studentClassService.findById(editId);
            studentClass.setDescription(description);
            studentClassService.update(studentClass);
            //对更新状态进行保存
            studentClassService.save(studentClass);
            result.setSuccess(true);
            result.setMsg("修改成功");
        } catch (Exception e) {
            e.printStackTrace();
            result.setMsg("修改失败");
            logger.error("修改失败" + e);
        }
        return result;
    }

    //查看教研室
    @RequestMapping("/listDepartment")
    public String listDepartment(ModelMap modelMap,Integer schoolId) {

        modelMap.addAttribute("schoolId", schoolId);
        return "baseInfoManage/listDepartment";
    }

    //查看专业
    @RequestMapping("/listMajor")
    public String listMajor(ModelMap modelMap,Integer departmentId) {
        modelMap.addAttribute("departmentId", departmentId);
        return "baseInfoManage/listMajor";
    }

    //查看班级
    @RequestMapping("/listStudentClass")
    public String listStudentClass(ModelMap modelMap, Integer majorId) {
        modelMap.addAttribute("majorId", majorId);
        return "baseInfoManage/listStudentClass";
    }

    //查询学院
    @RequestMapping(value = "/selectSchool")
    public String selectSchool(HttpServletRequest httpServletRequest, ModelMap modelMap, String description, Integer pageNo, Integer pageSize) {
        Page<School> schools = schoolService.pageQuery(pageNo, pageSize, description);
        CommonHelper.pagingHelp(modelMap, schools, "schools", CommonHelper.getRequestUrl(httpServletRequest), schools.getTotalElements());
        modelMap.put("description", description);
        return "baseInfoManage/listSchool";
    }

    //删除学院
    @RequestMapping(value = "/deleteSchool", method = RequestMethod.GET)
    @ResponseBody
    public Result deleteSchool( Integer schoolId) {
        Result result = new Result();
        try {
            School school = schoolService.findById(schoolId);
            if (school.getDepartment().isEmpty()) {
                schoolService.deleteObject(school);
            }
            result.setSuccess(true);
            result.setMsg("删除成功");
        } catch (Exception e) {
            result.setMsg("删除失败");
            e.printStackTrace();
        }
        return result;
    }

    //删除教研室
    @RequestMapping(value = "/deleteDepartment", method = RequestMethod.GET)
    @ResponseBody
    public Result deleteDepartment( Integer departmentId) {
        Result result = new Result();
        try {
            Department department = departmentService.findById(departmentId);
            if (department.getMajor().isEmpty()) {
                departmentService.deleteObject(department);
            }
            result.setMsg("删除成功");
            result.setSuccess(true);
        } catch (Exception e) {
            result.setMsg("删除失败");
            e.printStackTrace();
        }
        return result;
    }

    //删除专业
    @RequestMapping(value = "/deleteMajor", method = RequestMethod.GET)
    @ResponseBody
    public Result deleteMajor( Integer majorId) {
        Result result = new Result();
        try {
            Major major = majorService.findById(majorId);
            if (major.getStudentClass().isEmpty()) {
                majorService.deleteObject(major);
            }
            result.setSuccess(true);
            result.setMsg("删除成功");

        } catch (Exception e) {
            result.setMsg("删除失败");
            e.printStackTrace();
        }
        return result;
    }

    //删除班级
    @RequestMapping(value = "/deleteStudentClass", method = RequestMethod.GET)
    @ResponseBody
    public Result deleteStudentClass( Integer studentClassId) {
        Result result = new Result();
        try {
            StudentClass studentClass = studentClassService.findById(studentClassId);
            studentClassService.deleteObject(studentClass);
            result.setSuccess(true);
            result.setMsg("删除成功");
        } catch (Exception e) {
            e.printStackTrace();
            result.setMsg("删除失败");
        }
        return result;
    }
}
