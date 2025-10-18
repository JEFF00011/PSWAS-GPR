import { defineStore } from 'pinia'
import { ref } from 'vue'

export interface Alert {
  id: string
  personnel_id?: string
  alert_type: string
  severity: 'low' | 'medium' | 'high' | 'critical'
  camera_id: string
  location: string
  description: string
  image_url: string
  status: 'pending' | 'acknowledged' | 'resolved'
  created_at: string
  resolved_at?: string
  resolved_by?: string
}

export interface VideoStream {
  id: string
  camera_id: string
  name: string
  location: string
  status: 'online' | 'offline' | 'maintenance'
  enabled_features: {
    gait: boolean
    face: boolean
    action: boolean
  }
}

export interface SystemStats {
  total_recognitions: number
  gait_recognitions: number
  face_recognitions: number
  total_alerts: number
  critical_alerts: number
  average_response_time: number
}

export const useSystemStore = defineStore('system', () => {
  const currentView = ref('dashboard')
  const alerts = ref<Alert[]>([])
  const videoStreams = ref<VideoStream[]>([])
  const systemStats = ref<SystemStats>({
    total_recognitions: 0,
    gait_recognitions: 0,
    face_recognitions: 0,
    total_alerts: 0,
    critical_alerts: 0,
    average_response_time: 0
  })

  const setCurrentView = (view: string) => {
    currentView.value = view
  }

  const addAlert = (alert: Alert) => {
    alerts.value.unshift(alert)
  }

  const updateAlertStatus = (id: string, status: Alert['status']) => {
    const alert = alerts.value.find(a => a.id === id)
    if (alert) {
      alert.status = status
      if (status === 'resolved') {
        alert.resolved_at = new Date().toISOString()
        alert.resolved_by = 'SYS-ADMIN'
      }
    }
  }

  const updateSystemStats = (stats: Partial<SystemStats>) => {
    systemStats.value = { ...systemStats.value, ...stats }
  }

  return {
    currentView,
    alerts,
    videoStreams,
    systemStats,
    setCurrentView,
    addAlert,
    updateAlertStatus,
    updateSystemStats
  }
})
