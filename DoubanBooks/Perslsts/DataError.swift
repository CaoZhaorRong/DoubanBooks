//
//  DataError.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/12.
//  Copyright © 2019 2017yd. All rights reserved.
//

import Foundation
enum DataError:Error{
    case readCollectionError(String)
    case readSingleerror(String)
    case entityExtistsError(String)
    case deleteEntityError(String)
    case updateEntityError(String)
}
