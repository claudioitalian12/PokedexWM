//
//  Networking.swift
//  Pokedex
//
//  Created by claudio cavalli on 01/05/2020.
//  Copyright © 2020 claudio cavalli. All rights reserved.
//

import Foundation

struct Networking<Model: Decodable> {
    typealias completionHandler = (Result<Model?, NetworkError>) -> Void
    
    static func getPokedex(offset: String, completion: @escaping completionHandler) {
        let request = PokedexEndpoint.pokedex(offset: offset).request
        
        self.dataTaskRequest(request: request) { result in
            completion(result)
        }
    }
    
    static func getPokemon(id: String, completion: @escaping completionHandler) {
        let request = PokedexEndpoint.pokemon(id: id).request
        
        self.dataTaskRequest(request: request) { result in
            completion(result)
        }
    }
}
