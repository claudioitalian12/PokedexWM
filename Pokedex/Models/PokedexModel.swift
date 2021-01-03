//
//  PokedexModel.swift
//  Pokedex
//
//  Created by claudio cavalli on 27/12/20.
//

struct Pokedex: Decodable {
    // MARK: property
    var results: [NamedAPIResource]
}
