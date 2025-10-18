<template>
  <div class="face-recognition">
    <div class="page-header">
      <h1>检车员身份验证</h1>
      <p>基于人脸识别的身份验证 - 3个监控点在线</p>
    </div>

    <div class="stats-row">
      <div class="stat-box">
        <div class="stat-label">验证准确率</div>
        <div class="stat-value">99.2%</div>
      </div>
      <div class="stat-box">
        <div class="stat-label">平均响应时间</div>
        <div class="stat-value">128ms</div>
      </div>
      <div class="stat-box">
        <div class="stat-label">检车员模板数</div>
        <div class="stat-value">156</div>
      </div>
      <div class="stat-box">
        <div class="stat-label">今日验证</div>
        <div class="stat-value">35</div>
      </div>
    </div>

    <div class="content-section">
      <div class="recognition-panel">
        <div class="panel-header">
          <h2>实时识别结果</h2>
          <div class="filters">
            <select class="filter-select">
              <option>全部监控点</option>
              <option>CAM-001 1号股道作业区</option>
              <option>CAM-003 股道3-4横越点</option>
              <option>CAM-005 5号股道端部</option>
            </select>
            <select class="filter-select">
              <option>全部置信度</option>
              <option>高置信度 (≥95%)</option>
              <option>中置信度 (80-95%)</option>
              <option>低置信度 (<80%)</option>
            </select>
          </div>
        </div>

        <div class="recognition-list">
          <div
            v-for="record in faceRecords"
            :key="record.id"
            class="face-record"
          >
            <div class="face-image">
              <svg viewBox="0 0 24 24" width="48" height="48">
                <path fill="currentColor" d="M9 11.75c-.69 0-1.25.56-1.25 1.25s.56 1.25 1.25 1.25 1.25-.56 1.25-1.25-.56-1.25-1.25-1.25zm6 0c-.69 0-1.25.56-1.25 1.25s.56 1.25 1.25 1.25 1.25-.56 1.25-1.25-.56-1.25-1.25-1.25zM12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8 0-.29.02-.58.05-.86 2.36-1.05 4.23-2.98 5.21-5.37C11.07 8.33 14.05 10 17.42 10c.78 0 1.53-.09 2.25-.26.21.71.33 1.47.33 2.26 0 4.41-3.59 8-8 8z"/>
              </svg>
            </div>
            <div class="record-content">
              <div class="person-header">
                <div>
                  <div class="person-name">{{ record.name }}</div>
                  <div class="person-meta">
                    <span class="employee-badge">{{ record.employee_id }}</span>
                    <span class="department-badge">{{ record.department }}</span>
                  </div>
                </div>
                <div class="confidence-badge" :class="getConfidenceLevel(record.confidence)">
                  {{ (record.confidence * 100).toFixed(1) }}%
                </div>
              </div>
              <div class="record-details">
                <div class="detail-item">
                  <svg viewBox="0 0 24 24" width="14" height="14">
                    <path fill="currentColor" d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/>
                  </svg>
                  <span>{{ record.location }}</span>
                </div>
                <div class="detail-item">
                  <svg viewBox="0 0 24 24" width="14" height="14">
                    <path fill="currentColor" d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm.5-13H11v6l5.25 3.15.75-1.23-4.5-2.67z"/>
                  </svg>
                  <span>{{ formatTime(record.timestamp) }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="info-panel">
        <div class="panel-header">
          <h2>系统功能</h2>
        </div>

        <div class="capabilities">
          <div class="capability-card">
            <div class="capability-icon">
              <svg viewBox="0 0 24 24" width="24" height="24">
                <path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l6.59-6.59L18 9l-8 8z"/>
              </svg>
            </div>
            <div class="capability-title">1对N识别</div>
            <div class="capability-desc">从海量库中快速检索目标</div>
          </div>

          <div class="capability-card">
            <div class="capability-icon">
              <svg viewBox="0 0 24 24" width="24" height="24">
                <path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l6.59-6.59L18 9l-8 8z"/>
              </svg>
            </div>
            <div class="capability-title">M对N识别</div>
            <div class="capability-desc">多目标同时识别</div>
          </div>

          <div class="capability-card">
            <div class="capability-icon">
              <svg viewBox="0 0 24 24" width="24" height="24">
                <path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l6.59-6.59L18 9l-8 8z"/>
              </svg>
            </div>
            <div class="capability-title">活体检测</div>
            <div class="capability-desc">防御照片、视频伪造</div>
          </div>

          <div class="capability-card">
            <div class="capability-icon">
              <svg viewBox="0 0 24 24" width="24" height="24">
                <path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l6.59-6.59L18 9l-8 8z"/>
              </svg>
            </div>
            <div class="capability-title">姿态补偿</div>
            <div class="capability-desc">支持正面、侧脸识别</div>
          </div>
        </div>

        <div class="tech-specs">
          <h3>技术规格</h3>
          <div class="spec-list">
            <div class="spec-item">
              <span class="spec-label">特征维度</span>
              <span class="spec-value">128维向量</span>
            </div>
            <div class="spec-item">
              <span class="spec-label">识别距离</span>
              <span class="spec-value">1-5米</span>
            </div>
            <div class="spec-item">
              <span class="spec-label">光照适应</span>
              <span class="spec-value">灰度变换+直方图均衡</span>
            </div>
            <div class="spec-item">
              <span class="spec-label">关键点数</span>
              <span class="spec-value">眼、鼻、嘴等多点定位</span>
            </div>
          </div>
        </div>

        <div class="actions-section">
          <h3>模板管理</h3>
          <button class="action-btn primary" @click="addFaceTemplate">+ 添加人脸模板</button>
          <button class="action-btn" @click="batchImport">批量导入</button>
          <button class="action-btn" @click="viewTemplateLibrary">查看模板库</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

interface FaceRecord {
  id: string
  name: string
  employee_id: string
  department: string
  location: string
  confidence: number
  timestamp: string
}

const faceRecords = ref<FaceRecord[]>([
  {
    id: '1',
    name: '张伟',
    employee_id: 'EMP-10023',
    department: '检车段',
    location: '1号股道作业区',
    confidence: 0.987,
    timestamp: new Date(Date.now() - 15000).toISOString()
  },
  {
    id: '2',
    name: '王明',
    employee_id: 'EMP-10145',
    department: '检车段',
    location: '股道3-4横越点',
    confidence: 0.945,
    timestamp: new Date(Date.now() - 45000).toISOString()
  },
  {
    id: '3',
    name: '赵刚',
    employee_id: 'EMP-10198',
    department: '检车段',
    location: '5号股道端部',
    confidence: 0.923,
    timestamp: new Date(Date.now() - 90000).toISOString()
  },
  {
    id: '4',
    name: '周静',
    employee_id: 'EMP-10267',
    department: '人事部',
    location: '主入口',
    confidence: 0.978,
    timestamp: new Date(Date.now() - 135000).toISOString()
  },
  {
    id: '5',
    name: '吴涛',
    employee_id: 'EMP-10134',
    department: '生产部',
    location: '生产车间',
    confidence: 0.956,
    timestamp: new Date(Date.now() - 180000).toISOString()
  }
])

const getConfidenceLevel = (confidence: number) => {
  if (confidence >= 0.95) return 'high'
  if (confidence >= 0.8) return 'medium'
  return 'low'
}

const formatTime = (timestamp: string) => {
  const date = new Date(timestamp)
  const now = new Date()
  const diff = now.getTime() - date.getTime()
  const minutes = Math.floor(diff / 60000)

  if (minutes < 1) return '刚刚'
  if (minutes < 60) return `${minutes}分钟前`
  return date.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
}

const addFaceTemplate = () => {
  alert('添加人脸模板\n\n请确保：\n1. 光线充足，避免逆光\n2. 正面拍摄，露出完整面部\n3. 表情自然，避免遮挡\n4. 多角度采集以提高识别率')
}

const batchImport = () => {
  alert('批量导入功能\n\n支持格式：\n- 照片文件 (JPG/PNG)\n- Excel人员名单\n- 自动关联人员信息')
}

const viewTemplateLibrary = () => {
  alert('人脸模板库\n\n总数: 12,847\n高质量: 11,523\n待优化: 1,324')
}
</script>

<style scoped>
.face-recognition {
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
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
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
.info-panel {
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

.filters {
  display: flex;
  gap: 8px;
}

.filter-select {
  padding: 8px 12px;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  font-size: 13px;
  color: #374151;
  background: white;
  cursor: pointer;
}

.recognition-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.face-record {
  display: flex;
  gap: 16px;
  padding: 16px;
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  transition: all 0.2s;
}

.face-record:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  border-color: #4facfe;
}

.face-image {
  width: 64px;
  height: 64px;
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  flex-shrink: 0;
}

.record-content {
  flex: 1;
}

.person-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 8px;
}

.person-name {
  font-size: 16px;
  font-weight: 600;
  color: #111827;
  margin-bottom: 4px;
}

.person-meta {
  display: flex;
  gap: 8px;
}

.employee-badge,
.department-badge {
  font-size: 11px;
  padding: 3px 8px;
  border-radius: 4px;
  font-weight: 600;
}

.employee-badge {
  background: #dbeafe;
  color: #1e40af;
}

.department-badge {
  background: #f3e8ff;
  color: #6b21a8;
}

.confidence-badge {
  padding: 6px 12px;
  border-radius: 6px;
  font-size: 13px;
  font-weight: 700;
}

.confidence-badge.high {
  background: #d1fae5;
  color: #065f46;
}

.confidence-badge.medium {
  background: #fef3c7;
  color: #92400e;
}

.confidence-badge.low {
  background: #fee2e2;
  color: #991b1b;
}

.record-details {
  display: flex;
  gap: 16px;
}

.detail-item {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 12px;
  color: #6b7280;
}

.detail-item svg {
  flex-shrink: 0;
}

.capabilities {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 12px;
  margin-bottom: 24px;
}

.capability-card {
  padding: 16px;
  background: #f9fafb;
  border-radius: 8px;
  text-align: center;
}

.capability-icon {
  width: 40px;
  height: 40px;
  margin: 0 auto 12px;
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

.capability-title {
  font-size: 14px;
  font-weight: 600;
  color: #111827;
  margin-bottom: 4px;
}

.capability-desc {
  font-size: 12px;
  color: #6b7280;
}

.tech-specs {
  margin-bottom: 24px;
}

.tech-specs h3 {
  font-size: 15px;
  font-weight: 600;
  color: #111827;
  margin: 0 0 16px 0;
}

.spec-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.spec-item {
  display: flex;
  justify-content: space-between;
  padding: 12px;
  background: #f9fafb;
  border-radius: 6px;
}

.spec-label {
  font-size: 13px;
  color: #6b7280;
  font-weight: 500;
}

.spec-value {
  font-size: 13px;
  color: #111827;
  font-weight: 600;
}

.actions-section h3 {
  font-size: 15px;
  font-weight: 600;
  color: #111827;
  margin: 0 0 16px 0;
}

.action-btn {
  width: 100%;
  padding: 12px;
  background: white;
  color: #4facfe;
  border: 2px solid #4facfe;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  margin-bottom: 8px;
}

.action-btn:hover {
  background: #f0f9ff;
}

.action-btn.primary {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  color: white;
  border: none;
}

.action-btn.primary:hover {
  box-shadow: 0 4px 12px rgba(79, 172, 254, 0.3);
  transform: translateY(-1px);
}

@media (max-width: 1200px) {
  .content-section {
    grid-template-columns: 1fr;
  }

  .capabilities {
    grid-template-columns: 1fr;
  }
}
</style>
