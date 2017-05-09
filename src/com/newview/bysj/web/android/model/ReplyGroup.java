package com.newview.bysj.web.android.model;


import java.util.List;

/**
 * @author zhan
 *         Created on 2017/05/08  23:15
 */
public class ReplyGroup {
    private Long id;
    private String description;                                    //答辩小组名称
    private String location;                                       //答辩的地点
    private Integer leader_id;                                     //答辩小组组长的id
    private String leader_name;                                     //答辩小组组长的名称
    private ReplyTime replyTime;
    private List<GraduateProject> graduateProjects;

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

    public ReplyTime getReplyTime() {
        return replyTime;
    }

    public void setReplyTime(ReplyTime replyTime) {
        this.replyTime = replyTime;
    }

    public List<GraduateProject> getGraduateProjects() {
        return graduateProjects;
    }

    public void setGraduateProjects(List<GraduateProject> graduateProjects) {
        this.graduateProjects = graduateProjects;
    }
}
