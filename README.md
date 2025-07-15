# Home Assistant OS H618-k2b & rk3399-custom Build System


本工程以 Home Assistant OS 官方源码为子模块，自动拉取并编译。通过本地 haos-overlay 目录结构，覆盖和定制官方源码配置，实现新开发板的快速适配。

本工程为 Home Assistant OS 在 Allwinner H618-k2b 和 Rockchip RK3399 平台的完整构建系统，支持内核、U-Boot、固件、根文件系统、分区镜像等一站式自动化编译与打包。

---

## 系统功能 

- ✅主板适配：H681-kicpi-K2B、rk3399 like pc(一块类似rk3399pc的板子，姑且命名为rk3399-custom) 
- ✅完整官方HAOS功能
- ✅丰富的官方加载项
- ✅OTA升级功能
- ✅无终端配网
- ✅WIFI、有线网络、蓝牙
- ✅http://homeassistant.local:4000 后台管理
---

## 目录结构说明

本项目主要目录结构如下：

- `build.sh`：一键编译脚本，支持多平台参数。
- `haos-overlay/`：本地定制与覆盖目录，结构与官方源码一致。
- `operating-system/`：官方 Home Assistant OS 源码子模块。
- `output/`：编译生成的所有产物，包括镜像、固件、分区文件等。
- `Documentation/`：平台、配置、开发相关文档说明。
- `scripts/`：辅助脚本，如工具链下载、内核更新等。
- `tests/`：自动化测试相关内容。

详细目录请参考各文件夹下 README 或注释。

---

## 快速开始

### 1. 环境准备(ubuntu24)
- 推荐 Ubuntu 24.04+，需安装 `docker`、`git` 等常用工具。
- 工程会自动下载和准备交叉编译工具链，无需手动配置。
```bash

# 下载代码 
git clone --recurse-submodules https://github.com/LanSilence/haos-ace.git

# docker 安装
sudo apt update
sudo apt install apt-transport-https curl

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# 添加软件源，如果是低于ubuntu24 版本，添加源的方式有所不同
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 更新软件包列表
sudo apt update

# 安装 Docker
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### 2. 一键编译

以 H618-k2b 为例：
```bash
./build.sh k2b_h618
```

以 rk3399-custom 为例：
```bash
./build.sh rk3399-custom
```

编译流程包括：


### 3. 产物说明

编译完成后，主要产物位于 `output/images/` 目录，包括：

- 系统镜像（如 `haos_boardid-version.img.xz`）：用于烧录到存储介质，直接启动。
- 升级文件（如 `haos_k2b-h618-16.0.raucb`）：用于OTA升级。

不同平台产物名称略有差异，具体请参考 `output/images/` 目录内容。


---

## 开发与定制

### 覆盖机制说明

主要机制如下：
- 官方源码作为子模块管理，自动同步最新代码。
- 本地 haos-overlay 目录结构与官方源码一致，支持任意文件的定制与覆盖。
- 编译流程自动应用本地修改，优先使用本地配置，无需直接改动官方源码。
- 适配新开发板只需在 overlay 目录下按官方结构添加/修改配置文件。
- 优先级：本地修改 > 官方配置

### 适配新开发板

```bash
# 以适配 new-board 为例
mkdir -p haos-overlay/buildroot-external/board/new-board/
touch haos-overlay/buildroot-external/configs/new-config_defconfig
# 添加/修改配置文件

# 一键编译
./build.sh new-config
```

## 主要功能与特性
- 支持多平台（H618-k2b、rk3399-custom）一键切换与编译
- OTA 在线升级与断点续传
- 无终端配网，支持 USB/网页多种方式
- 支持 WIFI、有线网络、蓝牙
- 后台管理页面：性能监控、日志、系统更新、恢复出厂、指示灯控制等
- 支持多种开发板快速适配与扩展


---

### 上电开机与网络配置
- 上电后需先配置网络。
- H618-kickpi 当前有线网口已适配，推荐使用 5G WiFi。

#### 配网方式
1. USB 配网：
   - 使用 Type-C 线连接电脑 USB 口。
   - 打开串口终端（推荐 mobaxterm、windterm），波特率任意（模拟串口）。
   - 打开后无提示，直接输入：
     ```
     wifi -s <ssid> -p <passwd>
     ```
   - 连接成功后会显示获取到的 IP。
2. 电脑浏览器访问 `http://<ip>:4000` 进入管理后台。
3. 建议重启后再访问 `http://<ip>:8123` 进入 Home Assistant 页面。

---

### 后台管理功能
- 性能监控
  ![性能监控](doc/image.png)
- 日志查看
- 系统更新
![alt text](doc/image-3.png)
- 恢复出厂设置
- 系统重启
- 指示灯控制
- 网络升级包在线升级、支持升级打断
- FRP 配置文件修改
- 版本信息查看
![alt text](doc/image-2.png)
> 可将管理页面添加到 Home Assistant 导航栏，便于快速访问。

## 指示灯说明
- 指示灯常亮：系统正常启动
- 指示灯快闪：未连接无线或者有线
- 指示灯慢闪：无线或者有线已连接，但无网络
- 指示灯心跳：网络连接正常
- 指示灯长灭：人为关闭指示灯或者系统未启动

---

## 常见问题

### Q: 工程找不到工具链？
A: 首次编译会自动下载并解压 toolchain，无需手动干预。

### Q: 如何定制内核/U-Boot配置？
A: 修改 `board/<平台>/linux-config` 或 `uboot-config`，重新编译即可。

### Q: 如何添加/修改分区布局？
A: 修改 `genimage/` 下的分区配置文件（如 `partitions-os-mbr.cfg`、`hdimage-mbr.cfg` 等）。

### Q: 如何定制根文件系统？
A: 修改 `ubuntu/rootfs-overlay/` 目录内容，或自定义 `mk-rootfs.sh` 脚本。

---

## 参考文档
- `doc/编译h618.md`：H618 平台编译说明
- `doc/需要挂载的分区.md`：分区挂载说明
- 官方 Home Assistant OS 文档
- 各 SoC 官方文档（Allwinner、Rockchip）

---

## 维护者
- 本工程由 Home Assistant OS 社区爱好者维护
- 如有问题请提交 issue 或 PR

---

## License
本工程遵循 GPLv2/MIT 等开源协议，详见各源码目录 LICENSE 文件。
