# XrayR  修改版 一键安装指南

支持 VLESS + TCP + Reality 协议，兼容 NewV2board 面板。

## 快速安装

SSH 登录到新服务器（需要 root 权限），运行：

```bash
bash <(curl -Ls https://raw.githubusercontent.com/hk9999-png/siran-xrayr/main/install-xrayr.sh)
```

> 如果 GitHub raw 访问不了，先把 `install-xrayr.sh` 上传到服务器，然后 `bash install-xrayr.sh`。

脚本会自动完成：
1. 识别服务器架构（amd64 / arm64），无法识别时手动选择
2. 安装官方 XrayR 框架（systemd 服务、目录结构等）
3. 下载 wyx2685 修改版二进制文件替换官方版本
4. 启动 XrayR 服务

## 安装完成后

### 上传配置文件

将 `config.yml` 上传到服务器 `/etc/XrayR/config.yml`：

```bash
# 在本地执行，替换为你的服务器 IP
scp config.yml root@你的服务器IP:/etc/XrayR/config.yml
```

### 重启服务

```bash
XrayR restart
```

### 检查状态

```bash
# 查看运行日志
XrayR log

# 查看版本
XrayR version

# 查看服务状态
XrayR status
```

## 常用命令

| 命令 | 说明 |
|------|------|
| `XrayR start` | 启动 |
| `XrayR stop` | 停止 |
| `XrayR restart` | 重启 |
| `XrayR log` | 查看日志 |
| `XrayR status` | 查看状态 |
| `XrayR version` | 查看版本 |

## 注意事项

- 此版本基于 wyx2685 修改版 XrayR，支持 Reality 协议
- 官方 XrayR 0.9.4 **不支持** Reality，必须使用此修改版
- config.yml 中 Reality 节点需要配置 `DisableLocalREALITYConfig: true` 让面板下发 Reality 参数
- `VlessFlow: "xtls-rprx-vision"` 需写在 ApiConfig 中
- `CertMode` 设为 `none`（Reality 不使用传统证书）

## 文件说明

- `install-xrayr.sh` — 一键安装脚本
- `config.yml` — XrayR 配置文件模板
