package com.newview.bysj.web.userManager.authority;

import com.newview.bysj.domain.Employee;
import com.newview.bysj.domain.School;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.util.PageInfo;
import com.newview.bysj.web.baseController.BaseController;
import org.apache.log4j.Logger;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Objects;

/**
 * 用户角色设置
 */
@Controller
@RequestMapping("usersManage")
public class EmployeeToRoleManageController extends BaseController {

    private static final Logger LOGGER = Logger.getLogger(EmployeeToRoleManageController.class);

    /**
     * 跳转到用户设置角色页面
     */
    @RequestMapping("/employeeToRole")
    public String list(Model model) {
        List<School> schools = schoolService.findAll();
        model.addAttribute("schoolList", schools);
        return "usersManage/authority/employeeToRole";
    }

    //最高角色是教研室主任
    @RequestMapping("/department/employeeToRole")
    @ResponseBody
    public PageInfo departmentEmployee(HttpSession httpSession, Integer page, Integer rows, String name, String no) {
        PageInfo pageInfo = new PageInfo();
        try {
            //获取当前用户
            Employee employee = employeeService.findById(CommonHelper.getCurrentActor(httpSession).getId());
            //获取当前用户所在教研室下的所有职工
            //Page<Employee> employees = employeeService.getEmployeeByDepartment(employee.getDepartment().getId(), page, rows);
            Integer departmentId = employee.getDepartment().getId();
            Integer schoolId = employee.getDepartment().getSchool().getId();
            Page<Employee> employees = searchEmployeeList(employee, name, no, departmentId, schoolId, page, rows);
            if (employee != null) {
                pageInfo.setRows(employees.getContent());
                pageInfo.setTotal((int) employees.getTotalElements());
            }
        } catch (Exception e) {
            LOGGER.error("教研室用户获取角色失败" + e);
            e.printStackTrace();
        }

        return pageInfo;
    }

    //最高角色是院级管理员
    @RequestMapping("/school/employeeToRole")
    @ResponseBody
    public PageInfo schoolEmployee(HttpSession httpSession, Integer page, Integer rows, String name, String no, Integer departmentSelect) {
        PageInfo pageInfo = new PageInfo();
        try {
            //获取当前用户
            Employee employee = employeeService.findById(CommonHelper.getCurrentActor(httpSession).getId());
            Integer schoolSelect = employee.getDepartment().getSchool().getId();
            Page<Employee> employees = searchEmployeeList(employee, name, no, departmentSelect, schoolSelect, page, rows);

            if (employees != null) {
                pageInfo.setRows(employees.getContent());
                pageInfo.setTotal((int) employees.getTotalElements());
            }
        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.error("院级管理员获取角色失败" + e);
        }
        return pageInfo;
    }

    //最高角色是校级管理员
    @RequestMapping("/college/employeeToRole")
    @ResponseBody
    public PageInfo collegeEmployee(Integer page, Integer rows, String name, String no, Integer departmentSelect, Integer schoolSelect, HttpSession httpSession) {
        PageInfo pageInfo = new PageInfo();
        try {
            Employee employee = employeeService.findById(CommonHelper.getCurrentActor(httpSession).getId());
            Page<Employee> employees = searchEmployeeList(employee, name, no, departmentSelect, schoolSelect, page, rows);

            if (employees != null) {
                pageInfo.setRows(employees.getContent());
                pageInfo.setTotal((int) employees.getTotalElements());
            }
        } catch (Exception e) {
            LOGGER.error("校级管理员获取角色失败" + e);
            e.printStackTrace();
        }
        return pageInfo;
    }

    //根据查询条件进行查询
    private Page<Employee> searchEmployeeList(Employee employee, String employeeName, String employeeNo, Integer departmentId, Integer schoolId, Integer pageNo, Integer pageSize) {
        Page<Employee> employees;
        if (Objects.equals(employeeName, ""))
            employeeName = null;
        if (Objects.equals(employeeNo, ""))
            employeeNo = null;
        if (schoolId == null || schoolId == 0) {
            employees = employeeService.getEmployees(employeeNo, employeeName,
                    pageNo, pageSize);
        } else {
            if (departmentId == 0) {
                if (employeeNo == null && employeeName == null) {
                    employees = employeeService.getEmployeeBySchool(schoolId,
                            pageNo, pageSize);
                } else {
                    employees = employeeService.getEmployeeBySchool(employeeNo, employeeName, schoolId, pageNo, pageSize);
                }
            } else {
                if (employeeNo == null && employeeName == null) {
                    employees = employeeService.getEmployeeByDepartment(departmentId, pageNo, pageSize);
                } else {
                    employees = employeeService.getEmployeeByDepartment(employeeNo, employeeName, departmentId, pageNo, pageSize);
                }
            }
        }
        return employees;
    }


}
