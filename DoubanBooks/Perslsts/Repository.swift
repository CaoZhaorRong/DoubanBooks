//
//  Repository.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/15.
//  Copyright © 2019 2017yd. All rights reserved.
//

import Foundation
import CoreData
class Repository<T:DateViewModelDelegate> where T:NSObject{
    ///类约束:定义协议进行约束
    
    var app:AppDelegate
    var context:NSManagedObjectContext
    
    init(_ app:AppDelegate) {
        self.app = app
        context = app.persistentContainer.viewContext
    }
    
    /// 插入数据
    func insert(vm:T){
        let desription = NSEntityDescription.entity(forEntityName: T.entityName, in: context)
        let obj = NSManagedObject(entity: desription!, insertInto: context)
        
        for(key,value) in vm.entityPairs(){
            obj.setValue(value, forKey: key)
        }
        app.saveContext()
    }
    
    /// 获取视图模型数据集合
    /// -returns 视图模型对象集合
    func get() throws -> [T]{
        var obj = [T]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        do {
            let result = try context.fetch(fetch)
            
            for item in result{
                let t = T()
                t.packageSelf(result: item as! NSFetchRequestResult)
                obj.append(t)
            }
            
             return obj
        } catch  {
            throw DataError.readCollectionError("读取集合数据失败")
        }
       
    }
    
    /// 根据关键词查询，模糊查询
    /// -parameter cols：z需要匹配的咧如：["name","publisher"]
    /// -parameter keyword 搜索关键词
    /// -returns 视图模型对象集合
    func getBy(_ cols:[String],keywrod:String,_ isb:Bool) throws -> [T]{
        var obj = [T]()
        var format = ""
        var args = [String]()
        for col in cols {
            if isb {
                format += "\(col) = %@ || "
                args .append(keywrod)
            }else{
                format += "\(col) like[c] %@ || "
                args .append("*\(keywrod)*")
            }
        }
        format.removeLast(3)
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
          fetch.predicate = NSPredicate(format: format, args)
        do {
            let result = try context.fetch(fetch)
            for item in result{
                let t = T()
                t.packageSelf(result: item as! NSFetchRequestResult)
                obj.append(t)
            }
            
            return obj
        } catch  {
            throw DataError.readCollectionError("读取集合数据失败")
        }
        
    }
    
    
    /// 根据关键词判断数据是否存在
    /// -parameter cols：z需要匹配的咧如：["name","publisher"]
    /// -parameter keyword 搜索关键词
    /// -returns true
    func isEntityExists(_ cols:[String],keywrod:String)throws -> Bool{
        ///定义where 子句
        var format = ""
        var args = [String]()
        for col in cols {
            format += "\(col) = %@ || "
            args .append(keywrod)
        }
        format.removeLast(3)
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: format, args)
        do {
            let result = try context.fetch(fetch) as! [T]
            return result.count>0;
        } catch  {
            throw DataError.entityExtistsError("检查是否存在数据出错")
        }
    }
  
    /// 根据视图模型的id进行删除
    /// -parameter id：视图模型的uuid
    /// -parameter
    /// -returns
    func delete(id:UUID)throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", id.uuidString)
        do {
            let obj = try context.fetch(fetch)[0] as! NSManagedObject
                context.delete(obj )
            ///只有被托管对象才能调用context方法进行保存
            app.saveContext()
        } catch  {
            throw DataError.deleteEntityError("删除数据失败！")
        }
    }
    
    /// 根据视图模型的id进行更新
    /// -parameter id：视图模型的uuid
    /// -parameter
    /// -returns
    func update(vm:T)throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", vm.id.uuidString)
        do {
            let obj = try context.fetch(fetch)[0] as! NSManagedObject
            for(key,value) in vm.entityPairs(){
                obj.setValue(value, forKey: key)
            }
            app.saveContext()
        } catch  {
            throw DataError.updateEntityError("更新数据失败！")
        }
        
    }
    
}
