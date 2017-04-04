package com.newview.bysj.util;

import java.io.Serializable;

/**
 * 操作结果集
 *
 * @author zhan
 *         Created on 2017/04/03  22:33
 */
public class Result implements Serializable{

    private boolean success = false;
    private String msg = "";
    private Object object = null;

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Object getObject() {
        return object;
    }

    public void setObject(Object object) {
        this.object = object;
    }
}
