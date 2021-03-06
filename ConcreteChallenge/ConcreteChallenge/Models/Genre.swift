//
//  Genre.swift
//  ConcreteChallenge
//
//  Created by Thiago  Wlasenko Nicolau on 01/11/18.
//  Copyright © 2018 Thiago  Wlasenko Nicolau. All rights reserved.
//

import Foundation
import RealmSwift

class GenreJSON: Decodable {
    var genres: [Genre]?
}


class Genre: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class AllGenres: Object {
    var genresList = List<Genre>()
}
