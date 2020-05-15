# X-Developer Analysis Action

- [English](https://github.com/FieldTech/x-developer-analysis-action/blob/master/README.md)
- [中文](https://github.com/FieldTech/x-developer-analysis-action/blob/master/README-zh-cn.md)

This GitHub Action connects GitHub and [X-Developer](https://x-developer.cn) service - Git Analytics Platform for Engineering Productivity.

## Usage

This Action authenticate with X-Developer server by GitHub secrets `APPID` and `APPKEY`, it send `git log` csv file to X-Developer team analysis service by `TEAMID` whenever users pushed to or merged pull requests to GitHub repository.

### Create Your X-Developer Account

Enter [X-Developer Site](https://x-developer.cn) and register an account for free.

Get your `APPID` `APPKEY` from [API](https://x-developer.cn/accounts/api) page.

### Create Your Team

- For free users, you could only create public analysis project, **it means everyone could access your team reports,** we recommend this to **opensource project teams.**
- Private project is only for paid users.

> This GitHub Action is free for all the users.

Once you created a project, check your `TEAMID` from [API](https://x-developer.cn/accounts/api) page.

### Create GitHub Secrets

Enter your repository setting -> secrets, create `APPID` `APPKEY` `TEAMID` and specify the values.

> You could create `APPID` and `APPKEY` in organization `secrets` if you're working in an organization.

### Config Action

To analysis activity on non-master branches, please create a `workflow` yaml file as below:

```
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

To analysis activity on `master` branch, please create a `workflow` yaml file as below (specify Master parameter to True):

```
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

Workflow introduction

It has three steps as below: setup `Python` environment, install `xdclient` and run `xdclient` command line.

```
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

## License

All the scripts and documentation in this project under the [MIT License](https://github.com/FieldTech/x-developer-analysis-actions/blob/master/LICENSE).
