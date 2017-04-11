package com.newview.bysj.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import org.codehaus.jackson.annotate.JsonBackReference;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import javax.persistence.*;
import java.io.Serializable;
import java.util.List;

/**
 * 题目性质
 */
@Entity
@Table(name = "projectFidelity")
@DynamicInsert(true)
@DynamicUpdate(true)
public class ProjectFidelity implements Serializable {

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
    @OneToMany(mappedBy = "projectFidelity")
    private List<GraduateProject> graduateProject;

    public ProjectFidelity() {
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
    public List<GraduateProject> getGraduateProject() {
        return graduateProject;
    }

    public void setGraduateProject(List<GraduateProject> graduateProject) {
        this.graduateProject = graduateProject;
    }

}
