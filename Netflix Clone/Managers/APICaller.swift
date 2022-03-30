//
//  APICaller.swift
//  Netflix Clone
//
//  Created by Daffolapmac-155 on 27/03/22.
//

import Foundation

struct Constants {
    static let API_KEY = "8ff07fe9d4c22a6de1ca72ff6ae59aac"
    static let baseURL = "https://api.themoviedb.org"
    
    static let youTubeAPI_KEY = "AIzaSyAjDIwfICRdndgDl3CWCS6GefKk2CJYw0w"
    static let youTubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}


enum APIError: Error{
    case failedToGetData
}
class APICaller {
    static let shared =  APICaller()
    
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void){
        
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else{return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){ data, response, error in
            guard let data = data, error == nil  else {
                return
            }
            do{
                let results =  try JSONDecoder().decode(trendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
            

        }
            task.resume()
        
    }
    
    
    func getTrendingTvs(completion: @escaping (Result<[Title],Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else {return}
        
        let task  =  URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results =  try JSONDecoder().decode(trendingTitleResponse.self, from: data)
                completion(.success(results.results))

              
            }catch{
                completion(.failure(APIError.failedToGetData))
            }

        }
        task.resume()
        
    }
     
    func getUpcomingMovies(completion: @escaping (Result<[Title],Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)") else{ return }
        
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                let results = try JSONDecoder().decode(trendingTitleResponse.self, from: data)
                completion(.success(results.results))

            }catch{
                completion(.failure(APIError.failedToGetData))
            }
            

        }
        task.resume()
        
    }
    
    
    
    func getPopular(completion: @escaping (Result<[Title],Error>) -> Void){
        
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1")else{
            return}
            let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
                    guard let data = data, error == nil else {
                        return
                    }
                do{
                    let results =  try JSONDecoder().decode(trendingTitleResponse.self, from: data)
                    completion(.success(results.results))
                }catch{
                    completion(.failure(APIError.failedToGetData))
                }
                    
                    
        }.resume()
        
    }
    
    
    func getTopRated(completion: @escaping (Result<[Title],Error>) -> Void){
        
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data , error == nil else {
                return
            }
         
            do{
                let results = try JSONDecoder().decode(trendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
            
        }.resume()
    }
    
    
    func getDiscoverMovies(completion: @escaping (Result<[Title],Error>) -> Void){
        
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data , error == nil else {
                return
            }
         
            do{
                let results = try JSONDecoder().decode(trendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
            
        }.resume()
    }

    func search(with query: String,completion: @escaping (Result<[Title],Error>) -> Void){
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data , error == nil else {
                return
            }
         
            do{
                let results = try JSONDecoder().decode(trendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
            
        }.resume()
    }
    
    func getMovie(with query: String, completion: @escaping(Result<VideoElement,Error>) -> Void ){
        // used for making the url like whitespace is replaced by identifier in a url
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.youTubeBaseURL)q=\(query)&key=\(Constants.youTubeAPI_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data , error == nil else {
                return
            }
         
            do{
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completion(.success(results.items[0]))

            }catch{
                completion(.failure(APIError.failedToGetData))
//                print(error.localizedDescription)
            }
            
        }.resume()
    }

}


//https://youtube.googleapis.com/youtube/v3/search?q=Harry%20Potter&key=[YOUR_API_KEY]
