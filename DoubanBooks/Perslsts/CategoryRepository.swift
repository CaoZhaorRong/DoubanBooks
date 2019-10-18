//
//  categoryRepository.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/12.
//  Copyright © 2019 2017yd. All rights reserved.
//

import Foundation
import CoreData
class CategoryRepository{
    
    var app:AppDelegate
    var context:NSManagedObjectContext
    
    init(_ app:AppDelegate) {
        self.app = app
        context = app.persistentContainer.viewContext
    }
    
    func insert(vm:VMCategory){
        let desription = NSEntityDescription.entity(forEntityName: VMCategory.entityName, in: context)
        let category = NSManagedObject(entity: desription!, insertInto: context)
        
            category.setValue(vm.id, forKey: VMCategory.colId)
            category.setValue(vm.name, forKey: VMCategory.colName)
            category.setValue(vm.image, forKey: VMCategory.colImage)
            app.saveContext()
       
      
    }
    
    func get(keyword:String? = nil) throws -> [VMCategory]{
        var category = [VMCategory]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        do {
            if let kw = keyword {
                fetch.predicate = NSPredicate(format: "name like[c] %@", "*\(kw)*")
            }
             let result = try context.fetch(fetch) as! [Category]
             for item in result{
                let vm = VMCategory()
                vm.id = item.id!
                vm.name = item.name
                vm.image = item.image
                category.append(vm)
            }
        } catch  {
            throw DataError.readCollectionError("读取集合数据失败")
        }
        return category
    }
    
    func isExists(name:String) throws -> Bool{
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
            fetch.predicate = NSPredicate(format: "\(VMCategory.colName)=%@", name)
        do {
            let result = try context.fetch(fetch) as! [VMCategory]
            return result.count>0;
        } catch  {
            throw DataError.entityExtistsError("检查是否存在数据出错")
        }       
    }
    
    func delete(id:UUID)throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", id.uuidString)
        do {
            let result = try context.fetch(fetch)
            for m in result{
                context.delete(m as! NSManagedObject)
            }
            //只有被托管对象才能调用context方法进行保存
            app.saveContext()
        } catch  {
            throw DataError.deleteEntityError("删除错误！")
        }
       
    }
    
    func update(vm:VMCategory)throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", vm.id.debugDescription)
        do {
            let result = try context.fetch(fetch) as! [Category]
            for item in result{
                item.name = vm.name
                item.image = vm.image
                app.saveContext()
            }
        } catch  {
            throw DataError.updateEntityError("更新错误！")
        }
        
    }
    
//    func getByKeyword(keyword:String?) throws -> [VMCategory]{
//        var category = [VMCategory]()
//        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
//        if let kw = keyword {
//            fetch.predicate = NSPredicate(format: "name like[c] %@", "*\(kw)*")
//        }
//        let result =  try context.fetch(fetch) as! [Category]
//        for item in result{
//            let vm = VMCategory()
//            vm.id = item.id!
//            vm.name = item.name
//            vm.image = item.image
//            category.append(vm)
//        }
//        return category
//    }
}
