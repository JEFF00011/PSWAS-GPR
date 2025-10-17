<template>
  <div class="personnel-management">
    <div class="page-header">
      <h1>人员管理</h1>
      <p>管理人员信息及生物特征模板</p>
    </div>

    <div class="management-container">
      <div class="toolbar">
        <div class="search-box">
          <svg viewBox="0 0 24 24" width="18" height="18">
            <path fill="currentColor" d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
          </svg>
          <input
            v-model="searchQuery"
            type="text"
            placeholder="搜索姓名、工号或部门..."
          />
        </div>
        <button class="add-btn" @click="addPerson">+ 添加人员</button>
      </div>

      <div class="personnel-table">
        <table>
          <thead>
            <tr>
              <th>姓名</th>
              <th>工号</th>
              <th>部门</th>
              <th>职位</th>
              <th>步态模板</th>
              <th>人脸模板</th>
              <th>状态</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="person in filteredPersonnel" :key="person.id">
              <td>
                <div class="person-cell">
                  <div class="avatar">
                    <svg viewBox="0 0 24 24" width="24" height="24">
                      <path fill="currentColor" d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                    </svg>
                  </div>
                  <span class="person-name">{{ person.name }}</span>
                </div>
              </td>
              <td>
                <span class="employee-id">{{ person.employee_id }}</span>
              </td>
              <td>{{ person.department }}</td>
              <td>{{ person.position }}</td>
              <td>
                <div class="template-status">
                  <span class="template-count" :class="{ hasTemplates: person.gait_templates > 0 }">
                    {{ person.gait_templates }}
                  </span>
                  <button class="template-btn" @click="manageGaitTemplate(person.id)">管理</button>
                </div>
              </td>
              <td>
                <div class="template-status">
                  <span class="template-count" :class="{ hasTemplates: person.face_templates > 0 }">
                    {{ person.face_templates }}
                  </span>
                  <button class="template-btn" @click="manageFaceTemplate(person.id)">管理</button>
                </div>
              </td>
              <td>
                <span class="status-badge" :class="person.status">
                  {{ person.status === 'active' ? '在职' : '离职' }}
                </span>
              </td>
              <td>
                <div class="action-buttons">
                  <button class="icon-btn edit" title="编辑" @click="editPerson(person.id)">
                    <svg viewBox="0 0 24 24" width="16" height="16">
                      <path fill="currentColor" d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
                    </svg>
                  </button>
                  <button class="icon-btn delete" title="删除" @click="deletePerson(person.id)">
                    <svg viewBox="0 0 24 24" width="16" height="16">
                      <path fill="currentColor" d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/>
                    </svg>
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

interface Personnel {
  id: string
  name: string
  employee_id: string
  department: string
  position: string
  gait_templates: number
  face_templates: number
  status: 'active' | 'inactive'
}

const searchQuery = ref('')

const personnel = ref<Personnel[]>([
  {
    id: '1',
    name: '张伟',
    employee_id: 'EMP-10023',
    department: '技术部',
    position: '高级工程师',
    gait_templates: 3,
    face_templates: 2,
    status: 'active'
  },
  {
    id: '2',
    name: '李娜',
    employee_id: 'EMP-10156',
    department: '生产部',
    position: '生产主管',
    gait_templates: 2,
    face_templates: 1,
    status: 'active'
  },
  {
    id: '3',
    name: '王强',
    employee_id: 'EMP-10089',
    department: '物流部',
    position: '仓库管理员',
    gait_templates: 1,
    face_templates: 1,
    status: 'active'
  },
  {
    id: '4',
    name: '刘芳',
    employee_id: 'EMP-10234',
    department: '质检部',
    position: '质检员',
    gait_templates: 2,
    face_templates: 2,
    status: 'active'
  },
  {
    id: '5',
    name: '陈明',
    employee_id: 'EMP-10045',
    department: '研发部',
    position: '研发工程师',
    gait_templates: 3,
    face_templates: 3,
    status: 'active'
  },
  {
    id: '6',
    name: '赵丽',
    employee_id: 'EMP-10178',
    department: '市场部',
    position: '市场专员',
    gait_templates: 1,
    face_templates: 1,
    status: 'active'
  }
])

const filteredPersonnel = computed(() => {
  if (!searchQuery.value) return personnel.value

  const query = searchQuery.value.toLowerCase()
  return personnel.value.filter(p =>
    p.name.toLowerCase().includes(query) ||
    p.employee_id.toLowerCase().includes(query) ||
    p.department.toLowerCase().includes(query)
  )
})

const addPerson = () => {
  alert('添加新人员\n\n请填写：\n- 姓名\n- 工号\n- 部门\n- 职位\n\n添加后可采集生物特征模板')
}

const manageGaitTemplate = (personId: string) => {
  const person = personnel.value.find(p => p.id === personId)
  if (person) {
    alert(`管理步态模板 - ${person.name}\n\n当前模板数: ${person.gait_templates}\n\n操作:\n- 查看已有模板\n- 采集新模板\n- 删除低质量模板`)
  }
}

const manageFaceTemplate = (personId: string) => {
  const person = personnel.value.find(p => p.id === personId)
  if (person) {
    alert(`管理人脸模板 - ${person.name}\n\n当前模板数: ${person.face_templates}\n\n操作:\n- 查看已有模板\n- 采集新模板\n- 更新照片`)
  }
}

const editPerson = (personId: string) => {
  const person = personnel.value.find(p => p.id === personId)
  if (person) {
    alert(`编辑人员信息 - ${person.name}\n\n可修改:\n- 部门\n- 职位\n- 状态`)
  }
}

const deletePerson = (personId: string) => {
  const person = personnel.value.find(p => p.id === personId)
  if (person && confirm(`确认删除人员 ${person.name}？\n\n注意: 将同时删除该人员的所有生物特征模板`)) {
    personnel.value = personnel.value.filter(p => p.id !== personId)
    alert('人员已删除')
  }
}
</script>

<style scoped>
.personnel-management {
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

.management-container {
  background: white;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 24px;
  border-bottom: 1px solid #e5e7eb;
}

.search-box {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 16px;
  background: #f9fafb;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  width: 360px;
}

.search-box svg {
  color: #9ca3af;
  flex-shrink: 0;
}

.search-box input {
  flex: 1;
  border: none;
  background: transparent;
  font-size: 14px;
  color: #111827;
  outline: none;
}

.search-box input::placeholder {
  color: #9ca3af;
}

.add-btn {
  padding: 10px 20px;
  background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.add-btn:hover {
  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
  transform: translateY(-1px);
}

.personnel-table {
  overflow-x: auto;
}

table {
  width: 100%;
  border-collapse: collapse;
}

thead {
  background: #f9fafb;
}

th {
  padding: 16px 24px;
  text-align: left;
  font-size: 13px;
  font-weight: 600;
  color: #6b7280;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

tbody tr {
  border-bottom: 1px solid #f3f4f6;
  transition: all 0.2s;
}

tbody tr:hover {
  background: #f9fafb;
}

td {
  padding: 16px 24px;
  font-size: 14px;
  color: #374151;
}

.person-cell {
  display: flex;
  align-items: center;
  gap: 12px;
}

.avatar {
  width: 40px;
  height: 40px;
  background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  flex-shrink: 0;
}

.person-name {
  font-weight: 600;
  color: #111827;
}

.employee-id {
  font-family: 'Monaco', 'Consolas', monospace;
  font-size: 13px;
  color: #6b7280;
  background: #f3f4f6;
  padding: 4px 8px;
  border-radius: 4px;
}

.template-status {
  display: flex;
  align-items: center;
  gap: 8px;
}

.template-count {
  padding: 4px 10px;
  background: #fee2e2;
  color: #991b1b;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 700;
}

.template-count.hasTemplates {
  background: #d1fae5;
  color: #065f46;
}

.template-btn {
  padding: 4px 10px;
  background: transparent;
  color: #3b82f6;
  border: 1px solid #3b82f6;
  border-radius: 4px;
  font-size: 11px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.template-btn:hover {
  background: #3b82f6;
  color: white;
}

.status-badge {
  padding: 5px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 700;
}

.status-badge.active {
  background: #d1fae5;
  color: #065f46;
}

.status-badge.inactive {
  background: #fee2e2;
  color: #991b1b;
}

.action-buttons {
  display: flex;
  gap: 8px;
}

.icon-btn {
  width: 32px;
  height: 32px;
  border: none;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s;
}

.icon-btn.edit {
  background: #dbeafe;
  color: #1e40af;
}

.icon-btn.edit:hover {
  background: #bfdbfe;
}

.icon-btn.delete {
  background: #fee2e2;
  color: #991b1b;
}

.icon-btn.delete:hover {
  background: #fecaca;
}
</style>
