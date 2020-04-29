//
//  main.swift
//  CopyKit
//
//  Created by 李腾芳 on 2020/4/27.
//  Copyright © 2020 HSBC Holdings plc. All rights reserved.
//

// description
// 读取指定文件夹的strings 文件
// 将其转换为swift文件
// 写入到指定路径

// TODO: 区分 绝对路径和相对路径
// 2. TODO: bundle 需要动态处理,bundleConvertible 协议
// 3. TODO: 批量读取文件
// 5. TODO: 校验是否某个文件key缺少

// TODO: 校验strings file md5 值 和pod原理差不多，使用lock文件锁住，这样的话，不需要每次都重新生成souce code文件
// TODO: hook git的commit 操作，只有在strings file改动下，才运行该脚本
// TODO: 写一个demo
// TODO: 更新文档

import Commandant
import Foundation

struct ArgumentsError: Error {
}

struct CopyConvertCommand: CommandProtocol {
    typealias Options = CopyConvertOptions

    typealias ClientError = ArgumentsError

    let verb = "convert"
    let function = "convert strings to swift file"

    func run(_ options: CopyConvertOptions) -> Result<(), ArgumentsError> {
        // Use the parsed options to do something interesting here.

        let outPath = options.outPath

        let folderPath = options.folderPath

        let copyBundleCovertibleClassName = options.copyBundleCovertibleClassName

        let manager = StringsConvertManager(outPath: outPath, folderPath: folderPath, copyBundleCovertibleClassName: copyBundleCovertibleClassName)
        do {
            try manager.convertStringsFile()
            return Result<(), ArgumentsError>.success(())
        } catch {
            return Result<(), ArgumentsError>.failure(ArgumentsError())
        }
    }
}

struct CopyConvertOptions: OptionsProtocol {
    let outPath: String
    let folderPath: String
    let copyBundleCovertibleClassName: String

    static func create(_ outPath: String) -> (String) -> (String) -> CopyConvertOptions {
        return { folderPath in { copyBundleCovertibleClassName in CopyConvertOptions(outPath: outPath, folderPath: folderPath, copyBundleCovertibleClassName: copyBundleCovertibleClassName) } }
    }

    static func evaluate(_ m: CommandMode) -> Result<CopyConvertOptions, CommandantError<ArgumentsError>> {
        return create
            <*> m <| Option(key: "outPath", defaultValue: "0", usage: "the strings file output path")
            <*> m <| Option(key: "folderPath", defaultValue: "false", usage: "strings file bundle path")
            <*> m <| Option(key: "copyBundleCovertibleClassName", defaultValue: "false", usage: "copyBundleCovertibleImplClassName")
        //       <*> m <| Argument(usage: "the log to read")
    }
}

let commands = CommandRegistry<ArgumentsError>()
commands.register(CopyConvertCommand())
commands.register(HelpCommand(registry: commands))

var arguments = CommandLine.arguments

// Remove the executable name.
assert(!arguments.isEmpty)
arguments.remove(at: 0)

if let verb = arguments.first {
    // Remove the command name.
    arguments.remove(at: 0)

    if let result = commands.run(command: verb, arguments: arguments) {
        // Handle success or failure.
        switch result {
        case .success(()):
            print("*** success ***")
        case let .failure(error):
            print(error)
            exit(-1)
        }

    } else {
        // Unrecognized command.
        print("Unrecognized command.")
        exit(-1)
    }
} else {
    // No command given.
    print("No command given")
    exit(-1)
}
