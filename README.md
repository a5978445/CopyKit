CopyKit
=====

## 目标
做一个copy管理的工具，读取strings file,自动生成source code

## Step
1. 生成单个文件夹下的copy 
2. 对不同的地区的copy 进行比对， 比对是否有缺失，例如en 下某个key缺失， 给出警告， 鉴于我们的app通常是多地区的，所以输入的文件夹可以是多个，或者某个文件下所有各个bundle