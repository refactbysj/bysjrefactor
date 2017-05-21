package com.newview.bysj.web.android.model;


import java.util.List;

/**
 * @author zhan
 *         Created on 2017/05/08  23:15
 */
public class ReplyGroup {
    private Long id;
    private String description;  //答辩小组名称
    private String location;     //答辩的地点
    private Integer leader_id;   //答辩小组组长的id
    private String leader_name;  //答辩小组组长的id
    private long beginTime;      //答辩的开始时间
    private long endTime;        //答辩的结束时间
    private List<GraduateProject> graduateProjects;
    private String major;       //答辩专业
    private String replyMembers;//答辩成员
    private long tutorId;      //登陆用户的id




    public ReplyGroup() {
    }


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public Integer getLeader_id() {
        return leader_id;
    }

    public void setLeader_id(Integer leader_id) {
        this.leader_id = leader_id;
    }

    public String getLeader_name() {
        return leader_name;
    }

    public void setLeader_name(String leader_name) {
        this.leader_name = leader_name;
    }

    public long getBeginTime() {
        return beginTime;
    }

    public void setBeginTime(long beginTime) {
        this.beginTime = beginTime;
    }

    public long getEndTime() {
        return endTime;
    }

    public void setEndTime(long endTime) {
        this.endTime = endTime;
    }

    public List<GraduateProject> getGraduateProjects() {
        return graduateProjects;
    }

    public void setGraduateProjects(List<GraduateProject> graduateProjects) {
        this.graduateProjects = graduateProjects;
    }

    public String getMajor() {
        return major;
    }

    public void setMajor(String major) {
        this.major = major;
    }

    public String getReplyMembers() {
        return replyMembers;
    }

    public void setReplyMembers(String replyMembers) {
        this.replyMembers = replyMembers;
    }

    public long getTutorId() {
        return tutorId;
    }

    public void setTutorId(long tutorId) {
        this.tutorId = tutorId;
    }
}
