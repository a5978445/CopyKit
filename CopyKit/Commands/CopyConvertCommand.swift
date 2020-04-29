//
//  CopyConvertCommand.swift
//  CopyKit
//
//  Created by 李腾芳 on 2020/4/29.
//  Copyright © 2020 HSBC Holdings plc. All rights reserved.
//

import Cocoa
import Commandant

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
