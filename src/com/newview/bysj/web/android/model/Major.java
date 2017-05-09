package com.newview.bysj.web.android.model;

/**
 * @author zhan
 *         Created on 2017/05/08  23:06
 */
public class Major {
    private long id;
    private String description;

    public Major() {
    }

    public Major(long id, String description) {
        this.id = id;
        this.description = description;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
