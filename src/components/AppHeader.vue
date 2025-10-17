<template>
  <header class="app-header">
    <div class="header-left">
      <div class="logo-section">
        <div class="logo-icon">
          <svg viewBox="0 0 24 24" width="32" height="32">
            <path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
          </svg>
        </div>
        <div class="logo-text">
          <h1>基于步态体态识别的人员作业安全预警系统</h1>
          <p>铁路装备慧眼识图战队</p>
        </div>
      </div>
    </div>

    <div class="header-center">
      <div class="status-indicators">
        <div class="status-item">
          <span class="status-dot online"></span>
          <span>在线摄像头: {{ onlineStreams }}</span>
        </div>
        <div class="status-item">
          <span class="status-dot" :class="alertLevel"></span>
          <span>实时告警: {{ pendingAlerts }}</span>
        </div>
      </div>
    </div>

    <div class="header-right">
      <div class="time-display">
        {{ currentTime }}
      </div>
      <div class="user-menu">
        <div class="user-avatar">
          <svg viewBox="0 0 24 24" width="24" height="24">
            <path fill="currentColor" d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
          </svg>
        </div>
        <span class="user-name">管理员</span>
      </div>
    </div>
  </header>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { useSystemStore } from '../stores/system'

const systemStore = useSystemStore()
const currentTime = ref('')

const onlineStreams = computed(() =>
  systemStore.videoStreams.filter(s => s.status === 'online').length
)

const pendingAlerts = computed(() =>
  systemStore.alerts.filter(a => a.status === 'pending').length
)

const alertLevel = computed(() => {
  const criticalCount = systemStore.alerts.filter(
    a => a.status === 'pending' && a.severity === 'critical'
  ).length
  if (criticalCount > 0) return 'critical'
  if (pendingAlerts.value > 0) return 'warning'
  return 'normal'
})

let timeInterval: number

const updateTime = () => {
  const now = new Date()
  currentTime.value = now.toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour12: false
  })
}

onMounted(() => {
  updateTime()
  timeInterval = setInterval(updateTime, 1000)
})

onUnmounted(() => {
  clearInterval(timeInterval)
})
</script>

<style scoped>
.app-header {
  height: 72px;
  background: white;
  color: #111827;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 32px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  border-bottom: 1px solid #e5e7eb;
  position: relative;
  z-index: 100;
}

.header-left {
  flex: 0 0 auto;
}

.logo-section {
  display: flex;
  align-items: center;
  gap: 12px;
}

.logo-icon {
  width: 40px;
  height: 40px;
  background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);
}

.logo-icon svg {
  color: white;
}

.logo-text h1 {
  font-size: 18px;
  font-weight: 600;
  margin: 0;
  line-height: 1.2;
  color: #111827;
}

.logo-text p {
  font-size: 11px;
  margin: 2px 0 0 0;
  color: #6b7280;
  font-weight: 400;
}

.header-center {
  flex: 1;
  display: flex;
  justify-content: center;
}

.status-indicators {
  display: flex;
  gap: 32px;
}

.status-item {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  color: #374151;
}

.status-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  animation: pulse 2s infinite;
}

.status-dot.online {
  background: #10b981;
  box-shadow: 0 0 8px rgba(16, 185, 129, 0.6);
}

.status-dot.warning {
  background: #f59e0b;
  box-shadow: 0 0 8px rgba(245, 158, 11, 0.6);
}

.status-dot.critical {
  background: #ef4444;
  box-shadow: 0 0 8px rgba(239, 68, 68, 0.6);
}

.status-dot.normal {
  background: #6b7280;
  box-shadow: 0 0 8px rgba(107, 114, 128, 0.6);
}

@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}

.header-right {
  flex: 0 0 auto;
  display: flex;
  align-items: center;
  gap: 24px;
}

.time-display {
  font-size: 14px;
  font-weight: 500;
  font-family: 'Monaco', 'Consolas', monospace;
  color: #374151;
}

.user-menu {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  background: #f9fafb;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;
}

.user-menu:hover {
  background: #f3f4f6;
}

.user-avatar {
  width: 32px;
  height: 32px;
  background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.user-name {
  font-size: 14px;
  font-weight: 500;
  color: #111827;
}
</style>
