package com.newview.bysj.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import javax.persistence.*;
import java.io.Serializable;

/**
 * 用户角色。user类和role类的中间表
 */
@Entity
@Table(name = "user_role")
@DynamicInsert(true)
@DynamicUpdate(true)
public class UserRole implements Serializable {

    /**
     *
     */
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    /**
     * 用户
     * 多对一
     *
     * @generated
     */
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
    /**
     * 用户
     * 多对一
     *
     * @generated
     */
    @ManyToOne
    @JoinColumn(name = "role_id")
    private Role role;
    /**
     * @generated
     */
    private boolean qualified;

    public UserRole() {
        super();
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    @JsonIgnore
    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public boolean isQualified() {
        return qualified;
    }

    public void setQualified(boolean qualified) {
        this.qualified = qualified;
    }


}
