package com.newview.bysj.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import javax.persistence.*;
import java.io.Serializable;

/**
 * 角色资源
 */
@Entity
@Table(name = "roleresource")
@DynamicInsert(true)
@DynamicUpdate(true)
public class RoleResource implements Serializable {

    /**
     *
     */
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    /**
     * 角色
     * 多对一
     *
     * @generated
     */
    @ManyToOne
    @JoinColumn(name = "role_id")
    private Role role;
    /**
     * 资源
     * 多对一
     *
     * @generated
     */
    @ManyToOne
    @JoinColumn(name = "resource_id")
    private Resource resource;
    /**
     * 期限
     * 一对一
     *
     * @generated
     */
    @OneToOne(mappedBy = "roleResource")
    private Validity validity;

    public RoleResource() {
        super();
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    @JsonIgnore
    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    @JsonIgnore
    public Resource getResource() {
        return resource;
    }

    public void setResource(Resource resource) {
        this.resource = resource;
    }

    public Validity getValidity() {
        return validity;
    }

    public void setValidity(Validity validity) {
        this.validity = validity;
    }


}
