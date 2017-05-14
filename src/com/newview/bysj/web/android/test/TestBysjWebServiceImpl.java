package com.newview.bysj.web.android.test;

import com.newview.bysj.domain.Mail;
import com.newview.bysj.domain.Student;
import com.newview.bysj.domain.Tutor;
import com.newview.bysj.web.android.AndroidBase;
import com.newview.bysj.web.android.model.Addressee;
import com.newview.bysj.web.android.model.GraduateProject;
import com.newview.bysj.web.android.model.Notice;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 测试类
 *
 * @author zhan
 *         Created on 2017/05/09  13:44
 */
@Controller
public class TestBysjWebServiceImpl extends AndroidBase{
    /**
     * 获取当前我申报的课题
     *
     * @param id 当前用户的id
     * @return 当前用户课题的集合
     */
    @RequestMapping(value = "/getGraduateProjectByTutorIdTest.json", method = RequestMethod.GET)
    @ResponseBody
    public List<GraduateProject> getGraduateProjectByTutorId(String id) {
        List<com.newview.bysj.web.android.model.GraduateProject> graduateProjectList = new ArrayList<>();
        //获取对应的tutor
        Tutor tutor = tutorService.findById(Integer.parseInt(id));
        //根据当前tutor获取申报的课题
        List<com.newview.bysj.domain.GraduateProject> graduateProjects = graduateProjectService.getGraduateProjectByTutor(tutor);
        if (graduateProjects != null) {
            for (com.newview.bysj.domain.GraduateProject graduateProject : graduateProjects) {
                graduateProjectList.add(this.getAndroidGraduateProjectByGraduateProject(graduateProject));
            }
        }
        return graduateProjectList;
    }



    /**
     * 获取我收到的通知
     *
     * @param id tutorId
     */
    @RequestMapping(value = "/getMyReceivedNoticesTest.json")
    @ResponseBody
    public List<Notice> getReceivedMailTest(String id) {
        List<Notice> notices = new ArrayList<>();
        Tutor tutor = tutorService.findById(Integer.parseInt(id));
        //如果当前tutor为空，则返回一个空的mail对象
        if (tutor == null) {
            notices.add(new Notice());
        } else {
            if (tutor.getReceiveMail() != null) {
                //获取收到的邮件，并添加集合中
                for (Mail mail : tutor.getReceiveMail()) {
                    notices.add(this.getNoticeByMail(mail));
                }
            }
        }
        return notices;
    }


    /**
     * 获取我发布的通知
     *
     * @param id tutorId
     */
    @RequestMapping(value = "/getMyReleasedNoticesTest.json")
    @ResponseBody
    public List<Notice> getSendMailTest( String id) {
        List<Notice> notices = new ArrayList<>();
        Tutor tutor = tutorService.findById(Integer.parseInt(id));
        if (tutor == null) {
            notices.add(new Notice());
        } else {
            if (tutor.getMail() != null) {
                for (Mail mail : tutor.getMail()) {
                    notices.add(this.getNoticeByMail(mail));
                }
            }
        }
        return notices;
    }

    /**
     * 用来获取发送通知时用到的收件人，
     * 只获取指导老师的学生和与指导老师在同一个教研室的老师
     * @param id tutorId
     */
    @RequestMapping(value = "/getAddresseeTest.json")
    @ResponseBody
    public Map<String, List<Addressee>> getAddresseeTest( String id) {

        Map<String, List<Addressee>> map = new HashMap<>();
        //获取指导老师所在教研室的老师
        Tutor tutor = tutorService.findById(Integer.parseInt(id));
        if (tutor != null) {
            List<Addressee> addresseesTutor = new ArrayList<>();
            for (Tutor tutor1 : tutor.getDepartment().getTutor()) {
                addresseesTutor.add(this.getAddresseeByAddressee(tutor1, null));
            }
            map.put("tutors", addresseesTutor);
            //获取该指导老师的学生
            if (tutor.getStudent() != null) {
                List<Addressee> addresseesStudent = new ArrayList<>();
                for (Student student : tutor.getStudent()) {
                    addresseesStudent.add(this.getAddresseeByStudent(student));
                }
                map.put("students", addresseesStudent);
            }
        }
        return map;
    }

}
