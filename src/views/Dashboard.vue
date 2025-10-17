<template>
  <div class="dashboard">
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-icon recognitions">
          <svg viewBox="0 0 24 24" width="28" height="28">
            <path fill="currentColor" d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-label">今日识别总数</div>
          <div class="stat-value">{{ stats.total_recognitions.toLocaleString() }}</div>
          <div class="stat-trend positive">+12.5% 较昨日</div>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon gait">
          <svg viewBox="0 0 24 24" width="28" height="28">
            <path fill="currentColor" d="M13.5 5.5c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zM9.8 8.9L7 23h2.1l1.8-8 2.1 2v6h2v-7.5l-2.1-2 .6-3C14.8 12 16.8 13 19 13v-2c-1.9 0-3.5-1-4.3-2.4l-1-1.6c-.4-.6-1-1-1.7-1-.3 0-.5.1-.8.1L6 8.3V13h2V9.6l1.8-.7"/>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-label">步态识别</div>
          <div class="stat-value">{{ stats.gait_recognitions.toLocaleString() }}</div>
          <div class="stat-trend positive">+8.3% 较昨日</div>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon face">
          <svg viewBox="0 0 24 24" width="28" height="28">
            <path fill="currentColor" d="M9 11.75c-.69 0-1.25.56-1.25 1.25s.56 1.25 1.25 1.25 1.25-.56 1.25-1.25-.56-1.25-1.25-1.25zm6 0c-.69 0-1.25.56-1.25 1.25s.56 1.25 1.25 1.25 1.25-.56 1.25-1.25-.56-1.25-1.25-1.25zM12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8 0-.29.02-.58.05-.86 2.36-1.05 4.23-2.98 5.21-5.37C11.07 8.33 14.05 10 17.42 10c.78 0 1.53-.09 2.25-.26.21.71.33 1.47.33 2.26 0 4.41-3.59 8-8 8z"/>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-label">人脸识别</div>
          <div class="stat-value">{{ stats.face_recognitions.toLocaleString() }}</div>
          <div class="stat-trend positive">+15.2% 较昨日</div>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon alerts">
          <svg viewBox="0 0 24 24" width="28" height="28">
            <path fill="currentColor" d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-label">今日告警</div>
          <div class="stat-value">{{ stats.total_alerts.toLocaleString() }}</div>
          <div class="stat-trend negative">+5.7% 较昨日</div>
        </div>
      </div>
    </div>

    <div class="content-grid">
      <div class="video-section">
        <div class="section-header">
          <h2>实时视频流</h2>
          <button class="add-btn" @click="addCamera">+ 添加监控点</button>
        </div>
        <div class="video-grid">
          <div
            v-for="stream in videoStreams"
            :key="stream.id"
            class="video-card"
          >
            <div class="video-frame">
              <div class="video-placeholder">
                <svg viewBox="0 0 24 24" width="48" height="48">
                  <path fill="currentColor" d="M17 10.5V7c0-.55-.45-1-1-1H4c-.55 0-1 .45-1 1v10c0 .55.45 1 1 1h12c.55 0 1-.45 1-1v-3.5l4 4v-11l-4 4z"/>
                </svg>
              </div>
              <div class="video-status" :class="stream.status">
                {{ stream.status === 'online' ? '在线' : '离线' }}
              </div>
              <div class="video-features">
                <span v-if="stream.enabled_features.gait" class="feature-badge">步态</span>
                <span v-if="stream.enabled_features.face" class="feature-badge">人脸</span>
                <span v-if="stream.enabled_features.action" class="feature-badge">动作</span>
              </div>
            </div>
            <div class="video-info">
              <div class="video-name">{{ stream.name }}</div>
              <div class="video-location">{{ stream.location }}</div>
            </div>
          </div>
        </div>
      </div>

      <div class="alerts-section">
        <div class="section-header">
          <h2>实时告警</h2>
          <router-link to="/alerts" class="view-all">查看全部 →</router-link>
        </div>
        <div class="alerts-list">
          <div
            v-for="alert in recentAlerts"
            :key="alert.id"
            class="alert-item"
            :class="alert.severity"
          >
            <div class="alert-icon">
              <svg viewBox="0 0 24 24" width="20" height="20">
                <path fill="currentColor" d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/>
              </svg>
            </div>
            <div class="alert-content">
              <div class="alert-header">
                <span class="alert-type">{{ getAlertTypeLabel(alert.alert_type) }}</span>
                <span class="alert-time">{{ formatTime(alert.created_at) }}</span>
              </div>
              <div class="alert-location">{{ alert.location }}</div>
              <div class="alert-description">{{ alert.description }}</div>
            </div>
            <div class="alert-actions">
              <button
                v-if="alert.status === 'pending'"
                @click="acknowledgeAlert(alert.id)"
                class="action-btn"
              >
                确认
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { useSystemStore } from '../stores/system'

const systemStore = useSystemStore()

const stats = computed(() => systemStore.systemStats)
const videoStreams = computed(() => systemStore.videoStreams)
const recentAlerts = computed(() => systemStore.alerts.slice(0, 5))

const getAlertTypeLabel = (type: string) => {
  const labels: Record<string, string> = {
    no_helmet: '未佩戴安全帽',
    no_vest: '未穿反光衣',
    fall: '摔倒检测',
    climb: '攀爬行为',
    run: '奔跑检测',
    gather: '人员聚集',
    intrusion: '区域入侵'
  }
  return labels[type] || type
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

const acknowledgeAlert = (id: string) => {
  systemStore.updateAlertStatus(id, 'acknowledged')
}

const addCamera = () => {
  const cameraCount = systemStore.videoStreams.length + 1
  const newCamera = {
    id: String(Date.now()),
    camera_id: `CAM-00${cameraCount}`,
    name: `监控点${cameraCount}`,
    location: '待配置',
    status: 'offline' as const,
    enabled_features: { gait: true, face: true, action: true }
  }
  systemStore.videoStreams.push(newCamera)
  alert(`已添加新监控点: ${newCamera.camera_id}`)
}

onMounted(() => {
  systemStore.updateSystemStats({
    total_recognitions: 15847,
    gait_recognitions: 6523,
    face_recognitions: 9324,
    total_alerts: 23,
    critical_alerts: 3,
    average_response_time: 245
  })

  systemStore.videoStreams = [
    {
      id: '1',
      camera_id: 'CAM-001',
      name: '主入口',
      location: '1号楼大厅',
      status: 'online',
      enabled_features: { gait: true, face: true, action: true }
    },
    {
      id: '2',
      camera_id: 'CAM-002',
      name: '东侧通道',
      location: '1号楼东侧',
      status: 'online',
      enabled_features: { gait: true, face: false, action: true }
    },
    {
      id: '3',
      camera_id: 'CAM-003',
      name: '生产车间',
      location: '2号楼车间A',
      status: 'online',
      enabled_features: { gait: false, face: true, action: true }
    },
    {
      id: '4',
      camera_id: 'CAM-004',
      name: '仓库区域',
      location: '3号楼仓库',
      status: 'online',
      enabled_features: { gait: true, face: true, action: true }
    }
  ]

  systemStore.alerts = [
    {
      id: '1',
      alert_type: 'no_helmet',
      severity: 'high',
      camera_id: 'CAM-003',
      location: '2号楼车间A',
      description: '检测到工作人员未佩戴安全帽',
      image_url: '',
      status: 'pending',
      created_at: new Date(Date.now() - 2 * 60000).toISOString()
    },
    {
      id: '2',
      alert_type: 'intrusion',
      severity: 'critical',
      camera_id: 'CAM-004',
      location: '3号楼仓库',
      description: '非授权人员进入限制区域',
      image_url: '',
      status: 'pending',
      created_at: new Date(Date.now() - 5 * 60000).toISOString()
    },
    {
      id: '3',
      alert_type: 'no_vest',
      severity: 'medium',
      camera_id: 'CAM-002',
      location: '1号楼东侧',
      description: '检测到人员未穿反光衣',
      image_url: '',
      status: 'pending',
      created_at: new Date(Date.now() - 15 * 60000).toISOString()
    }
  ]
})
</script>

<style scoped>
.dashboard {
  padding: 24px;
  background: #f9fafb;
  min-height: calc(100vh - 72px);
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
  margin-bottom: 24px;
}

.stat-card {
  background: white;
  border-radius: 12px;
  padding: 24px;
  display: flex;
  gap: 16px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  transition: all 0.3s;
}

.stat-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  transform: translateY(-2px);
}

.stat-icon {
  width: 56px;
  height: 56px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.stat-icon.recognitions {
  background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
  color: white;
}

.stat-icon.gait {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  color: white;
}

.stat-icon.face {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  color: white;
}

.stat-icon.alerts {
  background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
  color: white;
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
  margin-bottom: 4px;
}

.stat-trend {
  font-size: 12px;
  font-weight: 600;
}

.stat-trend.positive {
  color: #10b981;
}

.stat-trend.negative {
  color: #ef4444;
}

.content-grid {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 24px;
}

.video-section,
.alerts-section {
  background: white;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.section-header h2 {
  font-size: 18px;
  font-weight: 600;
  color: #111827;
  margin: 0;
}

.add-btn {
  padding: 8px 16px;
  background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.add-btn:hover {
  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
  transform: translateY(-1px);
}

.view-all {
  font-size: 13px;
  color: #3b82f6;
  text-decoration: none;
  font-weight: 500;
}

.view-all:hover {
  text-decoration: underline;
}

.video-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 16px;
}

.video-card {
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  overflow: hidden;
  transition: all 0.2s;
}

.video-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.video-frame {
  position: relative;
  background: #1f2937;
  aspect-ratio: 16 / 9;
  display: flex;
  align-items: center;
  justify-content: center;
}

.video-placeholder {
  color: #4b5563;
}

.video-status {
  position: absolute;
  top: 8px;
  right: 8px;
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 11px;
  font-weight: 600;
  text-transform: uppercase;
}

.video-status.online {
  background: #10b981;
  color: white;
}

.video-status.offline {
  background: #ef4444;
  color: white;
}

.video-features {
  position: absolute;
  bottom: 8px;
  left: 8px;
  display: flex;
  gap: 4px;
}

.feature-badge {
  padding: 3px 8px;
  background: rgba(0, 0, 0, 0.7);
  color: white;
  border-radius: 4px;
  font-size: 10px;
  font-weight: 600;
}

.video-info {
  padding: 12px;
}

.video-name {
  font-size: 14px;
  font-weight: 600;
  color: #111827;
  margin-bottom: 4px;
}

.video-location {
  font-size: 12px;
  color: #6b7280;
}

.alerts-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.alert-item {
  display: flex;
  gap: 12px;
  padding: 16px;
  border-left: 4px solid;
  border-radius: 8px;
  background: #f9fafb;
}

.alert-item.low {
  border-left-color: #10b981;
}

.alert-item.medium {
  border-left-color: #f59e0b;
}

.alert-item.high {
  border-left-color: #f97316;
}

.alert-item.critical {
  border-left-color: #ef4444;
}

.alert-icon {
  width: 36px;
  height: 36px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  background: white;
}

.alert-item.critical .alert-icon {
  color: #ef4444;
}

.alert-item.high .alert-icon {
  color: #f97316;
}

.alert-item.medium .alert-icon {
  color: #f59e0b;
}

.alert-content {
  flex: 1;
}

.alert-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 4px;
}

.alert-type {
  font-size: 14px;
  font-weight: 600;
  color: #111827;
}

.alert-time {
  font-size: 11px;
  color: #6b7280;
}

.alert-location {
  font-size: 12px;
  color: #6b7280;
  margin-bottom: 4px;
}

.alert-description {
  font-size: 13px;
  color: #4b5563;
}

.alert-actions {
  display: flex;
  align-items: center;
}

.action-btn {
  padding: 6px 12px;
  background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
  color: white;
  border: none;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.action-btn:hover {
  box-shadow: 0 2px 8px rgba(59, 130, 246, 0.3);
}

@media (max-width: 1200px) {
  .content-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .stats-grid {
    grid-template-columns: 1fr;
  }
}
</style>
