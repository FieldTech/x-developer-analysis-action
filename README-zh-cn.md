# X-Developer Analysis Action

- [English](https://github.com/FieldTech/x-developer-analysis-action/blob/master/README.md)
- [中文](https://github.com/FieldTech/x-developer-analysis-action/blob/master/README-zh-cn.md)

X-Developer Analysis Action 在代码提交后，自动触发 X-Developer 团队效能分析并通知分析结果。

> [X-Developer](https://x-developer.cn) 由场量科技研发，是全球第一款事实数据型研发效能度量分析平台。使用 X-Developer 平台及其开源工具，无需购买、设置或管理任何基础设施，您只需登录即可开始开展研发团队效能改进工作。目前，X-Developer 提供了最便捷、完整的研发效能度量解决方案，让您能够以开发者为中心展开改进活动，使您的团队能够围绕目标协同工作，及时同步项目进展，从而将他们从繁重的任务状态维护、项目报告工作中解放出来，集中精力完成研发工作，更好地编写代码，提高业务获得的价值。

## 如何使用

当用户向 GitHub 仓库推送或合并请求时，此 Action 使用 GitHub secrets 中配置的 `APPID` 和 `APPKEY`，完成 [X-Developer](https://x-developer.cn) 身份认证，并发送 `git log` csv 文件到 X-Developer 对应 `TEAMID` 的团队，完成效能分析。

### 1. 创建 X-Developer 帐户

访问 [X-Developer Site](https://x-developer.cn) 网站免费注册。

注册完成后，可在 [API](https://x-developer.cn/accounts/api) 页面查看您的 `APPID` `APPKEY` 。

### 2. 创建团队

- 免费用户只能创建公开的团队，**所有人均可查看到您的分析结果**，适用于开源项目。
- 私有项目仅对付费用户开放。

> 此 GitHub Action 面向任何用户均免费。

创建团队完成后，即可在 [API](https://x-developer.cn/accounts/api) 页面查看对应的 `TEAMID` 。

### 3. 创建 GitHub Secrets

进入仓库 setting -> secrets, 创建 `APPID` `APPKEY` `TEAMID` 并配置对应的值。

> 如果您使用 GitHub 组织，可以将 `APPID` `APPKEY` 配置在您的组织 `secrets` ，即可被所有仓库使用，以简化操作步骤。

### 4. 使用 Action

#### 开发分支

在开发分支上建立分析任务，用于帮助您近实时地管理团队日常开发活动，请配置 `workflow` 文件如下所示：

```yaml
on:
  push:
    branches: [ dev, test ]         # 非主干分支

jobs:
  analysis:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v1
      - name: X-Developer Analysis Action
        uses: FieldTech/x-developer-analysis-action@V1.2
        with:
          APPID: ${{ secrets.APPID }}
          APPKEY: ${{ secrets.APPKEY }}
          TEAMID: ${{ secrets.TEAMID }}
```

#### 主干

如果您需要统计发布的需求、任务或Issues，以及如合并、发布等活动，请对配置 `workflow` 文件如下所示：

```yaml
on:
  push:
    branches: [ master ]            # 主干分支

jobs:
  analysis:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v1
      - name: X-Developer Analysis Action
        uses: FieldTech/x-developer-analysis-action@V1.2
        with:
          APPID: ${{ secrets.APPID }}
          APPKEY: ${{ secrets.APPKEY }}
          TEAMID: ${{ secrets.TEAMID }}
          Master: True              # 将 Master 参数标记为 True
```
---

## Workflow 说明

X-Developer Action 完整的 Workflow 如下所示，分为构建 `Python` 环境、安装 `xdclient` 客户端与调用 `xdclient` 命令行执行分析三个步骤。

```yaml
name: X-Developer Analysis Action

on:
  push:
    branches: [ master ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v1

    - name: Setup Python 2.7
      uses: actions/setup-python@v1
      with:
        python-version: 2.7.18

    - name: Install X-Developer client
      run: pip install xdclient

    - name: Run X-Developer analysis
      env:
        APPID: ${{ secrets.APPID }}
        APPKEY: ${{ secrets.APPKEY }}
        TEAMID: ${{ secrets.TEAMID }}
      run: python -m xdclient -i $APPID -k $APPKEY -t $TEAMID -m True
```

## 示例项目

通过此链接即可查看分析效果：[示例项目](https://x-developer.cn/projects/)

## 许可证

项目中所有的脚本、文档都遵循 [MIT License](https://github.com/FieldTech/x-developer-analysis-actions/blob/master/LICENSE)。
