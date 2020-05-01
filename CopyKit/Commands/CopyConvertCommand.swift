//
//  CopyConvertCommand.swift
//  CopyKit
//
//  Created by 李腾芳 on 2020/4/29.
//  Copyright © 2020 HSBC Holdings plc. All rights reserved.
//

import Cocoa
import Commandant

enum ArgumentsError: Error {
    case wraped(Error)
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

        let manager = StringsConvertManager(outPath: outPath, folderPath: folderPath, copyBundleCovertibleClassName: copyBundleCovertibleClassName, platform: options.platform)
        do {
            try manager.convertStringsFile()
            return Result<(), ArgumentsError>.success(())
        } catch {
            return Result<(), ArgumentsError>.failure(ArgumentsError.wraped(error))
        }
    }
}

struct CopyConvertOptions: OptionsProtocol {
    let outPath: String
    let folderPath: String
    let copyBundleCovertibleClassName: String
    let platform: String

    static func create(_ outPath: String) -> (String) -> (String) -> (String) -> CopyConvertOptions {
        return {
            folderPath in {
                copyBundleCovertibleClassName in {
                    platform in CopyConvertOptions(outPath: outPath, folderPath: folderPath, copyBundleCovertibleClassName: copyBundleCovertibleClassName, platform: platform)
                }
            }
        }
    }

    static func evaluate(_ m: CommandMode) -> Result<CopyConvertOptions, CommandantError<ArgumentsError>> {
        return create
            <*> m <| Option(key: "outPath", defaultValue: "0", usage: "the source code files output path")
            <*> m <| Option(key: "folderPath", defaultValue: "false", usage: "strings file bundle path")
            <*> m <| Option(key: "copyBundleCovertibleClassName", defaultValue: "false", usage: "copyBundleCovertibleImplClassName: this class implementation copyBundleCovertible protocol, can't empty")
            <*> m <| Option(key: "platform", defaultValue: "iOS", usage: "platform: iOS or MacOS")
       //     <*> m <| Argument(usage: "the log to read")
    }
}
