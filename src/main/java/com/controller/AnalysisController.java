package com.controller;

import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.entity.ExampaperEntity;
import com.entity.ExamquestionEntity;
import com.entity.ExamrecordEntity;
import com.entity.ExamredetailsEntity;
import com.service.ExampaperService;
import com.service.ExamquestionService;
import com.service.ExamrecordService;
import com.service.ExamredetailsService;
import com.utils.R;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/analysis")
public class AnalysisController {

    @Autowired
    private ExampaperService exampaperService;

    @Autowired
    private ExamquestionService examquestionService;

    @Autowired
    private ExamrecordService examrecordService;

    @Autowired
    private ExamredetailsService examredetailsService;

    @RequestMapping("/summary")
    public R summary() {
        List<ExampaperEntity> papers = exampaperService.selectList(new EntityWrapper<ExampaperEntity>());
        List<ExamquestionEntity> questions = examquestionService.selectList(new EntityWrapper<ExamquestionEntity>());
        List<ExamrecordEntity> records = examrecordService.selectList(new EntityWrapper<ExamrecordEntity>());
        List<ExamredetailsEntity> details = examredetailsService.selectList(new EntityWrapper<ExamredetailsEntity>());

        Map<Integer, ExampaperEntity> paperMap = new HashMap<Integer, ExampaperEntity>();
        for (ExampaperEntity paper : papers) {
            paperMap.put(paper.getId(), paper);
        }

        Map<Integer, Integer> questionCountByPaper = new HashMap<Integer, Integer>();
        Map<Integer, Integer> questionPaperMap = new HashMap<Integer, Integer>();
        for (ExamquestionEntity question : questions) {
            Integer paperId = question.getExampaperId();
            if (paperId == null) {
                continue;
            }
            questionPaperMap.put(question.getId(), paperId);
            questionCountByPaper.put(paperId, questionCountByPaper.containsKey(paperId) ? questionCountByPaper.get(paperId) + 1 : 1);
        }

        Map<Integer, Integer> responseCountByPaper = new HashMap<Integer, Integer>();
        int anonymousResponses = 0;
        for (ExamrecordEntity record : records) {
            Integer paperId = record.getExampaperId();
            if (paperId != null) {
                responseCountByPaper.put(paperId, responseCountByPaper.containsKey(paperId) ? responseCountByPaper.get(paperId) + 1 : 1);
            }
            if (record.getYonghuId() != null && record.getYonghuId() == 0) {
                anonymousResponses++;
            }
        }

        Map<Integer, Integer> answeredCountByPaper = new HashMap<Integer, Integer>();
        Map<Integer, Map<String, Integer>> optionCountByQuestion = new HashMap<Integer, Map<String, Integer>>();
        for (ExamredetailsEntity detail : details) {
            Integer questionId = detail.getExamquestionId();
            Integer paperId = questionPaperMap.get(questionId);
            if (paperId != null) {
                answeredCountByPaper.put(paperId, answeredCountByPaper.containsKey(paperId) ? answeredCountByPaper.get(paperId) + 1 : 1);
            }
            if (questionId != null) {
                String answer = detail.getExamredetailsMyanswer();
                if (answer == null || answer.trim().length() == 0) {
                    answer = "未填写";
                }
                Map<String, Integer> optionCounts = optionCountByQuestion.get(questionId);
                if (optionCounts == null) {
                    optionCounts = new LinkedHashMap<String, Integer>();
                    optionCountByQuestion.put(questionId, optionCounts);
                }
                optionCounts.put(answer, optionCounts.containsKey(answer) ? optionCounts.get(answer) + 1 : 1);
            }
        }

        List<Map<String, Object>> paperStats = new ArrayList<Map<String, Object>>();
        for (ExampaperEntity paper : papers) {
            Integer paperId = paper.getId();
            int questionCount = getCount(questionCountByPaper, paperId);
            int responseCount = getCount(responseCountByPaper, paperId);
            int answeredCount = getCount(answeredCountByPaper, paperId);
            int expectedAnswerCount = questionCount * responseCount;
            int completionRate = expectedAnswerCount == 0 ? 0 : Math.min(100, Math.round(answeredCount * 100f / expectedAnswerCount));

            Map<String, Object> row = new LinkedHashMap<String, Object>();
            row.put("id", paperId);
            row.put("name", paper.getExampaperName());
            row.put("questionCount", questionCount);
            row.put("responseCount", responseCount);
            row.put("answeredCount", answeredCount);
            row.put("completionRate", completionRate);
            paperStats.add(row);
        }
        Collections.sort(paperStats, new Comparator<Map<String, Object>>() {
            public int compare(Map<String, Object> left, Map<String, Object> right) {
                return ((Integer) right.get("responseCount")).compareTo((Integer) left.get("responseCount"));
            }
        });

        List<Map<String, Object>> questionStats = new ArrayList<Map<String, Object>>();
        for (ExamquestionEntity question : questions) {
            Map<String, Integer> optionCounts = optionCountByQuestion.get(question.getId());
            int total = 0;
            if (optionCounts != null) {
                for (Integer value : optionCounts.values()) {
                    total += value;
                }
            }
            Map<String, Object> row = new LinkedHashMap<String, Object>();
            row.put("id", question.getId());
            row.put("paperId", question.getExampaperId());
            ExampaperEntity paper = paperMap.get(question.getExampaperId());
            row.put("paperName", paper == null ? "" : paper.getExampaperName());
            row.put("name", question.getExamquestionName());
            row.put("answerCount", total);
            row.put("options", optionCounts == null ? new LinkedHashMap<String, Integer>() : optionCounts);
            questionStats.add(row);
        }
        Collections.sort(questionStats, new Comparator<Map<String, Object>>() {
            public int compare(Map<String, Object> left, Map<String, Object> right) {
                return ((Integer) right.get("answerCount")).compareTo((Integer) left.get("answerCount"));
            }
        });
        if (questionStats.size() > 8) {
            questionStats = questionStats.subList(0, 8);
        }

        Map<String, Integer> trendMap = buildSevenDayTrend(records);

        Map<String, Object> totals = new LinkedHashMap<String, Object>();
        totals.put("papers", papers.size());
        totals.put("questions", questions.size());
        totals.put("responses", records.size());
        totals.put("answers", details.size());
        totals.put("anonymousResponses", anonymousResponses);
        totals.put("registeredResponses", Math.max(0, records.size() - anonymousResponses));

        Map<String, Object> data = new LinkedHashMap<String, Object>();
        data.put("totals", totals);
        data.put("trend", trendMap);
        data.put("paperStats", paperStats);
        data.put("questionStats", questionStats);
        return R.ok().put("data", data);
    }

    private int getCount(Map<Integer, Integer> counts, Integer key) {
        if (key == null || !counts.containsKey(key)) {
            return 0;
        }
        return counts.get(key);
    }

    private Map<String, Integer> buildSevenDayTrend(List<ExamrecordEntity> records) {
        SimpleDateFormat format = new SimpleDateFormat("MM-dd");
        Map<String, Integer> trend = new LinkedHashMap<String, Integer>();
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        calendar.add(Calendar.DATE, -6);
        for (int i = 0; i < 7; i++) {
            trend.put(format.format(calendar.getTime()), 0);
            calendar.add(Calendar.DATE, 1);
        }
        for (ExamrecordEntity record : records) {
            Date time = record.getInsertTime() == null ? record.getCreateTime() : record.getInsertTime();
            if (time == null) {
                continue;
            }
            String label = format.format(time);
            if (trend.containsKey(label)) {
                trend.put(label, trend.get(label) + 1);
            }
        }
        return trend;
    }
}
