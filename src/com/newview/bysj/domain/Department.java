package com.newview.bysj.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import org.codehaus.jackson.annotate.JsonBackReference;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import javax.persistence.*;
import java.io.Serializable;
import java.util.List;

@Entity
@Table(name = "department")
@DynamicInsert(true)
@DynamicUpdate(true)
public class Department implements Serializable {

    /**
     *
     */
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    /**
     * @generated
     */
    private String description;
    /**
     * 学院
     * 多对一
     *
     * @generated
     */
    @ManyToOne
    @JoinColumn(name = "school_id")
    private School school;
    /**
     * 专业
     * 一对多
     *
     * @generated
     */
    @OneToMany(mappedBy = "department", cascade = CascadeType.ALL)
    @JsonIgnore
    private List<Major> major;
    /**
     * 导师
     * 一对多
     *
     * @generated
     */
    @OneToMany(mappedBy = "department")
    @JsonIgnore
    private List<Tutor> tutor;
    /**
     * 答辩小组
     * 一对多
     *
     * @generated
     */
    @OneToMany(mappedBy = "department", cascade = CascadeType.ALL)
    @JsonIgnore
    private List<ReplyGroup> replyGroup;
    /**
     * 评论模板
     * 一对多
     *
     * @generated
     */
    @OneToMany(mappedBy = "department", cascade = CascadeType.ALL)
    private List<RemarkTemplate> remarkTemplate;
    /**
     * 教师申请题目的时间
     * 一对一
     *
     * @generated
     */
    @OneToOne
    @JsonIgnore
    private ConstraintOfProposeProject constraintOfProposeProject;
    /**
     * 审核开题报告的时间
     * 一对一
     *
     * @generated
     */
    @OneToOne
    private ConstraintOfApproveOpenningReport constraintOfApproveOpenningReport;
    /**
     * 教研室毕业设计时间
     * 一对一
     *
     * @generated
     */
    @OneToOne
    private ProjectTimeSpan projectTimeSpan;

    public Department() {
        super();
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @JsonBackReference
    @JsonIgnore
    public School getSchool() {
        return school;
    }

    @JsonBackReference
    public void setSchool(School school) {
        this.school = school;
    }

    @JsonBackReference
    @JsonIgnore
    public List<Major> getMajor() {
        return major;
    }

    public void setMajor(List<Major> major) {
        this.major = major;
    }

    @JsonBackReference
    public List<Tutor> getTutor() {
        return tutor;
    }

    public void setTutor(List<Tutor> tutor) {
        this.tutor = tutor;
    }

    public List<ReplyGroup> getReplyGroup() {
        return replyGroup;
    }

    public void setReplyGroup(List<ReplyGroup> replyGroup) {
        this.replyGroup = replyGroup;
    }

    public List<RemarkTemplate> getRemarkTemplate() {
        return remarkTemplate;
    }

    public void setRemarkTemplate(List<RemarkTemplate> remarkTemplate) {
        this.remarkTemplate = remarkTemplate;
    }

    @JsonIgnore
    public ConstraintOfProposeProject getConstraintOfProposeProject() {
        return constraintOfProposeProject;
    }

    public void setConstraintOfProposeProject(
            ConstraintOfProposeProject constraintOfProposeProject) {
        this.constraintOfProposeProject = constraintOfProposeProject;
    }

    public ConstraintOfApproveOpenningReport getConstraintOfApproveOpenningReport() {
        return constraintOfApproveOpenningReport;
    }

    public void setConstraintOfApproveOpenningReport(
            ConstraintOfApproveOpenningReport constraintOfApproveOpenningReport) {
        this.constraintOfApproveOpenningReport = constraintOfApproveOpenningReport;
    }

    public ProjectTimeSpan getProjectTimeSpan() {
        return projectTimeSpan;
    }

    public void setProjectTimeSpan(ProjectTimeSpan projectTimeSpan) {
        this.projectTimeSpan = projectTimeSpan;
    }


}
