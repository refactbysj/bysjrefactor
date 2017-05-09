package com.newview.bysj.web.android.model;

import java.util.List;

/**
 * @author zhan
 *         Created on 2017/05/09  13:37
 */
public class ProjectAndReplyGroup {
    private List<GraduateProject> graduateProjectList;
    private List<ReplyGroup> replyGroups;

    public List<GraduateProject> getGraduateProjectList() {
        return graduateProjectList;
    }

    public void setGraduateProjectList(List<GraduateProject> graduateProjectList) {
        this.graduateProjectList = graduateProjectList;
    }

    public List<ReplyGroup> getReplyGroups() {
        return replyGroups;
    }

    public void setReplyGroups(List<ReplyGroup> replyGroups) {
        this.replyGroups = replyGroups;
    }
}
