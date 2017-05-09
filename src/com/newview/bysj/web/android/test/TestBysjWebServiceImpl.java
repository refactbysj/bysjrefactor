package com.newview.bysj.web.android.test;

import com.newview.bysj.domain.Tutor;
import com.newview.bysj.web.android.AndroidBase;
import com.newview.bysj.web.android.model.GraduateProject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;

/**
 * 测试类
 *
 * @author zhan
 *         Created on 2017/05/09  13:44
 */
@Controller
public class TestBysjWebServiceImpl extends AndroidBase{
    /**
     * 获取当前我申报的课题
     *
     * @param id 当前用户的id
     * @return 当前用户课题的集合
     */
    @RequestMapping(value = "/getGraduateProjectByTutorIdTest.json", method = RequestMethod.GET)
    @ResponseBody
    public List<GraduateProject> getGraduateProjectByTutorId(String id) {
        List<com.newview.bysj.web.android.model.GraduateProject> graduateProjectList = new ArrayList<>();
        //获取对应的tutor
        Tutor tutor = tutorService.findById(Integer.parseInt(id));
        //根据当前tutor获取申报的课题
        List<com.newview.bysj.domain.GraduateProject> graduateProjects = graduateProjectService.getGraduateProjectByTutor(tutor);
        if (graduateProjects != null) {
            for (com.newview.bysj.domain.GraduateProject graduateProject : graduateProjects) {
                graduateProjectList.add(this.getAndroidGraduateProjectByGraduateProject(graduateProject));
            }
        }
        return graduateProjectList;
    }
}
