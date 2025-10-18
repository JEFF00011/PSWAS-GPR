<template>
  <div class="workflow-orchestration">
    <div class="page-header">
      <div class="header-content">
        <div>
          <h1>工作流编排中心</h1>
          <p>智能识别全流程可视化编排与实时监控</p>
        </div>
        <div class="header-actions">
          <button class="btn-secondary" @click="showTemplates = !showTemplates">
            <svg viewBox="0 0 24 24" width="18" height="18">
              <path fill="currentColor" d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
            </svg>
            模板库
          </button>
          <button class="btn-secondary" @click="toggleExecution">
            <svg viewBox="0 0 24 24" width="18" height="18">
              <path fill="currentColor" d="M8 5v14l11-7z"/>
            </svg>
            {{ isExecuting ? '停止执行' : '开始执行' }}
          </button>
          <button class="btn-primary" @click="saveWorkflow">
            <svg viewBox="0 0 24 24" width="18" height="18">
              <path fill="currentColor" d="M17 3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V7l-4-4zm-5 16c-1.66 0-3-1.34-3-3s1.34-3 3-3 3 1.34 3 3-1.34 3-3 3zm3-10H5V5h10v4z"/>
            </svg>
            保存工作流
          </button>
        </div>
      </div>
    </div>

    <div class="main-layout">
      <div class="left-panel">
        <div class="stats-overview">
          <h3>
            <svg viewBox="0 0 24 24" width="18" height="18">
              <path fill="currentColor" d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
            </svg>
            实时统计
          </h3>
          <div class="stats-grid">
            <div class="stat-card">
              <div class="stat-icon gait">
                <svg viewBox="0 0 24 24" width="20" height="20">
                  <path fill="currentColor" d="M13.5 5.5c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zM9.8 8.9L7 23h2.1l1.8-8 2.1 2v6h2v-7.5l-2.1-2 .6-3C14.8 12 16.8 13 19 13v-2c-1.9 0-3.5-1-4.3-2.4l-1-1.6c-.4-.6-1-1-1.7-1-.3 0-.5.1-.8.1L6 8.3V13h2V9.6l1.8-.7"/>
                </svg>
              </div>
              <div class="stat-info">
                <div class="stat-value">{{ stats.gaitRecognitions }}</div>
                <div class="stat-label">步态识别</div>
              </div>
            </div>
            <div class="stat-card">
              <div class="stat-icon face">
                <svg viewBox="0 0 24 24" width="20" height="20">
                  <path fill="currentColor" d="M9 11.75c-.69 0-1.25.56-1.25 1.25s.56 1.25 1.25 1.25 1.25-.56 1.25-1.25-.56-1.25-1.25-1.25zm6 0c-.69 0-1.25.56-1.25 1.25s.56 1.25 1.25 1.25 1.25-.56 1.25-1.25-.56-1.25-1.25-1.25zM12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8 0-.29.02-.58.05-.86 2.36-1.05 4.23-2.98 5.21-5.37C11.07 8.33 14.05 10 17.42 10c.78 0 1.53-.09 2.25-.26.21.71.33 1.47.33 2.26 0 4.41-3.59 8-8 8z"/>
                </svg>
              </div>
              <div class="stat-info">
                <div class="stat-value">{{ stats.faceRecognitions }}</div>
                <div class="stat-label">人脸识别</div>
              </div>
            </div>
            <div class="stat-card">
              <div class="stat-icon compliance">
                <svg viewBox="0 0 24 24" width="20" height="20">
                  <path fill="currentColor" d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4z"/>
                </svg>
              </div>
              <div class="stat-info">
                <div class="stat-value">{{ stats.complianceChecks }}</div>
                <div class="stat-label">合规检测</div>
              </div>
            </div>
            <div class="stat-card">
              <div class="stat-icon alert">
                <svg viewBox="0 0 24 24" width="20" height="20">
                  <path fill="currentColor" d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.89 2 2 2zm6-6v-5c0-3.07-1.64-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.63 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2z"/>
                </svg>
              </div>
              <div class="stat-info">
                <div class="stat-value">{{ stats.alerts }}</div>
                <div class="stat-label">告警触发</div>
              </div>
            </div>
          </div>
        </div>

        <div class="node-palette-panel">
          <h3>
            <svg viewBox="0 0 24 24" width="18" height="18">
              <path fill="currentColor" d="M12 2l-5.5 9h11L12 2zm0 3.84L13.93 9h-3.87L12 5.84zM17.5 13c-2.49 0-4.5 2.01-4.5 4.5s2.01 4.5 4.5 4.5 4.5-2.01 4.5-4.5-2.01-4.5-4.5-4.5zm0 7c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5zM3 21.5h8v-8H3v8zm2-6h4v4H5v-4z"/>
            </svg>
            节点库
          </h3>
          <div class="node-palette">
            <div
              v-for="nodeType in availableNodes"
              :key="nodeType.type"
              class="palette-node"
              @click="addNode(nodeType)"
              draggable="true"
            >
              <div class="palette-icon" :class="nodeType.type">
                <svg viewBox="0 0 24 24" width="18" height="18">
                  <path fill="currentColor" :d="getNodeIcon(nodeType.type)" />
                </svg>
              </div>
              <div class="palette-info">
                <div class="palette-name">{{ nodeType.name }}</div>
                <div class="palette-desc">{{ nodeType.description }}</div>
              </div>
            </div>
          </div>
        </div>

        <div class="execution-log" v-if="isExecuting">
          <h3>
            <svg viewBox="0 0 24 24" width="18" height="18">
              <path fill="currentColor" d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm0 4c1.66 0 3 1.34 3 3s-1.34 3-3 3-3-1.34-3-3 1.34-3 3-3zm6 12H6v-1.4c0-2 4-3.1 6-3.1s6 1.1 6 3.1V19z"/>
            </svg>
            执行日志
          </h3>
          <div class="log-entries">
            <div v-for="log in executionLogs" :key="log.id" class="log-entry" :class="log.type">
              <span class="log-time">{{ log.time }}</span>
              <span class="log-message">{{ log.message }}</span>
            </div>
          </div>
        </div>
      </div>

      <div class="center-panel">
        <div class="workflow-canvas">
          <div class="canvas-toolbar">
            <div class="toolbar-group">
              <button class="tool-btn" @click="zoomIn" title="放大">
                <svg viewBox="0 0 24 24" width="18" height="18">
                  <path fill="currentColor" d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
                  <path fill="currentColor" d="M12 10h-2v2H9v-2H7V9h2V7h1v2h2v1z"/>
                </svg>
              </button>
              <button class="tool-btn" @click="zoomOut" title="缩小">
                <svg viewBox="0 0 24 24" width="18" height="18">
                  <path fill="currentColor" d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14zM7 9h5v1H7z"/>
                </svg>
              </button>
              <button class="tool-btn" @click="resetView" title="重置视图">
                <svg viewBox="0 0 24 24" width="18" height="18">
                  <path fill="currentColor" d="M12 5V1L7 6l5 5V7c3.31 0 6 2.69 6 6s-2.69 6-6 6-6-2.69-6-6H4c0 4.42 3.58 8 8 8s8-3.58 8-8-3.58-8-8-8z"/>
                </svg>
              </button>
            </div>
            <div class="toolbar-info">
              <span>缩放: {{ zoomLevel }}%</span>
              <span>节点: {{ workflowNodes.length }}</span>
              <span>连接: {{ connections.length }}</span>
            </div>
          </div>

          <div class="canvas-area" ref="canvasArea">
            <div
              v-for="node in workflowNodes"
              :key="node.id"
              class="workflow-node"
              :style="{
                left: node.x + 'px',
                top: node.y + 'px',
                transform: `scale(${zoomLevel / 100})`
              }"
              @click="selectNode(node)"
              @mousedown="startDrag(node, $event)"
              :class="{
                active: selectedNode?.id === node.id,
                executing: node.executing,
                completed: node.completed,
                error: node.error
              }"
            >
              <div class="node-header">
                <div class="node-icon" :class="node.type">
                  <svg viewBox="0 0 24 24" width="20" height="20">
                    <path fill="currentColor" :d="getNodeIcon(node.type)" />
                  </svg>
                </div>
                <div class="node-badge" v-if="node.executing">
                  <div class="spinner"></div>
                </div>
                <div class="node-badge success" v-if="node.completed">✓</div>
                <div class="node-badge error" v-if="node.error">✗</div>
              </div>
              <div class="node-body">
                <div class="node-label">{{ node.name }}</div>
                <div class="node-meta">
                  <span class="node-type">{{ getNodeTypeName(node.type) }}</span>
                  <span class="node-status" :class="node.status">
                    {{ getStatusLabel(node.status) }}
                  </span>
                </div>
                <div class="node-metrics" v-if="node.metrics">
                  <div class="metric">
                    <svg viewBox="0 0 24 24" width="12" height="12">
                      <path fill="currentColor" d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm.5-13H11v6l5.25 3.15.75-1.23-4.5-2.67z"/>
                    </svg>
                    {{ node.metrics.avgTime }}ms
                  </div>
                  <div class="metric">
                    <svg viewBox="0 0 24 24" width="12" height="12">
                      <path fill="currentColor" d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                    </svg>
                    {{ node.metrics.successRate }}%
                  </div>
                </div>
              </div>
              <div class="node-ports">
                <div class="port input" :data-node="node.id"></div>
                <div class="port output" :data-node="node.id"></div>
              </div>
            </div>

            <svg class="connections-layer">
              <line
                v-for="(conn, index) in connections"
                :key="index"
                :x1="conn.x1 * zoomLevel / 100"
                :y1="conn.y1 * zoomLevel / 100"
                :x2="conn.x2 * zoomLevel / 100"
                :y2="conn.y2 * zoomLevel / 100"
                :stroke="conn.active ? '#10b981' : '#3b82f6'"
                :stroke-width="conn.active ? 3 : 2"
                stroke-dasharray="5,5"
                marker-end="url(#arrowhead)"
                :class="{ 'active-connection': conn.active }"
              >
                <animate
                  v-if="conn.active"
                  attributeName="stroke-dashoffset"
                  from="0"
                  to="10"
                  dur="0.5s"
                  repeatCount="indefinite"
                />
              </line>
              <defs>
                <marker
                  id="arrowhead"
                  markerWidth="10"
                  markerHeight="10"
                  refX="9"
                  refY="3"
                  orient="auto"
                >
                  <polygon points="0 0, 10 3, 0 6" fill="#3b82f6" />
                </marker>
              </defs>
            </svg>
          </div>
        </div>

        <div class="timeline-panel" v-if="isExecuting">
          <h3>
            <svg viewBox="0 0 24 24" width="18" height="18">
              <path fill="currentColor" d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm.5-13H11v6l5.25 3.15.75-1.23-4.5-2.67z"/>
            </svg>
            执行时间轴
          </h3>
          <div class="timeline">
            <div v-for="event in executionTimeline" :key="event.id" class="timeline-event" :class="event.type">
              <div class="timeline-marker"></div>
              <div class="timeline-content">
                <div class="timeline-title">{{ event.title }}</div>
                <div class="timeline-time">{{ event.timestamp }}</div>
                <div class="timeline-desc">{{ event.description }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="right-panel">
        <div class="config-panel" v-if="selectedNode">
          <h3>
            <svg viewBox="0 0 24 24" width="18" height="18">
              <path fill="currentColor" d="M19.14 12.94c.04-.3.06-.61.06-.94 0-.32-.02-.64-.07-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94L14.4 2.81c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.57-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58c-.05.3-.09.63-.09.94s.02.64.07.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32c.12.22.37.29.59.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .44-.17.47-.41l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.22.07-.47-.12-.61l-2.01-1.58zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6z"/>
            </svg>
            节点配置
          </h3>
          <div class="config-content">
            <div class="config-section">
              <label>节点名称</label>
              <input v-model="selectedNode.name" type="text" />
            </div>
            <div class="config-section">
              <label>节点类型</label>
              <input :value="getNodeTypeName(selectedNode.type)" type="text" readonly />
            </div>
            <div class="config-section">
              <label>节点状态</label>
              <select v-model="selectedNode.status">
                <option value="enabled">启用</option>
                <option value="disabled">禁用</option>
              </select>
            </div>
            <div class="config-section">
              <label>执行优先级</label>
              <select v-model="selectedNode.priority">
                <option value="high">高</option>
                <option value="medium">中</option>
                <option value="low">低</option>
              </select>
            </div>
            <div class="config-section">
              <label>超时设置 (秒)</label>
              <input v-model="selectedNode.timeout" type="number" min="1" max="300" />
            </div>
            <div class="config-section">
              <label>重试次数</label>
              <input v-model="selectedNode.retries" type="number" min="0" max="5" />
            </div>
            <div class="config-actions">
              <button class="btn-danger" @click="deleteNode">
                <svg viewBox="0 0 24 24" width="16" height="16">
                  <path fill="currentColor" d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/>
                </svg>
                删除节点
              </button>
              <button class="btn-secondary" @click="duplicateNode">
                <svg viewBox="0 0 24 24" width="16" height="16">
                  <path fill="currentColor" d="M16 1H4c-1.1 0-2 .9-2 2v14h2V3h12V1zm3 4H8c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h11c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm0 16H8V7h11v14z"/>
                </svg>
                复制节点
              </button>
            </div>
          </div>
        </div>

        <div class="performance-panel">
          <h3>
            <svg viewBox="0 0 24 24" width="18" height="18">
              <path fill="currentColor" d="M16 6l2.29 2.29-4.88 4.88-4-4L2 16.59 3.41 18l6-6 4 4 6.3-6.29L22 12V6z"/>
            </svg>
            性能监控
          </h3>
          <div class="performance-metrics">
            <div class="metric-card">
              <div class="metric-label">平均响应时间</div>
              <div class="metric-value">{{ performanceMetrics.avgResponseTime }}ms</div>
              <div class="metric-trend positive">↑ 12%</div>
            </div>
            <div class="metric-card">
              <div class="metric-label">成功率</div>
              <div class="metric-value">{{ performanceMetrics.successRate }}%</div>
              <div class="metric-trend positive">↑ 3%</div>
            </div>
            <div class="metric-card">
              <div class="metric-label">处理量</div>
              <div class="metric-value">{{ performanceMetrics.throughput }}/h</div>
              <div class="metric-trend positive">↑ 25%</div>
            </div>
            <div class="metric-card">
              <div class="metric-label">错误率</div>
              <div class="metric-value">{{ performanceMetrics.errorRate }}%</div>
              <div class="metric-trend negative">↓ 8%</div>
            </div>
          </div>
        </div>

        <div class="alerts-panel">
          <h3>
            <svg viewBox="0 0 24 24" width="18" height="18">
              <path fill="currentColor" d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/>
            </svg>
            实时告警
          </h3>
          <div class="alerts-list">
            <div v-for="alert in recentAlerts" :key="alert.id" class="alert-item" :class="alert.level">
              <div class="alert-icon">!</div>
              <div class="alert-content">
                <div class="alert-title">{{ alert.title }}</div>
                <div class="alert-time">{{ alert.time }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="templates-modal" v-if="showTemplates" @click="showTemplates = false">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h2>工作流模板库</h2>
          <button class="close-btn" @click="showTemplates = false">×</button>
        </div>
        <div class="templates-grid">
          <div
            v-for="template in templates"
            :key="template.id"
            class="template-card"
            @click="loadTemplate(template)"
          >
            <div class="template-preview">
              <svg viewBox="0 0 200 100" width="100%" height="100">
                <circle cx="30" cy="50" r="15" fill="#3b82f6" opacity="0.3"/>
                <circle cx="100" cy="50" r="15" fill="#10b981" opacity="0.3"/>
                <circle cx="170" cy="50" r="15" fill="#f59e0b" opacity="0.3"/>
                <line x1="45" y1="50" x2="85" y2="50" stroke="#3b82f6" stroke-width="2"/>
                <line x1="115" y1="50" x2="155" y2="50" stroke="#3b82f6" stroke-width="2"/>
              </svg>
            </div>
            <h4>{{ template.name }}</h4>
            <p>{{ template.description }}</p>
            <div class="template-meta">
              <span>{{ template.nodes.length }} 个节点</span>
              <span>{{ template.connections }} 个连接</span>
            </div>
            <div class="template-tags">
              <span v-for="tag in template.tags" :key="tag" class="tag">{{ tag }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'

interface WorkflowNode {
  id: string
  type: string
  name: string
  x: number
  y: number
  status: 'enabled' | 'disabled'
  executing?: boolean
  completed?: boolean
  error?: boolean
  priority?: 'high' | 'medium' | 'low'
  timeout?: number
  retries?: number
  metrics?: {
    avgTime: number
    successRate: number
  }
}

interface Connection {
  x1: number
  y1: number
  x2: number
  y2: number
  active?: boolean
}

const workflowNodes = ref<WorkflowNode[]>([
  { id: '1', type: 'gait', name: '步态识别入口', x: 100, y: 100, status: 'enabled', priority: 'high', timeout: 30, retries: 3, metrics: { avgTime: 245, successRate: 97 } },
  { id: '2', type: 'face', name: '人脸识别验证', x: 350, y: 100, status: 'enabled', priority: 'high', timeout: 20, retries: 2, metrics: { avgTime: 180, successRate: 99 } },
  { id: '3', type: 'compliance', name: '装备合规检测', x: 350, y: 280, status: 'enabled', priority: 'medium', timeout: 15, retries: 2, metrics: { avgTime: 120, successRate: 95 } },
  { id: '4', type: 'data', name: '数据聚合处理', x: 600, y: 100, status: 'enabled', priority: 'medium', timeout: 10, retries: 1, metrics: { avgTime: 85, successRate: 100 } },
  { id: '5', type: 'alert', name: '告警规则引擎', x: 600, y: 280, status: 'enabled', priority: 'high', timeout: 5, retries: 0, metrics: { avgTime: 50, successRate: 100 } },
  { id: '6', type: 'personnel', name: '人员信息关联', x: 850, y: 190, status: 'enabled', priority: 'low', timeout: 20, retries: 1, metrics: { avgTime: 150, successRate: 98 } }
])

const connections = ref<Connection[]>([
  { x1: 190, y1: 130, x2: 350, y2: 130, active: false },
  { x1: 190, y1: 130, x2: 350, y2: 310, active: false },
  { x1: 440, y1: 130, x2: 600, y2: 130, active: false },
  { x1: 440, y1: 310, x2: 600, y2: 310, active: false },
  { x1: 690, y1: 130, x2: 850, y2: 220, active: false },
  { x1: 690, y1: 310, x2: 850, y2: 220, active: false }
])

const selectedNode = ref<WorkflowNode | null>(null)
const isExecuting = ref(false)
const showTemplates = ref(false)
const zoomLevel = ref(100)
const draggingNode = ref<WorkflowNode | null>(null)
const dragOffset = ref({ x: 0, y: 0 })

const stats = ref({
  gaitRecognitions: 52,
  faceRecognitions: 35,
  complianceChecks: 87,
  alerts: 5
})

const performanceMetrics = ref({
  avgResponseTime: 156,
  successRate: 97.8,
  throughput: 87,
  errorRate: 2.2
})

const executionLogs = ref([
  { id: 1, time: '10:23:45', message: '检车员识别节点执行成功', type: 'success' },
  { id: 2, time: '10:23:46', message: '身份验证节点执行成功', type: 'success' },
  { id: 3, time: '10:23:47', message: '作业合规检测发现异常', type: 'warning' },
  { id: 4, time: '10:23:48', message: '安全告警已触发并发送', type: 'info' }
])

const executionTimeline = ref([
  { id: 1, type: 'start', title: '工作流启动', timestamp: '10:23:45', description: '开始执行检车作业监控流程' },
  { id: 2, type: 'processing', title: '检车员识别', timestamp: '10:23:45.234', description: '正在进行检车员步态特征提取' },
  { id: 3, type: 'processing', title: '身份验证', timestamp: '10:23:46.102', description: '正在进行检车员身份验证' },
  { id: 4, type: 'success', title: '识别完成', timestamp: '10:23:46.876', description: '检车员身份验证成功' }
])

const recentAlerts = ref([
  { id: 1, level: 'error', title: '侵入邻线：距离邻线列车不足2米', time: '2分钟前' },
  { id: 2, level: 'warning', title: '未佩戴防护帽：2号股道车底作业', time: '8分钟前' },
  { id: 3, level: 'info', title: '检车作业监控流程执行完成', time: '15分钟前' }
])

const availableNodes = [
  { type: 'gait', name: '步态识别', description: '基于步态特征的身份识别' },
  { type: 'face', name: '人脸识别', description: '高精度人脸特征匹配' },
  { type: 'compliance', name: '合规检测', description: '装备与动作规范检测' },
  { type: 'alert', name: '告警触发', description: '实时告警规则引擎' },
  { type: 'data', name: '数据处理', description: '数据聚合与分析' },
  { type: 'personnel', name: '人员管理', description: '人员信息查询与关联' },
  { type: 'monitor', name: '视频监控', description: '实时视频流分析' }
]

const templates = [
  {
    id: '1',
    name: '标准识别流程',
    description: '步态识别 → 人脸识别 → 合规检测 → 告警触发',
    nodes: ['gait', 'face', 'compliance', 'alert'],
    connections: 3,
    tags: ['标准', '高精度']
  },
  {
    id: '2',
    name: '快速识别流程',
    description: '人脸识别 → 告警触发',
    nodes: ['face', 'alert'],
    connections: 1,
    tags: ['快速', '轻量']
  },
  {
    id: '3',
    name: '全面检测流程',
    description: '多维度识别与检测的完整流程',
    nodes: ['gait', 'face', 'compliance', 'data', 'alert', 'personnel'],
    connections: 7,
    tags: ['完整', '多维度']
  },
  {
    id: '4',
    name: '安全合规流程',
    description: '侧重于安全装备与动作规范检测',
    nodes: ['monitor', 'compliance', 'alert'],
    connections: 2,
    tags: ['安全', '合规']
  }
]

const getNodeIcon = (type: string) => {
  const icons: Record<string, string> = {
    gait: 'M13.5 5.5c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zM9.8 8.9L7 23h2.1l1.8-8 2.1 2v6h2v-7.5l-2.1-2 .6-3C14.8 12 16.8 13 19 13v-2c-1.9 0-3.5-1-4.3-2.4l-1-1.6c-.4-.6-1-1-1.7-1-.3 0-.5.1-.8.1L6 8.3V13h2V9.6l1.8-.7',
    face: 'M9 11.75c-.69 0-1.25.56-1.25 1.25s.56 1.25 1.25 1.25 1.25-.56 1.25-1.25-.56-1.25-1.25-1.25zm6 0c-.69 0-1.25.56-1.25 1.25s.56 1.25 1.25 1.25 1.25-.56 1.25-1.25-.56-1.25-1.25-1.25zM12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8 0-.29.02-.58.05-.86 2.36-1.05 4.23-2.98 5.21-5.37C11.07 8.33 14.05 10 17.42 10c.78 0 1.53-.09 2.25-.26.21.71.33 1.47.33 2.26 0 4.41-3.59 8-8 8z',
    compliance: 'M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4z',
    alert: 'M12 22c1.1 0 2-.9 2-2h-4c0 1.1.89 2 2 2zm6-6v-5c0-3.07-1.64-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.63 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2z',
    data: 'M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z',
    personnel: 'M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z',
    monitor: 'M20 18c1.1 0 1.99-.9 1.99-2L22 6c0-1.1-.9-2-2-2H4c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2H0v2h24v-2h-4zM4 6h16v10H4V6z'
  }
  return icons[type] || icons.data
}

const getStatusLabel = (status: string) => {
  return status === 'enabled' ? '启用' : '禁用'
}

const getNodeTypeName = (type: string) => {
  const node = availableNodes.find(n => n.type === type)
  return node?.name || type
}

const selectNode = (node: WorkflowNode) => {
  selectedNode.value = node
}

const addNode = (nodeType: { type: string; name: string }) => {
  const newNode: WorkflowNode = {
    id: String(Date.now()),
    type: nodeType.type,
    name: nodeType.name,
    x: 100 + Math.random() * 300,
    y: 100 + Math.random() * 200,
    status: 'enabled',
    priority: 'medium',
    timeout: 30,
    retries: 2,
    metrics: {
      avgTime: Math.floor(Math.random() * 200) + 50,
      successRate: Math.floor(Math.random() * 10) + 90
    }
  }
  workflowNodes.value.push(newNode)
  stats.value.gaitRecognitions++
}

const deleteNode = () => {
  if (selectedNode.value) {
    workflowNodes.value = workflowNodes.value.filter(n => n.id !== selectedNode.value!.id)
    selectedNode.value = null
  }
}

const duplicateNode = () => {
  if (selectedNode.value) {
    const newNode = {
      ...selectedNode.value,
      id: String(Date.now()),
      name: selectedNode.value.name + ' (副本)',
      x: selectedNode.value.x + 50,
      y: selectedNode.value.y + 50
    }
    workflowNodes.value.push(newNode)
  }
}

const saveWorkflow = () => {
  alert(`工作流已保存\n\n节点数: ${workflowNodes.value.length}\n连接数: ${connections.value.length}\n执行状态: ${isExecuting.value ? '运行中' : '已停止'}`)
}

const toggleExecution = () => {
  isExecuting.value = !isExecuting.value

  if (isExecuting.value) {
    simulateExecution()
  }
}

const simulateExecution = () => {
  let index = 0
  const interval = setInterval(() => {
    if (!isExecuting.value || index >= workflowNodes.value.length) {
      clearInterval(interval)
      workflowNodes.value.forEach(node => {
        node.executing = false
        node.completed = false
      })
      connections.value.forEach(conn => conn.active = false)
      return
    }

    const node = workflowNodes.value[index]
    node.executing = true

    connections.value.forEach((conn, i) => {
      if (i === index) conn.active = true
    })

    setTimeout(() => {
      node.executing = false
      node.completed = true
      stats.value.gaitRecognitions += Math.floor(Math.random() * 3)
      stats.value.faceRecognitions += Math.floor(Math.random() * 5)
      stats.value.complianceChecks += Math.floor(Math.random() * 2)

      const newLog = {
        id: Date.now(),
        time: new Date().toLocaleTimeString(),
        message: `${node.name} 执行成功`,
        type: 'success'
      }
      executionLogs.value.unshift(newLog)
      if (executionLogs.value.length > 10) executionLogs.value.pop()
    }, 1500)

    index++
  }, 2000)
}

const loadTemplate = (template: any) => {
  showTemplates.value = false
  alert(`已加载模板: ${template.name}\n\n${template.description}\n\n节点数: ${template.nodes.length}`)
}

const zoomIn = () => {
  if (zoomLevel.value < 150) zoomLevel.value += 10
}

const zoomOut = () => {
  if (zoomLevel.value > 50) zoomLevel.value -= 10
}

const resetView = () => {
  zoomLevel.value = 100
}

const startDrag = (node: WorkflowNode, event: MouseEvent) => {
  draggingNode.value = node
  dragOffset.value = {
    x: event.clientX - node.x,
    y: event.clientY - node.y
  }
}

const onMouseMove = (event: MouseEvent) => {
  if (draggingNode.value) {
    draggingNode.value.x = event.clientX - dragOffset.value.x
    draggingNode.value.y = event.clientY - dragOffset.value.y
  }
}

const onMouseUp = () => {
  draggingNode.value = null
}

onMounted(() => {
  document.addEventListener('mousemove', onMouseMove)
  document.addEventListener('mouseup', onMouseUp)

  setInterval(() => {
    if (!isExecuting.value) {
      stats.value.gaitRecognitions += Math.floor(Math.random() * 3)
      stats.value.faceRecognitions += Math.floor(Math.random() * 5)
      stats.value.complianceChecks += Math.floor(Math.random() * 2)
      if (Math.random() > 0.7) stats.value.alerts++
    }
  }, 3000)
})

onUnmounted(() => {
  document.removeEventListener('mousemove', onMouseMove)
  document.removeEventListener('mouseup', onMouseUp)
})
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
  font-size: 28px;
  font-weight: 700;
  color: #111827;
  margin: 0 0 4px 0;
}

.page-header p {
  font-size: 14px;
  color: #6b7280;
  margin: 0;
}

.header-actions {
  display: flex;
  gap: 12px;
}

.btn-primary,
.btn-secondary {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 18px;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-primary {
  background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
  color: white;
}

.btn-primary:hover {
  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
  transform: translateY(-1px);
}

.btn-secondary {
  background: white;
  color: #374151;
  border: 1px solid #e5e7eb;
}

.btn-secondary:hover {
  background: #f9fafb;
  border-color: #d1d5db;
}

.main-layout {
  display: grid;
  grid-template-columns: 280px 1fr 320px;
  gap: 24px;
}

.left-panel,
.right-panel {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.stats-overview,
.node-palette-panel,
.execution-log,
.config-panel,
.performance-panel,
.alerts-panel {
  background: white;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.stats-overview h3,
.node-palette-panel h3,
.execution-log h3,
.config-panel h3,
.performance-panel h3,
.alerts-panel h3 {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  font-weight: 600;
  color: #111827;
  margin: 0 0 16px 0;
}

.stats-grid {
  display: grid;
  gap: 12px;
}

.stat-card {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px;
  background: #f9fafb;
  border-radius: 8px;
}

.stat-icon {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

.stat-icon.gait {
  background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
}

.stat-icon.face {
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
}

.stat-icon.compliance {
  background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
}

.stat-icon.alert {
  background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 20px;
  font-weight: 700;
  color: #111827;
}

.stat-label {
  font-size: 12px;
  color: #6b7280;
  margin-top: 2px;
}

.node-palette {
  display: flex;
  flex-direction: column;
  gap: 8px;
  max-height: 400px;
  overflow-y: auto;
}

.palette-node {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;
}

.palette-node:hover {
  border-color: #3b82f6;
  background: #f0f9ff;
}

.palette-icon {
  width: 32px;
  height: 32px;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  flex-shrink: 0;
}

.palette-icon.data {
  background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
}

.palette-icon.personnel {
  background: linear-gradient(135deg, #ec4899 0%, #db2777 100%);
}

.palette-icon.monitor {
  background: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%);
}

.palette-info {
  flex: 1;
  min-width: 0;
}

.palette-name {
  font-size: 13px;
  font-weight: 600;
  color: #111827;
}

.palette-desc {
  font-size: 11px;
  color: #6b7280;
  margin-top: 2px;
}

.execution-log {
  max-height: 300px;
}

.log-entries {
  display: flex;
  flex-direction: column;
  gap: 8px;
  max-height: 200px;
  overflow-y: auto;
}

.log-entry {
  display: flex;
  gap: 8px;
  padding: 8px;
  background: #f9fafb;
  border-radius: 6px;
  font-size: 12px;
  border-left: 3px solid #3b82f6;
}

.log-entry.success {
  border-left-color: #10b981;
}

.log-entry.warning {
  border-left-color: #f59e0b;
}

.log-entry.info {
  border-left-color: #3b82f6;
}

.log-time {
  color: #6b7280;
  font-family: monospace;
}

.log-message {
  color: #374151;
  flex: 1;
}

.center-panel {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.workflow-canvas {
  background: white;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.canvas-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 20px;
  border-bottom: 1px solid #e5e7eb;
  background: #fafbfc;
}

.toolbar-group {
  display: flex;
  gap: 4px;
}

.tool-btn {
  width: 32px;
  height: 32px;
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

.toolbar-info {
  display: flex;
  gap: 16px;
  font-size: 12px;
  color: #6b7280;
}

.canvas-area {
  position: relative;
  height: 600px;
  background: #fafbfc;
  background-image:
    linear-gradient(#e5e7eb 1px, transparent 1px),
    linear-gradient(90deg, #e5e7eb 1px, transparent 1px);
  background-size: 20px 20px;
  overflow: hidden;
}

.workflow-node {
  position: absolute;
  width: 160px;
  background: white;
  border: 2px solid #e5e7eb;
  border-radius: 12px;
  cursor: move;
  transition: all 0.2s;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.workflow-node:hover {
  border-color: #3b82f6;
  box-shadow: 0 4px 16px rgba(59, 130, 246, 0.15);
}

.workflow-node.active {
  border-color: #3b82f6;
  box-shadow: 0 4px 16px rgba(59, 130, 246, 0.3);
}

.workflow-node.executing {
  border-color: #10b981;
  animation: pulse 1s infinite;
}

.workflow-node.completed {
  border-color: #10b981;
}

.workflow-node.error {
  border-color: #ef4444;
}

@keyframes pulse {
  0%, 100% {
    box-shadow: 0 4px 16px rgba(16, 185, 129, 0.3);
  }
  50% {
    box-shadow: 0 4px 24px rgba(16, 185, 129, 0.6);
  }
}

.node-header {
  position: relative;
  padding: 12px;
  display: flex;
  justify-content: center;
  border-bottom: 1px solid #f3f4f6;
}

.node-icon {
  width: 44px;
  height: 44px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

.node-badge {
  position: absolute;
  top: 8px;
  right: 8px;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 700;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.node-badge.success {
  color: #10b981;
}

.node-badge.error {
  color: #ef4444;
}

.spinner {
  width: 12px;
  height: 12px;
  border: 2px solid #e5e7eb;
  border-top-color: #3b82f6;
  border-radius: 50%;
  animation: spin 0.6s linear infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.node-body {
  padding: 12px;
}

.node-label {
  font-size: 13px;
  font-weight: 600;
  color: #111827;
  margin-bottom: 6px;
}

.node-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.node-type {
  font-size: 11px;
  color: #6b7280;
}

.node-status {
  font-size: 10px;
  padding: 2px 6px;
  border-radius: 4px;
  font-weight: 500;
}

.node-status.enabled {
  background: #d1fae5;
  color: #065f46;
}

.node-status.disabled {
  background: #fee2e2;
  color: #991b1b;
}

.node-metrics {
  display: flex;
  gap: 8px;
}

.metric {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 11px;
  color: #6b7280;
}

.node-ports {
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
  pointer-events: none;
}

.port {
  position: absolute;
  width: 10px;
  height: 10px;
  background: #3b82f6;
  border: 2px solid white;
  border-radius: 50%;
  pointer-events: all;
  cursor: crosshair;
}

.port.input {
  left: -5px;
  top: 50%;
  transform: translateY(-50%);
}

.port.output {
  right: -5px;
  top: 50%;
  transform: translateY(-50%);
}

.connections-layer {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
}

.timeline-panel {
  background: white;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.timeline-panel h3 {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  font-weight: 600;
  color: #111827;
  margin: 0 0 16px 0;
}

.timeline {
  position: relative;
  padding-left: 24px;
  max-height: 200px;
  overflow-y: auto;
}

.timeline::before {
  content: '';
  position: absolute;
  left: 6px;
  top: 0;
  bottom: 0;
  width: 2px;
  background: #e5e7eb;
}

.timeline-event {
  position: relative;
  margin-bottom: 20px;
}

.timeline-marker {
  position: absolute;
  left: -20px;
  top: 4px;
  width: 10px;
  height: 10px;
  background: #3b82f6;
  border: 2px solid white;
  border-radius: 50%;
  box-shadow: 0 0 0 2px #e5e7eb;
}

.timeline-event.success .timeline-marker {
  background: #10b981;
}

.timeline-event.processing .timeline-marker {
  background: #f59e0b;
  animation: pulse-marker 1s infinite;
}

@keyframes pulse-marker {
  0%, 100% {
    box-shadow: 0 0 0 2px #e5e7eb, 0 0 0 4px rgba(245, 158, 11, 0.3);
  }
  50% {
    box-shadow: 0 0 0 2px #e5e7eb, 0 0 0 8px rgba(245, 158, 11, 0.1);
  }
}

.timeline-content {
  padding-left: 4px;
}

.timeline-title {
  font-size: 13px;
  font-weight: 600;
  color: #111827;
}

.timeline-time {
  font-size: 11px;
  color: #9ca3af;
  margin-top: 2px;
}

.timeline-desc {
  font-size: 12px;
  color: #6b7280;
  margin-top: 4px;
}

.config-panel {
  max-height: 500px;
  overflow-y: auto;
}

.config-content {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.config-section label {
  display: block;
  font-size: 12px;
  font-weight: 500;
  color: #374151;
  margin-bottom: 6px;
}

.config-section input,
.config-section select {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #e5e7eb;
  border-radius: 6px;
  font-size: 13px;
  color: #111827;
}

.config-section input:focus,
.config-section select:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.config-actions {
  display: flex;
  flex-direction: column;
  gap: 8px;
  padding-top: 8px;
}

.btn-danger {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  padding: 8px 14px;
  background: #ef4444;
  color: white;
  border: none;
  border-radius: 6px;
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-danger:hover {
  background: #dc2626;
}

.performance-metrics {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 12px;
}

.metric-card {
  padding: 12px;
  background: #f9fafb;
  border-radius: 8px;
}

.metric-label {
  font-size: 11px;
  color: #6b7280;
  margin-bottom: 6px;
}

.metric-value {
  font-size: 18px;
  font-weight: 700;
  color: #111827;
  margin-bottom: 4px;
}

.metric-trend {
  font-size: 11px;
  font-weight: 600;
}

.metric-trend.positive {
  color: #10b981;
}

.metric-trend.negative {
  color: #ef4444;
}

.alerts-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
  max-height: 250px;
  overflow-y: auto;
}

.alert-item {
  display: flex;
  gap: 10px;
  padding: 10px;
  border-radius: 8px;
  border-left: 3px solid;
}

.alert-item.error {
  background: #fef2f2;
  border-left-color: #ef4444;
}

.alert-item.warning {
  background: #fffbeb;
  border-left-color: #f59e0b;
}

.alert-item.info {
  background: #eff6ff;
  border-left-color: #3b82f6;
}

.alert-icon {
  width: 24px;
  height: 24px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  font-weight: 700;
  flex-shrink: 0;
}

.alert-item.error .alert-icon {
  background: #fee2e2;
  color: #dc2626;
}

.alert-item.warning .alert-icon {
  background: #fed7aa;
  color: #d97706;
}

.alert-item.info .alert-icon {
  background: #dbeafe;
  color: #2563eb;
}

.alert-content {
  flex: 1;
}

.alert-title {
  font-size: 12px;
  font-weight: 600;
  color: #111827;
  margin-bottom: 2px;
}

.alert-time {
  font-size: 11px;
  color: #6b7280;
}

.templates-modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  background: white;
  border-radius: 16px;
  width: 90%;
  max-width: 1200px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 24px 32px;
  border-bottom: 1px solid #e5e7eb;
}

.modal-header h2 {
  font-size: 20px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.close-btn {
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f3f4f6;
  border: none;
  border-radius: 6px;
  font-size: 24px;
  color: #6b7280;
  cursor: pointer;
  transition: all 0.2s;
}

.close-btn:hover {
  background: #e5e7eb;
  color: #111827;
}

.templates-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
  padding: 32px;
}

.template-card {
  padding: 20px;
  border: 2px solid #e5e7eb;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.2s;
}

.template-card:hover {
  border-color: #3b82f6;
  box-shadow: 0 8px 24px rgba(59, 130, 246, 0.15);
  transform: translateY(-2px);
}

.template-preview {
  margin-bottom: 16px;
  border-radius: 8px;
  overflow: hidden;
  background: #f9fafb;
}

.template-card h4 {
  font-size: 16px;
  font-weight: 600;
  color: #111827;
  margin: 0 0 8px 0;
}

.template-card p {
  font-size: 13px;
  color: #6b7280;
  margin: 0 0 12px 0;
  line-height: 1.5;
}

.template-meta {
  display: flex;
  gap: 12px;
  font-size: 12px;
  color: #9ca3af;
  margin-bottom: 12px;
}

.template-tags {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
}

.tag {
  padding: 4px 10px;
  background: #eff6ff;
  color: #2563eb;
  border-radius: 12px;
  font-size: 11px;
  font-weight: 500;
}
</style>
