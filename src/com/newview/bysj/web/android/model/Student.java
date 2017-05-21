package com.newview.bysj.web.android.model;

/**
 * @author zhan
 *         Created on 2017/05/08  23:08
 */
public class Student {
    private Long id;
    private String no;                   //学生的学号
    private String contact;             //学生的手机号
    private String name;                //学生的姓名
    private String majorDecription;   //学生所在的专业
    private String studentClass;      //学生所在的班级名称
    private Long tutorId;              //指导老师的id
    private Long projectId;           //学生答辩课题的id
    private Long replyGroupId;


    public Student() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNo() {
        return no;
    }

    public void setNo(String no) {
        this.no = no;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getMajorDecription() {
        return majorDecription;
    }

    public void setMajorDecription(String majorDecription) {
        this.majorDecription = majorDecription;
    }


    public Long getReplyGroupId() {
        return replyGroupId;
    }

    public void setReplyGroupId(Long replyGroupId) {
        this.replyGroupId = replyGroupId;
    }

    public String getStudentClass() {
        return studentClass;
    }

    public void setStudentClass(String studentClass) {
        this.studentClass = studentClass;
    }

    public Long getTutorId() {
        return tutorId;
    }

    public void setTutorId(Long tutorId) {
        this.tutorId = tutorId;
    }

    public Long getProjectId() {
        return projectId;
    }

    public void setProjectId(Long projectId) {
        this.projectId = projectId;
    }
}
