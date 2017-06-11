package com.newview.bysj.web.schoolExcellentProject;

import com.newview.bysj.domain.SchoolExcellentProject;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.util.PageInfo;
import com.newview.bysj.web.baseController.BaseController;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;

@Controller
public class CheckSchoolExcellentProjectController extends BaseController {
	//转到查看校优页面
	@RequestMapping("projects/listSchoolExcellentProjects")
	public String toPage(){
		return "excellentProjects/checkSchoolExcellentProjects";
	}
	//查看校优的初界面和查询功能
	@RequestMapping("projects/listSchoolExcellentProjectsList.html")
	@ResponseBody
	public PageInfo list(String title, String tutorName, Integer page, Integer rows){
		PageInfo pageInfo = new PageInfo();
		Page<SchoolExcellentProject> currentPage = schoolExcellentProjectService.getPagesSchoolExcellentProjectBySchoolAmin(title == null ? "" : title, tutorName == null ? "" : tutorName, null, page, rows);
		if (currentPage != null) {
			pageInfo.setRows(currentPage.getContent());
			pageInfo.setTotal((int) currentPage.getTotalElements());
		}
		return pageInfo;
	}
	//教研室主任确定省优候选人资格
	@RequestMapping("projects/approveProvinceExcellentProjectByDirector.html")
	public void approveExcellentProjectByDirector(Integer graduateProjectId,HttpServletResponse httpServletResponse){
		SchoolExcellentProject schoolExcellentProject = schoolExcellentProjectService.findById(graduateProjectId);
		//SchoolExcellentProject schoolExcellentProject=schoolExcellentProjectService.findById(schoolExcellentProjectId);
		schoolExcellentProject.setRecommended(true);
		schoolExcellentProjectService.saveAndFlush(schoolExcellentProject);
		CommonHelper.buildSimpleJson(httpServletResponse);
		
	}
	//教研室主任取消省优候选人资格
	@RequestMapping("projects/cancelProvinceExcellentProjectByDirector.html")
	public void cancelExcellentProjectByDirecor(Integer graduateProjectId,HttpServletResponse httpServeltResponse){
		SchoolExcellentProject schoolExcellentProject = schoolExcellentProjectService.findById(graduateProjectId);
		//SchoolExcellentProject schoolExcellentProject=schoolExcellentProjectService.findById(schoolExcellentProjectId);
		schoolExcellentProject.setRecommended(null);
		schoolExcellentProjectService.saveOrUpdate(schoolExcellentProject);
		CommonHelper.buildSimpleJson(httpServeltResponse);
	}
}
