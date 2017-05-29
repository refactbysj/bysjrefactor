package com.newview.bysj.web.provinceExcellentProject;


import com.newview.bysj.domain.GraduateProject;
import com.newview.bysj.domain.ProvinceExcellentProject;
import com.newview.bysj.domain.SchoolExcellentProject;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.service.GraduateProjectService;
import com.newview.bysj.util.PageInfo;
import com.newview.bysj.web.baseController.BaseController;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

@Controller
public class CheckProvinceExcellentProject extends BaseController {
	@RequestMapping("projects/listProvenceExcellentProjects.html")
	public String toPage(){
		return "excellentProjects/checkProvinceExcellentProjects";
	}
	@RequestMapping("projects/listProvenceExcellentProjectsList.html")
	@ResponseBody
	public PageInfo checkProvinceExcellentProject( Integer page, @ModelAttribute("title") String title, @ModelAttribute("tutorName") String tutorName , Integer rows){
		PageInfo pageInfo = new PageInfo();
		List<ProvinceExcellentProject> provinceExcellentProjects=provinceExcellentProjectService.findAll();
		List<Integer> ids= new ArrayList<>();
		for(ProvinceExcellentProject provinceExcellentProject:provinceExcellentProjects){
			ids.add(provinceExcellentProject.getGraudateProject().getId());
		}
		//显示省优课题和查询省优课题
		//Page<ProvinceExcellentProject> currentPage = provinceExcellentProjectService.getPagesProvinceExcellentProjectsBySchoolAdmin(title==null?"":title, tutorName==null?"":tutorName, page, rows);
		Page<GraduateProject> currentPage = graduateProjectService.getPagesForProvinceExcellentCandidate(title==null?"":title, tutorName==null?"":tutorName, page, rows,ids);
		pageInfo.setRows(currentPage.getContent());
		pageInfo.setTotal(currentPage.getNumberOfElements());
		return pageInfo;
	}
}
