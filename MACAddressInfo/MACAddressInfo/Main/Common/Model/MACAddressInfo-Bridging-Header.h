//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

/**
 1. 在Swift中使用Objective-C类
 在Xcode6中新建文件(⌘+N)，选择Swift，然后系统框提示是否同时创建XXX-Bridging-Header.h文件(XXX为你的项目名称)，确定。
 这个自动创建出来的Bridging-Header.h文件是沟通Swift世界和Objective-C世界的桥梁。任何需要在Swift文件中使用的自定义Objective-C类，必需先引入此Header文件。
 
 假设项目名称为TestSwift，其中存在Objective-C类Note（在Note.m中定义）:
 
 @interface Note : NSObject
 - (void)log;
 @end
 
 想在Swift中引用这个类，首先需要在TestSwift-Bridging-Header.h文件中import Note：
 
 #import "Note.h"
 
 然后在Swift代码中就能使用Note了:
 
 class ViewController: UIViewController {
     override func viewDidLoad() {
         super.viewDidLoad()
 
         var a:Note = Note()
         a.log()
     }
 }
 
 
 2. 在Objective-C中使用Swift类
 想在Objective-C文件中引用Swift文件中定义的类，需要在Objective-C文件中引入一个特殊的头文件: XXX-Swift.h，假设项目名称为 TestSwift，那么这个需要引入的header文件为 TestSwift-Swift.h：
 
 假设存在Book类(在Book.swift文件中定义）：
 
 import Foundation
 
 class Book : NSObject {
     var title:String
 
     init() {
         self.title = "Default Book"
     }
 
     func log() {
         println(self.title)
     }
 }
 在需要引用Book类的Objective-C文件中，先引入TestSwift-Swift.h头文件 :
 #import "TestSwift-Swift.h"
 
 然后就能使用Book了：
 
 Book *book = [Book new];
 [book log];
 
 最后再啰嗦一句，XXX-Swift.h文件在项目中是不可见的（估计此文件在编译时自动生成），在使用时只需遵循苹果既定规则就OK了。
 */


@import Charts;
