package com.newview.bysj.web.android;

import com.newview.bysj.domain.*;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.myAnnotation.MethodDescription;
import com.newview.bysj.web.android.model.Addressee;
import com.newview.bysj.web.android.model.Notice;
import com.newview.bysj.web.android.model.ProjectAndReplyGroup;
import com.newview.bysj.web.android.model.Scores;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.*;

/**
 * 给android端提供的接口
 * 当前类的名字命名不规范，建议重新更改
 *
 * @author zhan
 */
@Controller
public class BysjWebServiceImpl extends AndroidBase {

    //private static final Logger logger = Logger.getLogger(BysjWebServiceImpl.class);


    /**
     * 给android端提供的登录功能
     *
     * @param currentUser android端传递过来的user对象
     * @return 返回当前user对象对应的tutor, 如果获取tutor失败则返回一个空的tutor.
     */
    @MethodDescription("角色为tutor的用户登录")
    @RequestMapping(value = "/login.json", method = RequestMethod.POST)
    @ResponseBody
    public com.newview.bysj.web.android.model.Tutor login(@RequestBody User currentUser) {
        com.newview.bysj.web.android.model.Tutor androidTutor = new com.newview.bysj.web.android.model.Tutor();
        //获取输入的用户名
        String username = currentUser.getUsername();
        //获取输入的密码
        String password = currentUser.getPassword();
        //创建一个空的tutor
        Tutor tutor;
        //根据当前用户名获取对应的user
        User user = userService.uniqueResult("username", username);
        //如果不存在对应的user，则返回一个空的tutor
        if (user == null)
            return androidTutor;
        //如果存在，并且密码输入正确，则返回对应的tutor
        if (user.getPassword().equals(CommonHelper.makeMD5(password))) {
            tutor = tutorService.findById(user.getActor().getId());

            return this.getAndroidTutorByTutor(tutor);
        }
        //密码输入不正确，返回空的tutor
        return androidTutor;
    }


    /**
     * 获取当前我申报的课题
     *
     * @param id 当前用户的id
     * @return 当前用户课题的集合
     */
    @RequestMapping(value = "/getGraduateProjectByTutorId.json", method = RequestMethod.POST)
    @ResponseBody
    public List<com.newview.bysj.web.android.model.GraduateProject> getGraduateProjectByTutorId(
            @RequestBody String id) {
        List<com.newview.bysj.web.android.model.GraduateProject> graduateProjectList = new ArrayList<>();
        //获取对应的tutor
        Tutor tutor = tutorService.findById(Integer.parseInt(id));
        //根据当前tutor获取申报的课题
        List<GraduateProject> graduateProjects = graduateProjectService.getCurrentYearGraduateProjectByTutor(tutor);
        if (graduateProjects != null) {
            for (GraduateProject graduateProject : graduateProjects) {
                graduateProjectList.add(this.getAndroidGraduateProjectByGraduateProject(graduateProject));
            }
        }
        return graduateProjectList;
    }


    /**
     * 获取我发布的邮件和发给我的邮件
     * <p>
     * 分别获取我收到的邮件和我发送的邮件，并添加到邮件集合中返回给android端
     * <p>
     * 以下方法可以改进！！！！！！！！！！
     *
     * @param id 要获取的用户的id
     * @return 返回的是我发送的邮件和我收到的邮件的集合
     */
    @RequestMapping(value = "/mail.json", method = RequestMethod.POST)
    @ResponseBody
    public List<Mail> mailList(@RequestBody String id) {
        //创建一个mail集合，用来存放已收到的邮件和已发送的邮件
        List<Mail> allMail = new ArrayList<>();
        List<Mail> receiveMail = new ArrayList<>();
        List<Mail> sendMail;
        Tutor tutor = tutorService.findById(Integer.parseInt(id));
        //如果当前tutor为空，则返回一个空的mail对象
        if (tutor == null) {
            receiveMail.add(new Mail());
        } else {
            if (tutor.getReceiveMail() != null) {
                //获取收到的邮件，并添加集合中
                receiveMail = tutor.getReceiveMail();
                allMail.addAll(receiveMail);
            }
            if (tutor.getMail() != null) {
                //获取发送的邮件，并添加到集合中
                sendMail = tutor.getMail();
                allMail.addAll(sendMail);
            }
            //如果发送的邮件为空，则添加一个空的邮件
            else {
                allMail.add(new Mail());
            }
        }
        return allMail;
    }


    /**
     * 获取我收到的通知
     *
     * @param id tutorId
     */
    @RequestMapping(value = "/getMyReceivedNotices.json", method = RequestMethod.POST)
    @ResponseBody
    public List<Notice> getReceivedMail(@RequestBody String id) {
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
    @RequestMapping(value = "/getMyReleasedNotices.json", method = RequestMethod.POST)
    @ResponseBody
    public List<Notice> getSendMail(@RequestBody String id) {
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
     * 获取我的学生
     *
     * @param id 当前用户的id，用于获取用户
     * @return json数据
     */
    @RequestMapping(value = "/myStudent.json", method = RequestMethod.POST)
    @ResponseBody
    public List<com.newview.bysj.web.android.model.Student> getStudentByTutor(@RequestBody String id) {
        Tutor tutor = tutorService.findById(Integer.parseInt(id));
        List<com.newview.bysj.web.android.model.Student> students = new ArrayList<>();
        //获取当前老师的学生，如果没有给老师分配学生，则返回空的学生集合
        //如果当前tutor为空，则返回一个空的学生集合，这样做是为了方便android端的解析工作
        if (tutor == null || tutor.getStudent() == null) {
            students.add(new com.newview.bysj.web.android.model.Student());
            return students;
        }
        for (Student student : tutor.getStudent()) {
            students.add(this.getAndroidStudentByStudent(student));
        }
        //返回当前老师对应的学生
        return students;
    }

    /**
     * 根据tutorId获取课题和答辩小组
     */
    @RequestMapping(value = "/getProjectAndReplyByTutor.json", method = RequestMethod.POST)
    @ResponseBody
    public ProjectAndReplyGroup getProjectAndReplyByTutor(@RequestBody String id) {
        ProjectAndReplyGroup projectAndReplyGroup = new ProjectAndReplyGroup();
        Tutor tutor = tutorService.findById(Integer.parseInt(id));
        if (tutor != null) {
            List<GraduateProject> graduateProjects = tutor.getProposedGraduateProject();
            List<ReplyGroup> replyGroups = tutor.getReplyGroup();
            List<com.newview.bysj.web.android.model.GraduateProject> graduateProjects1 = new ArrayList<>();
            List<com.newview.bysj.web.android.model.ReplyGroup> replyGroups1 = new ArrayList<>();
            if (graduateProjects != null) {
                for (GraduateProject graduateProject : graduateProjects) {
                    graduateProjects1.add(this.getAndroidGraduateProjectByGraduateProject(graduateProject));
                }
            }
            if (replyGroups != null) {
                for (ReplyGroup replyGroup : replyGroups) {
                    replyGroups1.add(this.getAndroidReplyGroupByReplyGroup(replyGroup));
                }
            }
            projectAndReplyGroup.setGraduateProjectList(graduateProjects1);
            projectAndReplyGroup.setReplyGroups(replyGroups1);
        }
        return projectAndReplyGroup;
    }


    /**
     * 获取当前tutor所在的答辩小组
     *
     * @param id 当前用户的id
     * @return json数据
     */
    @RequestMapping(value = "/getReplyGroupByTutor.json", method = RequestMethod.POST)
    @ResponseBody
    public List<com.newview.bysj.web.android.model.ReplyGroup> getReplyGroupByTutor(@RequestBody String id) {
        List<com.newview.bysj.web.android.model.ReplyGroup> replyGroups = new ArrayList<>();
        Tutor tutor = tutorService.findById(Integer.parseInt(id));
        //获取该老师所在的答辩小组，如果没有给老师分配答辩小组，则返回一个空的答辩小组集合，方便android端的解析
        //如果当前tutor为空，则返回一个空的答辩小组集合，方便android端的解析
        if (tutor == null || tutor.getReplyGroup() == null) {
            replyGroups.add(new com.newview.bysj.web.android.model.ReplyGroup());
            return replyGroups;
        }
        for (ReplyGroup replyGroup : tutor.getReplyGroup()) {
            replyGroups.add(this.getAndroidReplyGroupByReplyGroup(replyGroup));
        }
        //返回该老师所在的答辩小组
        return replyGroups;
    }


    /**
     * 用来获取发送通知时用到的收件人，
     * 只获取指导老师的学生和与指导老师在同一个教研室的老师
     * @param id tutorId
     */
    @RequestMapping(value = "/getAddressee.json",method = RequestMethod.POST)
    @ResponseBody
    public Map<String, List<Addressee>> getAddressee(@RequestBody String id) {

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


    /**
     * 用于给发送邮件做准备，获取所有的学院和我的学生
     *
     * @param id 要发送邮件的tutor的id
     * @return 返回的是一个map集合，里面有学院的集合和我的学生的集合，可以通过key来查找
     */
    @RequestMapping(value = "/getAllSchoolAndMyStudent.json", method = RequestMethod.POST)
    @ResponseBody

    public Map<String, List<?>> getAllStudent(@RequestBody String id) {
        // 用于存放学院和我的学生
        Map<String, List<?>> map = new HashMap<>();
        Tutor tutor = tutorService.findById(Integer.parseInt(id));
        /*
         * 之前android端发送邮件获取的老师是所有学院的所有老师，但是为了
		 * 简化数据，并增强实用性，讨论后决定只给android端返回当前用户所在教研室的所有老师
		 */
        //获取当前老师所在教研室的所有老师
        List<Tutor> tutorList = tutor.getDepartment().getTutor();
        //获取当前老师的学生
        List<Student> studentList = tutor.getStudent();
        List<com.newview.bysj.web.android.model.Student> students = new ArrayList<>();
        List<com.newview.bysj.web.android.model.Tutor> tutors = new ArrayList<>();
        if (tutorList != null) {
            for (Tutor tutor1 : tutorList) {
                tutors.add(this.getAndroidTutorByTutor(tutor1));
            }
        }
        if (studentList != null) {
            for (Student student : studentList) {
                students.add(this.getAndroidStudentByStudent(student));
            }
        }
        // 将老师添加到map集合中
        map.put("allTutorInDepartment", tutors);
        // 将我的学生添加到map集合中
        map.put("myStudent", students);
        return map;
    }


    /**
     * android端发送邮件的提交方法
     * <p>
     * 此方法可以进行改进
     * 给android返回的状态码并不是boolean类型的，而的字符串类型。
     * 可以考虑改为boolean型，在android端也需要进行相应的修改
     *
     * @param notice android端返回的和邮件有关的对象
     * @return 以map集合的形势存放发送邮件的状态，如果成功则为（"status","true"）,失败则为("status","false")
     */
    @ResponseBody
    @RequestMapping(value = "/sendMail.json", method = RequestMethod.POST)
    public Map<String, String> sendMail(@RequestBody com.newview.bysj.web.android.model.Notice notice) {
        // 对发送的邮件进行异常处理，如果发送成功，则返回true,否则返回false
        try {
            // 获取邮件的发送者
            Tutor tutor = tutorService.findById(notice.getAddressor_id());
            // 通过set集合来去重
            Set<Actor> actorSet = new HashSet<>();
            String[] tutorStrs = new String[notice.getAddressees().size()];
            for (int i = 0; i < notice.getAddressees().size(); i++) {
                tutorStrs[i] = notice.getAddressees().get(i).getId().toString();
            }
            for (String tutorStrId : tutorStrs) {
                actorSet.add(actorService.findById(Integer.parseInt(tutorStrId)));
            }
            // 使用迭代器来对set集合进行遍历，将接收者添加到List集合中
            Iterator<Actor> actorIterator = actorSet.iterator();
            // 临时存储接收者的集合
            List<Actor> actorList = new ArrayList<>();
            while (actorIterator.hasNext()) {
                actorList.add(actorIterator.next());
            }
            // 创建一个新的邮件
            Mail sendMail = new Mail();
            // 设置接收者
            sendMail.setAddresses(actorList);
            // 设置标题
            sendMail.setTitle(notice.getTitle());
            // 设置内容
            sendMail.setContent(notice.getContent());
            // 设置发送的时间
            sendMail.setAddressTime(CommonHelper.getNow());
            // 设置发送者
            sendMail.setAddressor(tutor);
            mailService.saveOrUpdate(sendMail);
            return isComplete("true");
        } catch (Exception e) {
            return isComplete("false");
        }
    }

    /**
     * 答辩小组老师给课题打分的方法
     *
     * @param scores Scores类的对象，里面包含课题的id和一些具体的分数
     * @return 返回的是一个map类型的集合，通过String类型的value值"true","false"来代表打分成功和失败
     */

    @RequestMapping(value = "/setScoreWithProjectByGroupMembers.json", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> graduateProjectScore(@RequestBody Scores scores) {

        try {
            //获取答辩小组成员分数表中in_dex字段的最大值
            Integer maxIn_dex = replyGroupMemberScoreService.findIn_dex();
            Integer in_dex;
            if (maxIn_dex == null) {
                in_dex = 1;
            } else {
                in_dex = ++maxIn_dex;
            }
            GraduateProject graduateProject = graduateProjectService
                    .findById(scores.getGraduateProjectId());
            // 得到当前答辩老师所在的答辩小组
            ReplyGroup replyGroup = replyGroupService.findById(scores
                    .getReplyGroup_id());
            // 创建一个新的答辩小组成员的分数的实体类
            ReplyGroupMemberScore replyGroupMemberScore = new ReplyGroupMemberScore();
            // 完成任务的要求水平得分
            replyGroupMemberScore.setCompletenessScoreByGroupTutor(scores
                    .getCompletenessScoreByGroup());
            // 回答问题的正确性得分
            replyGroupMemberScore.setCorrectnessScoreByGroupTutor(scores
                    .getCorrectnessScoreByGroup());
            // 论文实物的质量得分
            replyGroupMemberScore.setQualityScoreByGroupTutor(scores
                    .getQualityScoreByGroup());
            // 论文内容的答辩陈述得分
            replyGroupMemberScore.setReplyScoreByGroupTutor(scores
                    .getReplyScoreByGroup());
            // 获取答辩老师提问学生的问题1
            replyGroupMemberScore.setQuestionByTutor_1(scores
                    .getQuestionByTutor_1());
            // 获取答辩老师提问学生的问题2
            replyGroupMemberScore.setQuestionByTutor_2(scores
                    .getQuestionByTutor_2());
            // 获取答辩老师提问学生的问题3
            replyGroupMemberScore.setQuestionByTutor_3(scores
                    .getQuestionByTutor_3());
            // 获取答辩老师对学生回答的问题的评价1
            replyGroupMemberScore.setResponseRemarkByTutor_1(scores
                    .getResponseRemarkByTutor_1());
            // 获取答辩老师对学生回答的问题的评价2
            replyGroupMemberScore.setResponseRemarkByTutor_2(scores
                    .getResponseRemarkByTutor_2());
            // 获取答辩老师对学生回答的问题的评价3
            replyGroupMemberScore.setResponseRemarkByTutor_3(scores
                    .getResponseRemarkByTutor_3());
            replyGroupMemberScore.setTutor_id(scores.getTutor_id());
            replyGroupMemberScore.setGraduateProjectId(scores
                    .getGraduateProjectId());
            replyGroupMemberScore.setReplyGroup_id(scores.getReplyGroup_id());
            replyGroupMemberScore.setStudentId(scores.getStudentId());
            // 关联课题
            replyGroupMemberScore.setGraduateProject(graduateProject);
            // 提交的日期
            replyGroupMemberScore.setSubmittedDate(CommonHelper.getNow());
            // 是否已经提交
            replyGroupMemberScore.setSubmitted(true);
            // 设置所属的答辩小组
            replyGroupMemberScore.setReplyGroup(replyGroup);
            // 设置给课题打分的老师
            replyGroupMemberScore.setTutor(tutorService.findById(scores
                    .getTutor_id()));


            // 临时解决懒加载的问题
            replyGroupMemberScore.setIn_dex(in_dex);
            // 持久化到数据库
            replyGroupMemberScoreService.saveOrUpdate(replyGroupMemberScore);

            // 重新获取，因为在持久化到数据库之后，session已经关闭。
            //在hibernate中保存一个实体，会返回当前实体对应的id,但是spring data jpa目前还没有找到这种方法
            replyGroupMemberScore = replyGroupMemberScoreService.uniqueResult(
                    "in_dex", Integer.class, in_dex);
            // 答辩老师只提交一次，并不涉及二次提交或修改。
            List<ReplyGroupMemberScore> replyGroupMemberScoreList = replyGroup
                    .getReplyGroupMemberScoreList();
            if (replyGroupMemberScoreList == null) {
                replyGroupMemberScoreList = new ArrayList<>();
                replyGroupMemberScoreList.add(replyGroupMemberScore);
            } else {
                replyGroupMemberScoreList.add(replyGroupMemberScore);
            }
            // 关联答辩小组和答辩小组成员分数
            replyGroup.setReplyGroupMemberScoreList(replyGroupMemberScoreList);
            // 持久化到数据库
            replyGroupService.saveOrUpdate(replyGroup);
            // 获取该课题的答辩老师所打的分数
            replyGroupMemberScoreList = graduateProject
                    .getReplyGroupMemberScores();
            // 如果没有答辩老师给该课题打分，则创建一个集合，将该老师的打分保存。不能获取集合，并添加到集合中去
            if (replyGroupMemberScoreList == null) {
                replyGroupMemberScoreList = new ArrayList<>();
                replyGroupMemberScoreList.add(replyGroupMemberScore);
            } else {
                replyGroupMemberScoreList.add(replyGroupMemberScore);
            }
            // 设置课题和答辩老师打分之间的关系
            graduateProject
                    .setReplyGroupMemberScores(replyGroupMemberScoreList);
            graduateProjectService.saveOrUpdate(graduateProject);
            return isComplete("true");
        } catch (Exception e) {
            return isComplete("false");
        }
    }


    /**
     * 抽取出的以上一些方法中共同的逻辑，用于给android端返回操作是成功还是失败
     *
     * @param str 需要给android端返回的信息，"true" or "false"
     * @return 给android端返回android集合，由android端进行解析。
     */
    private Map<String, String> isComplete(String str) {
        //创建一个map集合
        Map<String, String> map = new HashMap<>();
        //将要返回的信息添加到map集合中
        map.put("status", str);
        //返回到android端
        return map;
    }
}
