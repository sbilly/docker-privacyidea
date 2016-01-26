# docker-privacyIDEA

privacyIDEA 是一个双因素认证的服务器，支持多种双因素认证方案。

## 准备好 mysql 服务器

例如使用下面命令提供一个远程可以访问的 mysql 服务器

```bash
docker run --name mysql -ti -p 3306:3306 -e 'DB_REMOTE_ROOT_NAME=root' -e 'DB_REMOTE_ROOT_PASS=root' -e 'DB_REMOTE_ROOT_HOST=%' --rm sameersbn/mysql:latest
```

## 编辑 pi.cfg

编辑 config/etc/privacyidea/pi.cfg，确保 `SQLALCHEMY_DATABASE_URI` 和实际的 mysql 服务器配置匹配。为确保安全，最好修改 `SECRET_KEY` 和 `PI_PEPPER` 下面是一个例子：

```
# The realm, where users are allowed to login as administrators
SUPERUSER_REALM = ['super', 'administrators']
# Your database
SQLALCHEMY_DATABASE_URI = 'mysql://root:root@192.168.158.149:3306/privacyidea'
# This is used to encrypt the auth_token, Please CHANGE IT
SECRET_KEY = 'WH0C4R35!'
# This is used to encrypt the admin passwords, Please CHANGE IT
PI_PEPPER = "N0b0dyC4R3"
# This is used to encrypt the token data and token passwords
PI_ENCFILE = '/etc/privacyidea/enckey'
# This is used to sign the audit log
PI_AUDIT_KEY_PRIVATE = '/etc/privacyidea/private.pem'
PI_AUDIT_KEY_PUBLIC = '/etc/privacyidea//public.pem'
# PI_LOGFILE = '....'
# PI_LOGLEVEL = 20
# PI_INIT_CHECK_HOOK = 'your.module.function'
# PI_CSS = '/location/of/theme.css'
```

## 启动 docker-privacyidea

目前必须映射 `/etc/privacyidea`, `/etc/nginx/sites-available` 这两个目录

```bash
docker run -ti --rm -p 80:80 -v docker-privacyidea/config/etc/privacyidea:/etc/privacyidea -v docker-privacyidea/config/etc/nginx/sites-available:/etc/nginx/sites-available docker-privacyidea
```

## 增加用户

下面命令将会在 `0b6a74ce43e8` 这个 container 中增加一个用户名为 admin ，密码为 admin ，邮箱为 admin@nsa.gov 的管理用户。

```bash
docker exec 0b6a74ce43e8 sudo -u privacyidea /opt/privacyidea/venv/bin/python /opt/privacyidea/pi-manage admin add admin -e admin@nsa.gov -p admin
```