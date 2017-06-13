package com.newview.bysj.dao;

import com.newview.bysj.domain.GraduateProject;
import com.newview.bysj.jpaRepository.MyRepository;
import org.springframework.data.jpa.repository.Query;

public interface GraduateProjectDao extends MyRepository<GraduateProject, Integer> {

    @Query("select count(g.title) from GraduateProject g where g.title=?1")
    long getProjectCount(String title);

}
