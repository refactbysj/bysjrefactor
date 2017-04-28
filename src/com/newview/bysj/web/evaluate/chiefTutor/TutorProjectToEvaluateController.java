package com.newview.bysj.web.evaluate.chiefTutor;

import com.newview.bysj.domain.*;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.reports.TutorCommitments;
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
import java.util.*;

/**
 * 主指导老师的评审的controller
 * Created by zhan on 2016/3/24.
 */

@Controller
@RequestMapping("evaluate/chiefTutor")
public class TutorProjectToEvaluateController extends BaseController {

    private static final Logger logger = Logger.getLogger(TutorProjectToEvaluateController.class);

    /**
     * 跳转到指导教师评审表页面
     */
    @RequestMapping(value = "/projectsToEvaluate.html", method = RequestMethod.GET)
    public String chiefTutorEvaluateGet(ModelMap modelMap) {
        /*
        设置显示模式
        多个角色的评审共用一个jsp页面，下面的作用是用来获取是哪一个角色的评审
         */
        modelMap.put(Constants.EVALUATE_DISP, Constants.REPLY_TUTOR);
        return "evaluate/projectEvaluateList";
    }

    /**
     * 根据指导老师和题目的名称获取全部的课题
     *
     * @param httpSession 当前会话，用于获取当前的用户
     * @param modelMap    用于存储需要在jsp中获取的数据
     * @param page        当前页
     * @param rows        每页的条数
     * @param title       课题的题目
     * @return jsp
     */
    @RequestMapping(value = "/getTutorProjectsToEvaluateData.html", method = RequestMethod.POST)
    @ResponseBody
    public PageInfo chiefTutorEvaluatePost(HttpSession httpSession, ModelMap modelMap, Integer page, Integer rows, String title) {
        PageInfo pageInfo = new PageInfo();
        //获取当前tutor
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentTutor(httpSession).getId());
        //用于存放查询的条件
        HashMap<String, String> condition = new HashMap<>();
        //如果查询条件不为空，则添加到集合当中
        if (title != null) {
            condition.put("title", title);
            //去除最后一个逗号
            modelMap.put("title", title.substring(0, title.length() - 1));
        }
        //根据主指导和查询条件获取对应的课题
        Page<GraduateProject> graduateProjectPage = graduateProjectService.getPagesByMainTutorageWithConditions(tutor, page, rows, condition);
        if (graduateProjectPage != null && graduateProjectPage.getSize() > 0) {
            pageInfo.setRows(graduateProjectPage.getContent());
            pageInfo.setTotal((int) graduateProjectPage.getTotalElements());
        }
        return pageInfo;
    }

    /**
     * 添加或修改指导老师评审表的get方法
     *
     * @param projectIdToEvaluate 需要修改的对应课题的id
     * @param httpSession         用于获取当前的用户
     * @param model               用于存储需要在jsp中渲染的模型数据
     * @param httpServletRequest  用于获取请求的路径
     * @return jsp
     */
    @RequestMapping(value = "/evaluateProject.html", method = RequestMethod.GET)
    public String evaluateProjectGet(Integer projectIdToEvaluate, HttpSession httpSession, Model model, HttpServletRequest httpServletRequest) {
        //获取指定的课题
        GraduateProject graduateProject = graduateProjectService.findById(projectIdToEvaluate);
        Tutor tutor = tutorService.findById(CommonHelper.getCurrentTutor(httpSession).getId());
        //创建一个集合，用来存放当前用户所在教研室的评审模版
        Collection<RemarkTemplate> remarkTemplateCollection = new ArrayList<>();
        //如果当前课题是设计课题，则获取当前老师所在教研室的指导老师设计课题的评审模版
        if (graduateProject.getClass() == DesignProject.class)
            remarkTemplateCollection.addAll(remarkTemplateForDesignTutorService.list("department", Department.class, tutor.getDepartment()));
        else if (graduateProject.getClass() == PaperProject.class)
            remarkTemplateCollection.addAll(remarkTemplateForPaperTutorService.list("department", Department.class, tutor.getDepartment()));
        if (graduateProject.getCommentByTutor() != null) {
            //当前老师对该课题的评审是否通过
            model.addAttribute("isQualified", graduateProject.getCommentByTutor().getQualifiedByTutor());
        } else {
            model.addAttribute("isQualified", false);
            // TODO: 2017/4/27 0027 获取终稿的字数
        }

        model.addAttribute("graduateProject", graduateProject);
        model.addAttribute("remarkTemplates", remarkTemplateCollection);
        model.addAttribute("actionURL", httpServletRequest.getRequestURI());
        model.addAttribute("defaultGrades", CommonHelper.getDefaultGrades());
        return "evaluate/chiefTutor/addOrEditEvaluate";
    }


    /**
     * 获取终稿字数
     */
    @RequestMapping(value = "/getFinalDraftCharCount", method = RequestMethod.POST)
    @ResponseBody
    public Result getFinalDraftCharCount(Integer projectId, HttpSession httpSession) {
        Result result = new Result();
        try {
            GraduateProject graduateProject = graduateProjectService.findById(projectId);
            String finalPath = graduateProject.getFinalDraft();
            logger.info("获取的" + graduateProject.getStudent().getName() + "终稿文件路径" + finalPath);
            result.setObject(CommonHelper.getCharCountByFilePath(finalPath, httpSession));
            result.setSuccess(true);
            result.setMsg("获取论文字数成功");
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("获取论文字数失败");
            e.printStackTrace();
            result.setMsg("获取论文字数失败");
        }
        return result;
    }


    /**
     * 添加或修改指导老师评审表的提交方法
     *
     * @param graduateProjectId       需要添加或修改的评审表对应的id
     * @param remark                  指导老师的评语
     * @param graduateProject         评审的课题，spring表单绑定的对象
     * @param httpSession             用于获取当前数据
     * @param commentByTutorQualified 是否允许答辩
     * @return 重定向到指导老师评审表的jsp
     */
    @RequestMapping(value = "/evaluateProject.html", method = RequestMethod.POST)
    @ResponseBody
    public Result evaluateProjectPost(Integer graduateProjectId, String remark, GraduateProject graduateProject, HttpSession httpSession, Boolean commentByTutorQualified) {
        Result result = new Result();
        try {
            //获取当前tutor
            Tutor tutor = tutorService.findById(CommonHelper.getCurrentTutor(httpSession).getId());
            //得到数据库中对应的课题
            GraduateProject graduateProjectEvaluate = graduateProjectService.findById(graduateProjectId);
            //如果是第一次对该课题进行评审操作
            if (graduateProjectEvaluate.getCommentByTutor() == null) {
                CommentByTutor commentByTutor = new CommentByTutor();
                this.saveEvaluateByTutor(tutor, graduateProject, graduateProjectEvaluate, commentByTutor, commentByTutorQualified, remark);
            }
            //获取该课题原来的评审
            else {
                CommentByTutor commentByTutor = graduateProjectEvaluate.getCommentByTutor();
                this.saveEvaluateByTutor(tutor, graduateProject, graduateProjectEvaluate, commentByTutor, commentByTutorQualified, remark);
            }
            result.setSuccess(true);
            result.setMsg("评审成功");
        } catch (Exception e) {
            logger.error("修改指导老师评审表失败" + e);
            e.printStackTrace();
            result.setMsg("评审失败");
        }

        return result;
    }

    /**
     * 保存老师评审表的方法
     * <p>
     * 建议将该方法改为私有的，只供本类中使用
     *
     * @param tutor                     当前的tutor
     * @param graduateProject           评审后的课题
     * @param graduateProjectByEvaluate 需要被评审的课题
     * @param commentByTutor            当前课题的评审老师
     * @param qualified                 是否通过
     * @param remark                    评语
     */
    private void saveEvaluateByTutor(Tutor tutor, GraduateProject graduateProject, GraduateProject graduateProjectByEvaluate, CommentByTutor commentByTutor, Boolean qualified, String remark) {
        commentByTutor.setAchievementLevelScore(graduateProject.getCommentByTutor().getAchievementLevelScore());
        commentByTutor.setBasicAblityScore(graduateProject.getCommentByTutor().getBasicAblityScore());
        commentByTutor.setWorkAblityScore(graduateProject.getCommentByTutor().getWorkAblityScore());
        commentByTutor.setWorkLoadScore(graduateProject.getCommentByTutor().getWorkLoadScore());
        commentByTutor.setSubmittedByTutor(true);
        commentByTutor.setQualifiedByTutor(qualified);
        if (commentByTutor.getSubmittedDate() == null) {
            commentByTutor.setSubmittedDate(CommonHelper.getNow());
        }
        //论文字数
        commentByTutor.setTutorEvaluteDissertationWordCount(graduateProject.getCommentByTutor().getTutorEvaluteDissertationWordCount());
        //是否完成
        commentByTutor.setTutorEvaluteHasCompleteProject(graduateProject.getCommentByTutor().getTutorEvaluteHasCompleteProject());
        commentByTutor.setTutorEvaluteHasMiddleExam(graduateProject.getCommentByTutor().getTutorEvaluteHasMiddleExam());
        //外文资料翻译
        commentByTutor.setTutorEvaluteHasTranslationMaterail(graduateProject.getCommentByTutor().getTutorEvaluteHasTranslationMaterail());
        //中英摘要
        commentByTutor.setTutorEvaluteHasTwoAbstract(graduateProject.getCommentByTutor().getTutorEvaluteHasTwoAbstract());
        //外语资料翻译的字数
        commentByTutor.setTutorEvaluteHasTranslationWordCount(graduateProject.getCommentByTutor().getTutorEvaluteHasTranslationWordCount());
        //将评语中与正则表达式匹配的内容进行替换
        commentByTutor.setRemark(remark.replaceAll("\\s*|\t|\r|\n", ""));
        commentByTutor.setTutorCommenter(tutor);
        graduateProjectByEvaluate.setCommentByTutor(commentByTutor);
        graduateProjectService.saveOrUpdate(graduateProjectByEvaluate);
    }


    /**
     * 查看指导老师评审表的方法
     *
     * @param projectId 需要查看的评审表对应课题的id
     * @param model  用于存储需要在jsp中进行渲染的数据
     * @return jsp
     */
    @RequestMapping(value = "/viewTutorEvaluate.html", method = RequestMethod.GET)
    public String viewTutorEvaluate(Integer projectId, Model model) {
        //获取对应的课题
        GraduateProject graduateProject = graduateProjectService.findById(projectId);
        model.addAttribute("graduateProject", graduateProject);
        return "evaluate/viewEvaluate/viewTutorEvaluate";
    }

    /**
     * 将评审表生成报表的方法
     * <p>
     * 对一些属性需要进行非空的判断，以免出现空指针异常
     *
     * @param reportId           评审表的id
     * @param httpServletRequest 用于获取签名照上传的路径
     * @param model              用于存储数据
     * @return 报表
     */
    @RequestMapping("/printReport.html")
    public String printReport(Integer reportId, HttpServletRequest httpServletRequest, Model model) {
        //创建用于存放报表数据的list集合
        List<TutorCommitments> tutorCommitmentsList = new ArrayList<>();
        TutorCommitments tutorCommitments = new TutorCommitments();
        GraduateProject graduateProject = graduateProjectService.findById(reportId);
        //获取审核的时间
        //运行时报了空指针的异常
        //Calendar calendar = graduateProject.getAuditByTutor().getAuditDate();
        //如果没有副标题，则只显示题目。如果有副标题，则加上。  标题--副标题
        if (graduateProject.getSubTitle() == null) {
            tutorCommitments.setTitle(graduateProject.getTitle());
        } else {
            tutorCommitments.setTitle(graduateProject.getTitle() + "----" + graduateProject.getSubTitle());
        }
        //当前课题对应的学生有没有姓名
        if (graduateProject.getStudent().getName() == null) {
            tutorCommitments.setName("无名氏");
        } else {
            tutorCommitments.setName(graduateProject.getStudent().getName());
        }
        //课题学生所在的班级
        tutorCommitments.setStudentClass(graduateProject.getStudent().getStudentClass().getDescription());
        //学生的学号
        tutorCommitments.setNumber(graduateProject.getStudent().getName());
        //基本知识、基本理论等分数
        if (graduateProject.getCommentByTutor().getBasicAblityScore() == null) {
            tutorCommitments.setBasicAbilityScore(0);
        } else {
            tutorCommitments.setBasicAbilityScore(graduateProject.getCommentByTutor().getBasicAblityScore());
        }
        //工作量、工作态度得分
        if (graduateProject.getCommentByTutor().getWorkLoadScore() == null) {
            tutorCommitments.setWorkLoadScore(0);
        } else {
            tutorCommitments.setWorkLoadScore(graduateProject.getCommentByTutor().getWorkLoadScore());
        }
        //独立工作能力、分析与解决问题的能力得分
        if (graduateProject.getCommentByTutor().getWorkAblityScore() == null) {
            tutorCommitments.setWorkAbilityScore(0);
        } else {
            tutorCommitments.setWorkAbilityScore(graduateProject.getCommentByTutor().getWorkAblityScore());
        }
        //完成任务情况及水平得分
        if (graduateProject.getCommentByTutor().getAchievementLevelScore() == null) {
            tutorCommitments.setAchievementLevelScore(0);
        } else {
            tutorCommitments.setAchievementLevelScore(graduateProject.getCommentByTutor().getAchievementLevelScore());
        }
        //是否同意答辩
        if (graduateProject.getCommentByTutor().getQualifiedByTutor()) {
            //原程序中使用\r\n来进行换行，这只是在windows系统下起作用，在unix下为\n。因此动态获取换行符，使具有更好的平台可移植性
            tutorCommitments.setRemarkOfCommentFromTutor(graduateProject.getCommentByTutor().getRemark() + System.getProperty("line.separator") + "同意答辩");
        } else {
            tutorCommitments.setRemarkOfCommentFromTutor(graduateProject.getCommentByTutor().getRemark() + System.getProperty("line.separator") + "不同意答辩");
        }
        //Calendar calendar = Calendar.getInstance();
        Calendar calendar = graduateProject.getCommentByTutor().getSubmittedDate();
        //设置时间
        tutorCommitments.setYear(CommonHelper.getYearByCalendar(calendar));
        //月份是从0开始计的
        tutorCommitments.setMonth(CommonHelper.getMonthByCalendar(calendar));
        tutorCommitments.setDay(CommonHelper.getDayOfMontyByCalendar(calendar));
        //获取根路径
        String basePath = CommonHelper.getRootPath(httpServletRequest.getSession());
        //教师有没有上传签名照片
        if (graduateProject.getMainTutorage().getTutor().getSignPictureURL() != null) {
            tutorCommitments.setSignature(CommonHelper.getUploadPath(httpServletRequest.getSession()) + graduateProject.getCommentByTutor().getTutorCommenter().getSignPictureURL());
            tutorCommitments.setSignature_txt(" ");
        } else {
            tutorCommitments.setSignature(basePath + "/images/signature/open.png");
            tutorCommitments.setSignature_txt(graduateProject.getMainTutorage().getTutor().getName());
        }
        Integer sum = graduateProject.getCommentByTutor().getAchievementLevelScore() + graduateProject.getCommentByTutor().getBasicAblityScore() + graduateProject.getCommentByTutor().getWorkAblityScore() + graduateProject.getCommentByTutor().getWorkLoadScore();
        tutorCommitments.setSum(sum);
        String yes = "/images/signature/duihao.png";
        //是否已经完成了任务
        if (graduateProject.getCommentByTutor().getTutorEvaluteHasCompleteProject()) {
            tutorCommitments.setFinishWork(basePath + yes);
        } else {
            tutorCommitments.setNoFinishWork(basePath + yes);
        }
        //论文字数
        if (graduateProject.getCommentByTutor().getTutorEvaluteDissertationWordCount() == 0) {
            tutorCommitments.setProjectWordNum(0);
        } else {
            tutorCommitments.setProjectWordNum(graduateProject.getCommentByTutor().getTutorEvaluteDissertationWordCount());
        }
        //是否是论文课题
        if (graduateProject instanceof PaperProject) {
            PaperProject paperProject = (PaperProject) graduateProject;
            if (paperProject.getOpenningReport() == null) {
                tutorCommitments.setNoOpenningReport(basePath + yes);
            } else {
                tutorCommitments.setOpenningReport(basePath + yes);
            }
        } else {
            tutorCommitments.setNoOpenningReport(basePath + yes);
        }

        //有无中期检查表
        if (graduateProject.getCommentByTutor().getTutorEvaluteHasMiddleExam()) {
            tutorCommitments.setMiddleExam(basePath + yes);
        } else {
            tutorCommitments.setNoMiddleExam(basePath + yes);
        }

        //有无外文资料翻译
        if (graduateProject.getCommentByTutor().getTutorEvaluteHasTranslationMaterail()) {
            tutorCommitments.setTranslationMaterail(basePath + yes);
        } else {
            tutorCommitments.setNoTranslationMaterail(basePath + yes);
        }

        //外语资料翻译的字数
        if (graduateProject.getCommentByTutor().getTutorEvaluteHasTranslationWordCount() == null) {
            tutorCommitments.setTranslationWordCount(0);
        } else {
            tutorCommitments.setTranslationWordCount(graduateProject.getCommentByTutor().getTutorEvaluteHasTranslationWordCount());
        }

        //有无中、英摘要
        if (graduateProject.getCommentByTutor().getTutorEvaluteHasTwoAbstract()) {
            tutorCommitments.setTwoAbstract(basePath + yes);
        } else {
            tutorCommitments.setNoTwoAbstract(basePath + yes);
        }

        //软硬件的完成情况
        if (graduateProject.getCommentByTutor().getTutorEvaluteHasSoftHardWare() != null && graduateProject.getCommentByTutor().getTutorEvaluteHasSoftHardWare()) {
            tutorCommitments.setSoftHardWare(basePath + yes);
        } else {
            tutorCommitments.setNoSoftHardWare(basePath + yes);
        }

        //累计旷课时间
        if (graduateProject.getCommentByTutor().getTutorEvaluteAttendance() == null) {
            tutorCommitments.setAttendance("无");
            tutorCommitments.setAttendanceOfHouse(0);
        } else {
            if (graduateProject.getCommentByTutor().getTutorEvaluteAttendance() == 0) {
                tutorCommitments.setAttendance("无");
                tutorCommitments.setAttendanceOfHouse(0);
            } else {
                tutorCommitments.setAttendance("有");
                tutorCommitments.setAttendanceOfHouse(graduateProject.getCommentByTutor().getTutorEvaluteAttendance());
            }
        }

        tutorCommitmentsList.add(tutorCommitments);
        JRDataSource jrBeanCollectionDataSource = new JRBeanCollectionDataSource(tutorCommitmentsList);
        model.addAttribute("url", "/WEB-INF/reports/ChiefTutorReport.jrxml");
        //报表格式
        model.addAttribute("format", "pdf");
        model.addAttribute("jrMainDataSource", jrBeanCollectionDataSource);
        return "iReportView";
    }
}

