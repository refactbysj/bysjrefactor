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


    com.newview.bysj.web.android.model.Tutor getAndroidTutorByTutor(Tutor tutor) {
        com.newview.bysj.web.android.model.Tutor tutor1 = new com.newview.bysj.web.android.model.Tutor();
        tutor1.setId(tutor.getId().longValue());
        tutor1.setName(tutor.getName());
        tutor1.setNo(tutor.getNo());
        tutor1.setSex(tutor.getSex());
        tutor1.setDepartmentName(tutor.getDepartment().getDescription());
        List<Student> students = tutor.getStudent();
        List<com.newview.bysj.web.android.model.Student> students1 = new ArrayList<>();
        if (students != null) {
            for (Student student : students) {
                students1.add(this.getAndroidStudentByStudent(student));
            }
        }
        tutor1.setStudentList(students1);
        StringBuilder sb = new StringBuilder();
        if (tutor.getReplyGroup() != null) {
            for (ReplyGroup replyGroup : tutor.getReplyGroup()) {
                sb.append(replyGroup.getId()).append("、");
            }
            tutor1.setReplyId(sb.toString().substring(0,sb.toString().length()));
        }
        return tutor1;
    }




    com.newview.bysj.web.android.model.Student getAndroidStudentByStudent(Student student) {
        com.newview.bysj.web.android.model.Student student1 = new com.newview.bysj.web.android.model.Student();
        student1.setId(student.getId().longValue());
        student1.setName(student.getName());
        student1.setNo(student.getNo());
        student1.setMajorDecription(student.getStudentClass()!=null&&student.getStudentClass().getMajor()!=null?student.getStudentClass().getMajor().getDescription():null);
        student1.setContact(student.getContact() !=null ? student.getContact().getMoblie() : null);
        student1.setTutorId(student.getTutor() != null ? student.getTutor().getId().longValue() : null);
        student1.setStudentClass(student.getStudentClass()!=null?student.getStudentClass().getDescription():null);
        student1.setReplyGroupId(student.getReplyGroup() != null ? student.getReplyGroup().getId().longValue() : null);
        student1.setProjectId(student.getGraduateProject() != null ? student.getGraduateProject().getId().longValue() : null);
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
        graduateProject1.setCompletenessScoreByGroup(commentByGroup != null ? commentByGroup.getCompletenessScore()!=null?commentByGroup.getCompletenessScore().intValue():null : null);
        graduateProject1.setCorrectnessScoreByGroup(commentByGroup != null ? commentByGroup.getCorrectnessSocre()!=null?commentByGroup.getCorrectnessSocre().intValue():null : null);
        graduateProject1.setQualityScoreBtGroup(commentByGroup != null ? commentByGroup.getQualityScore()!=null?commentByGroup.getQualityScore().intValue():null: null);
        graduateProject1.setReplyScoreByGroup(commentByGroup != null ? commentByGroup.getReplyScore()!=null?commentByGroup.getReplyScore().intValue() :null: null);
        graduateProject1.setReplyGroupId(graduateProject.getReplyGroup() != null ? graduateProject.getReplyGroup().getId().longValue() : null);
        graduateProject1.setStudent(graduateProject.getStudent() != null ? this.getAndroidStudentByStudent(graduateProject.getStudent()) : null);
        graduateProject1.setAuditByDirector(graduateProject.getAuditByDirector() != null ? graduateProject.getAuditByDirector().getApprove() : false);
        graduateProject1.setTutorId(graduateProject.getProposer().getId().longValue());
        graduateProject1.setCorrectnessScoreByGroup(graduateProject.getCommentByGroup() != null&&graduateProject.getCommentByGroup().getCorrectnessSocre()!=null ? graduateProject.getCommentByGroup().getCorrectnessSocre().intValue() : null);
        graduateProject1.setCompletenessScoreByGroup(graduateProject.getCommentByGroup() != null&&graduateProject.getCommentByGroup().getCompletenessScore()!=null ? graduateProject.getCommentByGroup().getCompletenessScore().intValue() : null);
        graduateProject1.setQualityScoreBtGroup(graduateProject.getCommentByGroup() != null&&graduateProject.getCommentByGroup().getQualityScore()!=null ? graduateProject.getCommentByGroup().getQualityScore().intValue() : null);
        graduateProject1.setReplyScoreByGroup(graduateProject.getCommentByGroup() != null &&graduateProject.getCommentByGroup().getReplyScore()!=null? graduateProject.getCommentByGroup().getReplyScore().intValue() : null);
        graduateProject1.setScoresState(graduateProject1.getCompletenessScoreByGroup()+graduateProject1.getCorrectnessScoreByGroup()+
                                        graduateProject1.getQualityScoreBtGroup()+graduateProject1.getReplyScoreByGroup());
        return graduateProject1;
    }

    com.newview.bysj.web.android.model.ReplyGroup getAndroidReplyGroupByReplyGroup(ReplyGroup replyGroup) {
        com.newview.bysj.web.android.model.ReplyGroup replyGroup1 = new com.newview.bysj.web.android.model.ReplyGroup();
        replyGroup1.setId((long) replyGroup.getId());
        replyGroup1.setDescription(replyGroup.getDescription());
        replyGroup1.setLocation(replyGroup.getClassRoom() != null ? replyGroup.getClassRoom().getDescription() : null);
        replyGroup1.setLeader_id(replyGroup.getLeader() != null ? replyGroup.getLeader().getId() : null);
        replyGroup1.setLeader_name(replyGroup.getLeader() != null ? replyGroup.getLeader().getName() : null);
        if (replyGroup.getReplyTime() != null) {
            replyGroup1.setBeginTime(replyGroup.getReplyTime().getBeginTime() != null ? replyGroup.getReplyTime().getBeginTime().getTimeInMillis() : -1L);
            replyGroup1.setEndTime(replyGroup.getReplyTime().getEndTime() != null ? replyGroup.getReplyTime().getEndTime().getTimeInMillis() : -1L);
        }

        //replyGroup1.setReplyTime(replyGroup.getReplyTime() != null ? this.getAndroidReplyTimeByReplyTime(replyGroup.getReplyTime()) : null);
        List<GraduateProject> graduateProjects = replyGroup.getGraduateProject();
        List<com.newview.bysj.web.android.model.GraduateProject> graduateProjects1 = new ArrayList<>();
        if (graduateProjects != null) {
            for (GraduateProject graduateProject : graduateProjects) {
                replyGroup1.setMajor(graduateProject.getMajor().getDescription());
                graduateProjects1.add(this.getAndroidGraduateProjectByGraduateProject(graduateProject));
            }
        }
        StringBuilder sb = new StringBuilder();
        String tutorNames = "";
        if (replyGroup.getMembers() != null) {
            for (Tutor tutor : replyGroup.getMembers()) {
                sb.append(tutor.getName()).append("、");
            }
            tutorNames = sb.toString().substring(0, sb.toString().length());
        }
        replyGroup1.setReplyMembers(tutorNames);
        replyGroup1.setGraduateProjects(graduateProjects1);
        return replyGroup1;
    }

    protected Notice getNoticeByMail(Mail mail) {
        Notice notice = new Notice();
        notice.setId(mail.getId().longValue());
        notice.setTitle(mail.getTitle());
        notice.setContent(mail.getContent());
        notice.setAddressTime(mail.getAddressTime().getTimeInMillis());
        notice.setAddressor_id(mail.getAddressor().getId().longValue());
        notice.setAddressor_name(mail.getAddressor().getName());
        List<Long> addresseeId = new ArrayList<>();
        List<String> addresseeName = new ArrayList<>();
        if (mail.getAddresses() != null) {
            for (Actor actor : mail.getAddresses()) {
                addresseeId.add(actor.getId().longValue());
                addresseeName.add(actor.getName());
            }
        }

        notice.setAddresseeIdList(addresseeId);
        notice.setAddresseeNameList(addresseeName);
        return notice;
    }

    protected Addressee getAddresseeByAddressee(Actor actor,Long noticeId) {
        Addressee addressee = new Addressee();
        addressee.setId(actor.getId().longValue());
        if (noticeId != null) {
            addressee.setNoticeId(noticeId);
        }
        addressee.setName(actor.getName());
        return addressee;
    }

    protected Addressee getAddresseeByStudent(Student student) {
        Addressee addressee = new Addressee();
        addressee.setId(student.getId().longValue());
        addressee.setName(student.getName());
        return addressee;
    }

}
