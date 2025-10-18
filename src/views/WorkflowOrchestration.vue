<template>
  <div class="workflow-orchestration">
    <div class="page-header">
      <div class="header-content">
        <div>
          <h1>工作流可视化编排</h1>
          <p>步态识别 → 人脸识别 → 合规检测 智能编排</p>
        </div>
        <div class="header-actions">
          <button class="btn-secondary" @click="clearWorkflow">
            <svg viewBox="0 0 24 24" width="18" height="18">
              <path fill="currentColor" d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
            </svg>
            清空画布
          </button>
          <button class="btn-secondary" @click="saveTemplate">
            <svg viewBox="0 0 24 24" width="18" height="18">
              <path fill="currentColor" d="M17 3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V7l-4-4zm-5 16c-1.66 0-3-1.34-3-3s1.34-3 3-3 3 1.34 3 3-1.34 3-3 3zm3-10H5V5h10v4z"/>
            </svg>
            保存工作流
          </button>
          <button class="btn-primary" @click="executeWorkflow" :disabled="canvasNodes.length === 0">
            <svg viewBox="0 0 24 24" width="18" height="18">
              <path fill="currentColor" d="M8 5v14l11-7z"/>
            </svg>
            执行工作流
          </button>
        </div>
      </div>
    </div>

    <div class="main-layout">
      <div class="left-sidebar">
        <div class="palette-section">
          <h3>
            <svg viewBox="0 0 24 24" width="18" height="18">
              <path fill="currentColor" d="M12 2l-5.5 9h11L12 2zm0 3.84L13.93 9h-3.87L12 5.84zM17.5 13c-2.49 0-4.5 2.01-4.5 4.5s2.01 4.5 4.5 4.5 4.5-2.01 4.5-4.5-2.01-4.5-4.5-4.5zm0 7c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5zM3 21.5h8v-8H3v8zm2-6h4v4H5v-4z"/>
            </svg>
            节点组件
          </h3>
          <div class="node-palette">
            <div
              v-for="node in nodeTypes"
              :key="node.type"
              class="palette-node"
              :class="node.category"
              draggable="true"
              @dragstart="onDragStart($event, node)"
            >
              <div class="node-icon">
                <svg viewBox="0 0 24 24" width="20" height="20">
                  <path fill="currentColor" :d="node.icon"/>
                </svg>
              </div>
              <div class="node-info">
                <div class="node-name">{{ node.name }}</div>
                <div class="node-desc">{{ node.description }}</div>
              </div>
            </div>
          </div>
        </div>

        <div class="stats-section">
          <h3>
            <svg viewBox="0 0 24 24" width="18" height="18">
              <path fill="currentColor" d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
            </svg>
            执行统计
          </h3>
          <div class="stats-list">
            <div class="stat-item">
              <span class="stat-label">检车员识别</span>
              <span class="stat-value">{{ stats.gaitRecognitions }}</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">身份验证</span>
              <span class="stat-value">{{ stats.faceRecognitions }}</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">合规检测</span>
              <span class="stat-value">{{ stats.complianceChecks }}</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">告警触发</span>
              <span class="stat-value">{{ stats.alerts }}</span>
            </div>
          </div>
        </div>
      </div>

      <div class="canvas-area">
        <div class="canvas-toolbar">
          <div class="toolbar-left">
            <span class="canvas-title">工作流画布</span>
            <span class="node-count">{{ canvasNodes.length }} 个节点</span>
          </div>
          <div class="toolbar-right">
            <button class="tool-btn" @click="zoomIn" title="放大">
              <svg viewBox="0 0 24 24" width="18" height="18">
                <path fill="currentColor" d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
              </svg>
            </button>
            <button class="tool-btn" @click="zoomOut" title="缩小">
              <svg viewBox="0 0 24 24" width="18" height="18">
                <path fill="currentColor" d="M19 13H5v-2h14v2z"/>
              </svg>
            </button>
            <button class="tool-btn" @click="resetView" title="重置视图">
              <svg viewBox="0 0 24 24" width="18" height="18">
                <path fill="currentColor" d="M12 5V1L7 6l5 5V7c3.31 0 6 2.69 6 6s-2.69 6-6 6-6-2.69-6-6H4c0 4.42 3.58 8 8 8s8-3.58 8-8-3.58-8-8-8z"/>
              </svg>
            </button>
          </div>
        </div>

        <div
          class="workflow-canvas"
          @drop="onDrop"
          @dragover.prevent
          @dragenter.prevent
          :style="{ transform: `scale(${zoomLevel})` }"
        >
          <div class="canvas-grid"></div>
          <div class="canvas-hint" v-if="canvasNodes.length === 0">
            <svg viewBox="0 0 24 24" width="48" height="48">
              <path fill="currentColor" d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
            </svg>
            <p>从左侧拖拽节点到画布开始编排工作流</p>
          </div>

          <svg class="connections-layer" v-if="canvasNodes.length > 1">
            <defs>
              <marker id="arrowhead" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
                <polygon points="0 0, 10 3, 0 6" fill="#3b82f6" />
              </marker>
            </defs>
            <path
              v-for="(connection, index) in connections"
              :key="index"
              :d="connection.path"
              stroke="#3b82f6"
              stroke-width="2"
              fill="none"
              marker-end="url(#arrowhead)"
            />
          </svg>

          <div
            v-for="(node, index) in canvasNodes"
            :key="node.id"
            class="canvas-node"
            :class="[node.category, { active: node.isActive, executing: node.isExecuting }]"
            :style="{ left: node.x + 'px', top: node.y + 'px' }"
            draggable="true"
            @dragstart="onNodeDragStart($event, node)"
            @dragend="onNodeDragEnd"
          >
            <div class="node-header">
              <div class="node-header-icon">
                <svg viewBox="0 0 24 24" width="20" height="20">
                  <path fill="currentColor" :d="node.icon"/>
                </svg>
              </div>
              <div class="node-header-title">{{ node.name }}</div>
              <button class="node-delete" @click="removeNode(node.id)" title="删除节点">
                <svg viewBox="0 0 24 24" width="16" height="16">
                  <path fill="currentColor" d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
                </svg>
              </button>
            </div>
            <div class="node-body">
              <div class="node-description">{{ node.description }}</div>
              <div class="node-params" v-if="node.params">
                <div class="param-item" v-for="(value, key) in node.params" :key="key">
                  <span class="param-key">{{ key }}:</span>
                  <span class="param-value">{{ value }}</span>
                </div>
              </div>
            </div>
            <div class="node-footer">
              <span class="node-index">节点 {{ index + 1 }}</span>
              <span class="node-status" v-if="node.status">{{ node.status }}</span>
            </div>
            <div class="node-ports">
              <div class="port input" v-if="index > 0"></div>
              <div class="port output" v-if="index < canvasNodes.length - 1"></div>
            </div>
          </div>
        </div>
      </div>

      <div class="right-sidebar">
        <div class="execution-panel">
          <h3>
            <svg viewBox="0 0 24 24" width="18" height="18">
              <path fill="currentColor" d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm.5-13H11v6l5.25 3.15.75-1.23-4.5-2.67z"/>
            </svg>
            执行日志
          </h3>
          <div class="execution-logs">
            <div
              v-for="log in executionLogs"
              :key="log.id"
              class="log-entry"
              :class="log.type"
            >
              <span class="log-time">{{ log.time }}</span>
              <span class="log-message">{{ log.message }}</span>
            </div>
            <div class="log-empty" v-if="executionLogs.length === 0">
              暂无执行日志
            </div>
          </div>
        </div>

        <div class="templates-panel">
          <h3>
            <svg viewBox="0 0 24 24" width="18" height="18">
              <path fill="currentColor" d="M4 6H2v14c0 1.1.9 2 2 2h14v-2H4V6zm16-4H8c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-1 9H9V9h10v2zm-4 4H9v-2h6v2zm4-8H9V5h10v2z"/>
            </svg>
            常用模板
          </h3>
          <div class="template-list">
            <div
              v-for="template in templates"
              :key="template.id"
              class="template-item"
              @click="loadTemplate(template)"
            >
              <div class="template-name">{{ template.name }}</div>
              <div class="template-desc">{{ template.description }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

interface NodeType {
  type: string
  name: string
  description: string
  category: 'input' | 'process' | 'decision' | 'output'
  icon: string
  params?: Record<string, any>
}

interface CanvasNode extends NodeType {
  id: string
  x: number
  y: number
  isActive: boolean
  isExecuting: boolean
  status?: string
}

interface Connection {
  from: string
  to: string
  path: string
}

interface ExecutionLog {
  id: number
  time: string
  message: string
  type: 'success' | 'warning' | 'error' | 'info'
}

interface Template {
  id: string
  name: string
  description: string
  nodes: NodeType[]
}

const nodeTypes = ref<NodeType[]>([
  {
    type: 'video_input',
    name: '视频流输入',
    description: '从监控摄像头获取视频流',
    category: 'input',
    icon: 'M17 10.5V7c0-.55-.45-1-1-1H4c-.55 0-1 .45-1 1v10c0 .55.45 1 1 1h12c.55 0 1-.45 1-1v-3.5l4 4v-11l-4 4z',
    params: { 摄像头: 'CAM-001', 帧率: '25fps' }
  },
  {
    type: 'gait_recognition',
    name: '步态识别',
    description: '检车员步态特征提取与识别',
    category: 'process',
    icon: 'M13.5 5.5c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zM9.8 8.9L7 23h2.1l1.8-8 2.1 2v6h2v-7.5l-2.1-2 .6-3C14.8 12 16.8 13 19 13v-2c-1.9 0-3.5-1-4.3-2.4l-1-1.6c-.4-.6-1-1-1.7-1-.3 0-.5.1-.8.1L6 8.3V13h2V9.6l1.8-.7',
    params: { 算法: 'GaitNet', 阈值: '0.85' }
  },
  {
    type: 'face_recognition',
    name: '人脸识别',
    description: '检车员人脸特征匹配验证',
    category: 'process',
    icon: 'M9 11.75c-.69 0-1.25.56-1.25 1.25s.56 1.25 1.25 1.25 1.25-.56 1.25-1.25-.56-1.25-1.25-1.25zm6 0c-.69 0-1.25.56-1.25 1.25s.56 1.25 1.25 1.25 1.25-.56 1.25-1.25-.56-1.25-1.25-1.25zM12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8 0-.29.02-.58.05-.86 2.36-1.05 4.23-2.98 5.21-5.37C11.07 8.33 14.05 10 17.42 10c.78 0 1.53-.09 2.25-.26.21.71.33 1.47.33 2.26 0 4.41-3.59 8-8 8z',
    params: { 算法: 'FaceNet', 阈值: '0.95' }
  },
  {
    type: 'identity_verify',
    name: '身份核验',
    description: '多模态身份融合验证',
    category: 'decision',
    icon: 'M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4z',
    params: { 融合策略: '加权平均' }
  },
  {
    type: 'compliance_check',
    name: '合规检测',
    description: '作业行为合规性分析',
    category: 'process',
    icon: 'M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z',
    params: { 检测项: '5项', 置信度: '0.90' }
  },
  {
    type: 'violation_detect',
    name: '违规判定',
    description: '识别违规行为并分类',
    category: 'decision',
    icon: 'M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z',
    params: { 严重级别: '高/中/低' }
  },
  {
    type: 'alert_trigger',
    name: '告警触发',
    description: '生成并推送安全告警',
    category: 'output',
    icon: 'M12 22c1.1 0 2-.9 2-2h-4c0 1.1.89 2 2 2zm6-6v-5c0-3.07-1.64-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.63 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2z',
    params: { 推送方式: '短信+邮件' }
  },
  {
    type: 'data_storage',
    name: '数据存储',
    description: '保存识别结果和日志',
    category: 'output',
    icon: 'M19.35 10.04C18.67 6.59 15.64 4 12 4 9.11 4 6.6 5.64 5.35 8.04 2.34 8.36 0 10.91 0 14c0 3.31 2.69 6 6 6h13c2.76 0 5-2.24 5-5 0-2.64-2.05-4.78-4.65-4.96z',
    params: { 数据库: 'Supabase' }
  }
])

const canvasNodes = ref<CanvasNode[]>([])
const draggedNode = ref<NodeType | null>(null)
const draggedCanvasNode = ref<CanvasNode | null>(null)
const zoomLevel = ref(1)

const stats = ref({
  gaitRecognitions: 52,
  faceRecognitions: 35,
  complianceChecks: 87,
  alerts: 5
})

const executionLogs = ref<ExecutionLog[]>([
  { id: 1, time: '14:23:45', message: '工作流开始执行', type: 'info' },
  { id: 2, time: '14:23:46', message: '视频流输入节点就绪', type: 'success' },
  { id: 3, time: '14:23:47', message: '检车员识别节点执行成功', type: 'success' },
  { id: 4, time: '14:23:48', message: '身份验证节点执行成功', type: 'success' },
  { id: 5, time: '14:23:49', message: '合规检测发现异常', type: 'warning' },
  { id: 6, time: '14:23:50', message: '安全告警已触发并发送', type: 'info' }
])

const templates = ref<Template[]>([
  {
    id: '1',
    name: '标准检测流程',
    description: '视频输入 → 步态识别 → 人脸识别 → 合规检测 → 告警',
    nodes: []
  },
  {
    id: '2',
    name: '快速身份验证',
    description: '视频输入 → 人脸识别 → 身份核验 → 数据存储',
    nodes: []
  },
  {
    id: '3',
    name: '重点监控模式',
    description: '视频输入 → 步态识别 → 违规判定 → 告警触发',
    nodes: []
  }
])

const connections = computed(() => {
  const conns: Connection[] = []
  for (let i = 0; i < canvasNodes.value.length - 1; i++) {
    const from = canvasNodes.value[i]
    const to = canvasNodes.value[i + 1]
    const path = `M ${from.x + 150} ${from.y + 60} L ${to.x} ${to.y + 60}`
    conns.push({ from: from.id, to: to.id, path })
  }
  return conns
})

const onDragStart = (event: DragEvent, node: NodeType) => {
  draggedNode.value = node
  if (event.dataTransfer) {
    event.dataTransfer.effectAllowed = 'copy'
  }
}

const onDrop = (event: DragEvent) => {
  event.preventDefault()
  if (!draggedNode.value) return

  const canvas = event.currentTarget as HTMLElement
  const rect = canvas.getBoundingClientRect()
  const x = (event.clientX - rect.left) / zoomLevel.value - 75
  const y = (event.clientY - rect.top) / zoomLevel.value - 60

  const newNode: CanvasNode = {
    ...draggedNode.value,
    id: Date.now().toString(),
    x,
    y,
    isActive: false,
    isExecuting: false
  }

  canvasNodes.value.push(newNode)
  draggedNode.value = null
}

const onNodeDragStart = (_event: DragEvent, node: CanvasNode) => {
  draggedCanvasNode.value = node
}

const onNodeDragEnd = (event: DragEvent) => {
  if (!draggedCanvasNode.value) return

  const canvas = document.querySelector('.workflow-canvas') as HTMLElement
  const rect = canvas.getBoundingClientRect()
  const x = (event.clientX - rect.left) / zoomLevel.value - 75
  const y = (event.clientY - rect.top) / zoomLevel.value - 60

  draggedCanvasNode.value.x = Math.max(0, x)
  draggedCanvasNode.value.y = Math.max(0, y)
  draggedCanvasNode.value = null
}

const removeNode = (id: string) => {
  const index = canvasNodes.value.findIndex(n => n.id === id)
  if (index > -1) {
    canvasNodes.value.splice(index, 1)
  }
}

const clearWorkflow = () => {
  if (confirm('确定要清空画布吗？')) {
    canvasNodes.value = []
  }
}

const zoomIn = () => {
  zoomLevel.value = Math.min(zoomLevel.value + 0.1, 2)
}

const zoomOut = () => {
  zoomLevel.value = Math.max(zoomLevel.value - 0.1, 0.5)
}

const resetView = () => {
  zoomLevel.value = 1
}

const executeWorkflow = () => {
  if (canvasNodes.value.length === 0) return

  const timestamp = new Date().toLocaleTimeString('zh-CN', { hour12: false })
  executionLogs.value.unshift({
    id: Date.now(),
    time: timestamp,
    message: `开始执行工作流（${canvasNodes.value.length}个节点）`,
    type: 'info'
  })

  canvasNodes.value.forEach((node, index) => {
    setTimeout(() => {
      node.isExecuting = true
      node.status = '执行中'

      setTimeout(() => {
        node.isExecuting = false
        node.status = '已完成'
        const time = new Date().toLocaleTimeString('zh-CN', { hour12: false })
        executionLogs.value.unshift({
          id: Date.now() + index,
          time,
          message: `${node.name} 执行完成`,
          type: 'success'
        })

        if (index === canvasNodes.value.length - 1) {
          const finalTime = new Date().toLocaleTimeString('zh-CN', { hour12: false })
          executionLogs.value.unshift({
            id: Date.now() + 1000,
            time: finalTime,
            message: '工作流执行完成',
            type: 'info'
          })
        }
      }, 1000)
    }, index * 1200)
  })
}

const saveTemplate = () => {
  if (canvasNodes.value.length === 0) {
    alert('画布为空，无法保存')
    return
  }
  alert(`工作流已保存（${canvasNodes.value.length}个节点）`)
}

const loadTemplate = (template: Template) => {
  alert(`加载模板：${template.name}`)
}
</script>

<style scoped>
.workflow-orchestration {
  padding: 24px;
  background: #f9fafb;
  min-height: calc(100vh - 72px);
}

.page-header {
  margin-bottom: 24px;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.page-header h1 {
  margin: 0 0 4px 0;
  font-size: 28px;
  font-weight: 600;
  color: #111827;
}

.page-header p {
  margin: 0;
  color: #6b7280;
  font-size: 14px;
}

.header-actions {
  display: flex;
  gap: 12px;
}

.btn-primary, .btn-secondary {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 20px;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-primary {
  background: #3b82f6;
  color: white;
}

.btn-primary:hover:not(:disabled) {
  background: #2563eb;
}

.btn-primary:disabled {
  background: #9ca3af;
  cursor: not-allowed;
}

.btn-secondary {
  background: white;
  color: #374151;
  border: 1px solid #e5e7eb;
}

.btn-secondary:hover {
  background: #f9fafb;
}

.main-layout {
  display: grid;
  grid-template-columns: 280px 1fr 320px;
  gap: 20px;
  height: calc(100vh - 200px);
}

.left-sidebar, .right-sidebar {
  background: white;
  border-radius: 12px;
  padding: 20px;
  overflow-y: auto;
}

.palette-section h3, .stats-section h3, .execution-panel h3, .templates-panel h3 {
  display: flex;
  align-items: center;
  gap: 8px;
  margin: 0 0 16px 0;
  font-size: 16px;
  font-weight: 600;
  color: #111827;
}

.palette-section {
  margin-bottom: 24px;
}

.node-palette {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.palette-node {
  display: flex;
  gap: 12px;
  padding: 12px;
  background: #f9fafb;
  border: 2px solid #e5e7eb;
  border-radius: 8px;
  cursor: grab;
  transition: all 0.2s;
}

.palette-node:hover {
  border-color: #3b82f6;
  background: #eff6ff;
  transform: translateY(-2px);
}

.palette-node:active {
  cursor: grabbing;
}

.palette-node.input { border-left: 4px solid #10b981; }
.palette-node.process { border-left: 4px solid #3b82f6; }
.palette-node.decision { border-left: 4px solid #f59e0b; }
.palette-node.output { border-left: 4px solid #8b5cf6; }

.node-icon {
  flex-shrink: 0;
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: white;
  border-radius: 8px;
}

.node-info {
  flex: 1;
  min-width: 0;
}

.node-name {
  font-size: 14px;
  font-weight: 600;
  color: #111827;
  margin-bottom: 4px;
}

.node-desc {
  font-size: 12px;
  color: #6b7280;
  line-height: 1.4;
}

.stats-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.stat-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px;
  background: #f9fafb;
  border-radius: 8px;
}

.stat-label {
  font-size: 14px;
  color: #6b7280;
}

.stat-value {
  font-size: 18px;
  font-weight: 600;
  color: #111827;
}

.canvas-area {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.canvas-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  border-bottom: 1px solid #e5e7eb;
  background: #f9fafb;
}

.toolbar-left {
  display: flex;
  align-items: center;
  gap: 16px;
}

.canvas-title {
  font-size: 16px;
  font-weight: 600;
  color: #111827;
}

.node-count {
  font-size: 14px;
  color: #6b7280;
}

.toolbar-right {
  display: flex;
  gap: 8px;
}

.tool-btn {
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: white;
  border: 1px solid #e5e7eb;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s;
}

.tool-btn:hover {
  background: #f9fafb;
  border-color: #3b82f6;
}

.workflow-canvas {
  flex: 1;
  position: relative;
  overflow: auto;
  background: #fafafa;
  transform-origin: top left;
  transition: transform 0.2s;
}

.canvas-grid {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-image:
    linear-gradient(#e5e7eb 1px, transparent 1px),
    linear-gradient(90deg, #e5e7eb 1px, transparent 1px);
  background-size: 20px 20px;
  opacity: 0.5;
}

.canvas-hint {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  text-align: center;
  color: #9ca3af;
}

.canvas-hint svg {
  opacity: 0.3;
  margin-bottom: 16px;
}

.canvas-hint p {
  margin: 0;
  font-size: 14px;
}

.connections-layer {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
}

.canvas-node {
  position: absolute;
  width: 280px;
  background: white;
  border: 2px solid #e5e7eb;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  cursor: move;
  transition: all 0.2s;
}

.canvas-node:hover {
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
  z-index: 10;
}

.canvas-node.input { border-top: 4px solid #10b981; }
.canvas-node.process { border-top: 4px solid #3b82f6; }
.canvas-node.decision { border-top: 4px solid #f59e0b; }
.canvas-node.output { border-top: 4px solid #8b5cf6; }

.canvas-node.executing {
  animation: pulse 1.5s infinite;
  border-color: #3b82f6;
}

@keyframes pulse {
  0%, 100% { box-shadow: 0 0 0 0 rgba(59, 130, 246, 0.4); }
  50% { box-shadow: 0 0 0 10px rgba(59, 130, 246, 0); }
}

.node-header {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 16px;
  background: #f9fafb;
  border-bottom: 1px solid #e5e7eb;
  border-radius: 10px 10px 0 0;
}

.node-header-icon {
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: white;
  border-radius: 6px;
}

.node-header-title {
  flex: 1;
  font-size: 14px;
  font-weight: 600;
  color: #111827;
}

.node-delete {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: transparent;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  color: #6b7280;
  transition: all 0.2s;
}

.node-delete:hover {
  background: #fee2e2;
  color: #dc2626;
}

.node-body {
  padding: 16px;
}

.node-description {
  font-size: 13px;
  color: #6b7280;
  margin-bottom: 12px;
  line-height: 1.5;
}

.node-params {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.param-item {
  display: flex;
  gap: 8px;
  font-size: 12px;
  padding: 8px;
  background: #f9fafb;
  border-radius: 6px;
}

.param-key {
  color: #6b7280;
  font-weight: 500;
}

.param-value {
  color: #111827;
}

.node-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 16px;
  border-top: 1px solid #e5e7eb;
  background: #fafafa;
  border-radius: 0 0 10px 10px;
}

.node-index {
  font-size: 12px;
  color: #9ca3af;
}

.node-status {
  font-size: 12px;
  color: #10b981;
  font-weight: 500;
}

.node-ports {
  position: absolute;
}

.port {
  position: absolute;
  width: 12px;
  height: 12px;
  background: #3b82f6;
  border: 2px solid white;
  border-radius: 50%;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.port.input {
  left: -6px;
  top: 54px;
}

.port.output {
  right: -6px;
  top: 54px;
}

.execution-panel {
  margin-bottom: 24px;
}

.execution-logs {
  display: flex;
  flex-direction: column;
  gap: 8px;
  max-height: 300px;
  overflow-y: auto;
}

.log-entry {
  padding: 10px 12px;
  background: #f9fafb;
  border-left: 3px solid #e5e7eb;
  border-radius: 6px;
  font-size: 12px;
}

.log-entry.success { border-left-color: #10b981; }
.log-entry.warning { border-left-color: #f59e0b; }
.log-entry.error { border-left-color: #ef4444; }
.log-entry.info { border-left-color: #3b82f6; }

.log-time {
  color: #9ca3af;
  margin-right: 8px;
}

.log-message {
  color: #374151;
}

.log-empty {
  text-align: center;
  padding: 40px 20px;
  color: #9ca3af;
  font-size: 14px;
}

.template-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.template-item {
  padding: 12px;
  background: #f9fafb;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;
}

.template-item:hover {
  background: #eff6ff;
  border-color: #3b82f6;
}

.template-name {
  font-size: 14px;
  font-weight: 600;
  color: #111827;
  margin-bottom: 4px;
}

.template-desc {
  font-size: 12px;
  color: #6b7280;
  line-height: 1.4;
}
</style>
