# Contacts-backend 

## 简介
一个简单的联系人管理后端 API 系统

## 功能
- JWT(Json Web Token) 登录注册
- 联系人 CRUD

## Quick start

```
$ bundle install
$ rake db:create
$ rake db:migration
$ rake db:seed_fu #初始化数据
$ puma -p 3005  # 启动 webserver
```