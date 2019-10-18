//
//  BookRepository.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/14.
//  Copyright © 2019 2017yd. All rights reserved.
//

import Foundation
import CoreData
class BookRepository{
    var app:AppDelegate
    var context :NSManagedObjectContext
    
    init(_ app:AppDelegate) {
        self.app = app
        context = app.persistentContainer.viewContext
    }
    
    func insert(vm:VMBook){
        let desription = NSEntityDescription.entity(forEntityName: VMBook.entityName, in: context)
        let book = NSManagedObject(entity: desription!, insertInto: context)
        
        book.setValue(vm.id, forKey: VMBook.colId)
        book.setValue(vm.author, forKey: VMBook.colAuthor)
        book.setValue(vm.image, forKey: VMBook.colImage)
         book.setValue(vm.authorIntro, forKey: VMBook.colAuthorIntro)
         book.setValue(vm.pages, forKey: VMBook.colPages)
         book.setValue(vm.binding, forKey: VMBook.colBinding)
         book.setValue(vm.price, forKey: VMBook.colPrice)
         book.setValue(vm.categoryId, forKey: VMBook.colCategoryId)
         book.setValue(vm.isbn10, forKey: VMBook.colIsbn10)
         book.setValue(vm.isbn13, forKey: VMBook.colIsbn13)
         book.setValue(vm.publisher, forKey: VMBook.colPublisher)
         book.setValue(vm.pubdate, forKey: VMBook.colPubdate)
         book.setValue(vm.summary, forKey: VMBook.colSummary)
         book.setValue(vm.title, forKey: VMBook.colTitle)
         app.saveContext()
        
        
    }
    
    func get() throws -> [VMBook]{
        var book = [VMBook]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        do {
            let result = try context.fetch(fetch) as! [Book]
            for item in result{
                let vm = VMBook()
                vm.id = item.id!
                vm.image = item.image
                vm.author = item.author
                vm.authorIntro = item.authorIntro
                vm.binding = item.binding
                vm.categoryId = item.categoryId
                vm.isbn10 = item.isbn10
                vm.isbn13 = item.isbn13
                vm.pages = item.pages
                vm.pubdate = item.pubdate
                vm.publisher = item.publisher
                vm.price = item.price
                vm.summary = item.summary
                vm.title = item.title
                book.append(vm)
            }
        } catch  {
            throw DataError.readCollectionError("读取集合数据失败")
        }
        return book
    }
    
    func isExists(isbn:String) throws -> Bool{
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        fetch.predicate = NSPredicate(format: "\(VMBook.colIsbn10)=%@ || \(VMBook.colIsbn13)=%@", isbn,isbn)
        do {
            let result = try context.fetch(fetch) as! [VMBook]
            return result.count>0;
        } catch  {
            throw DataError.entityExtistsError("检查是否存在数据出错")
        }
    }
    
    func delete(id:UUID)throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", id.uuidString)
        do {
            let result = try context.fetch(fetch)
            for m in result{
                context.delete(m as! NSManagedObject )
            }
            //只有被托管对象才能调用context方法进行保存
            app.saveContext()
        } catch  {
            throw DataError.deleteEntityError("删除图书错误！")
        }
       
    }
    
    func update(vm:VMBook)throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", vm.id.uuidString)
        do {
            let obj = try context.fetch(fetch)[0] as! NSManagedObject
            obj.setValue(vm.id, forKey: VMBook.colId)
            obj.setValue(vm.author, forKey: VMBook.colAuthor)
            obj.setValue(vm.image, forKey: VMBook.colImage)
            obj.setValue(vm.authorIntro, forKey: VMBook.colAuthorIntro)
            obj.setValue(vm.pages, forKey: VMBook.colPages)
            obj.setValue(vm.binding, forKey: VMBook.colBinding)
            obj.setValue(vm.price, forKey: VMBook.colPrice)
            obj.setValue(vm.categoryId, forKey: VMBook.colCategoryId)
            obj.setValue(vm.isbn10, forKey: VMBook.colIsbn10)
            obj.setValue(vm.isbn13, forKey: VMBook.colIsbn13)
            obj.setValue(vm.publisher, forKey: VMBook.colPublisher)
            obj.setValue(vm.pubdate, forKey: VMBook.colPubdate)
            obj.setValue(vm.summary, forKey: VMBook.colSummary)
            obj.setValue(vm.title, forKey: VMBook.colTitle)
            app.saveContext()
        } catch  {
            throw DataError.updateEntityError("更新图书错误！")
        }
       
    }
    
    func getByKeyword(keyword format:String,args:[Any]) throws -> [VMBook]{
            var book = [VMBook]()
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        
        do {
            fetch.predicate = NSPredicate(format: format, argumentArray:args)
            
            let result = try context.fetch(fetch) as! [Book]
            for item in result{
                let vm = VMBook()
                vm.id = item.id!
                vm.image = item.image
                vm.author = item.author
                vm.authorIntro = item.authorIntro
                vm.binding = item.binding
                vm.categoryId = item.categoryId
                vm.isbn10 = item.isbn10
                vm.isbn13 = item.isbn13
                vm.pages = item.pages
                vm.pubdate = item.pubdate
                vm.publisher = item.publisher
                vm.price = item.price
                vm.summary = item.summary
                vm.title = item.title
                book.append(vm)
            }
             return book
        } catch  {
            throw DataError.readCollectionError("读取集合数据失败")
        }
    }
    
}
