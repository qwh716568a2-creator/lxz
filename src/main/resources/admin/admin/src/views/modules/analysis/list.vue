<template>
  <div class="analysis-page">
    <div class="analysis-toolbar">
      <div>
        <h1>数据分析</h1>
        <p>统计问卷发布、填写、题目作答与匿名填写情况。</p>
      </div>
      <el-button type="primary" @click="loadData" :loading="loading">刷新数据</el-button>
    </div>

    <div class="analysis-cards">
      <div class="analysis-card" v-for="item in cards" :key="item.label">
        <div class="card-label">{{ item.label }}</div>
        <div class="card-value">{{ item.value }}</div>
        <div class="card-note">{{ item.note }}</div>
      </div>
    </div>

    <div class="analysis-grid">
      <div class="analysis-panel">
        <h2>近 7 日填写趋势</h2>
        <div class="trend">
          <div class="trend-item" v-for="item in trendRows" :key="item.label">
            <div class="bar-value">{{ item.value }}</div>
            <div class="bar" :style="{ height: item.height + 'px' }"></div>
            <div class="bar-label">{{ item.label }}</div>
          </div>
        </div>
      </div>

      <div class="analysis-panel">
        <h2>题目选项分布</h2>
        <div v-if="questionStats.length === 0" class="empty">暂无题目作答数据</div>
        <div v-for="question in questionStats" :key="question.id" class="question">
          <div class="question-title">{{ question.name }}</div>
          <div class="question-meta">{{ question.paperName }} / {{ question.answerCount }} 次作答</div>
          <div v-for="option in optionRows(question.options)" :key="option.name" class="option-row">
            <div class="option-name" :title="option.name">{{ option.name }}</div>
            <div class="option-bar"><span :style="{ width: option.width + '%' }"></span></div>
            <div>{{ option.value }}</div>
          </div>
        </div>
      </div>

      <div class="analysis-panel paper-panel">
        <h2>问卷填写排行</h2>
        <el-table :data="paperStats" border size="small">
          <el-table-column prop="name" label="问卷名称"></el-table-column>
          <el-table-column prop="questionCount" label="题目数" width="100" align="center"></el-table-column>
          <el-table-column prop="responseCount" label="填写数" width="100" align="center"></el-table-column>
          <el-table-column prop="answeredCount" label="作答明细" width="110" align="center"></el-table-column>
          <el-table-column label="完成度" width="220">
            <template slot-scope="scope">
              <el-progress :percentage="scope.row.completionRate || 0"></el-progress>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      loading: false,
      totals: {},
      trend: {},
      paperStats: [],
      questionStats: []
    }
  },
  computed: {
    cards() {
      return [
        { label: '问卷总数', value: this.totals.papers || 0, note: '已创建问卷' },
        { label: '题目总数', value: this.totals.questions || 0, note: '题库题目' },
        { label: '填写记录', value: this.totals.responses || 0, note: '提交次数' },
        { label: '答题明细', value: this.totals.answers || 0, note: '题目作答' },
        { label: '匿名填写', value: this.totals.anonymousResponses || 0, note: '无需登录提交' }
      ]
    },
    trendRows() {
      const keys = Object.keys(this.trend || {})
      const max = Math.max.apply(null, keys.map(key => this.trend[key] || 0).concat([1]))
      return keys.map(key => {
        const value = this.trend[key] || 0
        return {
          label: key,
          value,
          height: Math.max(8, Math.round(value / max * 220))
        }
      })
    }
  },
  created() {
    this.loadData()
  },
  methods: {
    loadData() {
      this.loading = true
      this.$http({
        url: 'analysis/summary',
        method: 'get'
      }).then(({ data }) => {
        if (data && data.code === 0) {
          const payload = data.data || {}
          this.totals = payload.totals || {}
          this.trend = payload.trend || {}
          this.paperStats = payload.paperStats || []
          this.questionStats = payload.questionStats || []
        } else {
          this.$message.error(data.msg || '数据加载失败')
        }
        this.loading = false
      })
    },
    optionRows(options) {
      const keys = Object.keys(options || {})
      const max = Math.max.apply(null, keys.map(key => options[key] || 0).concat([1]))
      return keys.map(key => {
        const value = options[key] || 0
        return {
          name: key,
          value,
          width: Math.max(4, Math.round(value / max * 100))
        }
      })
    }
  }
}
</script>

<style scoped>
.analysis-page {
  background: #f3f6fb;
  padding: 20px;
  color: #111827;
}
.analysis-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  margin-bottom: 18px;
}
.analysis-toolbar h1 {
  margin: 0 0 8px;
  font-size: 24px;
}
.analysis-toolbar p {
  margin: 0;
  color: #6b7280;
}
.analysis-cards {
  display: grid;
  grid-template-columns: repeat(5, minmax(120px, 1fr));
  gap: 18px;
  margin-bottom: 22px;
}
.analysis-card,
.analysis-panel {
  background: #fff;
  border: 1px solid #e5eaf3;
  border-radius: 4px;
}
.analysis-card {
  padding: 28px 30px;
}
.card-label,
.card-note,
.question-meta {
  color: #526078;
}
.card-value {
  margin-top: 18px;
  font-size: 34px;
  font-weight: 800;
}
.card-note {
  margin-top: 14px;
}
.analysis-grid {
  display: grid;
  grid-template-columns: minmax(0, 1.15fr) minmax(360px, .85fr);
  gap: 20px;
}
.analysis-panel {
  padding: 22px;
}
.paper-panel {
  grid-column: 1 / -1;
}
.trend {
  height: 300px;
  display: flex;
  align-items: flex-end;
  gap: 14px;
  padding: 12px 6px 0;
  border-bottom: 1px solid #e5eaf3;
}
.trend-item {
  flex: 1;
  text-align: center;
}
.bar {
  min-height: 8px;
  border-radius: 4px 4px 0 0;
  background: linear-gradient(180deg, #756ff9 0%, #54c4ef 100%);
}
.bar-value,
.bar-label {
  color: #5f687c;
}
.bar-value {
  margin-bottom: 10px;
}
.bar-label {
  margin-top: 9px;
}
.question {
  padding-bottom: 16px;
  margin-bottom: 18px;
  border-bottom: 1px solid #e5eaf3;
}
.question-title {
  font-size: 16px;
  font-weight: 800;
}
.option-row {
  display: grid;
  grid-template-columns: minmax(72px, 160px) 1fr 44px;
  gap: 10px;
  align-items: center;
  margin: 10px 0;
}
.option-name {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.option-bar {
  height: 8px;
  border-radius: 4px;
  background: #edf1f7;
  overflow: hidden;
}
.option-bar span {
  display: block;
  height: 100%;
  background: #f26b4f;
}
.empty {
  padding: 32px;
  text-align: center;
  color: #6b7280;
}
@media (max-width: 1200px) {
  .analysis-cards {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
  .analysis-grid {
    grid-template-columns: 1fr;
  }
}
</style>
