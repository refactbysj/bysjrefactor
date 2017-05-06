package com.newview.bysj.web.userManager.employee;

import com.newview.bysj.domain.Contact;
import com.newview.bysj.domain.Employee;
import com.newview.bysj.domain.User;
import com.newview.bysj.domain.UserRole;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.util.PageInfo;
import com.newview.bysj.util.Result;
import com.newview.bysj.web.baseController.BaseController;
import org.apache.log4j.Logger;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("usersManage")
public class SchoolAdminEmployeeController extends BaseController {
    private static final Logger logger = Logger.getLogger(SchoolAdminEmployeeController.class);

    @RequestMapping("/employee")
    public String list(Model model) {
        model.addAttribute("schoolList", schoolService.findAll());
        return "usersManage/employee/schoolAdminEmployeeList";
    }

    // 最高角色教研室主任
    @RequestMapping(value = "/department/employee",method = RequestMethod.POST)
    @ResponseBody
    public PageInfo departmentEmployee( HttpSession httpSession, Integer page, Integer rows, String no, String name) {
        PageInfo pageInfo = new PageInfo();
        // 获取当前用户
        Employee employee = employeeService.findById(( CommonHelper.getCurrentActor(httpSession)).getId());
        Integer departmentId = employee.getDepartment().getId();
        Integer schoolId = employee.getDepartment().getSchool().getId();
        // 获取该用户教研室下的所有职工
        Page<Employee> employees = searchEmployeeList(employee, name, no, departmentId, schoolId, page, rows);
        if (employees != null) {
            pageInfo.setRows(employees.getContent());
            pageInfo.setTotal((int) employees.getTotalElements());
        }
        return pageInfo;

    }

    // 最高角色是院级管理员
    @RequestMapping(value = "/school/employee",method = RequestMethod.POST)
    @ResponseBody
    public PageInfo schoolEmployee(HttpSession httpSession, String no, String name,
                                   Integer departmentId, Integer page, Integer rows) {
        PageInfo pageInfo = new PageInfo();
        // 获取当前用户
        Employee employee = employeeService.findById((CommonHelper.getCurrentActor(httpSession)).getId());
        Integer schoolId = employee.getDepartment().getSchool().getId();
        // 获取用户所在学院下的职工
        Page<Employee> employees = searchEmployeeList(employee, name, no, departmentId, schoolId, page, rows);
        if (employees != null) {
            pageInfo.setRows(employees.getContent());
            pageInfo.setTotal((int) employees.getTotalElements());
        }
        return pageInfo;
    }

    // 最高角色是校级管理员
    @RequestMapping(value = "/college/employee",method = RequestMethod.POST)
    @ResponseBody
    public PageInfo collegeEmployee(HttpSession httpSession,Integer page,
                                  String no, String name, Integer departmentId, Integer schoolId,Integer rows) {
        PageInfo pageInfo = new PageInfo();
        // 获取当前用户
        Employee employee = employeeService.findById(CommonHelper.getCurrentActor(httpSession).getId());
        Page<Employee> employees = searchEmployeeList(employee, name, no, departmentId, schoolId, page, rows);
        if (employees != null) {
            pageInfo.setRows(employees.getContent());
            pageInfo.setTotal((int) employees.getTotalElements());
        }
        return pageInfo;
    }


    // 教研室主任添加
    @RequestMapping(value = "/department/employeeAdd.html", method = RequestMethod.GET)
    public String departmentAddEmployee(HttpServletRequest request, HttpSession httpSession, ModelMap modelMap) {
        modelMap.addAttribute("employee", new Employee());
        paperModel(request, modelMap);
        return "usersManage/employee/addOrEditEmployee";
    }

    // 院级管理员添加
    @RequestMapping(value = "/school/employeeAdd.html", method = RequestMethod.GET)
    public String schoolAddEmployee(HttpServletRequest request, HttpSession httpSession, ModelMap modelMap) {
        modelMap.addAttribute("employee", new Employee());
        paperModel(request, modelMap);
        return "usersManage/employee/addOrEditEmployee";
    }

    // 校级管理员添加
    @RequestMapping(value = "/college/employeeAdd.html", method = RequestMethod.GET)
    public String collegeAddEmployee(HttpServletRequest httpServletRequest, ModelMap modelMap) {
        modelMap.addAttribute("employee", new Employee());
        paperModel(httpServletRequest, modelMap);
        return "usersManage/employee/addOrEditEmployee";
    }

    //教研室主任添加提交方法
    @RequestMapping(value = "/department/employeeAdd.html", method = RequestMethod.POST)
    @ResponseBody
    public Result departmentAddEmployee(@ModelAttribute("employee") Employee employee,
                                        HttpServletResponse httpServletResponse, Integer departmentId) {
        Result result = new Result();
        try {
            addOrEditEmployee(employee, departmentId);
            result.setSuccess(true);
            result.setMsg("添加成功");
        } catch (Exception e) {
            e.printStackTrace();
            result.setMsg("添加失败");
            logger.error("添加教师失败"+e);
        }
        return result;
    }

    //院级管理员添加提交方法
    @RequestMapping(value = "/school/employeeAdd.html", method = RequestMethod.POST)
    @ResponseBody
    public Result schoolAddEmployee(HttpServletResponse httpServletResponse,
                                    @ModelAttribute("employee") Employee employee, Integer departmentId) {
        Result result = new Result();
        try {
            addOrEditEmployee(employee, departmentId);
            result.setSuccess(true);
            result.setMsg("添加成功");
        } catch (Exception e) {
            logger.error("添加教师失败" + e);
            e.printStackTrace();
            result.setMsg("添加失败");
        }
        return result;
    }

    //校级管理员添加提交方法
    @RequestMapping(value = "/college/employeeAdd.html", method = RequestMethod.POST)
    @ResponseBody
    public Result collegeAddEmployee(HttpServletResponse httpServletResponse,
                                     @ModelAttribute("employee") Employee employee, Integer departmentId) {
        Result result = new Result();
        try {
            addOrEditEmployee(employee, departmentId);
            result.setSuccess(true);
            result.setMsg("添加成功");
        } catch (Exception e) {
            logger.error("添加教师失败" + e);
            e.printStackTrace();
            result.setMsg("添加失败");
        }
        return result;
    }

    // 教研室主任修改
    @RequestMapping("/department/employeeEdit.html")
    public String editEmployeeByDepartment(HttpSession httpSession, HttpServletRequest request, ModelMap modelMap,
                                           Integer employeeId) {
        Employee employee = employeeService.findById(employeeId);
        modelMap.addAttribute("employee", employee);
        modelMap.addAttribute("currentDepartment", employee.getDepartment());
        modelMap.addAttribute("departmentList", employee.getDepartment().getSchool().getDepartment());
        modelMap.addAttribute("edited", true);
        paperModel(request, modelMap);
        return "usersManage/employee/addOrEditEmployee";

    }

    // 院级管理员修改
    @RequestMapping("/school/employeeEdit.html")
    public String editEmployeeBySchool(HttpSession httpSession, HttpServletRequest request, ModelMap modelMap,
                                       Integer employeeId) {
        Employee employee = employeeService.findById(employeeId);
        modelMap.addAttribute("employee", employee);
        modelMap.addAttribute("currentDepartment", employee.getDepartment());
        modelMap.addAttribute("departmentList", employee.getDepartment().getSchool().getDepartment());
        modelMap.addAttribute("edited", true);
        paperModel(request, modelMap);
        return "usersManage/employee/addOrEditEmployee";
    }

    // 校级管理员修改
    @RequestMapping("/college/employeeEdit.html")
    public String editEmployeeByCollege(HttpSession httpSession, HttpServletRequest request, ModelMap modelMap,
                                        Integer employeeId) {
        Employee employee = employeeService.findById(employeeId);
        modelMap.addAttribute("employee", employee);
        modelMap.addAttribute("currentDepartment", employee.getDepartment());
        modelMap.addAttribute("departmentList", employee.getDepartment().getSchool().getDepartment());
        modelMap.addAttribute("edited", true);
        paperModel(request, modelMap);
        return "usersManage/employee/addOrEditEmployee";
    }

    @RequestMapping(value = "/department/employeeEdit.html", method = RequestMethod.POST)
    @ResponseBody
    public Result editEmployeeByDeparmtment(HttpServletResponse httpServletResponse,
                                            HttpServletRequest httpServletRequest, @ModelAttribute("employee") Employee employee,
                                            Integer departmentId) {
        Result result = new Result();
        try {
            addOrEditEmployee(employee, departmentId);
            result.setSuccess(true);
            result.setMsg("修改成功");
        } catch (Exception e) {
            result.setMsg("修改失败");
            e.printStackTrace();
            logger.error("修改教师信息失败" + e);
        }
        return result;
    }

    @RequestMapping(value = "/school/employeeEdit.html", method = RequestMethod.POST)
    @ResponseBody
    public Result editEmployeeBySchool(HttpServletResponse httpServletResponse,
                                       @ModelAttribute("employee") Employee employee, Integer departmentId) {
        Result result = new Result();
        try {
            addOrEditEmployee(employee, departmentId);
            result.setSuccess(true);
            result.setMsg("修改成功");
        } catch (Exception e) {
            e.printStackTrace();
            result.setMsg("修改失败");
            logger.error("修改教师信息失败");
        }
        return  result;
    }

    @RequestMapping(value = "/college/employeeEdit.html", method = RequestMethod.POST)
    @ResponseBody
    public Result editEmployeeByCollege(HttpServletResponse httpServletResponse, HttpServletRequest httpServletRequest,
                                        @ModelAttribute("employee") Employee employee, Integer departmentId) {
        Result result = new Result();
        try {
            addOrEditEmployee(employee, departmentId);
            result.setSuccess(true);
            result.setMsg("修改成功");
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("修改教师信息失败"+e);
            result.setMsg("修改失败");

        }
        return result;
    }

    //添加或修改教师
    private void addOrEditEmployee(Employee employee, Integer departmentId) {
        Employee employeeReady = null;
        if (employee.getId() == null) {
            if (employee.getProTitle() != null) {
                employee.setProTitle(
                        proTitleService.uniqueResult("description", employee.getProTitle().getDescription()));
            } else {
                employee.setProTitle(null);
            }
            if (employee.getDegree() != null) {
                employee.setDegree(degreeService.uniqueResult("description", employee.getDegree().getDescription()));
            } else {
                employee.setDegree(null);
            }

            employeeReady = employee;
            // 为employee设置登陆用户
            User user = new User();
            user.setActor(employeeReady);
            user.setPassword(CommonHelper.makeMD5(employee.getNo()));
            user.setUsername(employee.getNo());
            employeeReady.setUser(user);
            // 保存user并级联保存employeeReady
            userService.save(user);
            // 重新获取保存的user对象
            user = userService.uniqueResult("username", employee.getNo());
            UserRole userRole = new UserRole();
            userRole.setUser(user);
            userRole.setRole(roleService.findById(10));
            userRoleService.save(userRole);
            // 重新获取保存对象否则更新employee会出错
            employeeReady = employeeService.uniqueResult("no", employee.getNo());
        } else {
            employeeReady = employeeService.findById(employee.getId());
            employeeReady.setName(employee.getName());
            employeeReady.setNo(employee.getNo());
            employeeReady.setSex(employee.getSex());
            if (employee.getProTitle() != null) {
                employeeReady.setProTitle(
                        proTitleService.uniqueResult("description", employee.getProTitle().getDescription()));
            } else {
                employeeReady.setProTitle(null);
            }
            if (employee.getDegree() != null) {
                employeeReady
                        .setDegree(degreeService.uniqueResult("description", employee.getDegree().getDescription()));
            } else {
                employeeReady.setDegree(null);
            }
            if (employeeReady.getContact() == null) {
                Contact contact = new Contact();
                contact.setEmail(employee.getContact().getEmail());
                contact.setMoblie(employee.getContact().getMoblie());
                contact.setQq(employee.getContact().getQq());
                employeeReady.setContact(contact);
            } else {
                employeeReady.getContact().setEmail(employee.getContact().getEmail());
                employeeReady.getContact().setMoblie(employee.getContact().getMoblie());
                employeeReady.getContact().setQq(employee.getContact().getQq());
            }
        }
        employeeReady.setDepartment(departmentService.findById(departmentId));
        employeeService.saveOrUpdate(employeeReady);
    }

    private void paperModel(HttpServletRequest request, ModelMap modelMap) {
        modelMap.addAttribute("degree", degreeService.findAll());
        modelMap.addAttribute("proTitle", proTitleService.findAll());
        modelMap.addAttribute("schoolList", schoolService.findAll());
        modelMap.addAttribute("postActionUrl", CommonHelper.getRequestUrl(request));
    }

    //根据条件进行搜索
    private Page<Employee> searchEmployeeList(Employee employee, String employeeName, String employeeNo,
                                             Integer departmentId, Integer schoolId, Integer pageNo, Integer pageSize) {
        Page<Employee> employees = null;
        if (employeeNo==null||employeeNo .equals("")) {
            employeeNo = null;
        }
        if (employeeName==null||employeeName .equals("")) {
            employeeName = null;
        }

        if (departmentId == null) {
            departmentId = employee.getDepartment().getId();
        }
        if (schoolId==null||schoolId == 0) {
            employees = employeeService.getEmployees(employeeNo, employeeName, pageNo, pageSize);
        } else {
            if (departmentId==null||departmentId == 0) {
                if (employeeNo == null && employeeName == null) {
                    employees = employeeService.getEmployeeBySchool(schoolId, pageNo, pageSize);
                } else {
                    employees = employeeService.getEmployeeBySchool(employeeNo, employeeName, schoolId, pageNo,
                            pageSize);
                }
            } else {
                if (employeeNo == null && employeeName == null) {
                    employees = employeeService.getEmployeeByDepartment(departmentId, pageNo, pageSize);
                } else {
                    employees = employeeService.getEmployeeByDepartment(employeeNo, employeeName, departmentId, pageNo,
                            pageSize);
                }
            }
        }
        return employees;

    }

    // 删除
    @RequestMapping("/employeeDelete")
    @ResponseBody
    public Result deleteEmployee(HttpServletResponse httpServletResponse,
                                 @ModelAttribute("employeeId") Integer employeeId) {
        Result result = new Result();
        try {
            Employee employee = employeeService.findById(employeeId);
            employeeService.deleteEmployee(employee);
            result.setMsg("删除成功");
            result.setSuccess(true);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("删除失败" + e);
            result.setMsg("删除失败");
        }
        return result;
    }

    // 重置密码
    @RequestMapping(value = "/resetpassWord")
    @ResponseBody
    public Result resetPassWord(HttpServletResponse httpServletResponse, Integer employeeId) {
        Result result = new Result();
        try {
            Employee employee = employeeService.findById(employeeId);
            User user = employee.getUser();
            user.setPassword(CommonHelper.makeMD5(employee.getNo()));
            userService.update(user);
            // 对更新状态进行保存
            userService.save(user);
            result.setSuccess(true);
            result.setMsg("重置密码成功");
        } catch (Exception e) {
            logger.error("重置密码失败" + e);
            e.printStackTrace();
            result.setMsg("重置密码失败");
        }
        return result;

    }
}
