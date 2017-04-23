package com.newview.bysj.web.evaluate.reviewer;

import com.newview.bysj.domain.*;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.reports.ReviewerCommitments;
import com.newview.bysj.util.Constants;
import com.newview.bysj.util.PageInfo;
import com.newview.bysj.util.Result;
import com.newview.bysj.web.baseController.BaseController;
import net.sf.jasperreports.engine.JRDataSource;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import org.apache.log4j.Logger;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.*;

/**
 * 评阅人评审
 * Created by zhan on 2016/3/24.
 */

@Controller
@RequestMapping("evaluate/reviewer")
public class ReviewerProjectToEvaluateController extends BaseController {

    private static final Logger logger = Logger.getLogger(ReviewerProjectToEvaluateController.class);

    //评阅人评审表的get方法
    @RequestMapping(value = "/projectsToEvaluate.html", method = RequestMethod.GET)
    public String reviewerEvaluate(ModelMap modelMap) {
        modelMap.put(Constants.EVALUATE_DISP, Constants.REPLY_REVIEWER);
        return "evaluate/projectEvaluateList";
    }

    /**
     * 根据评阅人和题目获取全部的课题
     *
     * @param httpSession 用于获取当前用户
     * @param title       题目的名称
     */
    @RequestMapping(value = "/getProjectsToEvaluateData.html", method = RequestMethod.POST)
    @ResponseBody
    public PageInfo reviewerEvaluatePost(HttpSession httpSession, String title, Integer page, Integer rows) {
        PageInfo pageInfo = new PageInfo();
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentTutor(httpSession).getId());
        HashMap<String, String> condition = new HashMap<>();
        if (title != null) {
            title = title.substring(0, title.length() - 1);
            condition.put("title", title);
        }
        Page<GraduateProject> graduateProjectPage = graduateProjectService
                .getPagesByReviewer(tutor, condition, page, rows);

        if (graduateProjectPage != null && graduateProjectPage.getSize() > 0) {
            pageInfo.setRows(graduateProjectPage.getContent());
            pageInfo.setTotal((int) graduateProjectPage.getTotalElements());
        }
        return pageInfo;
    }


    /**
     * 评审或修改的get方法
     *
     * @param graduateProjectId  需要修改或评审的id
     * @param httpSession        用于获取当前的用户，并获取对应的模版
     * @param model              用于存储需要在jsp获取的数据
     * @param httpServletRequest 用于获取请求的url
     * @return jsp
     */
    @RequestMapping(value = "/evaluateProject.html", method = RequestMethod.GET)
    public String evaluateProjectGet(Integer graduateProjectId, HttpSession httpSession, Model model, HttpServletRequest httpServletRequest) {
        GraduateProject graduateProject = graduateProjectService.findById(graduateProjectId);
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentTutor(httpSession).getId());
        //获取该用户的模版
        Collection<RemarkTemplate> remarkTemplateCollection = new ArrayList<>();
        //用于判断修改的课题是论文还是设计
        if (graduateProject.getClass() == DesignProject.class)
            remarkTemplateCollection.addAll(remarkTemplateForDesignReviewerService.list("department", Department.class, tutor.getDepartment()));
        else if (graduateProject.getClass() == PaperProject.class)
            remarkTemplateCollection.addAll(remarkTemplateForPaperReviewerService.list("department", Department.class, tutor.getDepartment()));
        //对当前课题的评审是否通过，为空则不通过
        if (graduateProject.getCommentByReviewer() != null) {
            model.addAttribute("isQualified", graduateProject.getCommentByReviewer().getQualifiedByReviewer());
        } else {
            model.addAttribute("isQualified", false);
        }
        model.addAttribute("graduateProject", graduateProject);
        model.addAttribute("actionURL", httpServletRequest.getRequestURI());
        model.addAttribute("remarkTemplates", remarkTemplateCollection);
        model.addAttribute("defaultGrades", CommonHelper.getDefaultGrades());
        return "evaluate/reviewer/EditOrAddEvaluate";
    }

    /**
     * 评审或修改的post方法
     *
     * @param graduateProject 从jsp页面传过来的graduateProject对象，前台使用了spring的form表单，可以自动绑定对象
     * @param remark          评语
     * @param qualified       是否可以答辩
     */
    @RequestMapping(value = "/evaluateProject.html", method = RequestMethod.POST)
    @ResponseBody
    public Result evaluateProjectPost(GraduateProject graduateProject, String remark, Boolean qualified) {
        Result result = new Result();
        try {
            GraduateProject graduateProjectEvaluate = graduateProjectService.findById(graduateProject.getId());
            //判断是修改还是初次评审
            if (graduateProjectEvaluate.getCommentByReviewer() == null) {
                CommentByReviewer commentByReviewer = new CommentByReviewer();
                this.saveEvaluateProject(graduateProject, graduateProjectEvaluate, qualified, remark, commentByReviewer);
            } else {
                CommentByReviewer commentByReviewer = graduateProjectEvaluate.getCommentByReviewer();
                this.saveEvaluateProject(graduateProject, graduateProjectEvaluate, qualified, remark, commentByReviewer);
            }
            result.setSuccess(true);
            result.setMsg("评审成功");
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("评审失败" + e);
            result.setMsg("评审失败");
        }
        return result;
    }

    private void saveEvaluateProject(GraduateProject graduateProject, GraduateProject graduateProjectEvaluate, Boolean qualified, String remark, CommentByReviewer commentByReviewer) {
        //评分阶段：成果的技术水平（实用性和创新性）（0—10分）
        commentByReviewer.setAchievementScore(graduateProject.getCommentByReviewer().getAchievementScore());
        //评分阶段：设计（论文）质量评分（正确性、条理性、 规范性、合理性、清晰、工作量）（0—10分）
        commentByReviewer.setQualityScore(graduateProject.getCommentByReviewer().getQualityScore());
        //审核
        commentByReviewer.setSubmittedByReviewer(true);
        //审核日期
        if (commentByReviewer.getSubmittedDate() == null)
            commentByReviewer.setSubmittedDate(CommonHelper.getNow());
        //评语
        commentByReviewer.setRemarkByReviewer(remark.replaceAll("\\s*|\t|\r|\n", ""));
        //工作量
        commentByReviewer.setReviewerEvaluationWordload(graduateProject.getCommentByReviewer().getReviewerEvaluationWordload());
        // 实物性能
        commentByReviewer.setReviewerEvaluationProductQuality(graduateProject.getCommentByReviewer().getReviewerEvaluationProductQuality());
        //说明书版面质量
        commentByReviewer.setReviewerEvaluationPrintingQuality(graduateProject.getCommentByReviewer().getReviewerEvaluationPrintingQuality());
        //难易程度
        commentByReviewer.setReviewerEvaluationDifficulty(graduateProject.getCommentByReviewer().getReviewerEvaluationDifficulty());
        //图文质量
        commentByReviewer.setReviewerEvaluationDiagramQuality(graduateProject.getCommentByReviewer().getReviewerEvaluationDiagramQuality());
        //是否允许答辩
        commentByReviewer.setQualifiedByReviewer(qualified);
        graduateProjectEvaluate.setCommentByReviewer(commentByReviewer);
        graduateProjectService.saveOrUpdate(graduateProjectEvaluate);
    }


    @RequestMapping("/printReport.html")
    public String printEvaluateReport(Integer reportId, HttpServletRequest httpServletRequest, Model model) throws NoSuchMethodException, InvocationTargetException, IllegalAccessException {
        //创建用于存放报表数据的list集合
        List<ReviewerCommitments> reviewerCommitmentsList = new ArrayList<>();
        //获取当前的课题
        GraduateProject graduateProject = graduateProjectService.findById(reportId);
        ReviewerCommitments reviewerCommitments = new ReviewerCommitments();
        Calendar reviewerAuditTime = graduateProject.getCommentByReviewer().getSubmittedDate();
        //如果没有副标题，则只显示标题
        if (graduateProject.getSubTitle().length() == 0) {
            reviewerCommitments.setTitle(graduateProject.getTitle());
        } else {
            reviewerCommitments.setTitle(graduateProject.getTitle() + "----" + graduateProject.getSubTitle());
        }

        reviewerCommitments.setStudentClass(graduateProject.getStudent().getStudentClass().getDescription());
        //如果没有姓名，则显示为无名氏
        if (graduateProject.getStudent().getName() == null) {
            reviewerCommitments.setName("无名氏");
        } else {
            reviewerCommitments.setName(graduateProject.getStudent().getName());
        }

        //学生的学号
        reviewerCommitments.setNumber(graduateProject.getStudent().getNo());
        String basePath = CommonHelper.getRootPath(httpServletRequest.getSession());
        //老师如果没有签名照片，则显示透明的图片
        if (graduateProject.getReviewer().getSignPictureURL() == null) {
            reviewerCommitments.setSignature(basePath + "/images/signature/open.png");
            reviewerCommitments.setSignature_txt(graduateProject.getReviewer().getName());
        } else {
            reviewerCommitments.setSignature(CommonHelper.getUploadPath(httpServletRequest.getSession()) + graduateProject.getReviewer().getSignPictureURL());
            reviewerCommitments.setSignature_txt(" ");
        }

        reviewerCommitments.setYear(CommonHelper.getYearByCalendar(reviewerAuditTime));
        reviewerCommitments.setMonth(CommonHelper.getMonthByCalendar(reviewerAuditTime));
        reviewerCommitments.setDay(CommonHelper.getDayOfMontyByCalendar(reviewerAuditTime));
        //课题质量得分
        reviewerCommitments.setQualityScore(graduateProject.getCommentByReviewer().getQualityScore());
        //成果水平得分
        reviewerCommitments.setAchivementScore(graduateProject.getCommentByReviewer().getAchievementScore());
        //总分
        reviewerCommitments.setSum(graduateProject.getCommentByReviewer().getTotalScoreReviewer());
        //评阅人的评语
        if (graduateProject.getCommentByReviewer().getQualifiedByReviewer()) {
            reviewerCommitments.setRemarkofCommentFromReviewer(graduateProject.getCommentByReviewer().getRemarkByReviewer() + System.getProperty("line.separator") + "同意答辩");
        } else {
            reviewerCommitments.setRemarkofCommentFromReviewer(graduateProject.getCommentByReviewer().getRemarkByReviewer() + System.getProperty("line.separator") + "不同意答辩");
        }
        String yes = basePath + "/images/signature/duihao.png";
        //获取反射类
        Class clazz = reviewerCommitments.getClass();
        //难易程度
        //reviewerEvaluationDifficulty_
        Method setReviewerEvaluateDifficulty = clazz.getMethod("setReviewerEvaluationDifficulty_" + graduateProject.getCommentByReviewer().getReviewerEvaluationDifficulty(), String.class);
        setReviewerEvaluateDifficulty.invoke(reviewerCommitments, yes);
        //工作量
        Method setReviewerEvaluationWordload = clazz.getMethod("setReviewerEvaluationWordload_" + graduateProject.getCommentByReviewer().getReviewerEvaluationWordload(), String.class);
        setReviewerEvaluationWordload.invoke(reviewerCommitments, yes);
        //说明书（论文）版面质量
        Method setReviewerEvaluationPrintingQuality = clazz.getMethod("setReviewerEvaluationPrintingQuality_" + graduateProject.getCommentByReviewer().getReviewerEvaluationPrintingQuality(), String.class);
        setReviewerEvaluationPrintingQuality.invoke(reviewerCommitments, yes);
        //图样质量
        Method setReviewerEvaluationDiagramQuality = clazz.getMethod("setReviewerEvaluationDiagramQuality_" + graduateProject.getCommentByReviewer().getReviewerEvaluationDiagramQuality(), String.class);
        setReviewerEvaluationDiagramQuality.invoke(reviewerCommitments, yes);
        //实物性能
        Method setReviewerEvaluationProductQuality = clazz.getMethod("setReviewerEvaluationProductQuality_" + graduateProject.getCommentByReviewer().getReviewerEvaluationProductQuality(), String.class);
        setReviewerEvaluationProductQuality.invoke(reviewerCommitments, yes);

        //Integer sum = graduateProject.getCommentByReviewer().getAchievementScore() + graduateProject.getCommentByReviewer().getQualityScore();
        reviewerCommitmentsList.add(reviewerCommitments);
        JRDataSource jrBeanCollectionDataSource = new JRBeanCollectionDataSource(reviewerCommitmentsList);
        model.addAttribute("url", "/WEB-INF/reports/ReviewerReport.jrxml");
        model.addAttribute("format", "pdf");
        model.addAttribute("jrMainDataSource", jrBeanCollectionDataSource);

        return "iReportView";
    }


}
