//
//  VMBookFactory.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/14.
//  Copyright © 2019 2017yd. All rights reserved.
//

import Foundation
final class BookFactory{
    var app:AppDelegate?
    ///var repository :BookRepository
    var repository :Repository<VMBook>
    private static var instance:BookFactory?
    
    private init(_ app:AppDelegate) {
        repository = Repository<VMBook>(app)
    }
    
    static func getInstance(_ app:AppDelegate) -> BookFactory{
        //先判断再实例化
        if let obj = instance{
            return obj
        }else{
            let token = "net.lzzy.factory.book"
            DispatchQueue.once(token: token, block: {
                if instance == nil{
                    instance = BookFactory(app)
                }
            })
            return instance!
        }
    }
    func isBookExtists(book:VMBook)throws -> Bool{
        var match10 = false
        var match13 = false
        if let isbn10 = book.isbn10 {
            if isbn10.count > 0 {
                match10 = try repository.isEntityExists([VMBook.colIsbn10], keywrod: isbn10)
            }
        }
        if let isbn13 = book.isbn13 {
            if isbn13.count > 0 {
                match13 = try repository.isEntityExists([VMBook.colIsbn13], keywrod: isbn13)
            }
        }
        return match10 || match13
    }
    
    func getAllBooks() throws -> [VMBook]{
        return try repository.get()
    }
    
    func searchBooks(keyword:String) throws -> [VMBook]{
        return try repository.getBy(
            [VMBook.colTitle,VMBook.colAuthor,VMBook.colIsbn13,VMBook.colSummary,VMBook.colPublisher], keywrod: keyword, false)
    }
    
    func getBooksOf(category id:UUID)throws -> [VMBook]{
           return try  repository.getBy([VMBook.colCategoryId], keywrod: id.uuidString, true)
    }
    
    func add(book: VMBook) ->(Bool,String?){
        do {
            if try isBookExtists(book: book){
                return (false,"同样的图书已经存在！")
            }else{
                repository.insert(vm: book)
                return (true,nil)
            }
        } catch DataError.entityExtistsError(let info) {
            return (false,info)
        }catch {
            return(false,error.localizedDescription)
        }
    }
    func removeBook(id:UUID) -> (Bool,String?){
        do {
            try repository.delete(id: id)
            return (true,"删除成功！")
        }catch DataError.deleteEntityError(let info){
            return (false,info)
        } catch  {
            return (false,error.localizedDescription)
        }
    }
    
    func update(book:VMBook) ->(Bool,String){
        do {
            try repository.update(vm: book)
            return (true,"更新成功！")
        } catch  {
            return (false,error.localizedDescription)
        }
    }
}

