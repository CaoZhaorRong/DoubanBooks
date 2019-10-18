//
//  CategoryFactory.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/14.
//  Copyright © 2019 2017yd. All rights reserved.
//

import CoreData
import Foundation
final class  CategoryFactory{
    //单例模式 类需要改为final 构造器为保护的
    var app:AppDelegate?
    var repository:Repository<VMCategory>
    //懒汉式不可直接赋值
    private static var instance : CategoryFactory?
    private init(_ app:AppDelegate) {
        repository = Repository<VMCategory>(app)
    }
    
    static func getInstance(_ app:AppDelegate) -> CategoryFactory{
        //先判断再实例化
        if let obj = instance{
            return obj
        }else{
            let token = "net.lzzy.factory.category"
            DispatchQueue.once(token: token, block: {
                if instance == nil{
                    instance = CategoryFactory(app)
                }
                })
            return instance!
        }
    }
    func getAllCategorys() throws -> [VMCategory]{
        return try repository.get()
    }
    
    func getBy(keyword:String) throws -> [VMCategory]{
        return try repository.getBy(
            [VMCategory.colId,VMCategory.colName], keywrod: keyword, false)
    }
    
    func add(category: VMCategory) ->(Bool,String?){
        do {
            if try repository.isEntityExists([VMCategory.colName], keywrod: category.name!){
                return (false,"同样的类别已经存在！")
            }else{
                repository.insert(vm: category)
                return (true,nil)
            }
        } catch DataError.entityExtistsError(let info) {
            return (false,info)
        }catch {
            return(false,error.localizedDescription)
        }
    }
    
    func getBookCountOf(category id:UUID) -> Int?{
        do{
            return try
            BookFactory.getInstance(app!).getBooksOf(category: id).count
        }catch{
            return nil
        }
    }
    
    func deleteCategory(id:UUID) -> (Bool,String?){
            if let count = getBookCountOf(category: id){
            if count > 0{
                     return (false,"存在类别图书，不能删除")
            }
            }else{
                return (false,"无法获取类别信息！")
            }
         do {
            try repository.delete(id: id)
            return (true,"删除成功！")
         } catch DataError.deleteEntityError(let info){
            return (false,info)
        } catch  {
            return (false,error.localizedDescription)
        }
    }
    
    func update(catefory:VMCategory) ->(Bool,String){
        do {
            try repository.update(vm: catefory)
            return (true,"更新成功！")
        } catch  {
            return (false,error.localizedDescription)
        }
    }
}


extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    public class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
}
