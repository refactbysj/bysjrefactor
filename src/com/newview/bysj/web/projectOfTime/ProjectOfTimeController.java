package com.newview.bysj.web.projectOfTime;

import com.newview.bysj.domain.*;
import com.newview.bysj.exception.MessageException;
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
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Calendar;

/**
 * Created 2016/2/17,14:05.
 * Author 张战.
 * 选题流程时间设置的controller
 */
@Controller
public class ProjectOfTimeController extends BaseController {


    private static final Logger logger = Logger.getLogger(ProjectOfTimeController.class);

    @RequestMapping(value = "setTime.html", method = RequestMethod.GET)
    public String setTime(ModelMap modelMap, HttpSession httpSession) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy年MM月dd日");
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentActor(httpSession).getId());
        //获取审核开题报告的时间
        ConstraintOfApproveOpenningReport constraintOfApproveOpenningReport = tutor.getDepartment().getConstraintOfApproveOpenningReport();
        //获取教师申报题目的时间
        ConstraintOfProposeProject constraintOfProposeProject = tutor.getDepartment().getConstraintOfProposeProject();
        //获取教研室毕业设计的时间
        ProjectTimeSpan projectTimeSpan = tutor.getDepartment().getProjectTimeSpan();
        //Page<HolidayAndVacation> holidayAndVacationByPage = holidayAndVacationService.getPageByTutor(1, 20, "");
        // 1 true    0 false
        //判断教师申报题目的时间是否为空
        if (constraintOfProposeProject == null) {
            modelMap.put("ifShowProposeProjectTime", "0");
        } else {
            modelMap.put("ifShowProposeProjectTime", "1");
            modelMap.put("proposeProjectStartTime", dateFormat.format(constraintOfProposeProject.getStartTime().getTime()));
            modelMap.put("proposeProjectEndTime", dateFormat.format(constraintOfProposeProject.getEndTime().getTime()));
        }
        //判断审核开题报告的时间是否为空
        if (constraintOfApproveOpenningReport == null) {
            modelMap.put("ifShowOpeningReportTime", "0");
        } else {
            modelMap.put("ifShowOpeningReportTime", "1");
            modelMap.put("openingReportStartTime", dateFormat.format(constraintOfApproveOpenningReport.getStartTime().getTime()));
            modelMap.put("openingReportEndTime", dateFormat.format(constraintOfApproveOpenningReport.getEndTime().getTime()));
        }
        //判断教研室毕业设计的时间是否为空
        if (projectTimeSpan == null) {
            modelMap.put("ifShowProjectTimeSpan", "0");
        } else {
            modelMap.put("ifShowProjectTimeSpan", "1");
            modelMap.put("projectTimeSpanStartTime", dateFormat.format(projectTimeSpan.getBeginTime().getTime()));
            modelMap.put("projectTimeSpanEndTime", dateFormat.format(projectTimeSpan.getEndTime().getTime()));
        }

       /* if (holidayAndVacationByPage.getContent().size() == 0) {
            modelMap.put("ifShowHolidayTime", "0");
        } else {
            modelMap.put("ifShowHolidayTime", "1");
            CommonHelper.paging(modelMap, holidayAndVacationByPage, "holidayList");
        }*/
        modelMap.put("now", dateFormat.format(CommonHelper.getNow().getTime()));
        return "projectOfTime/showTime";
    }


    /**
     * 分页获取节假日
     * @param page 页数
     * @param rows 每页的条数
     */
    @RequestMapping(value = "/findHolidayPageData.html",method = RequestMethod.POST)
    @ResponseBody
    public PageInfo findHolidayPageData(Integer page, Integer rows) {
        PageInfo pageInfo = new PageInfo();
        Page<HolidayAndVacation> holidayAndVacations = holidayAndVacationService.getPageByTutor(page, rows, "");
        if (holidayAndVacations != null) {
            pageInfo.setRows(holidayAndVacations.getContent());
            pageInfo.setTotal((int)holidayAndVacations.getTotalElements());
            return pageInfo;
        }
        return null;
    }



    /**
     * 增加或修改教师申报题目的时间
     *
     * @param modelMap    map集合，便于在jsp中获取存储的值
     * @param httpSession 当前会话
     * @return 增加或修改的jsp
     */
    @RequestMapping(value = "addOrEditProposeProjectTime.html", method = RequestMethod.GET)
    public String addOrEditProposeProjectTime(ModelMap modelMap, HttpServletRequest httpServletRequest, HttpSession httpSession) {
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentActor(httpSession).getId());
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        if (tutor.getDepartment().getConstraintOfProposeProject() != null) {
            ConstraintOfProposeProject constraintOfProposeProject = tutor.getDepartment().getConstraintOfProposeProject();
            modelMap.put("projectTimeSpanStartTime", simpleDateFormat.format(constraintOfProposeProject.getStartTime().getTime()));
            modelMap.put("projectTimeSpanEndTime", simpleDateFormat.format(constraintOfProposeProject.getEndTime().getTime()));
        }
        modelMap.put("actionUrl", CommonHelper.getRequestUrl(httpServletRequest));
        modelMap.put("now", simpleDateFormat.format(CommonHelper.getNow().getTime()));
        return "projectOfTime/addOrEditTime";
    }

    @RequestMapping(value = "addOrEditProposeProjectTime.html", method = RequestMethod.POST)
    public String addOrEditProposeProjectTime(HttpSession httpSession, String startTime, String endTime) {
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentActor(httpSession).getId());
        Department department = tutor.getDepartment();
        if (department.getConstraintOfProposeProject() == null) {
            ConstraintOfProposeProject constraintOfProposeProject = new ConstraintOfProposeProject();
            constraintOfProposeProject.setDepartment(tutor.getDepartment());
            constraintOfProposeProject.setStartTime(CommonHelper.getCalendarByString(startTime,"yyyy-MM-dd"));
            //将最后的时间设置为23时59分59秒
            constraintOfProposeProject.setEndTime(CommonHelper.setLastTime(CommonHelper.getCalendarByString(endTime,"yyyy-MM-dd")));
            constraintOfProposeProjectService.save(constraintOfProposeProject);
            //如果不加下面这句话，点击提交更改时会报错，必须要重新获取才可以。
            constraintOfProposeProject = constraintOfProposeProjectService.uniqueResult("department", Department.class, department);
            department.setConstraintOfProposeProject(constraintOfProposeProject);
            departmentService.saveOrUpdate(department);
        } else {
            ConstraintOfProposeProject constraintOfProposeProject = department.getConstraintOfProposeProject();
            constraintOfProposeProject.setStartTime(CommonHelper.getCalendarByString(startTime,"yyyy-MM-dd"));
            constraintOfProposeProject.setEndTime(CommonHelper.setLastTime(CommonHelper.getCalendarByString(endTime,"yyyy-MM-dd")));
            constraintOfProposeProjectService.update(constraintOfProposeProject);
            //对更新状态进行保存
            constraintOfProposeProjectService.save(constraintOfProposeProject);
        }
        return "redirect:/setTime.html";
    }


    /**
     * 设置审核开题报告时间的get方法
     *
     * @param modelMap           存储需要在jsp中获取的数据
     * @param httpSession        用于获取当前的用户
     * @param httpServletRequest 用于获取请求的路径
     * @return jsp
     */
    @RequestMapping(value = "/addOrEditOpeningReportTime.html", method = RequestMethod.GET)
    public String addOrEditOpeningReportTime(ModelMap modelMap, HttpSession httpSession, HttpServletRequest httpServletRequest) {
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentTutor(httpSession).getId());
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        if (tutor.getDepartment().getConstraintOfApproveOpenningReport() != null) {
            ConstraintOfApproveOpenningReport constraintOfApproveOpenningReport = tutor.getDepartment().getConstraintOfApproveOpenningReport();
            modelMap.put("projectTimeSpanStartTime", simpleDateFormat.format(constraintOfApproveOpenningReport.getStartTime().getTime()));
            modelMap.put("projectTimeSpanEndTime", simpleDateFormat.format(constraintOfApproveOpenningReport.getEndTime().getTime()));
        }
        modelMap.put("now", simpleDateFormat.format(CommonHelper.getNow().getTime()));
        modelMap.put("actionUrl", CommonHelper.getRequestUrl(httpServletRequest));
        return "projectOfTime/addOrEditTime";
    }

    /**
     * 添加或修改毕业设计时间
     */
    @RequestMapping(value = "/addOrEditProjectTimeSpan.html", method = RequestMethod.GET)
    public String addOrEditProjectTimeSpan(HttpServletRequest httpServletRequest, HttpSession httpSession, ModelMap modelMap) {
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentActor(httpSession).getId());
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        if (tutor.getDepartment().getProjectTimeSpan() != null) {
            ProjectTimeSpan projectTimeSpan = tutor.getDepartment().getProjectTimeSpan();
            modelMap.put("projectTimeSpanStartTime", simpleDateFormat.format(projectTimeSpan.getBeginTime().getTime()));
            modelMap.put("projectTimeSpanEndTime", simpleDateFormat.format(projectTimeSpan.getEndTime().getTime()));
        }
        modelMap.put("now", simpleDateFormat.format(CommonHelper.getNow().getTime()));
        modelMap.put("actionUrl", CommonHelper.getRequestUrl(httpServletRequest));
        return "projectOfTime/addOrEditTime";
    }


    /**
     * 添加或修改毕业设计时间
     */
    @RequestMapping(value = "/addOrEditProjectTimeSpan.html", method = RequestMethod.POST)
    public String addOrEditProjectTimeSpan(HttpSession httpSession, String startTime, String endTime) {
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentTutor(httpSession).getId());
        Department department = tutor.getDepartment();
        if (department.getProjectTimeSpan() == null) {
            ProjectTimeSpan projectTimeSpan = new ProjectTimeSpan();
            projectTimeSpan.setBeginTime(CommonHelper.getCalendarByString(startTime,"yyyy-MM-dd"));
            projectTimeSpan.setEndTime(CommonHelper.setLastTime(CommonHelper.getCalendarByString(endTime,"yyyy-MM-dd")));
            projectTimeSpan.setYear(String.valueOf(CommonHelper.getCalendarByString(startTime,"yyyy-MM-dd").get(Calendar.YEAR)));
            projectTimeSpanService.save(projectTimeSpan);
            projectTimeSpanService.update(projectTimeSpan);
            projectTimeSpan = projectTimeSpanService.findById(1);
            //毕业设计时间需要重新获取
            department.setProjectTimeSpan(projectTimeSpan);
            departmentService.saveOrUpdate(department);
        } else {
            ProjectTimeSpan projectTimeSpan = department.getProjectTimeSpan();
            projectTimeSpan.setYear(String.valueOf(CommonHelper.getCalendarByString(startTime,"yyyy-MM-dd").get(Calendar.YEAR)));
            projectTimeSpan.setBeginTime(CommonHelper.getCalendarByString(startTime,"yyyy-MM-dd"));
            projectTimeSpan.setEndTime(CommonHelper.setLastTime(CommonHelper.getCalendarByString(endTime,"yyyy-MM-dd")));
            projectTimeSpanService.update(projectTimeSpan);
            projectTimeSpanService.save(projectTimeSpan);
        }
        return "redirect:/setTime.html";
    }

    /**
     * 添加或修改开题报告时间
     */
    @RequestMapping(value = "/addOrEditOpeningReportTime.html", method = RequestMethod.POST)
    public String addOrEditOpeningReportTime( HttpSession httpSession, String startTime, String endTime) {
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentTutor(httpSession).getId());
        Department department = tutor.getDepartment();
        if (department.getConstraintOfApproveOpenningReport() == null) {
            ConstraintOfApproveOpenningReport constraintOfApproveOpenningReport = new ConstraintOfApproveOpenningReport();
            constraintOfApproveOpenningReport.setStartTime(CommonHelper.getCalendarByString(startTime,"yyyy-MM-dd"));
            constraintOfApproveOpenningReport.setEndTime(CommonHelper.setLastTime(CommonHelper.getCalendarByString(endTime,"yyyy-MM-dd")));
            constraintOfApproveOpenningReport.setDepartment(tutor.getDepartment());
            constraintOfApproveOpenningReportService.save(constraintOfApproveOpenningReport);
            //开题报告时间必须要重新获取
            constraintOfApproveOpenningReport = constraintOfApproveOpenningReportService.uniqueResult("department", Department.class, department);
            department.setConstraintOfApproveOpenningReport(constraintOfApproveOpenningReport);
            departmentService.saveOrUpdate(department);

        } else {
            ConstraintOfApproveOpenningReport constraintOfApproveOpenningReport = department.getConstraintOfApproveOpenningReport();
            constraintOfApproveOpenningReport.setStartTime(CommonHelper.getCalendarByString(startTime,"yyyy-MM-dd"));
            constraintOfApproveOpenningReport.setEndTime(CommonHelper.setLastTime(CommonHelper.getCalendarByString(endTime,"yyyy-MM-dd")));
            constraintOfApproveOpenningReportService.saveOrUpdate(constraintOfApproveOpenningReport);
        }
        return "redirect:/setTime.html";
    }


    /**
     * 删除开题报告时间
     */
    @RequestMapping("/delOpeningReport.html")
    public String delOpeningReportTime(HttpSession httpSession, Integer delId, HttpServletResponse httpServletResponse) {
        Tutor tutor = CommonHelper.getCurrentTutor(httpSession);
        if (constraintOfApproveOpenningReportService.findById(delId) != null) {
            constraintOfApproveOpenningReportService.deleteById(delId);
            Department department = tutor.getDepartment();
            department.setConstraintOfApproveOpenningReport(null);
            departmentService.update(department);
        }
        CommonHelper.buildSimpleJson(httpServletResponse);
        return "redirect:/setTime.html";
    }

    /**
     * 添加或修改节假日时间
     */
    @RequestMapping(value = "/addOrEditHolidayTime.html", method = RequestMethod.GET)
    public String addOrEditHolidayTime(ModelMap modelMap, HttpServletRequest httpServletRequest, Integer editId) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        if (editId != null) {
            if (holidayAndVacationService.findById(editId) != null) {
                HolidayAndVacation holidayAndVacation = holidayAndVacationService.findById(editId);
                modelMap.put("holidayStartTime", simpleDateFormat.format(holidayAndVacation.getBeginTime().getTime()));
                modelMap.put("holidayEndTime", simpleDateFormat.format(holidayAndVacation.getEndTime().getTime()));
                modelMap.put("description", holidayAndVacation.getDescription());
                modelMap.put("editId", editId);
            } else {
                throw new MessageException("获取假期失败");
            }
        }
        modelMap.put("actionUrl", CommonHelper.getRequestUrl(httpServletRequest));
        modelMap.put("now", simpleDateFormat.format(CommonHelper.getNow().getTime()));
        return "projectOfTime/addOrEditHolidayTime";
    }

    /**
     * 添加或修改节假日
     */
    @RequestMapping(value = "/addOrEditHolidayTime.html", method = RequestMethod.POST)
    @ResponseBody
    public Result addOrEditHolidayTime(Integer editId, String description, String startTime, String endTime) {
        Result result = new Result();
        try {
            if (editId != null) {
                if (holidayAndVacationService.findById(editId) != null) {
                    HolidayAndVacation holidayAndVacation = holidayAndVacationService.findById(editId);
                    if (startTime != null&&!startTime.equals("")) {
                        holidayAndVacation.setBeginTime(CommonHelper.getCalendarByString(startTime, "yyyy-MM-dd"));
                    }else{
                        holidayAndVacation.setBeginTime(null);
                    }
                    if (endTime != null && !endTime.equals("")) {
                        holidayAndVacation.setEndTime(CommonHelper.setLastTime(CommonHelper.getCalendarByString(endTime, "yyyy-MM-dd")));
                    }else{
                        holidayAndVacation.setEndTime(null);
                    }
                    holidayAndVacation.setDescription(description);
                    holidayAndVacationService.update(holidayAndVacation);
                    result.setMsg("修改成功");
                } else {
                    throw new MessageException("获取假期失败");
                }
            } else {
                HolidayAndVacation holidayAndVacation = new HolidayAndVacation();
                if (startTime != null && !startTime.equals("")) {
                    holidayAndVacation.setBeginTime(CommonHelper.getCalendarByString(startTime, "yyyy-MM-dd"));
                }else{
                    holidayAndVacation.setBeginTime(null);
                }
                if (endTime != null && !endTime.equals("")) {
                    holidayAndVacation.setEndTime(CommonHelper.setLastTime(CommonHelper.getCalendarByString(endTime, "yyyy-MM-dd")));
                }else{
                    holidayAndVacation.setEndTime(null);
                }
                holidayAndVacation.setDescription(description);
                holidayAndVacationService.saveOrUpdate(holidayAndVacation);
                result.setMsg("添加成功");
            }
            result.setSuccess(true);
            return result;
        } catch (Exception e) {
            logger.error("添加或修改节假日失败" + e);
            result.setMsg("添加或修改节假日失败");
            result.setSuccess(false);
            return result;
        }
    }

    /**
     * 删除节假日
     */
    @RequestMapping("/delHolidayTime.html")
    @ResponseBody
    public Result delHolidayTime(Integer delId) {
        Result result = new Result();
        try {
            holidayAndVacationService.deleteById(delId);
            result.setSuccess(true);
            result.setMsg("节假日删除成功");
            return result;
        } catch (Exception e) {
            result.setSuccess(false);
            result.setMsg("节假日删除失败");
            return result;
        }
        //CommonHelper.buildSimpleJson(httpServletResponse);
    }

}
