package com.newview.bysj.web.android.model;

import java.util.List;

/**
 * @author zhan
 *         Created on 2017/05/08  23:12
 */
public class Tutor {
    private long id;
    private String name;
    private String no;
    private String sex;
    private Department department;
    private List<Student> studentList;

    public Tutor() {
    }

    public Tutor(long id, String name, String no, String sex, Department department, List<Student> studentList) {
        this.id = id;
        this.name = name;
        this.no = no;
        this.sex = sex;
        this.department = department;
        this.studentList = studentList;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
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

    public Department getDepartment() {
        return department;
    }

    public void setDepartment(Department department) {
        this.department = department;
    }

    public List<Student> getStudentList() {
        return studentList;
    }

    public void setStudentList(List<Student> studentList) {
        this.studentList = studentList;
    }
}
