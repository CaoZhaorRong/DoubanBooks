//
//  DateViewModelDelegate.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/15.
//  Copyright © 2019 2017yd. All rights reserved.
//

import Foundation
import CoreData
/**
 - 约束视图模型k类实现，暴露CoreDate entity相关属性及组装视图模型对象
 */
protocol DateViewModelDelegate {
    ///视图模型必须具有id
    var id:UUID {get}
    /// 视图模型对应的 coreDate entity的名称
    static var entityName:String {get}
    
    /// CoreDate Entity 属性与对应的 视图模型对象值集合
    ///
    /// - returns ：key是Coredate entity的各个属性的名称，any是对应值
    func entityPairs() -> Dictionary<String,Any?>
    
    ///
    /// - paraneter result : fetach方法查询结果
    func packageSelf(result:NSFetchRequestResult)
}
