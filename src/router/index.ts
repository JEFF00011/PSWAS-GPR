import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      redirect: '/dashboard'
    },
    {
      path: '/dashboard',
      name: 'dashboard',
      component: () => import('../views/Dashboard.vue')
    },
    {
      path: '/gait',
      name: 'gait',
      component: () => import('../views/GaitRecognition.vue')
    },
    {
      path: '/face',
      name: 'face',
      component: () => import('../views/FaceRecognition.vue')
    },
    {
      path: '/compliance',
      name: 'compliance',
      component: () => import('../views/ComplianceDetection.vue')
    },
    {
      path: '/workflow',
      name: 'workflow',
      component: () => import('../views/WorkflowOrchestration.vue')
    },
    {
      path: '/alerts',
      name: 'alerts',
      component: () => import('../views/AlertManagement.vue')
    },
    {
      path: '/personnel',
      name: 'personnel',
      component: () => import('../views/PersonnelManagement.vue')
    }
  ]
})

export default router
