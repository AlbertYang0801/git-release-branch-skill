# git-release-branch

用于团队 Git 发布流程的 Codex skill，覆盖：

- 从部署单中的提测分支创建并推送 `release/Vx.y.z_YYYYMMDD`；
- 生产发布后检查 release/master 双向差异，安全合并 master 并创建、推送版本 tag；
- 所有成功、失败和中止路径写入可审计的 Markdown 运行记录。

## 安装

复制整个 `git-release-branch-skill` 目录到个人 skills 目录，保持 `SKILL.md` 与 `runs/` 的相对位置不变。skill 内容不依赖旁边的需求跟踪目录。

## 使用示例

- “根据这个部署单上预发并创建 release 分支。”
- “生产发完了，检查 release 与 master 后打 tag。”

首次使用时会先询问服务路径表的保存位置，推荐 `%USERPROFILE%\.codex\git-release-branch\services.md`，也可选择其他可写路径；确认后，再在首次遇到服务时询问本地仓库路径并维护该文件。任何修改分支、合并、push 或 tag 操作都需要用户确认。

## 文件

- `SKILL.md`：触发条件、发布流程、安全门和运行记录格式。
- `runs/`：每次执行的原始结果；仓库中的两份带时间戳记录是 `0.1.0` 文档验收样例。

