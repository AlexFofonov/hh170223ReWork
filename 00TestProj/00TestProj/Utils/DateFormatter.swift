//
//  MagicFormatter.swift
//  00TestProj
//
//  Created by Александр Фофонов on 27.01.2023.
//

import Foundation

// означает, что этот протокол будем использовать только с DateFormatter
protocol DateFormatterProtocol: DateFormatter {
    
    func string(from date: Date) -> String
    func date(from string: String) -> Date?
    
}

extension DateFormatter : DateFormatterProtocol {}
