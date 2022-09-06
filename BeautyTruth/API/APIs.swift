//
//  MoviesAPI.swift
//  ModernMVVM
//
//  Created by Vadym Bulavin on 2/20/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import Foundation
import Amplify
import Combine
import SwiftUI


enum APIs {
    static func GetProduct(code: String) -> AnyPublisher<ProductDTO, Error> {
        let hashedValue = code.hashedValue("Ls75O8z1q9Ep9Kz0")
        let base = URL(string: "http://digit-eyes.com/gtin/v2_0/?upc_code=\(code)&app_key=/9nOS+obsRF5&signature=\(hashedValue!)&language=en")!
        let agent = Agent()
        let request = URLComponents(url: base, resolvingAgainstBaseURL: true)?
            .request
        return agent.run(request!)
    }
}

private extension URLComponents {
    var request: URLRequest? {
        url.map { URLRequest.init(url: $0) }
    }
}

// MARK: - DTOs

struct ProductDTO: Codable, Identifiable {
    var id = UUID()
    var description: String?
    var brand: String?
    var ingredients: String?
    var image: URL?
    var upc_code: String?
    var return_message: String?
    var return_code: String?
    
    enum CodingKeys: String, CodingKey {
        case description, brand, ingredients, image, upc_code, return_message, return_code
    }
}
