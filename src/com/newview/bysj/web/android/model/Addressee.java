package com.newview.bysj.web.android.model;

/**
 * @author zhan
 *         Created on 2017/05/14  13:17
 */
public class Addressee {
    private Long id;
    private long noticeId;
    private String name;

    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }

    public long getNoticeId() {
        return noticeId;
    }

    public void setNoticeId(long noticeId) {
        this.noticeId = noticeId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
