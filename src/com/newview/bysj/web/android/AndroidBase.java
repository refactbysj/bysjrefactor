package com.newview.bysj.web.android;

import com.newview.bysj.domain.*;
import com.newview.bysj.service.*;
import com.newview.bysj.web.android.model.Addressee;
import com.newview.bysj.web.android.model.Notice;
import com.sun.istack.internal.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.List;

/**
 * @author zhan
 *         Created on 2017/05/09  13:32
 */
@Controller
public class AndroidBase {

    @Autowired
    protected UserService userService;
    @Autowired
    protected TutorService tutorService;
    @Autowired
    protected GraduateProjectService graduateProjectService;
    @Autowired
    ActorService actorService;
    @Autowired
    MailService mailService;
    @Autowired
    ReplyGroupMemberScoreService replyGroupMemberScoreService;
    @Autowired
    ReplyGroupService replyGroupService;

    private com.newview.bysj.web.android.model.Department getAndroidDepartmentByDepartment(Department department) {
        com.newview.bysj.web.android.model.Department department1 = new com.newview.bysj.web.android.model.Department();
        department1.setDescription(department.getDescription());
        department1.setId(department.getId());
        return department1;
    }

    com.newview.bysj.web.android.model.Tutor getAndroidTutorByTutor(Tutor tutor) {
        com.newview.bysj.web.android.model.Tutor tutor1 = new com.newview.bysj.web.android.model.Tutor();
        tutor1.setId(tutor.getId());
        tutor1.setName(tutor.getName());
        tutor1.setNo(tutor.getNo());
        tutor1.setSex(tutor.getSex());
        tutor1.setDepartment(this.getAndroidDepartmentByDepartment(tutor.getDepartment()));
        List<Student> students = tutor.getStudent();
        List<com.newview.bysj.web.android.model.Student> students1 = new ArrayList<>();
        if (students != null) {
            for (Student student : students) {
                students1.add(this.getAndroidStudentByStudent(student));
            }
        }
        tutor1.setStudentList(students1);
        return tutor1;
    }

    private com.newview.bysj.web.android.model.Major getAndroidMajorByMajor(com.newview.bysj.domain.Major major) {
        com.newview.bysj.web.android.model.Major major1 = new com.newview.bysj.web.android.model.Major();
        major1.setId(major.getId());
        major1.setDescription(major.getDescription());
        return major1;
    }

    private com.newview.bysj.web.android.model.StudentClass getAndroidStudentClassByStudentClass(com.newview.bysj.domain.StudentClass studentClass) {
        com.newview.bysj.web.android.model.StudentClass studentClass1 = new com.newview.bysj.web.android.model.StudentClass();
        studentClass1.setId(studentClass.getId());
        studentClass1.setDescription(studentClass.getDescription());
        return studentClass1;
    }

    com.newview.bysj.web.android.model.Student getAndroidStudentByStudent(Student student) {
        com.newview.bysj.web.android.model.Student student1 = new com.newview.bysj.web.android.model.Student();
        student1.setId(student.getId());
        student1.setName(student.getName());
        student1.setNo(student.getNo());
        student1.setContact(student.getContact());
        student1.setTutorId(student.getTutor().getId().longValue());
        student1.setMajor(this.getAndroidMajorByMajor(student.getStudentClass().getMajor()));
        student1.setStudentClass(this.getAndroidStudentClassByStudentClass(student.getStudentClass()));
        return student1;
    }


    protected com.newview.bysj.web.android.model.GraduateProject getAndroidGraduateProjectByGraduateProject(@NotNull GraduateProject graduateProject) {
        com.newview.bysj.web.android.model.GraduateProject graduateProject1 = new com.newview.bysj.web.android.model.GraduateProject();
        graduateProject1.setId((long) graduateProject.getId());
        graduateProject1.setYear(String.valueOf(graduateProject.getYear()));
        graduateProject1.setTitle(graduateProject.getTitle());
        graduateProject1.setSubTitle(graduateProject.getSubTitle());
        graduateProject1.setCategory(graduateProject.getCategory());
        graduateProject1.setProjectType(graduateProject.getProjectType()!=null?graduateProject.getProjectType().getDescription():null);
        graduateProject1.setProjectFidelity(graduateProject.getProjectFidelity()!=null?graduateProject.getProjectFidelity().getDescription():null);
        graduateProject1.setProjectFrom(graduateProject.getProjectFrom()!=null?graduateProject.getProjectFrom().getDescription():null);
        graduateProject1.setContent(graduateProject.getContent());
        graduateProject1.setBasicRequirement(graduateProject.getBasicRequirement());
        graduateProject1.setBasicSkill(graduateProject.getBasicSkill());
        graduateProject1.setReference(graduateProject.getReference());
        graduateProject1.setMajor(graduateProject.getMajor()!=null?graduateProject.getMajor().getDescription():null);
        CommentByGroup commentByGroup = graduateProject.getCommentByGroup();
        graduateProject1.setCompletenessScoreByGroup(commentByGroup != null ? commentByGroup.getCompletenessScore().intValue() : null);
        graduateProject1.setCorrectnessScoreByGroup(commentByGroup != null ? commentByGroup.getCorrectnessSocre().intValue() : null);
        graduateProject1.setQualityScoreBtGroup(commentByGroup != null ? commentByGroup.getQualityScore().intValue(): null);
        graduateProject1.setReplyScoreByGroup(commentByGroup != null ? commentByGroup.getReplyScore().intValue() : null);
        graduateProject1.setStudent_name(graduateProject.getStudent() != null ? this.getAndroidStudentByStudent(graduateProject.getStudent()) : null);
        graduateProject1.setAuditByDirector(graduateProject.getAuditByDirector() != null ? graduateProject.getAuditByDirector().getApprove() : null);
        graduateProject1.setTutorId(graduateProject.getProposer().getId().longValue());
        return graduateProject1;
    }

    com.newview.bysj.web.android.model.ReplyGroup getAndroidReplyGroupByReplyGroup(ReplyGroup replyGroup) {
        com.newview.bysj.web.android.model.ReplyGroup replyGroup1 = new com.newview.bysj.web.android.model.ReplyGroup();
        replyGroup1.setId((long) replyGroup.getId());
        replyGroup1.setDescription(replyGroup.getDescription());
        replyGroup1.setLocation(replyGroup.getClassRoom() != null ? replyGroup.getClassRoom().getDescription() : null);
        replyGroup1.setLeader_id(replyGroup.getLeader() != null ? replyGroup.getLeader().getId() : null);
        replyGroup1.setLeader_name(replyGroup.getLeader() != null ? replyGroup.getLeader().getName() : null);
        replyGroup1.setReplyTime(replyGroup.getReplyTime() != null ? this.getAndroidReplyTimeByReplyTime(replyGroup.getReplyTime()) : null);
        List<GraduateProject> graduateProjects = replyGroup.getGraduateProject();
        List<com.newview.bysj.web.android.model.GraduateProject> graduateProjects1 = new ArrayList<>();
        if (graduateProjects != null) {
            for (GraduateProject graduateProject : graduateProjects) {
                graduateProjects1.add(this.getAndroidGraduateProjectByGraduateProject(graduateProject));
            }
        }
        List<com.newview.bysj.web.android.model.Tutor> tutors = new ArrayList<>();
        if (replyGroup.getMembers() != null) {
            for (Tutor tutor : replyGroup.getMembers()) {
                tutors.add(this.getAndroidTutorByTutor(tutor));
            }
        }
        replyGroup1.setTutorId(tutors);
        replyGroup1.setGraduateProjects(graduateProjects1);
        return replyGroup1;
    }

    private com.newview.bysj.web.android.model.ReplyTime getAndroidReplyTimeByReplyTime(com.newview.bysj.domain.ReplyTime replyTime) {
        com.newview.bysj.web.android.model.ReplyTime replyTime1 = new com.newview.bysj.web.android.model.ReplyTime();
        replyTime1.setBeginTime(replyTime.getBeginTime().getTimeInMillis());
        replyTime1.setEndTime(replyTime.getEndTime().getTimeInMillis());
        return replyTime1;
    }


    protected Notice getNoticeByMail(Mail mail) {
        Notice notice = new Notice();
        notice.setId(mail.getId().longValue());
        notice.setTitle(mail.getTitle());
        notice.setContent(mail.getContent());
        notice.setAddressTime(mail.getAddressTime().getTimeInMillis());
        notice.setAddressor_id(mail.getAddressor().getId());
        notice.setAddressor_name(mail.getAddressor().getName());
        List<Addressee> addressees = new ArrayList<>();
        if (mail.getAddresses() != null) {
            for (Actor actor : mail.getAddresses()) {
                addressees.add(this.getAddresseeByAddressee(actor,mail.getId().longValue()));
            }
            notice.setAddressee_name(addressees);
        }
        return notice;
    }

    protected Addressee getAddresseeByAddressee(Actor actor,Long noticeId) {
        Addressee addressee = new Addressee();
        addressee.setId(actor.getId().longValue());
        if (noticeId != null) {
            addressee.setNoticeId(noticeId);
        }
        addressee.setAddressee_name(actor.getName());
        return addressee;
    }

    protected Addressee getAddresseeByStudent(Student student) {
        Addressee addressee = new Addressee();
        addressee.setId(student.getId().longValue());
        addressee.setAddressee_name(student.getName());
        return addressee;
    }

}
