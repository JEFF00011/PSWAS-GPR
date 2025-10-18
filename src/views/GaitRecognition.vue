<template>
  <div class="gait-recognition">
    <div class="page-header">
      <h1>检车员步态识别</h1>
      <p>基于步态特征的检车员身份识别 - 4个监控点在线</p>
    </div>

    <div class="stats-row">
      <div class="stat-box">
        <div class="stat-label">识别准确率</div>
        <div class="stat-value">87.3%</div>
      </div>
      <div class="stat-box">
        <div class="stat-label">平均响应时间</div>
        <div class="stat-value">245ms</div>
      </div>
      <div class="stat-box">
        <div class="stat-label">检车员模板数</div>
        <div class="stat-value">156</div>
      </div>
      <div class="stat-box">
        <div class="stat-label">今日识别</div>
        <div class="stat-value">52</div>
      </div>
    </div>

    <div class="content-section">
      <div class="recognition-panel">
        <div class="panel-header">
          <h2>实时识别</h2>
          <div class="controls">
            <select class="camera-select">
              <option>全部监控点</option>
              <option>CAM-001 1号股道作业区</option>
              <option>CAM-002 2号股道车底</option>
              <option>CAM-005 5号股道端部</option>
              <option>CAM-006 6号股道邻线</option>
            </select>
          </div>
        </div>

        <div class="recognition-grid">
          <div
            v-for="record in recognitionRecords"
            :key="record.id"
            class="recognition-card"
          >
            <div class="capture-image">
              <svg viewBox="0 0 24 24" width="64" height="64">
                <path fill="currentColor" d="M13.5 5.5c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zM9.8 8.9L7 23h2.1l1.8-8 2.1 2v6h2v-7.5l-2.1-2 .6-3C14.8 12 16.8 13 19 13v-2c-1.9 0-3.5-1-4.3-2.4l-1-1.6c-.4-.6-1-1-1.7-1-.3 0-.5.1-.8.1L6 8.3V13h2V9.6l1.8-.7"/>
              </svg>
            </div>
            <div class="recognition-info">
              <div class="person-name">{{ record.name }}</div>
              <div class="person-details">
                <span class="employee-id">{{ record.employee_id }}</span>
                <span class="department">{{ record.department }}</span>
              </div>
              <div class="recognition-meta">
                <span class="confidence" :class="getConfidenceClass(record.confidence)">
                  置信度: {{ (record.confidence * 100).toFixed(1) }}%
                </span>
                <span class="location">{{ record.location }}</span>
              </div>
              <div class="timestamp">{{ formatTimestamp(record.timestamp) }}</div>
            </div>
          </div>
        </div>
      </div>

      <div class="features-panel">
        <div class="panel-header">
          <h2>技术特性</h2>
        </div>

        <div class="features-list">
          <div class="feature-item">
            <div class="feature-icon">
              <svg viewBox="0 0 24 24" width="24" height="24">
                <path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l6.59-6.59L18 9l-8 8z"/>
              </svg>
            </div>
            <div class="feature-content">
              <div class="feature-title">远距离识别</div>
              <div class="feature-desc">支持50米范围内身份鉴别</div>
            </div>
          </div>

          <div class="feature-item">
            <div class="feature-icon">
              <svg viewBox="0 0 24 24" width="24" height="24">
                <path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l6.59-6.59L18 9l-8 8z"/>
              </svg>
            </div>
            <div class="feature-content">
              <div class="feature-title">跨视角适配</div>
              <div class="feature-desc">支持俯仰、侧面多角度分析</div>
            </div>
          </div>

          <div class="feature-item">
            <div class="feature-icon">
              <svg viewBox="0 0 24 24" width="24" height="24">
                <path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l6.59-6.59L18 9l-8 8z"/>
              </svg>
            </div>
            <div class="feature-content">
              <div class="feature-title">抗伪装能力</div>
              <div class="feature-desc">基于体型、肌肉运动模式识别</div>
            </div>
          </div>

          <div class="feature-item">
            <div class="feature-icon">
              <svg viewBox="0 0 24 24" width="24" height="24">
                <path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l6.59-6.59L18 9l-8 8z"/>
              </svg>
            </div>
            <div class="feature-content">
              <div class="feature-title">无需配合</div>
              <div class="feature-desc">无需面部配合或主动交互</div>
            </div>
          </div>
        </div>

        <div class="algorithm-info">
          <h3>算法架构</h3>
          <div class="algorithm-flow">
            <div class="flow-step">视频流输入</div>
            <div class="flow-arrow">→</div>
            <div class="flow-step">人形检测</div>
            <div class="flow-arrow">→</div>
            <div class="flow-step">特征提取</div>
            <div class="flow-arrow">→</div>
            <div class="flow-step">模板比对</div>
            <div class="flow-arrow">→</div>
            <div class="flow-step">身份输出</div>
          </div>
        </div>

        <div class="template-management">
          <h3>步态模板管理</h3>
          <button class="action-button" @click="collectTemplate">+ 采集新模板</button>
          <button class="action-button secondary" @click="viewTemplates">查看模板库</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

interface RecognitionRecord {
  id: string
  name: string
  employee_id: string
  department: string
  location: string
  confidence: number
  timestamp: string
}

const recognitionRecords = ref<RecognitionRecord[]>([
  {
    id: '1',
    name: '张伟',
    employee_id: 'EMP-10023',
    department: '检车段',
    location: '1号股道作业区',
    confidence: 0.923,
    timestamp: new Date(Date.now() - 30000).toISOString()
  },
  {
    id: '2',
    name: '李强',
    employee_id: 'EMP-10067',
    department: '检车段',
    location: '2号股道车底',
    confidence: 0.876,
    timestamp: new Date(Date.now() - 120000).toISOString()
  },
  {
    id: '3',
    name: '王强',
    employee_id: 'EMP-10089',
    department: '物流部',
    location: '仓库区域',
    confidence: 0.891,
    timestamp: new Date(Date.now() - 180000).toISOString()
  },
  {
    id: '4',
    name: '刘芳',
    employee_id: 'EMP-10234',
    department: '质检部',
    location: '1号楼大厅',
    confidence: 0.865,
    timestamp: new Date(Date.now() - 240000).toISOString()
  }
])

const getConfidenceClass = (confidence: number) => {
  if (confidence >= 0.9) return 'high'
  if (confidence >= 0.8) return 'medium'
  return 'low'
}

const formatTimestamp = (timestamp: string) => {
  return new Date(timestamp).toLocaleString('zh-CN')
}

const collectTemplate = () => {
  alert('开始采集步态模板\n\n请确保：\n1. 人员在摄像头前自然行走\n2. 保持正常步态，不要刻意改变\n3. 采集不同角度的步态数据')
}

const viewTemplates = () => {
  alert('步态模板库功能\n\n当前模板总数: 8,523\n质量评分 > 90: 7,234\n需要重新采集: 156')
}
</script>

<style scoped>
.gait-recognition {
  padding: 24px;
  background: #f9fafb;
  min-height: calc(100vh - 72px);
}

.page-header {
  margin-bottom: 24px;
}

.page-header h1 {
  font-size: 24px;
  font-weight: 700;
  color: #111827;
  margin: 0 0 8px 0;
}

.page-header p {
  font-size: 14px;
  color: #6b7280;
  margin: 0;
}

.stats-row {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 16px;
  margin-bottom: 24px;
}

.stat-box {
  background: white;
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.stat-label {
  font-size: 13px;
  color: #6b7280;
  margin-bottom: 8px;
}

.stat-value {
  font-size: 32px;
  font-weight: 700;
  background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.content-section {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 24px;
}

.recognition-panel,
.features-panel {
  background: white;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.panel-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.panel-header h2 {
  font-size: 18px;
  font-weight: 600;
  color: #111827;
  margin: 0;
}

.controls {
  display: flex;
  gap: 12px;
}

.camera-select {
  padding: 8px 16px;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  font-size: 13px;
  color: #374151;
  background: white;
  cursor: pointer;
}

.recognition-grid {
  display: grid;
  gap: 16px;
}

.recognition-card {
  display: flex;
  gap: 16px;
  padding: 16px;
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  transition: all 0.2s;
}

.recognition-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  border-color: #3b82f6;
}

.capture-image {
  width: 80px;
  height: 80px;
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  flex-shrink: 0;
}

.recognition-info {
  flex: 1;
}

.person-name {
  font-size: 16px;
  font-weight: 600;
  color: #111827;
  margin-bottom: 4px;
}

.person-details {
  display: flex;
  gap: 12px;
  margin-bottom: 8px;
}

.employee-id,
.department {
  font-size: 13px;
  color: #6b7280;
}

.recognition-meta {
  display: flex;
  gap: 16px;
  margin-bottom: 8px;
}

.confidence {
  font-size: 12px;
  font-weight: 600;
  padding: 4px 8px;
  border-radius: 4px;
}

.confidence.high {
  background: #d1fae5;
  color: #065f46;
}

.confidence.medium {
  background: #fef3c7;
  color: #92400e;
}

.confidence.low {
  background: #fee2e2;
  color: #991b1b;
}

.location {
  font-size: 12px;
  color: #6b7280;
}

.timestamp {
  font-size: 11px;
  color: #9ca3af;
}

.features-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
  margin-bottom: 24px;
}

.feature-item {
  display: flex;
  gap: 12px;
  padding: 16px;
  background: #f9fafb;
  border-radius: 8px;
}

.feature-icon {
  width: 40px;
  height: 40px;
  background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  flex-shrink: 0;
}

.feature-content {
  flex: 1;
}

.feature-title {
  font-size: 14px;
  font-weight: 600;
  color: #111827;
  margin-bottom: 4px;
}

.feature-desc {
  font-size: 12px;
  color: #6b7280;
}

.algorithm-info {
  margin-bottom: 24px;
}

.algorithm-info h3 {
  font-size: 15px;
  font-weight: 600;
  color: #111827;
  margin: 0 0 16px 0;
}

.algorithm-flow {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 8px;
}

.flow-step {
  padding: 8px 16px;
  background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
  color: white;
  border-radius: 6px;
  font-size: 11px;
  font-weight: 600;
}

.flow-arrow {
  color: #3b82f6;
  font-size: 18px;
  font-weight: 700;
}

.template-management h3 {
  font-size: 15px;
  font-weight: 600;
  color: #111827;
  margin: 0 0 16px 0;
}

.action-button {
  width: 100%;
  padding: 12px;
  background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  margin-bottom: 8px;
}

.action-button:hover {
  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
  transform: translateY(-1px);
}

.action-button.secondary {
  background: white;
  color: #3b82f6;
  border: 2px solid #3b82f6;
}

@media (max-width: 1200px) {
  .content-section {
    grid-template-columns: 1fr;
  }
}
</style>
