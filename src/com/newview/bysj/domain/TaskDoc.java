package com.newview.bysj.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import javax.persistence.*;
import java.io.Serializable;

/**
 * 任务书
 */
@Entity
@Table(name = "taskDoc")
@DynamicInsert(true)
@DynamicUpdate(true)
public class TaskDoc implements Serializable {

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
    private String url;
    /**
     * 一对一
     *
     * @generated
     */
    @OneToOne
    @JoinColumn(name = "graduateProject_id")
    private GraduateProject graduateProject;
    /**
     * 教研室主任审核任务书
     * 一对一
     *
     * @generated
     */
    @OneToOne(cascade = CascadeType.ALL)
    private Audit auditByDepartmentDirector;
    /**
     * 导师审核任务书
     * 一对一
     *
     * @generated
     */
    @OneToOne(cascade = CascadeType.ALL)
    private Audit auditByTutor;
    /**
     * 院长审核任务书
     * 一对一
     *
     * @generated
     */
    @OneToOne(cascade = CascadeType.ALL)
    private Audit auditByBean;

    public TaskDoc() {
        super();
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    @JsonIgnore
    public GraduateProject getGraduateProject() {
        return graduateProject;
    }

    public void setGraduateProject(GraduateProject graduateProject) {
        this.graduateProject = graduateProject;
    }

    public Audit getAuditByDepartmentDirector() {
        return auditByDepartmentDirector;
    }

    public void setAuditByDepartmentDirector(Audit auditByDepartmentDirector) {
        this.auditByDepartmentDirector = auditByDepartmentDirector;
    }

    public Audit getAuditByTutor() {
        return auditByTutor;
    }

    public void setAuditByTutor(Audit auditByTutor) {
        this.auditByTutor = auditByTutor;
    }

    public Audit getAuditByBean() {
        return auditByBean;
    }

    public void setAuditByBean(Audit auditByBean) {
        this.auditByBean = auditByBean;
    }

}
