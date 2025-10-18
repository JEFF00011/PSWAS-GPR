<template>
  <div class="alert-management">
    <div class="page-header">
      <h1>告警管理</h1>
      <p>实时告警监控与处理</p>
    </div>

    <div class="stats-row">
      <div class="stat-card pending">
        <div class="stat-label">待处理</div>
        <div class="stat-value">{{ pendingCount }}</div>
      </div>
      <div class="stat-card acknowledged">
        <div class="stat-label">已确认</div>
        <div class="stat-value">{{ acknowledgedCount }}</div>
      </div>
      <div class="stat-card resolved">
        <div class="stat-label">已解决</div>
        <div class="stat-value">{{ resolvedCount }}</div>
      </div>
      <div class="stat-card total">
        <div class="stat-label">总计(今日)</div>
        <div class="stat-value">{{ totalCount }}</div>
      </div>
    </div>

    <div class="alerts-container">
      <div class="alerts-header">
        <div class="tabs">
          <button
            v-for="tab in tabs"
            :key="tab.value"
            class="tab"
            :class="{ active: currentTab === tab.value }"
            @click="currentTab = tab.value"
          >
            {{ tab.label }}
            <span v-if="tab.count > 0" class="tab-count">{{ tab.count }}</span>
          </button>
        </div>
        <div class="filters">
          <select v-model="severityFilter" class="filter-select">
            <option value="">全部严重级别</option>
            <option value="critical">严重</option>
            <option value="high">高</option>
            <option value="medium">中</option>
            <option value="low">低</option>
          </select>
          <select v-model="typeFilter" class="filter-select">
            <option value="">全部类型</option>
            <option value="no_helmet">未佩戴安全帽</option>
            <option value="no_vest">未穿反光衣</option>
            <option value="fall">摔倒检测</option>
            <option value="climb">攀爬行为</option>
            <option value="intrusion">区域入侵</option>
          </select>
        </div>
      </div>

      <div class="alerts-list">
        <div
          v-for="alert in filteredAlerts"
          :key="alert.id"
          class="alert-card"
          :class="alert.severity"
        >
          <div class="alert-indicator" :class="alert.severity"></div>
          <div class="alert-main">
            <div class="alert-header-row">
              <div class="alert-badges">
                <span class="severity-badge" :class="alert.severity">
                  {{ getSeverityLabel(alert.severity) }}
                </span>
                <span class="type-badge">
                  {{ getTypeLabel(alert.alert_type) }}
                </span>
              </div>
              <div class="alert-time">{{ formatTime(alert.created_at) }}</div>
            </div>

            <div class="alert-description">{{ alert.description }}</div>

            <div class="alert-meta-row">
              <div class="meta-items">
                <div class="meta-item">
                  <svg viewBox="0 0 24 24" width="14" height="14">
                    <path fill="currentColor" d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/>
                  </svg>
                  <span>{{ alert.location }}</span>
                </div>
                <div class="meta-item">
                  <svg viewBox="0 0 24 24" width="14" height="14">
                    <path fill="currentColor" d="M17 10.5V7c0-.55-.45-1-1-1H4c-.55 0-1 .45-1 1v10c0 .55.45 1 1 1h12c.55 0 1-.45 1-1v-3.5l4 4v-11l-4 4z"/>
                  </svg>
                  <span>{{ alert.camera_id }}</span>
                </div>
              </div>

              <div class="alert-actions">
                <button
                  v-if="alert.status === 'pending'"
                  @click="acknowledgeAlert(alert.id)"
                  class="action-btn acknowledge"
                >
                  确认
                </button>
                <button
                  v-if="alert.status === 'pending' || alert.status === 'acknowledged'"
                  @click="resolveAlert(alert.id)"
                  class="action-btn resolve"
                >
                  解决
                </button>
                <button class="action-btn details" @click="viewAlertDetails(alert)">详情</button>
              </div>
            </div>

            <div v-if="alert.status === 'resolved'" class="resolved-info">
              <svg viewBox="0 0 24 24" width="16" height="16">
                <path fill="currentColor" d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
              </svg>
              <span>已于 {{ formatTime(alert.resolved_at || '') }} 处理 ({{ alert.resolved_by || 'System' }})</span>
            </div>
          </div>
        </div>

        <div v-if="filteredAlerts.length === 0" class="empty-state">
          <svg viewBox="0 0 24 24" width="48" height="48">
            <path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l6.59-6.59L18 9l-8 8z"/>
          </svg>
          <p>暂无告警信息</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useSystemStore } from '../stores/system'

const systemStore = useSystemStore()
const router = useRouter()

const currentTab = ref('pending')
const severityFilter = ref('')
const typeFilter = ref('')

const alerts = computed(() => systemStore.alerts)

const tabs = computed(() => [
  { label: '待处理', value: 'pending', count: pendingCount.value },
  { label: '已确认', value: 'acknowledged', count: acknowledgedCount.value },
  { label: '已解决', value: 'resolved', count: resolvedCount.value },
  { label: '全部', value: 'all', count: 0 }
])

const pendingCount = computed(() =>
  alerts.value.filter(a => a.status === 'pending').length
)

const acknowledgedCount = computed(() =>
  alerts.value.filter(a => a.status === 'acknowledged').length
)

const resolvedCount = computed(() =>
  alerts.value.filter(a => a.status === 'resolved').length
)

const totalCount = computed(() => alerts.value.length)

const filteredAlerts = computed(() => {
  let filtered = alerts.value

  if (currentTab.value !== 'all') {
    filtered = filtered.filter(a => a.status === currentTab.value)
  }

  if (severityFilter.value) {
    filtered = filtered.filter(a => a.severity === severityFilter.value)
  }

  if (typeFilter.value) {
    filtered = filtered.filter(a => a.alert_type === typeFilter.value)
  }

  return filtered
})

const getSeverityLabel = (severity: string) => {
  const labels: Record<string, string> = {
    critical: '严重',
    high: '高',
    medium: '中',
    low: '低'
  }
  return labels[severity] || severity
}

const getTypeLabel = (type: string) => {
  const labels: Record<string, string> = {
    cross_line: '横越线路违规',
    intrusion: '侵入邻线',
    no_helmet: '未佩戴防护帽',
    unsafe_distance: '安全距离不足',
    three_simultaneous: '未执行三同时'
  }
  return labels[type] || type
}

const formatTime = (timestamp: string) => {
  if (!timestamp) return ''
  const date = new Date(timestamp)
  const now = new Date()
  const diff = now.getTime() - date.getTime()
  const minutes = Math.floor(diff / 60000)

  if (minutes < 1) return '刚刚'
  if (minutes < 60) return `${minutes}分钟前`
  if (minutes < 1440) return `${Math.floor(minutes / 60)}小时前`
  return date.toLocaleString('zh-CN')
}

const acknowledgeAlert = (id: string) => {
  systemStore.updateAlertStatus(id, 'acknowledged')
}

const resolveAlert = (id: string) => {
  systemStore.updateAlertStatus(id, 'resolved')
}

const viewAlertDetails = (alert: any) => {
  const typeRouteMap: Record<string, string> = {
    cross_line: '/compliance',
    intrusion: '/compliance',
    no_helmet: '/compliance',
    unsafe_distance: '/compliance',
    three_simultaneous: '/compliance',
    no_vest: '/compliance',
    fall: '/compliance',
    climb: '/compliance'
  }

  const targetRoute = typeRouteMap[alert.alert_type] || '/compliance'
  router.push(targetRoute)
}
</script>

<style scoped>
.alert-management {
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

.stat-card {
  background: white;
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  border-left: 4px solid;
}

.stat-card.pending {
  border-left-color: #ef4444;
}

.stat-card.acknowledged {
  border-left-color: #f59e0b;
}

.stat-card.resolved {
  border-left-color: #10b981;
}

.stat-card.total {
  border-left-color: #3b82f6;
}

.stat-label {
  font-size: 13px;
  color: #6b7280;
  margin-bottom: 8px;
}

.stat-value {
  font-size: 32px;
  font-weight: 700;
  color: #111827;
}

.alerts-container {
  background: white;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.alerts-header {
  padding: 24px 24px 0;
  border-bottom: 1px solid #e5e7eb;
}

.tabs {
  display: flex;
  gap: 8px;
  margin-bottom: 16px;
}

.tab {
  padding: 10px 20px;
  background: transparent;
  border: none;
  border-bottom: 3px solid transparent;
  font-size: 14px;
  font-weight: 600;
  color: #6b7280;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  gap: 8px;
}

.tab:hover {
  color: #111827;
}

.tab.active {
  color: #3b82f6;
  border-bottom-color: #3b82f6;
}

.tab-count {
  padding: 2px 8px;
  background: #e5e7eb;
  border-radius: 10px;
  font-size: 11px;
  font-weight: 700;
}

.tab.active .tab-count {
  background: #3b82f6;
  color: white;
}

.filters {
  display: flex;
  gap: 12px;
  padding-bottom: 16px;
}

.filter-select {
  padding: 8px 16px;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  font-size: 13px;
  color: #374151;
  background: white;
  cursor: pointer;
}

.alerts-list {
  padding: 24px;
  display: flex;
  flex-direction: column;
  gap: 16px;
  max-height: calc(100vh - 400px);
  overflow-y: auto;
}

.alert-card {
  display: flex;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  transition: all 0.2s;
}

.alert-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.alert-indicator {
  width: 6px;
  flex-shrink: 0;
}

.alert-indicator.critical {
  background: linear-gradient(180deg, #ef4444 0%, #dc2626 100%);
}

.alert-indicator.high {
  background: linear-gradient(180deg, #f97316 0%, #ea580c 100%);
}

.alert-indicator.medium {
  background: linear-gradient(180deg, #f59e0b 0%, #d97706 100%);
}

.alert-indicator.low {
  background: linear-gradient(180deg, #10b981 0%, #059669 100%);
}

.alert-main {
  flex: 1;
  padding: 16px 20px;
  background: white;
}

.alert-header-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.alert-badges {
  display: flex;
  gap: 8px;
}

.severity-badge,
.type-badge {
  padding: 4px 10px;
  border-radius: 4px;
  font-size: 11px;
  font-weight: 700;
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

.severity-badge.low {
  background: #d1fae5;
  color: #065f46;
}

.type-badge {
  background: #f3f4f6;
  color: #374151;
}

.alert-time {
  font-size: 12px;
  color: #9ca3af;
}

.alert-description {
  font-size: 14px;
  color: #374151;
  margin-bottom: 12px;
  line-height: 1.5;
}

.alert-meta-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.meta-items {
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

.alert-actions {
  display: flex;
  gap: 8px;
}

.action-btn {
  padding: 6px 14px;
  border: none;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.action-btn.acknowledge {
  background: #fef3c7;
  color: #92400e;
}

.action-btn.acknowledge:hover {
  background: #fde68a;
}

.action-btn.resolve {
  background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
  color: white;
}

.action-btn.resolve:hover {
  box-shadow: 0 2px 8px rgba(59, 130, 246, 0.3);
}

.action-btn.details {
  background: #f3f4f6;
  color: #374151;
}

.action-btn.details:hover {
  background: #e5e7eb;
}

.resolved-info {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 12px;
  padding: 10px 14px;
  background: #d1fae5;
  border-radius: 6px;
  font-size: 12px;
  color: #065f46;
}

.resolved-info svg {
  flex-shrink: 0;
}

.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: #9ca3af;
}

.empty-state svg {
  margin-bottom: 16px;
  opacity: 0.5;
}

.empty-state p {
  font-size: 14px;
  margin: 0;
}
</style>
