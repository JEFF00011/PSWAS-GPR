<template>
  <div class="compliance-detection">
    <div class="page-header">
      <h1>铁路作业合规检测</h1>
      <p>检车员作业监控 · 安全规范检测 · 违规行为识别</p>
    </div>

    <div class="stats-row">
      <div class="stat-box safety">
        <div class="stat-icon">
          <svg viewBox="0 0 24 24" width="24" height="24">
            <path fill="currentColor" d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4z"/>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-label">今日作业检测</div>
          <div class="stat-value">87</div>
        </div>
      </div>

      <div class="stat-box behavior">
        <div class="stat-icon">
          <svg viewBox="0 0 24 24" width="24" height="24">
            <path fill="currentColor" d="M13.5 5.5c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zM9.8 8.9L7 23h2.1l1.8-8 2.1 2v6h2v-7.5l-2.1-2 .6-3C14.8 12 16.8 13 19 13v-2c-1.9 0-3.5-1-4.3-2.4l-1-1.6c-.4-.6-1-1-1.7-1-.3 0-.5.1-.8.1L6 8.3V13h2V9.6l1.8-.7"/>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-label">检车员识别</div>
          <div class="stat-value">52</div>
        </div>
      </div>

      <div class="stat-box violations">
        <div class="stat-icon">
          <svg viewBox="0 0 24 24" width="24" height="24">
            <path fill="currentColor" d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-label">违规行为</div>
          <div class="stat-value">5</div>
        </div>
      </div>

      <div class="stat-box compliance">
        <div class="stat-icon">
          <svg viewBox="0 0 24 24" width="24" height="24">
            <path fill="currentColor" d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-label">合规率</div>
          <div class="stat-value">94.3%</div>
        </div>
      </div>
    </div>

    <div class="content-layout">
      <div class="detection-panel">
        <div class="panel-header">
          <h2>违规检测记录</h2>
          <div class="filters">
            <select class="filter-select">
              <option>全部类型</option>
              <option>横越线路违规</option>
              <option>侵入邻线</option>
              <option>未佩戴防护帽</option>
              <option>未留安全距离</option>
              <option>未执行三同时制度</option>
            </select>
            <select class="filter-select">
              <option>全部严重级别</option>
              <option>严重</option>
              <option>高</option>
              <option>中</option>
              <option>低</option>
            </select>
          </div>
        </div>

        <div class="detection-list">
          <div
            v-for="violation in violations"
            :key="violation.id"
            class="violation-card"
            :class="violation.severity"
          >
            <div class="violation-image">
              <img
                :src="violation.imageUrl"
                :alt="getTypeLabel(violation.type)"
                @error="handleImageError"
              />
            </div>
            <div class="violation-content">
              <div class="violation-header">
                <div class="violation-type">
                  <span class="type-badge" :class="violation.severity">
                    {{ getTypeLabel(violation.type) }}
                  </span>
                  <span class="severity-badge" :class="violation.severity">
                    {{ getSeverityLabel(violation.severity) }}
                  </span>
                </div>
                <div class="violation-time">{{ formatTime(violation.timestamp) }}</div>
              </div>
              <div class="violation-description">{{ violation.description }}</div>
              <div class="violation-meta">
                <div class="meta-item">
                  <svg viewBox="0 0 24 24" width="14" height="14">
                    <path fill="currentColor" d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/>
                  </svg>
                  <span>{{ violation.location }}</span>
                </div>
                <div class="meta-item">
                  <svg viewBox="0 0 24 24" width="14" height="14">
                    <path fill="currentColor" d="M17 10.5V7c0-.55-.45-1-1-1H4c-.55 0-1 .45-1 1v10c0 .55.45 1 1 1h12c.55 0 1-.45 1-1v-3.5l4 4v-11l-4 4z"/>
                  </svg>
                  <span>{{ violation.camera_id }}</span>
                </div>
              </div>
            </div>
            <div class="violation-actions">
              <button class="action-button view" @click="showDetail(violation)">查看详情</button>
              <button class="action-button resolve" @click="resolveViolation(violation.id)">处理</button>
            </div>
          </div>
        </div>
      </div>

      <div class="rules-panel">
        <div class="panel-header">
          <h2>检测规则</h2>
        </div>

        <div class="rules-section">
          <h3>铁路作业安全检测规则</h3>
          <div class="rule-list">
            <div class="rule-item">
              <div class="rule-icon helmet">
                <svg viewBox="0 0 24 24" width="20" height="20">
                  <path fill="currentColor" d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4z"/>
                </svg>
              </div>
              <div class="rule-content">
                <div class="rule-name">防护帽佩戴检测</div>
                <div class="rule-desc">检测检车员作业时是否佩戴防护帽</div>
              </div>
              <div class="rule-toggle">
                <label class="toggle-switch">
                  <input type="checkbox" checked>
                  <span class="toggle-slider"></span>
                </label>
              </div>
            </div>

            <div class="rule-item">
              <div class="rule-icon vest">
                <svg viewBox="0 0 24 24" width="20" height="20">
                  <path fill="currentColor" d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                </svg>
              </div>
              <div class="rule-content">
                <div class="rule-name">横越线路规范检测</div>
                <div class="rule-desc">检测横越线路时是否执行手指口述眼看制度</div>
              </div>
              <div class="rule-toggle">
                <label class="toggle-switch">
                  <input type="checkbox" checked>
                  <span class="toggle-slider"></span>
                </label>
              </div>
            </div>

            <div class="rule-item">
              <div class="rule-icon goggles">
                <svg viewBox="0 0 24 24" width="20" height="20">
                  <path fill="currentColor" d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/>
                </svg>
              </div>
              <div class="rule-content">
                <div class="rule-name">邻线侵入检测</div>
                <div class="rule-desc">检测检车员行走时是否侵入邻线危险区域</div>
              </div>
              <div class="rule-toggle">
                <label class="toggle-switch">
                  <input type="checkbox" checked>
                  <span class="toggle-slider"></span>
                </label>
              </div>
            </div>

            <div class="rule-item">
              <div class="rule-icon fall">
                <svg viewBox="0 0 24 24" width="20" height="20">
                  <path fill="currentColor" d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/>
                </svg>
              </div>
              <div class="rule-content">
                <div class="rule-name">安全距离检测</div>
                <div class="rule-desc">检测通过列车端部时是否留有规定安全距离</div>
              </div>
              <div class="rule-toggle">
                <label class="toggle-switch">
                  <input type="checkbox" checked>
                  <span class="toggle-slider"></span>
                </label>
              </div>
            </div>

            <div class="rule-item">
              <div class="rule-icon climb">
                <svg viewBox="0 0 24 24" width="20" height="20">
                  <path fill="currentColor" d="M13.5 5.5c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zM9.8 8.9L7 23h2.1l1.8-8 2.1 2v6h2v-7.5l-2.1-2 .6-3C14.8 12 16.8 13 19 13v-2c-1.9 0-3.5-1-4.3-2.4l-1-1.6c-.4-.6-1-1-1.7-1-.3 0-.5.1-.8.1L6 8.3V13h2V9.6l1.8-.7"/>
                </svg>
              </div>
              <div class="rule-content">
                <div class="rule-name">三同时制度检测</div>
                <div class="rule-desc">检测上下电动脱轨器时是否执行手扶牢脚踏实眼看准</div>
              </div>
              <div class="rule-toggle">
                <label class="toggle-switch">
                  <input type="checkbox" checked>
                  <span class="toggle-slider"></span>
                </label>
              </div>
            </div>
          </div>
        </div>

        <div class="add-rule-section">
          <button class="add-rule-btn" @click="addCustomRule">+ 添加自定义规则</button>
        </div>
      </div>
    </div>

    <div v-if="selectedViolation" class="modal-overlay" @click="closeDetail">
      <div class="modal-content" @click.stop>
        <button class="modal-close" @click="closeDetail">
          <svg viewBox="0 0 24 24" width="24" height="24">
            <path fill="currentColor" d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
          </svg>
        </button>

        <div class="modal-header">
          <div class="header-badges">
            <span class="severity-badge-large" :class="selectedViolation.severity">
              {{ getSeverityLabel(selectedViolation.severity) }}
            </span>
            <span class="type-badge-large">
              {{ getTypeLabel(selectedViolation.type) }}
            </span>
          </div>
          <h2>违规详情</h2>
        </div>

        <div class="modal-body">
          <div class="detail-section">
            <h3>抓拍图像</h3>
            <div class="evidence-image">
              <img
                :src="selectedViolation.imageUrl"
                :alt="getTypeLabel(selectedViolation.type)"
                @error="handleImageError"
              />
            </div>
          </div>

          <div class="detail-section">
            <h3>违规信息</h3>
            <div class="detail-grid">
              <div class="detail-item">
                <div class="detail-label">违规类型</div>
                <div class="detail-value">{{ getTypeLabel(selectedViolation.type) }}</div>
              </div>
              <div class="detail-item">
                <div class="detail-label">严重级别</div>
                <div class="detail-value">
                  <span class="severity-tag" :class="selectedViolation.severity">
                    {{ getSeverityLabel(selectedViolation.severity) }}
                  </span>
                </div>
              </div>
              <div class="detail-item">
                <div class="detail-label">发生位置</div>
                <div class="detail-value">{{ selectedViolation.location }}</div>
              </div>
              <div class="detail-item">
                <div class="detail-label">摄像头ID</div>
                <div class="detail-value">{{ selectedViolation.camera_id }}</div>
              </div>
              <div class="detail-item">
                <div class="detail-label">检测时间</div>
                <div class="detail-value">{{ formatFullTime(selectedViolation.timestamp) }}</div>
              </div>
              <div class="detail-item">
                <div class="detail-label">持续时长</div>
                <div class="detail-value">{{ selectedViolation.duration }}</div>
              </div>
            </div>
          </div>

          <div class="detail-section">
            <h3>详细描述</h3>
            <div class="description-box">
              {{ selectedViolation.description }}
            </div>
          </div>

          <div class="detail-section">
            <h3>AI分析结果</h3>
            <div class="analysis-box">
              <div class="analysis-item">
                <span class="analysis-label">检测置信度:</span>
                <span class="analysis-value">{{ selectedViolation.confidence }}%</span>
              </div>
              <div class="analysis-item">
                <span class="analysis-label">人体关键点:</span>
                <span class="analysis-value">17个关键点已检测</span>
              </div>
              <div class="analysis-item">
                <span class="analysis-label">检测算法:</span>
                <span class="analysis-value">YOLOv12 + RNN模型</span>
              </div>
            </div>
          </div>

          <div class="detail-section" v-if="selectedViolation.personnel">
            <h3>涉事人员</h3>
            <div class="personnel-info">
              <div class="personnel-avatar">
                <svg viewBox="0 0 24 24" width="32" height="32">
                  <path fill="currentColor" d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                </svg>
              </div>
              <div class="personnel-details">
                <div class="personnel-name">{{ selectedViolation.personnel.name }}</div>
                <div class="personnel-meta">
                  <span>工号: {{ selectedViolation.personnel.employee_id }}</span>
                  <span>部门: {{ selectedViolation.personnel.department }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="modal-footer">
          <button class="modal-btn secondary" @click="closeDetail">关闭</button>
          <button class="modal-btn primary" @click="markResolved">标记已处理</button>
          <button class="modal-btn danger" @click="generateReport">生成报告</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

interface Violation {
  id: string
  type: string
  severity: 'critical' | 'high' | 'medium' | 'low'
  description: string
  location: string
  camera_id: string
  timestamp: string
  imageUrl?: string
  duration?: string
  confidence?: number
  personnel?: {
    name: string
    employee_id: string
    department: string
  }
}

const selectedViolation = ref<Violation | null>(null)

const violations = ref<Violation[]>([
  {
    id: '1',
    type: 'cross_line',
    severity: 'high',
    description: '检测到检车员在横越线路时未执行手指口述眼看制度。系统通过视频分析识别到人员直接横越线路，未进行规定的安全确认动作，存在严重安全隐患。',
    location: '股道3-4之间',
    camera_id: 'CAM-003',
    timestamp: new Date(Date.now() - 120000).toISOString(),
    imageUrl: '/1.jpg',
    duration: '3秒',
    confidence: 96.8,
    personnel: {
      name: '张伟',
      employee_id: 'EMP-10023',
      department: '检车段'
    }
  },
  {
    id: '2',
    type: 'intrusion',
    severity: 'critical',
    description: '检测到检车员行走时侵入邻线，距离邻线列车不足2米。系统识别到人员位置超出安全界限，进入相邻股道危险区域，已触发紧急告警。',
    location: '6号股道',
    camera_id: 'CAM-006',
    timestamp: new Date(Date.now() - 300000).toISOString(),
    imageUrl: '/2.jpg',
    duration: '持续8秒',
    confidence: 98.5,
    personnel: {
      name: '李强',
      employee_id: 'EMP-10067',
      department: '检车段'
    }
  },
  {
    id: '3',
    type: 'no_helmet',
    severity: 'high',
    description: '检测到检车员作业时未佩戴防护帽。系统通过YOLOv12算法检测到作业人员头部区域未识别到防护帽特征，连续多帧确认违规行为。',
    location: '2号股道车底',
    camera_id: 'CAM-002',
    timestamp: new Date(Date.now() - 450000).toISOString(),
    imageUrl: '/3.jpg',
    duration: '作业全程',
    confidence: 97.3,
    personnel: {
      name: '王明',
      employee_id: 'EMP-10145',
      department: '检车段'
    }
  },
  {
    id: '4',
    type: 'unsafe_distance',
    severity: 'high',
    description: '检测到检车员进入现场通过列车端部时未留有安全距离。人员与列车端部距离小于1米，违反安全作业规定，存在被夹挤风险。',
    location: '5号股道列车端部',
    camera_id: 'CAM-005',
    timestamp: new Date(Date.now() - 600000).toISOString(),
    imageUrl: '/4.jpg',
    duration: '4秒',
    confidence: 94.1,
    personnel: {
      name: '赵刚',
      employee_id: 'EMP-10198',
      department: '检车段'
    }
  },
  {
    id: '5',
    type: 'three_simultaneous',
    severity: 'medium',
    description: '检测到检车员上下电动脱轨器时未执行三同时制度（手扶牢、脚踏实、眼看准）。系统识别到作业动作不规范，存在摔倒或踏空风险。',
    location: '1号股道电动脱轨器',
    camera_id: 'CAM-001',
    timestamp: new Date(Date.now() - 900000).toISOString(),
    imageUrl: '/5.jpg',
    duration: '上下过程',
    confidence: 91.7,
    personnel: {
      name: '刘洋',
      employee_id: 'EMP-10223',
      department: '检车段'
    }
  }
])

const showDetail = (violation: Violation) => {
  selectedViolation.value = violation
}

const closeDetail = () => {
  selectedViolation.value = null
}

const handleImageError = (event: Event) => {
  const img = event.target as HTMLImageElement
  img.src = 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iODAwIiBoZWlnaHQ9IjYwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSIjZjNmNGY2Ii8+PHRleHQgeD0iNTAlIiB5PSI1MCUiIGZvbnQtZmFtaWx5PSJBcmlhbCIgZm9udC1zaXplPSIyNCIgZmlsbD0iIzljYTNhZiIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZHk9Ii4zZW0iPuaKk+aLjeWbvuWDjzwvdGV4dD48L3N2Zz4='
}

const formatFullTime = (timestamp: string) => {
  return new Date(timestamp).toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour12: false
  })
}

const getTypeLabel = (type: string) => {
  const labels: Record<string, string> = {
    cross_line: '横越线路未执行手指口述眼看',
    intrusion: '行走时侵入邻线',
    no_helmet: '作业时未佩戴防护帽',
    unsafe_distance: '未留有安全距离',
    three_simultaneous: '未执行三同时制度'
  }
  return labels[type] || type
}

const getSeverityLabel = (severity: string) => {
  const labels: Record<string, string> = {
    critical: '严重',
    high: '高',
    medium: '中',
    low: '低'
  }
  return labels[severity] || severity
}

const formatTime = (timestamp: string) => {
  const date = new Date(timestamp)
  const now = new Date()
  const diff = now.getTime() - date.getTime()
  const minutes = Math.floor(diff / 60000)

  if (minutes < 1) return '刚刚'
  if (minutes < 60) return `${minutes}分钟前`
  if (minutes < 1440) return `${Math.floor(minutes / 60)}小时前`
  return date.toLocaleDateString('zh-CN')
}

const resolveViolation = (id: string) => {
  const violation = violations.value.find(v => v.id === id)
  if (violation) {
    if (confirm(`确认处理违规记录：${getTypeLabel(violation.type)}？`)) {
      violations.value = violations.value.filter(v => v.id !== id)
      alert('违规记录已标记为已处理')
    }
  }
}

const addCustomRule = () => {
  alert('添加自定义规则\n\n功能说明：\n1. 支持自定义检测区域\n2. 设置告警阈值\n3. 配置检测时间段\n4. 定义触发条件')
}

const markResolved = () => {
  if (selectedViolation.value && confirm('确认标记为已处理？')) {
    violations.value = violations.value.filter(v => v.id !== selectedViolation.value!.id)
    alert('已标记为处理完成')
    closeDetail()
  }
}

const generateReport = () => {
  if (selectedViolation.value) {
    alert(`正在生成违规报告...\n\n报告内容：\n- 违规类型: ${getTypeLabel(selectedViolation.value.type)}\n- 严重级别: ${getSeverityLabel(selectedViolation.value.severity)}\n- 发生时间: ${formatFullTime(selectedViolation.value.timestamp)}\n- 附件: 抓拍图像、AI分析数据\n\n报告将发送至管理员邮箱`)
  }
}
</script>

<style scoped>
.compliance-detection {
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
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 16px;
  margin-bottom: 24px;
}

.stat-box {
  background: white;
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  display: flex;
  gap: 16px;
  align-items: center;
}

.stat-icon {
  width: 48px;
  height: 48px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  flex-shrink: 0;
}

.stat-box.safety .stat-icon {
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
}

.stat-box.behavior .stat-icon {
  background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
}

.stat-box.violations .stat-icon {
  background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
}

.stat-box.compliance .stat-icon {
  background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
}

.stat-content {
  flex: 1;
}

.stat-label {
  font-size: 13px;
  color: #6b7280;
  margin-bottom: 4px;
}

.stat-value {
  font-size: 28px;
  font-weight: 700;
  color: #111827;
}

.content-layout {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 24px;
}

.detection-panel,
.rules-panel {
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

.detection-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.violation-card {
  display: flex;
  gap: 16px;
  padding: 16px;
  border-left: 4px solid;
  border-radius: 8px;
  background: #f9fafb;
  transition: all 0.2s;
}

.violation-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.violation-card.critical {
  border-left-color: #ef4444;
}

.violation-card.high {
  border-left-color: #f97316;
}

.violation-card.medium {
  border-left-color: #f59e0b;
}

.violation-card.low {
  border-left-color: #10b981;
}

.violation-image {
  width: 80px;
  height: 80px;
  border-radius: 8px;
  overflow: hidden;
  flex-shrink: 0;
  background: #f3f4f6;
}

.violation-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.violation-content {
  flex: 1;
}

.violation-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.violation-type {
  display: flex;
  gap: 8px;
}

.type-badge,
.severity-badge {
  padding: 4px 10px;
  border-radius: 4px;
  font-size: 11px;
  font-weight: 700;
}

.type-badge {
  background: #1f2937;
  color: white;
}

.severity-badge.critical {
  background: #fee2e2;
  color: #991b1b;
}

.severity-badge.high {
  background: #ffedd5;
  color: #9a3412;
}

.severity-badge.medium {
  background: #fef3c7;
  color: #92400e;
}

.violation-time {
  font-size: 11px;
  color: #9ca3af;
}

.violation-description {
  font-size: 13px;
  color: #374151;
  margin-bottom: 8px;
  line-height: 1.5;
}

.violation-meta {
  display: flex;
  gap: 16px;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 12px;
  color: #6b7280;
}

.violation-actions {
  display: flex;
  flex-direction: column;
  gap: 8px;
  justify-content: center;
}

.action-button {
  padding: 8px 16px;
  border: none;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  white-space: nowrap;
}

.action-button.view {
  background: #f3f4f6;
  color: #374151;
}

.action-button.view:hover {
  background: #e5e7eb;
}

.action-button.resolve {
  background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
  color: white;
}

.action-button.resolve:hover {
  box-shadow: 0 2px 8px rgba(59, 130, 246, 0.3);
}

.rules-section {
  margin-bottom: 24px;
}

.rules-section h3 {
  font-size: 15px;
  font-weight: 600;
  color: #111827;
  margin: 0 0 16px 0;
}

.rule-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.rule-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px;
  background: #f9fafb;
  border-radius: 8px;
}

.rule-icon {
  width: 36px;
  height: 36px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  flex-shrink: 0;
}

.rule-icon.helmet,
.rule-icon.vest,
.rule-icon.goggles {
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
}

.rule-icon.fall,
.rule-icon.climb,
.rule-icon.run,
.rule-icon.gather {
  background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
}

.rule-content {
  flex: 1;
}

.rule-name {
  font-size: 14px;
  font-weight: 600;
  color: #111827;
  margin-bottom: 2px;
}

.rule-desc {
  font-size: 12px;
  color: #6b7280;
}

.rule-toggle {
  flex-shrink: 0;
}

.toggle-switch {
  position: relative;
  display: inline-block;
  width: 44px;
  height: 24px;
}

.toggle-switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

.toggle-slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #cbd5e1;
  transition: 0.3s;
  border-radius: 24px;
}

.toggle-slider:before {
  position: absolute;
  content: "";
  height: 18px;
  width: 18px;
  left: 3px;
  bottom: 3px;
  background-color: white;
  transition: 0.3s;
  border-radius: 50%;
}

.toggle-switch input:checked + .toggle-slider {
  background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
}

.toggle-switch input:checked + .toggle-slider:before {
  transform: translateX(20px);
}

.add-rule-section {
  padding-top: 16px;
  border-top: 1px solid #e5e7eb;
}

.add-rule-btn {
  width: 100%;
  padding: 12px;
  background: white;
  color: #3b82f6;
  border: 2px dashed #3b82f6;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.add-rule-btn:hover {
  background: #f0f4ff;
  border-style: solid;
}

@media (max-width: 1200px) {
  .content-layout {
    grid-template-columns: 1fr;
  }
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 20px;
}

.modal-content {
  background: white;
  border-radius: 16px;
  max-width: 900px;
  width: 100%;
  max-height: 90vh;
  overflow-y: auto;
  position: relative;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
}

.modal-close {
  position: absolute;
  top: 16px;
  right: 16px;
  width: 40px;
  height: 40px;
  border: none;
  background: #f3f4f6;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s;
  z-index: 10;
}

.modal-close:hover {
  background: #e5e7eb;
  transform: rotate(90deg);
}

.modal-header {
  padding: 32px 32px 24px;
  border-bottom: 1px solid #e5e7eb;
}

.header-badges {
  display: flex;
  gap: 12px;
  margin-bottom: 16px;
}

.severity-badge-large,
.type-badge-large {
  padding: 8px 16px;
  border-radius: 8px;
  font-size: 13px;
  font-weight: 700;
}

.severity-badge-large.critical {
  background: #fee2e2;
  color: #991b1b;
}

.severity-badge-large.high {
  background: #ffedd5;
  color: #9a3412;
}

.severity-badge-large.medium {
  background: #fef3c7;
  color: #92400e;
}

.severity-badge-large.low {
  background: #d1fae5;
  color: #065f46;
}

.type-badge-large {
  background: #f3f4f6;
  color: #374151;
}

.modal-header h2 {
  font-size: 24px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.modal-body {
  padding: 24px 32px;
}

.detail-section {
  margin-bottom: 32px;
}

.detail-section:last-child {
  margin-bottom: 0;
}

.detail-section h3 {
  font-size: 16px;
  font-weight: 600;
  color: #111827;
  margin: 0 0 16px 0;
}

.evidence-image {
  width: 100%;
  border-radius: 12px;
  overflow: hidden;
  background: #f3f4f6;
  aspect-ratio: 16 / 9;
}

.evidence-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.detail-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
}

.detail-item {
  padding: 16px;
  background: #f9fafb;
  border-radius: 8px;
}

.detail-label {
  font-size: 12px;
  color: #6b7280;
  margin-bottom: 6px;
  font-weight: 500;
}

.detail-value {
  font-size: 14px;
  color: #111827;
  font-weight: 600;
}

.severity-tag {
  padding: 4px 10px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 700;
}

.severity-tag.critical {
  background: #fee2e2;
  color: #991b1b;
}

.severity-tag.high {
  background: #ffedd5;
  color: #9a3412;
}

.severity-tag.medium {
  background: #fef3c7;
  color: #92400e;
}

.severity-tag.low {
  background: #d1fae5;
  color: #065f46;
}

.description-box {
  padding: 16px;
  background: #f9fafb;
  border-radius: 8px;
  font-size: 14px;
  line-height: 1.6;
  color: #374151;
}

.analysis-box {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.analysis-item {
  display: flex;
  justify-content: space-between;
  padding: 14px 16px;
  background: #f9fafb;
  border-radius: 8px;
}

.analysis-label {
  font-size: 13px;
  color: #6b7280;
  font-weight: 500;
}

.analysis-value {
  font-size: 13px;
  color: #111827;
  font-weight: 700;
}

.personnel-info {
  display: flex;
  gap: 16px;
  padding: 16px;
  background: #f9fafb;
  border-radius: 8px;
}

.personnel-avatar {
  width: 56px;
  height: 56px;
  background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  flex-shrink: 0;
}

.personnel-details {
  flex: 1;
}

.personnel-name {
  font-size: 16px;
  font-weight: 700;
  color: #111827;
  margin-bottom: 6px;
}

.personnel-meta {
  display: flex;
  gap: 16px;
  font-size: 13px;
  color: #6b7280;
}

.modal-footer {
  padding: 24px 32px;
  border-top: 1px solid #e5e7eb;
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

.modal-btn {
  padding: 10px 24px;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.modal-btn.secondary {
  background: #f3f4f6;
  color: #374151;
}

.modal-btn.secondary:hover {
  background: #e5e7eb;
}

.modal-btn.primary {
  background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
  color: white;
}

.modal-btn.primary:hover {
  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
  transform: translateY(-1px);
}

.modal-btn.danger {
  background: #ef4444;
  color: white;
}

.modal-btn.danger:hover {
  background: #dc2626;
  box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
}

@media (max-width: 768px) {
  .detail-grid {
    grid-template-columns: 1fr;
  }

  .modal-content {
    max-width: 100%;
    max-height: 100vh;
    border-radius: 0;
  }

  .modal-body {
    padding: 20px;
  }

  .modal-footer {
    flex-direction: column;
  }

  .modal-btn {
    width: 100%;
  }
}
</style>
