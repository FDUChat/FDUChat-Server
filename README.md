# FDUChat-Server

##Documentation

###Basic Information

###Model

``User``
``INT id, TEXT username, TEXT password, TEXT portrait, INT contact_id, TEXT location, INT gender``

``Contact``
``INT id, TEXT contacts(json)``

``Moments``
``INT id, INT sender, TEXT mentioned(json), TEXT content, TEXT comments(json)``

``Comments``
``INT id, TEXT mentioned(json), TEXT content``

``Message``
``INT id, INT sender, INT receiver, TEXT content``

###API

####用户操作

#####注册用户

```
POST http://ip/users/

{
  "username": a,
  "password": b
}
```

#####用户登录

```
POST http://ip/login

{
  "username": a,
  "password": b
}
```

#####更新用户信息

```
PUT http://ip/users/id

{
  "password": a,
  "portrait": b,
  "location": c,
  "gender": d
}
```

#####更新用户分组

```
PUT http://ip/user/user_id/contact/

{
  "contacts":
  [
    {
      "groupname": a,
      "users": [uid0, uid1...]
    },
    ...
  ]
}
```
