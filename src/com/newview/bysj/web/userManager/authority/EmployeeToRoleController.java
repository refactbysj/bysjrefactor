package com.newview.bysj.web.userManager.authority;

import com.newview.bysj.domain.Employee;
import com.newview.bysj.domain.Role;
import com.newview.bysj.domain.UserRole;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.util.Result;
import com.newview.bysj.web.baseController.BaseController;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/authority")
public class EmployeeToRoleController extends BaseController {

    private static final Logger logger = Logger.getLogger(EmployeeToRoleController.class);

    @RequestMapping("/setEmployeeToRole")
    public String setEmployeeToRole(HttpSession httpSession, ModelMap modelMap, Integer employeeId) {
        Employee admin = employeeService.findById(CommonHelper.getCurrentActor(httpSession).getId());
        List<Role> roles = new ArrayList<>();
        for (UserRole userRole : admin.getUser().getUserRole()) {
            if (userRole.getRole().getRoleName().equals("ROLE_COLLEGE_ADMIN")) {
                roles.addAll(userRole.getRole().getRoleHandleds());
                // continue;
            } else if (userRole.getRole().getRoleName().equals("ROLE_SCHOOL_ADMIN")) {
                roles.addAll(userRole.getRole().getRoleHandleds());
                // continue;
            } else if (userRole.getRole().getRoleName().equals("ROLE_DEPARTMENT_DIRECTOR")) {
                roles.addAll(userRole.getRole().getRoleHandleds());
                // continue;
            }
        }
        Employee employee = employeeService.findById(employeeId);
        List<UserRole> userRoles = employee.getUser().getUserRole();
        List<Role> ownRoles = new ArrayList<>();
        for (UserRole userRole : userRoles) {
            for (Role role : roles) {
                if (userRole.getRole().getRoleHandler() != null && userRole.getRole().equals(role)) {
                    ownRoles.add(userRole.getRole());
                }
            }
        }
        roles.removeAll(ownRoles);
        modelMap.addAttribute("ownRoles", ownRoles);
        modelMap.addAttribute("noOwnRoles", roles);
        modelMap.addAttribute("employeeId", employeeId);
        return "usersManage/authority/userToRole";
    }

    /**
     * @param selectRoleId 已拥有的角色的id
     * @param employeeId   老师的id
     */
    @RequestMapping(value = "setEmployeeRole.html", method = RequestMethod.GET)
    @ResponseBody
    public Result setEmployeeToRole(String selectRoleId, Integer employeeId) {
        Result result = new Result();
        try {
            Employee employee = employeeService.findById(employeeId);
            Integer[] selectedList = selectRoleId.length() == 0 ? new Integer[0] : stringToInteger(selectRoleId);
            List<UserRole> userRoles = employee.getUser().getUserRole();
            //删除当前用户的所有角色
            if (userRoles != null && userRoles.size() > 0) {
                for (UserRole userRole : userRoles) {
                    userRole.setRole(null);
                    userRole.setUser(null);
                    userRoleService.saveOrUpdate(userRole);
                    userRoleService.deleteObject(userRole);
                }
            }

            //添加所选角色
            if (selectedList.length > 0) {
                Role role;
                for (Integer integer : selectedList) {
                    role = roleService.findById(integer);
                    UserRole userRole = new UserRole();
                    userRole.setUser(employee.getUser());
                    userRole.setRole(role);
                    userRoleService.saveOrUpdate(userRole);
                }
            }
            result.setSuccess(true);
            result.setMsg("分配角色成功");
        } catch (Exception e) {
            e.printStackTrace();
            result.setMsg("分配角色失败");
            logger.error("分配角色失败" + e);
        }
        return result;
    }

    public Integer[] arrayRemoveElement(Integer[] array, Integer elementIndex) {
        Integer[] newArray = new Integer[array.length - 1];
        int j = 0;
        for (int i = 0; i < array.length; i++) {
            if (i != elementIndex) {
                newArray[j] = array[i];
            } else {
                continue;
            }
        }
        return newArray;
    }

    public Integer[] stringToInteger(String str) {
        // 将字符串从第一个字符开始按，为分割标志截取成几个字符串
        String[] arrayList = str.substring(0).split(",");
        Integer[] array = new Integer[arrayList.length];
        for (int i = 0; i < array.length; i++) {
            array[i] = Integer.parseInt(arrayList[i]);
        }
        return array;

    }

}
