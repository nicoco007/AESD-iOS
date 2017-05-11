//
//  APICommunication.swift
//  JeuxAESD
//
//  Created by Nicolas Gnyra on 17-05-02.
//  Copyright © 2017 Nicolas Gnyra. All rights reserved.
//

import Foundation

class APICommunication {
    private static var _locations: [Location] = [Location]()
    
    public static var locations: [Location] {
        get {
            return _locations
        }
    }
    
    private static var _onLocationsUpdated: Event<[Location]> = Event<[Location]>()
    
    public static var onLocationsUpdated: Event<[Location]> {
        get {
            return _onLocationsUpdated
        }
    }
    
    static func loadLocations(forceRefresh: Bool = false) {
        if forceRefresh || self._locations.isEmpty {
            sendRequest("https://jeuxdelaesd.com/api/locations", onResponse: { (data, response, error) -> Void in
                var cachedData: Data? = nil
                
                if (data != nil && error == nil && response.statusCode == 200) {
                    saveToFile("locations.dat", data!)
                    cachedData = data
                    Logger.info("Loaded data from Internet")
                } else {
                    cachedData = readFromFile("locations.dat")
                    Logger.info("Loaded data from cache")
                }
                
                guard cachedData != nil else {
                    Logger.error("Failed to load data")
                    return
                }
                
                let json = try? JSONSerialization.jsonObject(with: cachedData!, options: [])
                
                guard let array = json as? NSArray else {
                    Logger.error("Failed to cast JSON to array")
                    return
                }
                
                self._locations.removeAll()
                
                for object in array {
                    guard let locationDictionary = object as? NSDictionary else {
                        Logger.error("Failed to parse location")
                        continue
                    }
                    
                    guard let location = Location(from: locationDictionary) else {
                        Logger.error("Failed to create instance of Location class from NSDictionary")
                        continue
                    }
                    
                    self._locations.append(location)
                }
                
                self._locations.sort(by: { (a, b) -> Bool in a.name > b.name })
                
                onLocationsUpdated.raise(self._locations)
            })
        } else {
            onLocationsUpdated.raise(self._locations)
        }
    }
    
    private static func saveToFile(_ fileName: String, _ data: Data) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent(fileName)
            
            do {
                try data.write(to: path)
            } catch {
                Logger.error("Failed to save data to file")
            }
        }
    }
    
    private static func readFromFile(_ fileName: String) -> Data? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent(fileName)
            
            do {
                let data = try Data(contentsOf: path)
                return data
            } catch {
                Logger.error("Failed to load data from file")
            }
        }
        
        return nil
    }
    
    typealias ResponseMethodHandler = (_ data: Data?, _ response: HTTPURLResponse, _ error: Error?) -> Void
    
    private static func sendRequest(_ url: String, onResponse: @escaping ResponseMethodHandler) {
        let requestUrl: URL = URL(string: url)!
        let session = URLSession.shared
        
        let task = session.dataTask(with: requestUrl)  { (data, response, error) -> Void in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            guard statusCode == 200 else {
                Logger.error("Failed to download data")
                onResponse(data, httpResponse, error)
                return
            }
                
            onResponse(data, httpResponse, error)
        }
        
        task.resume()
    }
}
