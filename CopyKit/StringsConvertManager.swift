//
//  StringsCovertManager.swift
//  CopyKit
//
//  Created by 李腾芳 on 2020/4/28.
//  Copyright © 2020 HSBC Holdings plc. All rights reserved.
//

import Cocoa

class StringsConvertManager: NSObject {
    //  输出路径
    var outPath: String

    // bundle 路径
    var folderPath: String

    // CopyBundleCovertible 实例类名
    var copyBundleCovertibleClassName: String

    init(outPath: String, folderPath: String, copyBundleCovertibleClassName: String) {
        self.outPath = outPath
        self.folderPath = folderPath
        self.copyBundleCovertibleClassName = copyBundleCovertibleClassName
    }

    func convertStringsFile() throws {
        let regionlprojURL = try getLprojFile(path: folderPath)

        let stringsFile = try getAllStringsFile(url: regionlprojURL)

        // 读取strings file
        try stringsFile.map { file -> (String, String) in

            let fileName = file.lastPathComponent.components(separatedBy: ".")[0]

            let result = try covertStringsFileToSwiftSourceCode(url: file)

            return (fileName, result)
        }
        // 写入指定文件
        .forEach { fileName, sourceString in
            try sourceString.write(to: URL(fileURLWithPath: outPath + "/\(fileName).swift"), atomically: true, encoding: String.Encoding.utf8)
        }
    }

    // 查找指定文件夹下的 .lproj 文件
    // 由于不同语言的 .lproj key是相同的，所以这里只检查一种语言的key
    // 这里默认检查en

    /// 获取指定目录下, lproj 文件路径
    /// - Parameters:
    ///   - path: 资源路径
    ///   - region: lproj name
    func getLprojFile(path: String, lprojName: String = "en.lproj") throws -> URL {
        var isDirectory: ObjCBool = false

        let lprojPath = "\(path)/\(lprojName)"

        guard FileManager.default.fileExists(atPath: lprojPath, isDirectory: &isDirectory) else {
            throw NSError(domain: "not found \(lprojName) in \(path)", code: 999, userInfo: nil)
        }

        if isDirectory.boolValue {
            return URL(fileURLWithPath: lprojPath)
        } else {
            throw NSError(domain: "\(lprojName) is not directory", code: 999, userInfo: nil)
        }
    }

    func getAllLprojFile(in path: URL) throws -> [URL] {
        let folders: [URL] = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])

        let lprojs = folders.filter { $0.pathExtension == "lproj" }
        guard lprojs.count > 0 else {
            throw NSError(domain: "not found lproj file in \(path)", code: 999, userInfo: nil)
        }

        return lprojs
    }

    /// 获取 ****.lproj 下所有strings 文件
    /// - Parameter url: lproj 文件路径名
    func getAllStringsFile(url: URL) throws -> [URL] {
        let stringsFile: [URL] = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
            .filter { $0.pathExtension == "strings" }
        return stringsFile
    }

    /// 根据.strings 生成对应的swift code
    /// - Parameter url: strings path
    func covertStringsFileToSwiftSourceCode(url: URL) throws -> String {
        guard let dic = NSDictionary(contentsOf: url) as? [String: String] else {
            throw NSError(domain: "invalid file: \(url)", code: 888, userInfo: nil)
        }

        var result = "struct Strings {\n"

        result += "\tenum Copy: String {\n"

        for (key, _) in dic {
            result += "\t\tcase \(mapKey(key)) = \"\(key)\"\n"
        }

        result += "\n"

        result += """
        \t\tfunc localized() -> String {
        \t\t\treturn bundle().localizedString(forKey: rawValue, value: nil, table: "copy")
        \t\t}\n
        """

        result += "\n"

        result += """
        \t\tfunc bundle() -> Bundle {
        \t\t\treturn \(copyBundleCovertibleClassName).shared.asBundle()
        \t\t}\n
        """

        result += "\t}\n"

        result += "}\n"

        print(result)
        print("*****")
        print(dic)
        return result
    }

    /// 将key 做一下处理，防止因为非法key，导致输出文件编译错误
    ///
    func mapKey(_ key: String) -> String {
        /// 将空格 转化为 _
        let key = key.replacingOccurrences(of: " ", with: "_")

        // 去掉空格，单词首字母大写
        let keys = key.split(separator: String.Element("_")).map { $0.capitalized }
        var resultKey = keys.reduce("") { $0 + $1 }

        // 首单词首字母小写
        if let firstLetter = resultKey.first {
            resultKey = resultKey.replacingCharacters(in: resultKey.startIndex ... resultKey.startIndex, with: firstLetter.lowercased())
        }

        return resultKey
    }
}
