# FDUChat-Server

##Documentation

###Basic Information

Powered by Sinatra (Ruby)

Gems rely on:
- sinatra
- sinatra-activerecord
- sinatra-reloader
- mysql
- jpush


###Model

``User``
``INT id, TEXT username, TEXT password, TEXT portrait, INT contact_id, TEXT location, INT gender``

``Contact``
``INT id, TEXT contacts(json)``

``Moments``
``INT id, INT sender, TEXT mentioned(json), TEXT content, TEXT comments(json)``

``Comments``
``INT id, TEXT mentioned(json), TEXT content``

###API

####用户操作

#####注册用户

```
POST http://ip/users/:username

{
  "username": a,
  "password": b
}

如果成功，返回
{
  "id": 202,
  "content": "register success"
}

如果密码字段缺失，返回代号 402 的错误（见Error Message）
如果用户存在，返回代号 401 的错误
```

#####用户登录

```
POST http://ip/login

{
  "username": a,
  "password": b
}

如果成功，返回
{
  "id": 201,
  "content": "login success"
}

如果用户不存在，返回 403 的错误
如果密码错误，返回 404 的错误
```

#####更新用户信息

```
PUT http://ip/users/:username

{
  "password": a,
  "portrait": b,
  "location": c,
  "gender": d
}


```

#####检查用户是否存在

```
GET http://ip/users/:username

如果成功，返回1，否则返回0
```

#####获得用户分组

```
GET http://ip/user/:username/contacts

如果成功，返回json
{
  contact:
  [
    "group_name": a,
    "friends": [username0, username1, ...]
  ],
  ...
}

```

#####更新用户分组

```
PUT http://ip/user/:username/contacts

{
  contacts:
  [
    {
      "group_name": a,
      "friends": [usn0, usn1...]
    },
    ...
  ]
}

如果成功，返回
{
  "id": 203,
  "content": "contact updated"
}
```

####消息操作

#####发送消息

```
POST http://ip/message/send

{
  "sender": a,
  "timestamp": b,
  "content": c,
  "receiver": d,
  "type": 1  # 1 是聊天消息, 2 是朋友圈更新消息
}

如果成功，返回JPush的成功发送信息（见JPush文档）
```

####朋友圈操作

#####发送朋友圈

```
POST http://ip/moments/send

{
  "sender": a,
  "timestamp": b,
  "content": c,
  "type": 2
}

```

#####获取朋友圈信息

```
GET http://ip/moments/:username

返回
{
  "moments":
  [
    {
      "timestamp": a,
      "content": b
    },
    ...
  ]
}

```

###Error Message

> 所有的错误信息均以json形式返回{"id": error_id, "content": error_explaination}

####基本错误

1. JSON不完整或是字段缺失
```
{
  "id": 400,
  "content": "Json is not valid"
}
```

####用户操作

1. 用户已经存在
```
400, User already exists
```

2. 密码缺失
```
401, Password missed
```

3. 用户不存在
```
403, No such user
```

4. 密码错误
```
404, Wrong password
```
