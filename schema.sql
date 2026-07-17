-- JBTI 求职痛点调研表
-- 初始化 / 变更后执行：npx wrangler d1 execute jbti-survey --remote --file=schema.sql
-- 常用分析：
--   选择率 = 某标签被选次数 / 被展示次数（tags_shown 必须参与计算，否则是假排行）
--   自由回答挖掘：SELECT tag_custom, dream_label FROM pain_points WHERE tag_custom != '' ORDER BY ts DESC;

CREATE TABLE IF NOT EXISTS pain_points (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ts TEXT DEFAULT (datetime('now')),   -- 入库时间（UTC）
  sid TEXT,                            -- 匿名会话ID（localStorage随机串，仅用于去重）
  framing TEXT,                        -- 提问框架 F1打听版 / F2红线版 / F3二选一版
  dream_raw TEXT,                      -- 理想工作原文
  dream_label TEXT,                    -- 归一化类目（JOB_CARDS label）
  tags_shown TEXT,                     -- JSON数组：本次展示的预设标签
  tags_picked TEXT,                    -- JSON数组：选中的标签，按点选顺序
  tag_custom TEXT,                     -- 自由填写的痛点原文
  skipped INTEGER DEFAULT 0,           -- 1 = 点了"不打听了"
  persona TEXT,                        -- 求职人格代码（GMSI等）
  jb INTEGER,                          -- JB浓度
  mbti TEXT DEFAULT '',                -- 若做了叠加解读
  star TEXT DEFAULT '',
  stage TEXT DEFAULT '',               -- 身份阶段：在校/应届/工作中/想转行
  region TEXT,                         -- 粗粒度地域（国·省·市，来自CF边缘，不存IP）
  src TEXT,                            -- 进站渠道（分享链接 ?src= 参数）
  dur INTEGER                          -- 从开测到交卷的秒数（数据质量过滤用）
);

CREATE INDEX IF NOT EXISTS idx_pp_label ON pain_points(dream_label);
CREATE INDEX IF NOT EXISTS idx_pp_ts ON pain_points(ts);
