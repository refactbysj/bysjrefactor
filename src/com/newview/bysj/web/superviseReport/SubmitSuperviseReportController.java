package com.newview.bysj.web.superviseReport;

import com.newview.bysj.domain.SchoolSupervisionReport;
import com.newview.bysj.domain.Tutor;
import com.newview.bysj.exception.MessageException;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.util.PageInfo;
import com.newview.bysj.util.Result;
import com.newview.bysj.web.baseController.BaseController;
import org.apache.log4j.Logger;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;

/**
 * Created by zhan on 2016/4/9.
 */
@Controller
@RequestMapping
public class SubmitSuperviseReportController extends BaseController {

    private static final Logger logger = Logger.getLogger(SubmitSuperviseReportController.class);

    //提交督导报告的方法
    @RequestMapping("/process/submitSuperviseReport.html")
    public String superviseReport(ModelMap modelMap, HttpSession httpSession, Integer pageNo, Integer pageSize, HttpServletRequest httpServletRequest) {
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentTutor(httpSession).getId());
        Page<SchoolSupervisionReport> schoolSupervisionReportPage = schoolSupervisionReportService.getPageByTutor(tutor, pageNo, pageSize);
        CommonHelper.pagingHelp(modelMap, schoolSupervisionReportPage, "supervisionReportList", httpServletRequest.getRequestURI(), schoolSupervisionReportPage.getTotalElements());
        return "supervise/listSuperviseReport";
    }

    @RequestMapping("/process/checkSuperviseReport.html")
    @ResponseBody
    public PageInfo checkSuperviseReport(HttpSession httpSession, Integer pageNo, Integer pageSize) {
        PageInfo pageInfo = new PageInfo();
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentTutor(httpSession).getId());
        Page<SchoolSupervisionReport> schoolSupervisionReportPage = schoolSupervisionReportService.getPageByTutor(tutor, pageNo, pageSize);
        pageInfo.setRows(schoolSupervisionReportPage.getContent());
        pageInfo.setTotal((int)schoolSupervisionReportPage.getTotalElements());
        return pageInfo;
    }
    //转向子页面
    @RequestMapping(value = "/process/touploadSupervisionReport.html")
    public String upload(){
        return "/supervise/uploadSuperviseReport";
    }


    //上传督导报告的方法
    @RequestMapping(value = "/process/uploadSupervisionReport.html", method = RequestMethod.POST)
    @ResponseBody
    public Result uploadSuperviseReport(MultipartFile superReportFile, HttpSession httpSession, HttpServletResponse httpServletResponse) {
        Result result = new Result();
        //获取上传报告的用户
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentTutor(httpSession).getId());
        if (superReportFile != null && superReportFile.getSize() > 0) {
            //获取文件名
            String fileName = System.currentTimeMillis() + tutor.getDepartment().getSchool().getDescription() + superReportFile.getOriginalFilename();
            //获取上传的路径
            String url = CommonHelper.fileUpload(superReportFile, httpSession, "superReport", fileName);
            SchoolSupervisionReport schoolSupervisionReport = new SchoolSupervisionReport();
            schoolSupervisionReport.setSchool(tutor.getDepartment().getSchool());
            schoolSupervisionReport.setCalendar(CommonHelper.getNow().getTime());
            schoolSupervisionReport.setIssuer(tutor);
            schoolSupervisionReport.setUrl(url);
            schoolSupervisionReportService.saveOrUpdate(schoolSupervisionReport);
            result.setSuccess(true);
            result.setMsg("上传成功！");
        } else {
            result.setMsg("上传失败！");
            throw new MessageException("获取上传的文件失败");
        }
        return result;
    }

    @RequestMapping("/process/delSuperReport.html")
    @ResponseBody
    public Result delSuperReport(Integer reportId) {
        Result result = new Result();
        //根据id找到文件进行删除
        schoolSupervisionReportService.deleteById(reportId);
        //给后台返回删除信息
        if(schoolSupervisionReportService.findById(reportId)==null){
            result.setSuccess(true);
            result.setMsg("删除成功！");
        }else {
            result.setMsg("删除失败！");
        }
        return result;
    }


    //下载督导报告的方法
    @RequestMapping("/process/downloadSupervisionReport.html")
    public ResponseEntity<byte[]> downLoadSuperReport(Integer reportId, HttpSession httpSession) throws IOException {
        //获取要下载的督导报告
        SchoolSupervisionReport schoolSupervisionReport = schoolSupervisionReportService.findById(reportId);
        return CommonHelper.download(httpSession, schoolSupervisionReport.getUrl(), new File(schoolSupervisionReport.getUrl()).getName());
    }
}
