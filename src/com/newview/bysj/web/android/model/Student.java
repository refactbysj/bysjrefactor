package com.newview.bysj.web.android.model;

import com.newview.bysj.domain.Contact;

/**
 * @author zhan
 *         Created on 2017/05/08  23:08
 */
public class Student {
    private  long id;
    private  String no;
    private String name;
    private Contact contact;
    private Major major;
    private StudentClass studentClass;
    private Long tutorId;
    public Student() {
    }

    public Student(long id, String no, String name, Contact contact, Major major, StudentClass studentClass) {
        this.id = id;
        this.no = no;
        this.name = name;
        this.contact = contact;
        this.major = major;
        this.studentClass = studentClass;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getNo() {
        return no;
    }

    public void setNo(String no) {
        this.no = no;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Contact getContact() {
        return contact;
    }

    public void setContact(Contact contact) {
        this.contact = contact;
    }

    public Major getMajor() {
        return major;
    }

    public void setMajor(Major major) {
        this.major = major;
    }

    public StudentClass getStudentClass() {
        return studentClass;
    }

    public void setStudentClass(StudentClass studentClass) {
        this.studentClass = studentClass;
    }

    public Long getTutorId() {
        return tutorId;
    }

    public void setTutorId(Long tutorId) {
        this.tutorId = tutorId;
    }
}
