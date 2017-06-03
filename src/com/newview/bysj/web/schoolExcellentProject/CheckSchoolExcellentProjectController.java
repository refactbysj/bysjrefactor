package com.newview.bysj.web.schoolExcellentProject;

import com.newview.bysj.domain.GraduateProject;
import com.newview.bysj.domain.SchoolExcellentProject;
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
import java.util.ArrayList;
import java.util.List;

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
		List<SchoolExcellentProject> schoolExcellentProjects=schoolExcellentProjectService.findAll();
		List<Integer> ids= new ArrayList<>();
		for(SchoolExcellentProject schoolExcellentProject:schoolExcellentProjects){
			ids.add(schoolExcellentProject.getGraduateProject().getId());
		}
		Page<GraduateProject> currentPage=graduateProjectService.getPagesForExcellentCandidate(title==null?"":title,tutorName==null?"":tutorName,null, page, rows,ids);
		pageInfo.setRows(currentPage.getContent());
		pageInfo.setTotal(currentPage.getNumberOfElements());
		return pageInfo;
	}
	//教研室主任确定省优候选人资格
	@RequestMapping("projects/approveProvinceExcellentProjectByDirector.html")
	public void approveExcellentProjectByDirector(Integer graduateProjectId,HttpServletResponse httpServletResponse){
		SchoolExcellentProject schoolExcellentProject=graduateProjectService.findById(graduateProjectId).getSchoolExcellentProject();
		//SchoolExcellentProject schoolExcellentProject=schoolExcellentProjectService.findById(schoolExcellentProjectId);
		schoolExcellentProject.setRecommended(true);
		schoolExcellentProjectService.saveOrUpdate(schoolExcellentProject);
		CommonHelper.buildSimpleJson(httpServletResponse);
		
	}
	//教研室主任取消省优候选人资格
	@RequestMapping("projects/cancelProvinceExcellentProjectByDirector.html")
	public void cancelExcellentProjectByDirecor(Integer graduateProjectId,HttpServletResponse httpServeltResponse){
		SchoolExcellentProject schoolExcellentProject=graduateProjectService.findById(graduateProjectId).getSchoolExcellentProject();
		//SchoolExcellentProject schoolExcellentProject=schoolExcellentProjectService.findById(schoolExcellentProjectId);
		schoolExcellentProject.setRecommended(null);
		schoolExcellentProjectService.saveOrUpdate(schoolExcellentProject);
		CommonHelper.buildSimpleJson(httpServeltResponse);
	}
}
