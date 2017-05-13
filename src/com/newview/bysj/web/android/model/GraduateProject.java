package com.newview.bysj.web.android.model;

/**
 * @author zhan
 *         Created on 2017/05/08  23:14
 */
public class GraduateProject {
    private Long id;
    private String year;
    private String title;                 //题目名称
    private String subTitle;              //副标题
    private String category;              //题目类别
    private String projectType;           //题目类型
    private String projectFidelity;       //题目性质
    private String projectFrom;           //题目来源
    private String content;               //工作内容
    private String basicRequirement;      //基本要求
    private String basicSkill;            //基本技能
    private String reference;            //参考文献
    private String major;                 //所在专业
    private Integer completenessScoreByGroup;      //完成任务规定的要求与水平评分
    private Integer correctnessScoreByGroup;       //回答问题的正确性评分
    private Integer qualityScoreBtGroup;           //论文与实务的质量评分
    private Integer replyScoreByGroup;             //论文内容的答辩陈述评分
    private Student student_name;      //选该题目学生
    private Boolean isAuditByDirector;

    public GraduateProject() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getYear() {
        return year;
    }

    public void setYear(String year) {
        this.year = year;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSubTitle() {
        return subTitle;
    }

    public void setSubTitle(String subTitle) {
        this.subTitle = subTitle;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getProjectType() {
        return projectType;
    }

    public void setProjectType(String projectType) {
        this.projectType = projectType;
    }

    public String getProjectFidelity() {
        return projectFidelity;
    }

    public void setProjectFidelity(String projectFidelity) {
        this.projectFidelity = projectFidelity;
    }

    public String getProjectFrom() {
        return projectFrom;
    }

    public void setProjectFrom(String projectFrom) {
        this.projectFrom = projectFrom;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getBasicRequirement() {
        return basicRequirement;
    }

    public void setBasicRequirement(String basicRequirement) {
        this.basicRequirement = basicRequirement;
    }

    public String getBasicSkill() {
        return basicSkill;
    }

    public void setBasicSkill(String basicSkill) {
        this.basicSkill = basicSkill;
    }

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public String getMajor() {
        return major;
    }

    public void setMajor(String major) {
        this.major = major;
    }

    public Integer getCompletenessScoreByGroup() {
        return completenessScoreByGroup;
    }

    public void setCompletenessScoreByGroup(Integer completenessScoreByGroup) {
        this.completenessScoreByGroup = completenessScoreByGroup;
    }

    public Integer getCorrectnessScoreByGroup() {
        return correctnessScoreByGroup;
    }

    public void setCorrectnessScoreByGroup(Integer correctnessScoreByGroup) {
        this.correctnessScoreByGroup = correctnessScoreByGroup;
    }

    public Integer getQualityScoreBtGroup() {
        return qualityScoreBtGroup;
    }

    public void setQualityScoreBtGroup(Integer qualityScoreBtGroup) {
        this.qualityScoreBtGroup = qualityScoreBtGroup;
    }

    public Integer getReplyScoreByGroup() {
        return replyScoreByGroup;
    }

    public void setReplyScoreByGroup(Integer replyScoreByGroup) {
        this.replyScoreByGroup = replyScoreByGroup;
    }

    public Student getStudent_name() {
        return student_name;
    }

    public void setStudent_name(Student student_name) {
        this.student_name = student_name;
    }


    public Boolean getAuditByDirector() {
        return isAuditByDirector;
    }

    public void setAuditByDirector(Boolean auditByDirector) {
        isAuditByDirector = auditByDirector;
    }
}
