//
//  main.swift
//  CopyKit
//
//  Created by 李腾芳 on 2020/4/27.
//  Copyright © 2020 HSBC Holdings plc. All rights reserved.
//

import Foundation


// description
// 读取指定文件夹的strings 文件
// 将其转换为swift文件
// 写入到指定路径
// 使用swiftformat 进行格式化处理

// 入参
// 1. bundle 路径
// 2. 输出路径
// 3. CopyBundleCovertible 实例类名







//let path = "/Users/litengfang/Desktop/FHAppArchitecture/FHAppArchitecture/en.lproj/copy.strings"
let outPath = "/Users/litengfang/Desktop/FHAppArchitecture/FHAppArchitecture"

let folderPath = "/Users/litengfang/Desktop/FHAppArchitecture/FHAppArchitecture/HK.bundle"

let CopyBundleCovertibleClassName = "DefaultBundle"

let bundleURL = URL(fileURLWithPath: folderPath)
// 查找指定文件夹下的 .lproj 文件
// 由于不同语言的 .lproj key是相同的，所以这里只检查一种语言的key
// 这里默认检查en
let region = "en.lproj"

//guard let bundleURL = bundleURL else {
//    fatalError("not found path: \(folderPath)")
//}


let folders: [URL]
do {
   folders = try FileManager.default.contentsOfDirectory(at: bundleURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
    

} catch  {
    throw error
}

let lprojs = folders.filter { $0.lastPathComponent == region }
guard lprojs.count > 0 else {
    print("not found \(region) in \(folderPath)")
    exit(-1)
}

let regionlproj = lprojs[0]

let stringsFile: [URL]
do {
   stringsFile = try FileManager.default.contentsOfDirectory(at: regionlproj, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
    .filter {  $0.pathExtension == "strings"}
    

} catch  {
    throw error
}

for file in stringsFile {
    // 1. TODO: key 需要做处理， 首字母小写， 去除下划线，并且将接下来的那个字母大写
    // 2. TODO: bundle 需要动态处理,bundleConvertible 协议
    // 3. TODO: 批量读取文件
    
    let fileName = file.lastPathComponent.components(separatedBy: ".")[0]
    
    
    guard let dic = NSDictionary(contentsOf: file) as? [String: String] else {
        print("invalid file: \(file)")
        exit(-1)
    }
    
    
    var result = "struct Strings {\n"
    
    result += "enum Copy: String {\n"
    
    for (key,_) in dic {
        result += "case \(key) = \"\(key)\"\n"
    }
    
    result += """
    func localized() -> String {
    return bundle().localizedString(forKey: rawValue, value: nil, table: "copy")
    }\n
    """
    result += """
    func bundle() -> Bundle {
    return \(CopyBundleCovertibleClassName).shared.asBundle()
    }\n
    """
    
    result += "}\n"
    
    result += "}\n"
    
    print(result)
    print("*****")
    try? result.write(to: URL.init(fileURLWithPath: outPath + "/\(fileName).swift"), atomically: true, encoding: String.Encoding.utf8)
    
    print(dic)
}







print("Hello, World!")


