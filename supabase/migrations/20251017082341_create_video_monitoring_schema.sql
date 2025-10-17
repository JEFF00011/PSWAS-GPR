/*
  # 智能视频监控分析系统数据库架构
  
  ## 概述
  为步态识别、人脸识别和动作合规检测系统创建完整的数据库架构
  
  ## 新建表
  
  ### 1. `personnel` - 人员信息表
    - `id` (uuid, 主键)
    - `name` (text) - 姓名
    - `employee_id` (text, 唯一) - 工号
    - `department` (text) - 部门
    - `position` (text) - 职位
    - `status` (text) - 状态 (active/inactive)
    - `created_at` (timestamptz)
    - `updated_at` (timestamptz)
  
  ### 2. `gait_templates` - 步态特征模板表
    - `id` (uuid, 主键)
    - `personnel_id` (uuid, 外键)
    - `feature_vector` (jsonb) - 步态特征向量
    - `capture_angle` (text) - 采集角度 (front/side/back)
    - `quality_score` (numeric) - 质量评分 (0-100)
    - `created_at` (timestamptz)
  
  ### 3. `face_templates` - 人脸特征模板表
    - `id` (uuid, 主键)
    - `personnel_id` (uuid, 外键)
    - `feature_vector` (jsonb) - 人脸特征向量 (128维)
    - `image_url` (text) - 原始照片URL
    - `quality_score` (numeric) - 质量评分
    - `created_at` (timestamptz)
  
  ### 4. `recognition_records` - 识别记录表
    - `id` (uuid, 主键)
    - `personnel_id` (uuid, 外键)
    - `recognition_type` (text) - 识别类型 (gait/face)
    - `camera_id` (text) - 摄像头ID
    - `location` (text) - 位置
    - `confidence` (numeric) - 置信度 (0-1)
    - `image_url` (text) - 抓拍图片
    - `timestamp` (timestamptz)
  
  ### 5. `compliance_alerts` - 合规告警表
    - `id` (uuid, 主键)
    - `personnel_id` (uuid, 外键, 可选)
    - `alert_type` (text) - 告警类型 (no_helmet/no_vest/fall/climb等)
    - `severity` (text) - 严重级别 (low/medium/high/critical)
    - `camera_id` (text) - 摄像头ID
    - `location` (text) - 位置
    - `description` (text) - 描述
    - `image_url` (text) - 证据图片
    - `status` (text) - 状态 (pending/acknowledged/resolved)
    - `resolved_at` (timestamptz)
    - `resolved_by` (text)
    - `created_at` (timestamptz)
  
  ### 6. `video_streams` - 视频流配置表
    - `id` (uuid, 主键)
    - `camera_id` (text, 唯一) - 摄像头ID
    - `name` (text) - 名称
    - `location` (text) - 位置
    - `stream_url` (text) - 流地址
    - `status` (text) - 状态 (online/offline/maintenance)
    - `enabled_features` (jsonb) - 启用的功能 (gait/face/action)
    - `created_at` (timestamptz)
    - `updated_at` (timestamptz)
  
  ### 7. `system_statistics` - 系统统计表
    - `id` (uuid, 主键)
    - `date` (date, 唯一) - 统计日期
    - `total_recognitions` (integer) - 总识别次数
    - `gait_recognitions` (integer) - 步态识别次数
    - `face_recognitions` (integer) - 人脸识别次数
    - `total_alerts` (integer) - 总告警数
    - `critical_alerts` (integer) - 严重告警数
    - `average_response_time` (numeric) - 平均响应时间(ms)
    - `created_at` (timestamptz)
  
  ## 安全设置
    - 为所有表启用行级安全 (RLS)
    - 为认证用户创建适当的访问策略
    - 确保数据隐私和安全合规
*/

-- 1. 人员信息表
CREATE TABLE IF NOT EXISTS personnel (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  employee_id text UNIQUE NOT NULL,
  department text DEFAULT '',
  position text DEFAULT '',
  status text DEFAULT 'active',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE personnel ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view all personnel"
  ON personnel FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert personnel"
  ON personnel FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update personnel"
  ON personnel FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- 2. 步态特征模板表
CREATE TABLE IF NOT EXISTS gait_templates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  personnel_id uuid REFERENCES personnel(id) ON DELETE CASCADE,
  feature_vector jsonb NOT NULL,
  capture_angle text DEFAULT 'front',
  quality_score numeric DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE gait_templates ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view gait templates"
  ON gait_templates FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert gait templates"
  ON gait_templates FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- 3. 人脸特征模板表
CREATE TABLE IF NOT EXISTS face_templates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  personnel_id uuid REFERENCES personnel(id) ON DELETE CASCADE,
  feature_vector jsonb NOT NULL,
  image_url text DEFAULT '',
  quality_score numeric DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE face_templates ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view face templates"
  ON face_templates FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert face templates"
  ON face_templates FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- 4. 识别记录表
CREATE TABLE IF NOT EXISTS recognition_records (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  personnel_id uuid REFERENCES personnel(id) ON DELETE SET NULL,
  recognition_type text NOT NULL,
  camera_id text NOT NULL,
  location text DEFAULT '',
  confidence numeric DEFAULT 0,
  image_url text DEFAULT '',
  timestamp timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_recognition_records_timestamp ON recognition_records(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_recognition_records_personnel ON recognition_records(personnel_id);

ALTER TABLE recognition_records ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view recognition records"
  ON recognition_records FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert recognition records"
  ON recognition_records FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- 5. 合规告警表
CREATE TABLE IF NOT EXISTS compliance_alerts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  personnel_id uuid REFERENCES personnel(id) ON DELETE SET NULL,
  alert_type text NOT NULL,
  severity text DEFAULT 'medium',
  camera_id text NOT NULL,
  location text DEFAULT '',
  description text DEFAULT '',
  image_url text DEFAULT '',
  status text DEFAULT 'pending',
  resolved_at timestamptz,
  resolved_by text DEFAULT '',
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_compliance_alerts_created ON compliance_alerts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_compliance_alerts_status ON compliance_alerts(status);
CREATE INDEX IF NOT EXISTS idx_compliance_alerts_severity ON compliance_alerts(severity);

ALTER TABLE compliance_alerts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view compliance alerts"
  ON compliance_alerts FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert compliance alerts"
  ON compliance_alerts FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update compliance alerts"
  ON compliance_alerts FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- 6. 视频流配置表
CREATE TABLE IF NOT EXISTS video_streams (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  camera_id text UNIQUE NOT NULL,
  name text NOT NULL,
  location text DEFAULT '',
  stream_url text DEFAULT '',
  status text DEFAULT 'online',
  enabled_features jsonb DEFAULT '{"gait": true, "face": true, "action": true}'::jsonb,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE video_streams ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view video streams"
  ON video_streams FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert video streams"
  ON video_streams FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update video streams"
  ON video_streams FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- 7. 系统统计表
CREATE TABLE IF NOT EXISTS system_statistics (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  date date UNIQUE NOT NULL DEFAULT CURRENT_DATE,
  total_recognitions integer DEFAULT 0,
  gait_recognitions integer DEFAULT 0,
  face_recognitions integer DEFAULT 0,
  total_alerts integer DEFAULT 0,
  critical_alerts integer DEFAULT 0,
  average_response_time numeric DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_system_statistics_date ON system_statistics(date DESC);

ALTER TABLE system_statistics ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view system statistics"
  ON system_statistics FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert system statistics"
  ON system_statistics FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update system statistics"
  ON system_statistics FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);