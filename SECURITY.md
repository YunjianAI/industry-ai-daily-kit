# Security

这个项目是公开模板仓库，只应该包含可分享的流程、Prompt、模板和示例配置。

## 不应提交的内容

- API key、token、webhook、Cookie
- 浏览器登录态或平台账号凭据
- 真实客户、朋友、团队成员资料
- 历史日报全文和自动化运行日志
- 个人 Obsidian vault 内容
- 本地绝对路径和私有脚本路径
- 未脱敏的自动化脚本
- `.obsidian/`、`.claude/`、`.codex/`、`.agents/` 等本地工作区目录

## 上传前检查

在仓库根目录运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\sanitize-check.ps1
```

如果脚本报出高风险命中，先处理后再提交。

## 公开项目建议

公开仓库里保留模板和方法论，不保留真实运行数据。真实日报、推送配置和个人工作流建议放在私有仓库或本地知识库中。

