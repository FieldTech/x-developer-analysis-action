# X-Developer Analysis Action

[![EN doc](https://img.shields.io/badge/document-English-blue.svg)](https://github.com/FieldTech/x-developer-analysis-action/blob/master/README.md)
[![CN doc](https://img.shields.io/badge/文档-中文版-blue.svg)](https://github.com/FieldTech/x-developer-analysis-action/blob/master/README-zh-cn.md)

This GitHub Action connects GitHub and [X-Developer](https://x-developer.cn) service - Git Analytics Platform for Engineering Productivity.

## Usage

This Action retrieves the Git log from CI workspace directly during the process in a workflow job. The user must specify X-Developer account ID-key and team id in GitHub secrets.

### 1. Create X-Developer account

Enter [X-Developer Site](https://x-developer.cn) and register an account for free.

Get your `APPID` `APPKEY` from [API](https://x-developer.cn/accounts/api) page.

### 2. Create team

- For free users, you could only create public team, **which will be listed in [X-Developer Explore](https://x-developer.cn) but only developers have permission to access internal reports,** we recommend this to **open source projects.**
- Private team is only for paid users.

> This GitHub Action is free for all the users.

Once you created a team, check your `TEAMID` from [API](https://x-developer.cn/accounts/api) page.

### 3. Create GitHub secrets

Enter your repository setting -> secrets, create `APPID` `APPKEY` `TEAMID` and specify the values.

> You could create `APPID` and `APPKEY` in organization `secrets` if you're working in an organization.

### 4. Config action

#### On develop/test branches

To analysis daily activities on non-master branches, please create a `workflow` yaml file as below:

```yaml
on:
  push:
    branches: [ dev, test ]     # Non-master branches

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

#### On Master

To analysis publish or pull request activities on `master` branch, please create a `workflow` yaml file as below (specify Master parameter to True):

```yaml
on:
  push:
    branches: [ master ]        # master branch

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
          Master: True          # specify master parameter to True
```

---

## Workflow introduction

It has three steps as below: setup `Python` environment, install `xdclient` and run `xdclient` command line.

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

## Demo

Feel free to access these [Demo Projects](https://x-developer.cn/projects/).

## Support

Any question or request, please contact us via [support@withfield.tech](mailto:support@withfield.tech)

## License

All the scripts and documentation in this project under the [MIT License](https://github.com/FieldTech/x-developer-analysis-actions/blob/master/LICENSE).
