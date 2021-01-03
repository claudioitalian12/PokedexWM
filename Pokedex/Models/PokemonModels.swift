//
//  PokemonModels.swift
//  Pokedex
//
//  Created by claudio cavalli on 27/12/20.
//

import UIKit

struct Pokemon: Decodable {
    // MARK: property
    let id: String
    let name: String
    let weight: String
    let height: String
    let stats: [PokemonStat]
    var types: [PokemonType]
    
    private enum CodingKeys: String, CodingKey {
        case id, name, types, stats, weight, height
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Pokemon.CodingKeys.self)
        name = try container.decode(String.self, forKey: .name).uppercased()
        types = try container.decode([PokemonType].self, forKey: .types).reversed()
        stats = try container.decode([PokemonStat].self, forKey: .stats)
        let weight = try container.decode(Int.self, forKey: .weight)
        let height = try container.decode(Int.self, forKey: .height)
        let number = try container.decode(Int.self, forKey: .id)
        self.id = String(number)
        self.weight = "\(CGFloat(weight)/10) KG"
        self.height = "\(CGFloat(height)/10) M"
    }
}

struct PokemonType: Decodable {
    // MARK: property
    let type: NamedAPIResource
}

struct PokemonStat: Decodable {
    // MARK: property
    let stat: NamedAPIResource
    let base_stat: CGFloat
    
    private enum CodingKeys: String, CodingKey {
        case stat, base_stat
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonStat.CodingKeys.self)
        stat = try container.decode(NamedAPIResource.self, forKey: .stat)
        let base_stat = try container.decode(Int.self, forKey: .base_stat)
        self.base_stat = CGFloat(base_stat)
    }
}
