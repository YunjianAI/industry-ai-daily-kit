# 安全和脱敏边界

这个仓库只应该存放可公开或可分享的模板、说明、Prompt 和示例配置。

## 不允许提交

- API key
- GitHub token
- OpenAI key
- 飞书 webhook
- Cookie
- 浏览器登录态
- 真实客户资料
- 真实朋友资料
- 历史日报全文
- 自动化运行日志
- 本地绝对路径
- Obsidian vault 个人上下文
- `.obsidian/`
- `.git/`
- `.claude/`
- `.codex/`
- `.agents/`

## 允许提交

- 脱敏后的流程说明
- 空白配置模板
- 示例关键词
- 示例日报结构
- Codex 启动 Prompt
- 脱敏检查脚本

## 上传前检查

在仓库根目录运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\sanitize-check.ps1
```

如果脚本报出高风险命中，先处理后再上传。

