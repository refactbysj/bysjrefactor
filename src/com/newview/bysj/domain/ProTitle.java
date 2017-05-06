package com.newview.bysj.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import javax.persistence.*;
import java.io.Serializable;
import java.util.List;

/**
 * 职称
 */
@Entity
@Table(name = "proTitle")
@DynamicInsert(true)
@DynamicUpdate(true)
public class ProTitle implements Serializable {

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
    @Column(length = 20)
    private String description;
    /**
     * @generated
     */
    private String no;
    /**
     * 导师
     * 一对多
     *
     * @generated
     */
    @OneToMany(mappedBy = "proTitle")
    private List<Tutor> tutor;

    public ProTitle() {
        super();
    }

    public ProTitle(String description) {
        this.description = description;
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

    public String getNo() {
        return no;
    }

    public void setNo(String no) {
        this.no = no;
    }

    @JsonIgnore
    public List<Tutor> getTutor() {
        return tutor;
    }

    public void setTutor(List<Tutor> tutor) {
        this.tutor = tutor;
    }


}
