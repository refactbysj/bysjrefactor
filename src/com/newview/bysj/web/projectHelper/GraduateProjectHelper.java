package com.newview.bysj.web.projectHelper;

import com.newview.bysj.domain.*;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.service.ConstraintOfProposeProjectService;
import com.newview.bysj.service.DesignProjectService;
import com.newview.bysj.service.GraduateProjectService;
import com.newview.bysj.service.PaperProjectService;
import org.apache.log4j.Logger;
import org.springframework.data.domain.Page;
import org.springframework.ui.ModelMap;

import java.text.SimpleDateFormat;

/**
 * Created 2016/3/6,19:35.
 * Author 张战.
 */
public class GraduateProjectHelper {

    public static final String VIEW_ALL = "all";

    public static final String VIEW_DESIGN = "design";

    public static final String VIEW_PAPAER = "paper";

    private static final Logger logger = Logger.getLogger(GraduateProjectHelper.class);

    private static final String SHOW_NAME = "ifShowAll";
    private static final String ABLE_TO_UPDATE = "ABLE_TO_UPDATE";
    private static final Boolean ACTION_EDIT_PROJECT = false;

    public static String editProject(GraduateProject graduateProject) {
        if (graduateProject.getCategory().equals("设计题目"))
            return "redirect:/process/addOrEditDesignProject";
        else
            return "redirect:/process/addOrEditPaperProject";
    }

    /**
     * 用来在选题流程中，查看全部题目、查看论文题目、查看设计题目高亮显示当前的处于哪个功能下
     *
     * @param modelMap    用于存储需要在jsp中获取的数据
     * @param description 用于描述是论文还是设计
     */
    public static void viewDesignOrPaper(ModelMap modelMap, String description) {
        modelMap.put("viewProjectTitle", description);
    }

    /**
     * 查看细节，将graduateProject添加到map中，便于共用一个jsp
     *
     * @param modelMap        需要盛放graduateProject的集合
     * @param graduateProject 需要添加到集合中的数据
     */
    public static void viewProjectAddToModel(ModelMap modelMap, GraduateProject graduateProject) {
        modelMap.put("graduateProject", graduateProject);
    }

    //用来判断当前时间是否在毕业设置的时间之内
    public static void timeInProjectTimeSpan(ModelMap modelMap, ProjectTimeSpan projectTimeSpan) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        String beginTime = simpleDateFormat.format(projectTimeSpan.getBeginTime().getTime());
        String endTime = simpleDateFormat.format(projectTimeSpan.getEndTime().getTime());
        String now = simpleDateFormat.format(CommonHelper.getNow().getTime());
        //两个日期型的字符串进行比较

        int compareTimeStart = CommonHelper.compareToString(beginTime, now);
        int compareTimeEnd = CommonHelper.compareToString(endTime, now);
        //毕业设计的开始时间在当前时间之前
        if (compareTimeStart < 0) {
            //毕业设计的结束时间在当前时间之后
            if (compareTimeEnd > 0) {
                modelMap.put("inTime", true);
            } else {
                modelMap.put("inTime", false);
                modelMap.addAttribute("beginTime", beginTime);
                modelMap.addAttribute("endTime", endTime);
            }
        } else {
            modelMap.put("inTime", false);
            modelMap.addAttribute("beginTime", beginTime);
            modelMap.addAttribute("endTime", endTime);
        }
    }



    /**
     * 将需要显示的元素的名称添加到model中
     *
     * @param modelMap map集合
     * @param showAll  列出所有的则为1，只列出自己的则为0
     */
    public static void display(ModelMap modelMap, Integer showAll) {
        modelMap.put(SHOW_NAME, showAll);
    }

    /**
     * 因为我申报的题目和修改老师的毕业设计共用的是一个jsp，所以以这个静态变量来区分是哪一个功能
     *
     * @param modelMap
     * @param ifEdit
     */
    public static void ACTION_EDIT_PROJECT(ModelMap modelMap, Boolean ifEdit) {
        modelMap.put("ACTION_EDIT_PROJECT", ifEdit);
    }

    /**
     * 用来设置维护题目的时间是否在允许的时间之间
     *
     * @param tutor                             用来传给service层，获取对应的教研室
     * @param modelMap                          添加在modelMap集合中，在jsp中获取
     * @param constraintOfProposeProjectService 用来获取当前时间是否在允许的时间之间
     */
    public static void setMyProjectDisplay(Tutor tutor, ModelMap modelMap, ConstraintOfProposeProjectService constraintOfProposeProjectService) {
        //在允许的时间之间则为true，否则为false
        boolean ableToUpdate = constraintOfProposeProjectService.isAbleToUpdateProject(tutor);
        //在jsp通过1和0来代表true和false
        if (ableToUpdate)
            modelMap.put(ABLE_TO_UPDATE, 1);
        else
            modelMap.put(ABLE_TO_UPDATE, 0);
    }

    //获取当前教研室所有课题的数量
    public static void addAllProjectNumToModel(ModelMap modelMap, GraduateProjectService graduateProjectService) {
        modelMap.put("projectCount", graduateProjectService.countAll(GraduateProject.class));
    }

    //获取当前教研室所有设计题目的数量
    public static void addAllDesignNumToModel(ModelMap modelMap, DesignProjectService designProjectService) {
        modelMap.put("designCount", designProjectService.countAll(DesignProject.class));
    }

    //获取当前教研室所有论文题目的数量
    public static void addAllPaperNumToModel(ModelMap modelMap, PaperProjectService paperProjectService) {
        modelMap.put("paperCount", paperProjectService.countAll(PaperProject.class));
    }

    //获取当前页的所有题目的条数
    public static void addProjectPageNumToModel(ModelMap modelMap, Page<GraduateProject> graduateProjectPage) {
        modelMap.put("graduateProjectNum", graduateProjectPage.getContent().size());
    }

    //获取当前页的设计题目的条数
    public static void addDesignPageNumToModel(ModelMap modelMap, Page<DesignProject> designProjectPage) {
        modelMap.put("graduateProjectNum", designProjectPage.getContent().size());
    }

    //获取当前页的论文题目的条数
    public static void addPaperPageNumToModel(ModelMap modelMap, Page<PaperProject> paperProjectPage) {
        modelMap.put("graduateProjectNum", paperProjectPage.getContent().size());
    }
}
