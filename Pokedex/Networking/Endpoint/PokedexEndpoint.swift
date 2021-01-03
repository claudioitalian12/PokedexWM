//
//  PokedexEndpoint.swift
//  Pokedex
//
//  Created by claudio cavalli on 27/12/20.
//

import Foundation

enum PokedexEndpoint {
    case pokedex(offset: String)
    case pokemon(id: String)
    case artwork(id: String)
}

extension PokedexEndpoint: Endpoint {
    var base: String {
        switch self {
        case .pokedex, .pokemon: return "https://pokeapi.co"
        case .artwork: return "https://raw.githubusercontent.com"
        }
    }
    
    var path: String {
        switch self {
        case .pokedex: return "/api/v2/pokemon"
        case .pokemon(let id): return "/api/v2/pokemon/\(id)"
        case .artwork(let id): return "/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .pokedex(let offset): return [ URLQueryItem(name: "offset", value: offset), URLQueryItem(name: "limit", value: "10") ]
        default: return []
        }
    }
}
