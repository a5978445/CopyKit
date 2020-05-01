CopyKit
=====

## 描述
优雅的语言国际化方案，自动读取strings file ，生成source code, 让手动更新copy成为历史


## 怎样集成
* download 代码，并且编译CopyKit
* 将CopyKit/Core/CopyBundleCovertible.swift copy 到你的主工程
* 定义一个主体类，支持CopyBundleCovertible 协议
* 添加build script,例如：

```sh

# `${SRCROOT}/tools/CopyKit` 编译生成的脚本程序
# 具体参数意义详见：`${SRCROOT}/tools/CopyKit  help convert`

${SRCROOT}/tools/CopyKit  convert --folderPath ${SRCROOT}/SampleApp/Resource/HK.bundle --copyBundleCovertibleClassName CopyBundleProvider --outPath ${SRCROOT}/SampleApp/Resource


```



* 将生成的source code文件加入project即可
* 最后你只需要一句代码即可以实现国际化，例如：

```swift
titleLabel.text = Strings.Home.helloWorld.localized()

```

## Demo
本Demo不仅演示了,多语言，还简单演示多地区，相信足以覆盖绝大部分使用场景