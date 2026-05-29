package com.utils;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import org.apache.commons.lang3.StringUtils;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class ChineseTypoChecker {
    private static final int MAX_ISSUES = 30;

    private ChineseTypoChecker() {
    }

    public static List<Map<String, Object>> check(String text, String apiUrl, String apiKey, String model) {
        if (StringUtils.isBlank(text)) {
            return new ArrayList<>();
        }
        if (StringUtils.isBlank(apiUrl) || StringUtils.isBlank(apiKey)) {
            throw new IllegalStateException("Typo API is not configured");
        }
        try {
            return checkByApi(text, apiUrl, apiKey, model);
        } catch (Exception e) {
            throw new IllegalStateException("Typo API request failed", e);
        }
    }

    private static List<Map<String, Object>> checkByApi(String text, String apiUrl, String apiKey, String model) throws Exception {
        System.setProperty("https.protocols", "TLSv1.2");
        HttpURLConnection connection = (HttpURLConnection) new URL(apiUrl).openConnection();
        connection.setRequestMethod("POST");
        connection.setConnectTimeout(8000);
        connection.setReadTimeout(20000);
        connection.setDoOutput(true);
        connection.setRequestProperty("Content-Type", "application/json;charset=UTF-8");
        connection.setRequestProperty("Accept", "application/json");
        connection.setRequestProperty("User-Agent", "tongyongwenjuandiaocha-typo-check/1.0");
        connection.setRequestProperty("Authorization", "Bearer " + apiKey);

        JSONObject body = new JSONObject(true);
        body.put("model", StringUtils.defaultIfBlank(model, "gpt-4o-mini"));
        body.put("temperature", 0);
        JSONArray messages = new JSONArray();
        messages.add(message("system", "You are a Chinese typo detector. Detect real Chinese typos according to context and semantics. Return JSON only, with no explanation. The exact schema is {\"hasTypos\":true/false,\"typos\":[\"wrong word 1\",\"wrong word 2\"]}. The typos array must contain only the original wrong Chinese words from the user's text. If there is no typo, return an empty typos array."));
        messages.add(message("user", text));
        body.put("messages", messages);

        byte[] payload = body.toJSONString().getBytes(StandardCharsets.UTF_8);
        try (OutputStream outputStream = connection.getOutputStream()) {
            outputStream.write(payload);
        }

        int status = connection.getResponseCode();
        BufferedReader reader = new BufferedReader(new InputStreamReader(
                status >= 200 && status < 300 ? connection.getInputStream() : connection.getErrorStream(),
                StandardCharsets.UTF_8
        ));
        StringBuilder response = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            response.append(line);
        }
        if (status < 200 || status >= 300) {
            throw new IllegalStateException("Typo API request failed: " + status + " " + response);
        }

        JSONObject responseJson = JSON.parseObject(response.toString());
        JSONArray choices = responseJson.getJSONArray("choices");
        if (choices == null || choices.isEmpty()) {
            return new ArrayList<>();
        }
        JSONObject message = choices.getJSONObject(0).getJSONObject("message");
        String content = message == null ? choices.getJSONObject(0).getString("text") : message.getString("content");
        return parseApiResult(content);
    }

    private static JSONObject message(String role, String content) {
        JSONObject message = new JSONObject(true);
        message.put("role", role);
        message.put("content", content);
        return message;
    }

    private static List<Map<String, Object>> parseApiResult(String content) {
        if (StringUtils.isBlank(content)) {
            return new ArrayList<>();
        }
        String jsonText = content.trim();
        if (jsonText.startsWith("```")) {
            jsonText = jsonText.replaceFirst("^```(?:json)?", "").replaceFirst("```$", "").trim();
        }

        JSONObject result = JSON.parseObject(jsonText);
        if (!result.getBooleanValue("hasTypos")) {
            return new ArrayList<>();
        }

        Set<String> words = new LinkedHashSet<>();
        JSONArray typos = result.getJSONArray("typos");
        if (typos != null) {
            for (Object item : typos) {
                if (words.size() >= MAX_ISSUES) {
                    break;
                }
                String original;
                if (item instanceof JSONObject) {
                    JSONObject object = (JSONObject) item;
                    original = firstNotBlank(object.getString("original"), object.getString("wrong"), object.getString("typo"));
                } else {
                    original = String.valueOf(item);
                }
                if (StringUtils.isNotBlank(original)) {
                    words.add(original.trim());
                }
            }
        }
        return toIssues(words);
    }

    private static String firstNotBlank(String... values) {
        for (String value : values) {
            if (StringUtils.isNotBlank(value)) {
                return value;
            }
        }
        return "";
    }

    private static List<Map<String, Object>> toIssues(Set<String> words) {
        List<Map<String, Object>> issues = new ArrayList<>();
        for (String word : words) {
            Map<String, Object> issue = new LinkedHashMap<>();
            issue.put("original", word);
            issues.add(issue);
        }
        return issues;
    }
}
