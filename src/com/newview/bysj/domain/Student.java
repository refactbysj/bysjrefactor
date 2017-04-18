package com.newview.bysj.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import javax.persistence.*;

@Entity
@Table(name = "student")
@Inheritance(strategy = InheritanceType.TABLE_PER_CLASS)
@DynamicInsert(true)
@DynamicUpdate(true)
public class Student extends Actor {

    /**
     *
     */
    private static final long serialVersionUID = 1L;
    /**
     * 导师
     * 多对一
     *
     * @generated
     */
    @ManyToOne
    @JoinColumn(name = "tutor_id")
    private Tutor tutor;
    /**
     * 班级
     * 多对一
     *
     * @generated
     */
    @ManyToOne
    @JoinColumn(name = "studentClass_id")
    private StudentClass studentClass;
    /**
     * 一对一
     *
     * @generated
     */
    @OneToOne(mappedBy = "student")
    private GraduateProject graduateProject;

    @ManyToOne
    @JoinColumn(name = "replyGroup_id")
    private ReplyGroup replyGroup;

    public Student() {
        super();
    }

    public Student(String no, String name) {
        super(no, name);
    }

    @Override
    public String toString() {
        return "Student []";
    }

    @JsonIgnore
    public Tutor getTutor() {
        return tutor;
    }

    public void setTutor(Tutor tutor) {
        this.tutor = tutor;
    }


    public StudentClass getStudentClass() {
        return studentClass;
    }

    public void setStudentClass(StudentClass studentClass) {
        this.studentClass = studentClass;
    }

    @JsonIgnore
    public GraduateProject getGraduateProject() {
        return graduateProject;
    }

    public void setGraduateProject(GraduateProject graduateProject) {
        this.graduateProject = graduateProject;
    }

    @JsonIgnore
    public ReplyGroup getReplyGroup() {
        return replyGroup;
    }

    public void setReplyGroup(ReplyGroup replyGroup) {
        this.replyGroup = replyGroup;
    }


}
