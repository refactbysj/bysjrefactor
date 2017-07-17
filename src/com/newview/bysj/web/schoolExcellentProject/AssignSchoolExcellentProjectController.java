package com.newview.bysj.web.schoolExcellentProject;

import com.newview.bysj.domain.GraduateProject;
import com.newview.bysj.domain.ProvinceExcellentProject;
import com.newview.bysj.domain.SchoolExcellentProject;
import com.newview.bysj.domain.Tutor;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.util.PageInfo;
import com.newview.bysj.web.baseController.BaseController;
import com.sun.xml.internal.bind.v2.TODO;
import org.apache.log4j.Logger;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Controller
public class AssignSchoolExcellentProjectController extends BaseController {
    private static final Logger logger = Logger.getLogger(AssignSchoolExcellentProjectController.class);

    @RequestMapping("projects/saveSchoolExcellentProjects")
    public String tolist() {
        return "excellentProjects/assginSchoolExcellentProjects";
    }

    //指定校优的初界面和查询
    //把所有的论文传到jsp
    @RequestMapping("projects/schoolExcellentProjects.html")
    @ResponseBody
    public PageInfo list(HttpSession httpSession,  Integer page, Integer rows,String title,String tutorName) {
        PageInfo pageInfo = new PageInfo();
        //获取当前用户
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentActor(httpSession).getId());
        //筛选
        Page<GraduateProject> graduateProject = graduateProjectService.getPagesForSchoolExcellenceCandidate(tutor.getDepartment().getSchool(),  page, rows,title,tutorName);
        if (graduateProject != null) {
            pageInfo.setRows(graduateProject.getContent());
            pageInfo.setTotal((int)graduateProject.getTotalElements());
        }

        return pageInfo;
    }


    //确定校优
    @RequestMapping("projects/approveSchoolExcellentProject.html")
    public void approveExcellentProjectByDirector(Integer graduateProjectId, HttpServletResponse httpServletResponse) {
        GraduateProject graduateProject = graduateProjectService.findById(graduateProjectId);

        SchoolExcellentProject schoolExcellentProject = new SchoolExcellentProject();
        schoolExcellentProject.setGraduateProject(graduateProject);
        schoolExcellentProject = schoolExcellentProjectService.saveAndFlush(schoolExcellentProject);
        graduateProject.setSchoolExcellentProject(schoolExcellentProject);
        graduateProject.setSchoolExcellentPro(true);
        graduateProjectService.saveOrUpdate(graduateProject);

        CommonHelper.buildSimpleJson(httpServletResponse);
    }

    //驳回推优
    @RequestMapping("projects/cancelSchoolExcellentProject.html")
    public void cancelExcellentProjectByDirector(Integer graduateProjectId, HttpServletResponse httpServletResponse) {
        GraduateProject graduateProject = graduateProjectService.findById(graduateProjectId);

        SchoolExcellentProject schoolExcellentProject = graduateProject.getSchoolExcellentProject();
        schoolExcellentProject.setGraduateProject(null);
//        schoolExcellentProjectService.deleteObject(schoolExcellentProject);
        graduateProject.setSchoolExcellentPro(false);
        graduateProject.setSchoolExcellentProject(null);
        schoolExcellentProjectService.deleteObject(schoolExcellentProject);
        graduateProjectService.saveOrUpdate(graduateProject);



        //驳回校优时对应驳回省优
        if(graduateProject.getProvinceExcellentProject()!=null) {
            ProvinceExcellentProject provinceExcellentProject = graduateProject.getProvinceExcellentProject();
            provinceExcellentProject.setGraudateProject(null);
            graduateProject.setProvinceExcellentProject(null);
            graduateProject.setProvinceExcellentPro(false);
            provinceExcellentProjectService.deleteObject(provinceExcellentProject);
            graduateProjectService.saveOrUpdate(graduateProject);
        }

        CommonHelper.buildSimpleJson(httpServletResponse);
    }
}