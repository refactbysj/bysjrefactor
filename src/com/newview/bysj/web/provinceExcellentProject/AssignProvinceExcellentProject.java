package com.newview.bysj.web.provinceExcellentProject;

import com.newview.bysj.domain.GraduateProject;
import com.newview.bysj.domain.ProvinceExcellentProject;
import com.newview.bysj.exception.MessageException;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.util.PageInfo;
import com.newview.bysj.util.Result;
import com.newview.bysj.web.baseController.BaseController;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Controller
public class AssignProvinceExcellentProject extends BaseController {

    //跳转到指定省优页面
    @RequestMapping("projects/saveProvenceExcellentProjects")
    public String toPage() {
        return "excellentProjects/assginProvinceExcellentProjects";
    }

    //指定省优初界面和查询功能
    @RequestMapping("projects/saveProvenceExcellentProjectsLists.html")
    @ResponseBody
    public PageInfo list(Integer page, Integer rows, String title, String tutorName) {
        PageInfo pageInfo = new PageInfo();
        Page<GraduateProject> graduateProject = graduateProjectService.getPagesForProvinceExcellentCandidate(title == null ? null : title, tutorName == null ? null : tutorName, page, rows);
        pageInfo.setRows(graduateProject.getContent());
        pageInfo.setTotal((int) graduateProject.getNumberOfElements());
        return pageInfo;
    }

    //确定推为省优
    @RequestMapping("projects/approveProvinceExcellentProject.html")
    public void approveExcellentProject(Integer graduateProjectId, HttpServletResponse httpServletResponse) {
        GraduateProject graduateProject = graduateProjectService.findById(graduateProjectId);
        ProvinceExcellentProject provinceExcellentProject = new ProvinceExcellentProject();
        provinceExcellentProject.setGraudateProject(graduateProject);
        //加上这句话，会报错，会建立2个ProvinceExcellentProject对象，这个不知什么问题
        //provinceExcellentProjectService.saveAndFlush(provinceExcellentProject);
        graduateProject.setProvinceExcellentProject(provinceExcellentProject);
        graduateProjectService.saveOrUpdate(graduateProject);
        CommonHelper.buildSimpleJson(httpServletResponse);


    }

    //取消省优
    @RequestMapping("projects/cancelProvinceExcellentProject.html")
    public void cancelProvinceExcellentProject(Integer graduateProjectId, HttpServletResponse httpServletResponse) {
        GraduateProject graduateProject = graduateProjectService.findById(graduateProjectId);
        ProvinceExcellentProject provinceExcellentProject = graduateProject.getProvinceExcellentProject();
        provinceExcellentProject.setGraudateProject(null);
        graduateProject.setProvinceExcellentProject(null);
        provinceExcellentProjectService.deleteObject(provinceExcellentProject);
        graduateProjectService.saveOrUpdate(graduateProject);
        CommonHelper.buildSimpleJson(httpServletResponse);

    }
}
