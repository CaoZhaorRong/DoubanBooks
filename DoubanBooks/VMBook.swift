//
//  VMBook.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/14.
//  Copyright © 2019 2017yd. All rights reserved.
//

import Foundation
import CoreData
class VMBook:NSObject,DateViewModelDelegate{
 
    
     var author: String?
     var authorIntro: String?
     var categoryId: UUID?
     var id: UUID
     var image: String?
     var isbn10: String?
     var isbn13: String?
     var pages: Int32?
     var price: String?
     var pubdate: String?
     var publisher: String?
     var summary: String?
     var title: String?
     var binding: String?
    
    override init() {
        self.id = UUID()
    }
    
    static let entityName = "Book"
    static let colId = "id"
    static let colImage = "image"
    static let colAuthor = "author"
    static let colAuthorIntro = "authorIntro"
    static let colCategoryId = "categoryId"
    static let colIsbn10 = "isbn10"
    static let colIsbn13 = "isbn13"
    static let colPages = "pages"
    static let colPrice = "price"
    static let colPubdate = "pubdate"
    static let colPublisher = "publisher"
    static let colSummary = "summary"
    static let colTitle = "title"
    static let colBinding = "binding"
    
    func entityPairs() -> Dictionary<String, Any?> {
        var dic : Dictionary<String,Any?> = Dictionary<String,Any?>()
        dic[VMBook.colId] = id
        dic[VMBook.colImage] = image
        dic[VMBook.colTitle] = title
        dic[VMBook.colCategoryId] = categoryId
        dic[VMBook.colPages] = pages
        dic[VMBook.colPrice] = price
        dic[VMBook.colAuthor] = author
        dic[VMBook.colIsbn10] = isbn10
        dic[VMBook.colIsbn13] = isbn13
        dic[VMBook.colBinding] = binding
        dic[VMBook.colPubdate] = pubdate
        dic[VMBook.colSummary] = summary
        dic[VMBook.colPublisher] = publisher
        dic[VMBook.colAuthorIntro] = authorIntro
        return dic
    }
    
    func packageSelf(result: NSFetchRequestResult) {
        let book = result as! Book
            id = book.id!
            image = book.image
            title = book.title
            categoryId = book.categoryId
            pages = book.pages
            price = book.price
            author = book.author
            isbn10 = book.isbn10
            isbn13 = book.isbn13
            binding = book.binding
            pubdate = book.pubdate
            summary = book.summary
            publisher = book.publisher
            authorIntro = book.authorIntro
    }
}
