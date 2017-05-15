package com.newview.bysj.web.android.model;

/**
 * @author zhan
 *         Created on 2017/05/14  13:17
 */
public class Addressee {
    private Long id;
    private Long addresseeId;
    private Long noticeId;
    private boolean isSelected;
    private String addresseeType;
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

    public Long getAddresseeId() {
        return addresseeId;
    }

    public void setAddresseeId(Long addresseeId) {
        this.addresseeId = addresseeId;
    }

    public void setNoticeId(Long noticeId) {
        this.noticeId = noticeId;
    }

    public boolean isSelected() {
        return isSelected;
    }

    public void setSelected(boolean selected) {
        isSelected = selected;
    }

    public String getAddresseeType() {
        return addresseeType;
    }

    public void setAddresseeType(String addresseeType) {
        this.addresseeType = addresseeType;
    }
}
