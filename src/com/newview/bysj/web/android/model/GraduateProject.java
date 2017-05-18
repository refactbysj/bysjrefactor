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
    private String category;             //题目类别   不需要
    private String projectType;           //题目类型
    private String projectFidelity;       //题目性质
    private String projectFrom;           //题目来源
    private Long replyGroup_id;      //该课题所在的答辩小组
    private String content;               //工作内容
    private String basicRequirement;      //基本要求
    private String basicSkill;            //基本技能
    private String reference;            //参考文献
    private String major;                 //所在专业
    private Integer completenessScoreByGroup;      //完成任务规定的要求与水平评分
    private Integer correctnessScoreByGroup;       //回答问题的正确性评分
    private Integer qualityScoreBtGroup;           //论文与实务的质量评分
    private Integer replyScoreByGroup; //论文内容的答辩陈述评分
    private String remark;        //指导老师的评语
    private Long student_id;       //选该题目学生的id
    private Student student;    //选该题目学生的姓名
    private Long tutorId;      //申报该题目老师的id
    private boolean isAllow;                     //是否允许答辩 在commentByTutor中可以找到
    private boolean auditByDirector;    //审核状态
    private int scoresState;

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

    public Long getReplyGroup_id() {
        return replyGroup_id;
    }

    public void setReplyGroup_id(Long replyGroup_id) {
        this.replyGroup_id = replyGroup_id;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public Long getStudent_id() {
        return student_id;
    }

    public void setStudent_id(Long student_id) {
        this.student_id = student_id;
    }

    public Student getStudent() {
        return student;
    }

    public void setStudent(Student student) {
        this.student = student;
    }

    public boolean isAllow() {
        return isAllow;
    }

    public void setAllow(boolean allow) {
        isAllow = allow;
    }

    public boolean isAuditByDirector() {
        return auditByDirector;
    }

    public void setAuditByDirector(boolean auditByDirector) {
        this.auditByDirector = auditByDirector;
    }

    public int getScoresState() {
        return scoresState;
    }

    public void setScoresState(int scoresState) {
        this.scoresState = scoresState;
    }

    public Long getTutorId() {
        return tutorId;
    }

    public void setTutorId(Long tutorId) {
        this.tutorId = tutorId;
    }
}
