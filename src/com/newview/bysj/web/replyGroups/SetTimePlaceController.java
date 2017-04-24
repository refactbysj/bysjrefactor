package com.newview.bysj.web.replyGroups;

import com.newview.bysj.domain.ReplyGroup;
import com.newview.bysj.domain.ReplyTime;
import com.newview.bysj.domain.Tutor;
import com.newview.bysj.helper.CommonHelper;
import com.newview.bysj.util.PageInfo;
import com.newview.bysj.util.Result;
import com.newview.bysj.web.baseController.BaseController;
import org.apache.log4j.Logger;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * 答辩时间地点设置
 * Created by zhan on 2016/3/17.
 */
@Controller
@RequestMapping("replyGroups")
public class SetTimePlaceController extends BaseController {

    private static final Logger logger = Logger.getLogger(SetTimePlaceController.class);

    /**
     * 答辩时间地点
     */
    @RequestMapping(value = "/setReplyGroup.html", method = RequestMethod.GET)
    public String listReplyGroup() {
        return "replyGroup/setReplyGroupsTime";
    }

    /**
     * 获取答辩小组数据
     */
    @RequestMapping("/getReplyGroupData.html")
    @ResponseBody
    public PageInfo getReplyGroupData(HttpSession httpSession, String groupName, Integer page, Integer rows) {
        PageInfo pageInfo = new PageInfo();
        Tutor tutor = CommonHelper.getCurrentTutor(httpSession);
        Page<ReplyGroup> replyGroupPage = replyGroupService.getReplyGroupSchool(tutor.getDepartment().getSchool(), groupName, page, rows);
        if (replyGroupPage != null && replyGroupPage.getSize() > 0) {
            pageInfo.setRows(replyGroupPage.getContent());
            pageInfo.setTotal((int) replyGroupPage.getTotalElements());
        }
        return pageInfo;
    }


    /**
     * 答辩时间地点的get方法
     *
     * @param httpServletRequest 用于获取当前的请求路径
     * @param model           存储需要在jsp中获取的数据
     * @param replyGroupId       需要修改的答辩小组的id
     * @return jsp
     */
    @RequestMapping(value = "/setTimeAndClassRoom.html", method = RequestMethod.GET)
    public String setTimeAndClassRoom(HttpServletRequest httpServletRequest, Model model, Integer replyGroupId) {
        //获取需要修改的答辩小组
        ReplyGroup replyGroup = replyGroupService.findById(replyGroupId);
        model.addAttribute("replyGroup", replyGroup);
        model.addAttribute("setReplyURL", httpServletRequest.getRequestURI());
        model.addAttribute("classList", classRoomService.findAll());
        model.addAttribute("replyGroupId", replyGroupId);
        if (replyGroup.getReplyTime() != null) {
            Long beginMillins = replyGroup.getReplyTime().getBeginTime().getTimeInMillis();
            Long endMillins = replyGroup.getReplyTime().getEndTime().getTimeInMillis();
            model.addAttribute("startTime", CommonHelper.getStringDateByMillionsAndPattern(beginMillins, "yyyy-MM-dd"));
            model.addAttribute("endTime", CommonHelper.getStringDateByMillionsAndPattern(endMillins, "yyyy-MM-dd"));
        }
        return "replyGroup/setTimeAndClassRoom";
    }

    /**
     * 答辩时间地点的post方法
     *
     * @param classRoomId  修改后的教室的id
     * @param replyGroupId 修改的答辩小组的id
     * @param startTime    开始时间
     * @param endTime      结束时间
     */
    @RequestMapping(value = "/setTimeAndClassRoom.html", method = RequestMethod.POST)
    @ResponseBody
    public Result setTimeAndClassRoom(Integer classRoomId, Integer replyGroupId, String startTime, String endTime) {
        Result result = new Result();
        try {
            //获取修改的答辩小组的名称
            ReplyGroup replyGroup = replyGroupService.findById(replyGroupId);
            //设置时间地点
            replyGroup.setReplyTime(new ReplyTime(CommonHelper.getCalendarByString(startTime, "yyyy-MM-dd"), CommonHelper.getCalendarByString(endTime, "yyyy-MM-dd")));
            //设置答辩的都是
            replyGroup.setClassRoom(classRoomService.findById(classRoomId));
            replyGroupService.saveOrUpdate(replyGroup);
            result.setSuccess(true);
            result.setMsg("设置答辩时间地点成功");
        } catch (Exception e) {
            logger.error("设置答辩时间地点失败" + e);
            result.setMsg("设置答辩时间地点失败");
            e.printStackTrace();
        }
        return result;
    }
}
