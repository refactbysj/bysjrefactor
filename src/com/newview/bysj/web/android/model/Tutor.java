package com.newview.bysj.web.android.model;

import java.util.List;

/**
 * @author zhan
 *         Created on 2017/05/08  23:12
 */
public class Tutor {
    private Long id;
    private String name;                  //姓名
    private String no;                    //职工号
    private String sex;                   //性别
    private String departmentName;      //部门
    private List<Student> studentList; //学生
    private String replyId;



    public Tutor() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNo() {
        return no;
    }

    public void setNo(String no) {
        this.no = no;
    }

    public String getSex() {
        return sex;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }



    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    public List<Student> getStudentList() {
        return studentList;
    }

    public void setStudentList(List<Student> studentList) {
        this.studentList = studentList;
    }

    public String getReplyId() {
        return replyId;
    }

    public void setReplyId(String replyId) {
        this.replyId = replyId;
    }
}
