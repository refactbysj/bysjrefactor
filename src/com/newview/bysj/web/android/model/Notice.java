package com.newview.bysj.web.android.model;

import java.util.List;

/**
 * @author zhan
 *         Created on 2017/05/08  23:18
 */
public class Notice {
    private Long id;
    private String title;             //通知的题目
    private String content;        //通知的内容
    private long addressTime;        //通知的时
    private Integer addressor_id;   //发送通知者的id
    private String addressor_name; //发送通知者的姓名
    private List<Addressee> addressees;
    public Notice() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }


    public Integer getAddressor_id() {
        return addressor_id;
    }

    public void setAddressor_id(Integer addressor_id) {
        this.addressor_id = addressor_id;
    }

    public String getAddressor_name() {
        return addressor_name;
    }

    public void setAddressor_name(String addressor_name) {
        this.addressor_name = addressor_name;
    }

    public long getAddressTime() {
        return addressTime;
    }

    public void setAddressTime(long addressTime) {
        this.addressTime = addressTime;
    }

    public List<Addressee> getAddressees() {
        return addressees;
    }

    public void setAddressees(List<Addressee> addressees) {
        this.addressees = addressees;
    }
}
