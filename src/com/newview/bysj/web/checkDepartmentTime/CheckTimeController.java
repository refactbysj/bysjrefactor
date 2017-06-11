package com.newview.bysj.web.checkDepartmentTime;

import com.newview.bysj.domain.Department;
import com.newview.bysj.domain.Tutor;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.util.PageInfo;
import com.newview.bysj.web.baseController.BaseController;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;


/**
 * Created by apple on 17/6/3.
 */
@Controller
@RequestMapping("process")
public class CheckTimeController extends BaseController {
    private static final Logger LOGGER = Logger.getLogger(CheckTimeController.class);

    /**
     * 转到查看时间设置页面
     */
    @RequestMapping(value = "/checkTime.html", method = RequestMethod.GET)
    public String toPage() {
        return "checkDepartmentTime/checkTimeList";
    }

    /**
     * 获取全部的教研室时间信息
     *
     *  @param page        当前页
     * @param rows        每页的条数
     * @return jsp
     */
    @RequestMapping(value = "/getCheckTimeList.html", method = RequestMethod.POST)
    @ResponseBody
    public PageInfo replyEvaluatePost(Integer page, Integer rows, HttpSession httpSession) {
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentTutor(httpSession).getId());
        PageInfo pageInfo = new PageInfo();
        //Page<Department> departments = departmentService.getPagesForDepartmentCandidate( page, rows);
        List<Department> departments = tutor.getDepartment().getSchool().getDepartment();
        if (departments != null) {
            pageInfo.setRows(departments);
            pageInfo.setTotal(departments.size());
        }
        return pageInfo;
    }

}
