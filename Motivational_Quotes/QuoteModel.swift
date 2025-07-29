//
//  QuoteModel.swift
//  Motivational_Quotes
//
//  Created by Евгений Васильев on 29.07.2025.
//
import UIKit

struct QuoteData : Codable {
    var success : Bool
    var data : QuoteList
}

struct QuoteList: Codable {
    var quotes: [Quotes]
}

struct Quotes : Codable {
    var qoute : String
    var author : String
    var cathegory : String
}
