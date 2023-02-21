//
//  ApiClient.swift
//  00TestProj
//
//  Created by Александр Фофонов on 03.02.2023.
//

import Foundation

class ApiClient {
    
    // человеческое название
    enum Error: Swift.Error {
        case callerDestroyed
        case urlNotFound
        case dataInitFail
        case decodingFail
        
        // развертка ошибки
        var description: String {
            switch self {
            case (.callerDestroyed):
                return "Объект, вызывающий данную функцию был уничтожен"
            case (.dataInitFail):
                return "Ошибка в инициализации объекта Data с заданным URL"
            case (.decodingFail):
                return "Ошибка в декодировании"
            default:
                return "???"
            }
        }
    }
    
    init(decoder: JSONDecoder) {
        self.decoder = decoder
    }
    
    private let decoder: JSONDecoder
    
    // убрали опционал с Resultа
    func request<ResponseData: Decodable>(
        _ type: ResponseData.Type,
        url: URL,
        completion: @escaping (Result<ResponseBody<ResponseData>, ApiClient.Error>) -> Void)
    {
        // [weak self] ВСЕГДА!!!!!!! КОГДА!!!!!! ПИШЕМ!!!!!! ЗАМЫКАНИЯ!!!!!!
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else {
                self?.finish(result: .failure(.callerDestroyed), completion: completion)
                return
            }
            
            // guardы - четко! Они защитят код он роста в широту
            guard let data = try? Data(contentsOf: url) else {
                self.finish(result: .failure(.dataInitFail), completion: completion)
                return
            }
            
            guard let responseBody = try? self.decoder.decode(ResponseBody<ResponseData>.self, from: data) else {
                self.finish(result: .failure(.decodingFail), completion: completion)
                return
            }
            
            self.finish(result: .success(responseBody), completion: completion)
        }
    }
    
    private func finish<ResponseData: Decodable>(
        result: Result<ResponseBody<ResponseData>, ApiClient.Error>,
        completion: @escaping (Result<ResponseBody<ResponseData>, ApiClient.Error>) -> Void
    ) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
    
}
