package com.newview.bysj.web.schoolExcellentProject;

import com.newview.bysj.domain.GraduateProject;
import com.newview.bysj.domain.ProvinceExcellentProject;
import com.newview.bysj.domain.SchoolExcellentProject;
import com.newview.bysj.domain.Tutor;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.util.PageInfo;
import com.newview.bysj.web.baseController.BaseController;
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
        pageInfo.setRows(graduateProject.getContent());
        pageInfo.setTotal((int)graduateProject.getTotalElements());
        return pageInfo;
    }


    //确定校优
    @RequestMapping("projects/approveSchoolExcellentProject.html")
    public void approveExcellentProjectByDirector(Integer graduateProjectId, HttpServletResponse httpServletResponse) {
        GraduateProject graduateProject = graduateProjectService.findById(graduateProjectId);

        SchoolExcellentProject schoolExcellentProject = new SchoolExcellentProject();
        schoolExcellentProject.setGraduateProject(graduateProject);
        schoolExcellentProject.setRecommended(true);
        schoolExcellentProject = schoolExcellentProjectService.saveAndFlush(schoolExcellentProject);

        ProvinceExcellentProject provinceExcellentProject= new ProvinceExcellentProject();
        provinceExcellentProject.setGraudateProject(graduateProject);
        provinceExcellentProject= provinceExcellentProjectService.saveAndFlush(provinceExcellentProject);

//        //重新获取保存的schoolExcellentProject否则更新graduateProject会出错
//        schoolExcellentProject = schoolExcellentProjectService.uniqueResult("graduateProject", GraduateProject.class, graduateProject);
//        provinceExcellentProject = provinceExcellentProjectService.uniqueResult("graduateProject", GraduateProject.class, graduateProject);

        graduateProject.setSchoolExcellentProject(schoolExcellentProject);
        graduateProject.setProvinceExcellentProject(provinceExcellentProject);
        graduateProjectService.saveOrUpdate(graduateProject);

        CommonHelper.buildSimpleJson(httpServletResponse);
    }

    //驳回推优
    @RequestMapping("projects/cancelSchoolExcellentProject.html")
    public void cancelExcellentProjectByDirector(Integer graduateProjectId, HttpServletResponse httpServletResponse) {
        GraduateProject graduateProject = graduateProjectService.findById(graduateProjectId);

        SchoolExcellentProject schoolExcellentProject = graduateProject.getSchoolExcellentProject();
        schoolExcellentProject.setGraduateProject(null);
        schoolExcellentProject.setRecommended(null);

        ProvinceExcellentProject provinceExcellentProject = graduateProject.getProvinceExcellentProject();
        if(graduateProject.getProvinceExcellentProject()!=null) {
            provinceExcellentProject.setGraudateProject(null);
        }

        graduateProject.setSchoolExcellentProject(null);

        schoolExcellentProjectService.deleteObject(schoolExcellentProject);
        provinceExcellentProjectService.deleteObject(provinceExcellentProject);


        graduateProjectService.saveOrUpdate(graduateProject);
        CommonHelper.buildSimpleJson(httpServletResponse);
    }
}