package com.newview.bysj.service;

import com.newview.bysj.dao.ConstraintOfApproveOpenningReportDao;
import com.newview.bysj.domain.ConstraintOfApproveOpenningReport;
import com.newview.bysj.domain.Department;
import com.newview.bysj.domain.Tutor;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.jpaRepository.MyRepository;
import com.newview.bysj.myAnnotation.MethodDescription;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("constraintOfApproveOpenningReportService")
public class ConstraintOfApproveOpenningReportService extends BasicService<ConstraintOfApproveOpenningReport, Integer> {

    ConstraintOfApproveOpenningReportDao constraintOfApproveOpenningReportDao;

    @Override
    @Autowired
    public void setDasciDao(
            MyRepository<ConstraintOfApproveOpenningReport, Integer> basicDao) {
        // TODO Auto-generated method stub
        this.basicDao = basicDao;
        constraintOfApproveOpenningReportDao = (ConstraintOfApproveOpenningReportDao) basicDao;

    }

    @MethodDescription("处理tutor所在教研室是否在维护开题报告时间范围内")
    public Boolean isAbleToUpdateOpenningReport(Tutor tutor) {
        ConstraintOfApproveOpenningReport openningReport = this.uniqueResult("department", Department.class, tutor.getDepartment());
        //如果开题报告的时间已经进行设置
        if (openningReport != null) {
            return CommonHelper.isNowInPeroid(openningReport.getStartTime(), openningReport.getEndTime());
        } else {
            //如果未设置时间，则返回true
            return true;
        }
    }

}
