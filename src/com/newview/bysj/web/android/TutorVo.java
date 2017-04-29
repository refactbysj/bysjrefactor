package com.newview.bysj.web.android;

import com.newview.bysj.domain.GraduateProject;
import com.newview.bysj.domain.ReplyGroup;

import java.io.Serializable;
import java.util.List;

/**
 * 封装需要返回的信息
 *
 * @author zhan
 *         Created on 2017/04/25  18:09
 */
public class TutorVo implements Serializable {


    private List<GraduateProject> proposerGraduateProject;


    private List<ReplyGroup> replyGroups;

    public List<GraduateProject> getProposerGraduateProject() {
        return proposerGraduateProject;
    }

    public void setProposerGraduateProject(List<GraduateProject> proposerGraduateProject) {
        this.proposerGraduateProject = proposerGraduateProject;
    }

    public List<ReplyGroup> getReplyGroups() {
        return replyGroups;
    }

    public void setReplyGroups(List<ReplyGroup> replyGroups) {
        this.replyGroups = replyGroups;
    }
}
