//
//  CoreDataController.swift
//  FIT5140_Ass1
//
//  Created by 匡正 on 1/9/19.
//  Copyright © 2019 匡正. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate {
    
    let DEFAULT_SIGHT_NAME = "Default Sight"
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    
    //Results
    var sightsFetchedResultsController: NSFetchedResultsController<Sights>?
    var imagesFetchedResultsController: NSFetchedResultsController<Images>?
    
    override init() {
        persistentContainer = NSPersistentContainer(name: "Ass1-Sights")
        persistentContainer.loadPersistentStores() {
            (description, error) in
            if let error = error{
                fatalError("Failed to load Core Date stack: \(error)")
            }
        }
        super.init()
        
        if fetchSights().count == 0{
            createDefaultEntries()
        }
    }
    
    func saveContext(){
        if persistentContainer.viewContext.hasChanges{
            do{
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save data to Core Data: \(error)")
            }
        }
    }
    
    func addSight(name: String, descripution: String, shortDescripution: String, iconName: String, latitude: Double, longitude: Double) -> Sights {
        let sight = NSEntityDescription.insertNewObject(forEntityName: "Sights", into: persistentContainer.viewContext) as! Sights
        sight.name = name
        sight.descripution = descripution
        sight.shortDesscripution = shortDescripution
        sight.iconName = iconName
        sight.latitude = latitude
        sight.longitude = longitude
        
        saveContext()
        return sight
    }
    
    func addImage(imageName: String) -> Images {
        let image = NSEntityDescription.insertNewObject(forEntityName: "Images", into: persistentContainer.viewContext) as! Images
        image.imageName = imageName
        
        saveContext()
        return image
    }
    
    func addImageToSight(sight: Sights, image: Images) -> Bool {
        guard let images = sight.sightImages, images.contains(image) == false  else {
            return false
        }
        
        sight.addToSightImages(image)
        
        saveContext()
        return true
    }
    
    func deleteSight(sight: Sights) {
        persistentContainer.viewContext.delete(sight)
        
        saveContext()
    }
    
    func deleteImahe(image: Images) {
        persistentContainer.viewContext.delete(image)
        
        saveContext()
    }
    
    func removeImageFromSight(sight: Sights, image: Images) {
        sight.removeFromSightImages(image)
        
        saveContext()
    }
    
    func addListener(listenr: DatabaseListener) {
        listeners.addDelegate(listenr)
        
        if listenr.listenerType == ListenerType.sights || listenr.listenerType == ListenerType.all {
            listenr.onSightsChange(change: .update, sights: fetchSights())
        }
        if listenr.listenerType == ListenerType.images || listenr.listenerType == ListenerType.all {
            listenr.onImagesChange(change: .update, images: fetchImages())
        }
    }
    
    func removeListener(listenr: DatabaseListener) {
        listeners.removeDelegate(listenr)
    }
    
    func fetchSights() -> [Sights] {
        if sightsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Sights> = Sights.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            sightsFetchedResultsController = NSFetchedResultsController<Sights>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            sightsFetchedResultsController?.delegate = self
            
            do{
                try sightsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request faild: \(error)")
            }
        }
        
        var sights = [Sights]()
        if sightsFetchedResultsController?.fetchedObjects != nil {
            sights = (sightsFetchedResultsController?.fetchedObjects)!
        }
        
        return sights
    }
    
    func fetchImages() -> [Images]{
        if imagesFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Images> = Images.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            imagesFetchedResultsController = NSFetchedResultsController<Images>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            imagesFetchedResultsController?.delegate = self
            
            do{
                try imagesFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request faild: \(error)")
            }
        }
        
        var images = [Images]()
        if imagesFetchedResultsController?.fetchedObjects != nil {
            images = (imagesFetchedResultsController?.fetchedObjects)!
        }
        
        return images
    }
    
     // MARK: - Fetched Results Conttroller Delegate
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == sightsFetchedResultsController {
            listeners.invoke {
                (listener) in
                if listener.listenerType == ListenerType.sights || listener.listenerType == ListenerType.all {
                    listener.onSightsChange(change: .update, sights: fetchSights())
                }
            }
        }
        else if controller == imagesFetchedResultsController {
            listeners.invoke {
                (listener) in
                if listener.listenerType == ListenerType.images || listener.listenerType == ListenerType.all {
                    listener.onImagesChange(change: .update, images: fetchImages())
                }
            }
        }
    }
    
// MARK: - Default entries
    
    //lazy var defaultSights: [Sights]
    
    func createDefaultEntries(){
        let _ = addSight(name: "Melbourne Town Hall", descripution: "or over 135 years, Melbourne Town Hall has been at the heart of events which have shaped the city's future and celebrated monumental milestones. Here, Federation was debated, Nellie Melba debuted and the Beatles greeted adoring fans. The grand interiors echo with countless celebrations, gala occasions, festivals, and commemorations - the imprints of a community life across generations.", shortDescripution: "90-130 Swanston St, Melbourne VIC 3000", iconName: "baseline_party_mode_black_18dp.png", latitude: -37.815091, longitude: 144.967045)
        let _ = addSight(name: "Federation Square", descripution: "World-class art galleries and installations. Mind-blowing food and drink. Thrilling, extraordinary events that capture the hearts of Melburnians year after year. Fed Square is anything but square.", shortDescripution: "Swanston St & Flinders St, Melbourne VIC 3000", iconName: "baseline_party_mode_black_18dp.png", latitude: -37.817959, longitude: 144.969816)
        let _ = addSight(name: "Flinders Street Railway Station", descripution: "Flinders Street railway station is a railway station on the corner of Flinders and Swanston Streets in Melbourne, Victoria, Australia. It serves the entire metropolitan rail network. Backing onto the city reach of the Yarra River in the heart of the city, the complex covers two whole city blocks and extends from Swanston Street to Queen Street.", shortDescripution: "Flinders St, Melbourne VIC 3000", iconName: "baseline_train_black_18dp.png", latitude: -37.817970, longitude: 144.967440)
        let _ = addSight(name: "St Paul's Cathedral", descripution: "St Paul’s stands at the very heart of the City of Melbourne. In style, it echoes the grand Cathedrals of Europe. Designed by distinguished English revival architect William Butterfield, the Cathedral is built in the neo-Gothic transitional style, partly Early English and partly Decorated. Many consider St Paul’s to be Butterfield’s final masterpiece.", shortDescripution: "Flinders Ln & Swanston St, Melbourne VIC 3000", iconName: "baseline_party_mode_black_18dp.png", latitude: -37.817076, longitude: 144.967714)
        let _ = addSight(name: "Chinatown Melbourne", descripution: "Chinatown is a distinctive and well known area of Melbourne which dates back to the gold rush days of the 1850s. Chinatown Melbourne is the longest continuous Chinese settlement in the western world. Chinatown’s essential character and main focus is along Little Bourke Street with alleys that link the area to Bourke Street and Lonsdale Street.", shortDescripution: "Little Bourke St, Melbourne VIC 3000", iconName: "baseline_party_mode_black_18dp.png", latitude: -37.811627, longitude: 144.968295)
        let _ = addSight(name: "Parliament House", descripution: "Located on Spring Street on the edge of the central city grid, the grand colonnaded front dominates the vista up Bourke Street. Construction began in 1855, and the first stage was officially opened the following year, with various sections completed over the following decades; it has never been completed, and the planned dome is one of the most well known unbuilt features of Melbourne. Between 1901 and 1927, it served as the meeting place of the Parliament of Australia, during the period when Melbourne was the temporary national capital. The building is listed on the Victorian Heritage Register.", shortDescripution: "Spring St, East Melbourne VIC 3002", iconName: "baseline_party_mode_black_18dp.png", latitude: -37.811074, longitude: 144.973493)
        let _ = addSight(name: "Cooks' Cottage", descripution: "Originally located in Yorkshire, England, and built in 1755 by the parents of Captain James Cook, Cooks’ Cottage was brought to Melbourne by Sir Russell Grimwade in 1934.", shortDescripution: "Fitzroy Gardens, East Melbourne VIC 3002", iconName: "baseline_party_mode_black_18dp.png", latitude: -37.814549, longitude: 144.979375)
        let _ = addSight(name: "State Library Victoria", descripution: "Established in 1854 as the Melbourne Public Library, State Library Victoria is Australia's oldest public library and one of the first free public libraries in the world.", shortDescripution: "328 Swanston St, Melbourne VIC 3000", iconName: "baseline_menu_book_black_18dp.png", latitude: -37.809868, longitude: 144.964552)
        let _ = addSight(name: "Flagstaff Gardens", descripution: "Flagstaff Gardens is the oldest park in Melbourne, Victoria, Australia, first established in 1862. Today it is one of the most visited and widely used parks in the city by residents, nearby office workers and tourists. The gardens are notable for their archaeological, horticultural, historical and social significance to the history of Melbourne.", shortDescripution: "309-311 William St, West Melbourne VIC 3003", iconName: "baseline_party_mode_black_18dp.png", latitude: -37.810771, longitude: 144.955180)
        let _ = addSight(name: "Queen Victoria Market", descripution: "Officially opened on 20 March 1878, the Market has been serving the people of Melbourne for more than 140 years. The Market has seen many transformations and has recently been added to the National Heritage List, recognising the significant place it holds in Australian history as our nation’s most iconic fresh produce market.", shortDescripution: "Queen St, Melbourne VIC 3000", iconName: "baseline_local_grocery_store_black_18dp.png", latitude: -37.806531, longitude: 144.958066)
        let _ = addSight(name: "RMIT University", descripution: "One of Australia's original tertiary institutions, RMIT University enjoys an international reputation for excellence in professional and vocational education, applied research, and engagement with the needs of industry and the community.", shortDescripution: "124 La Trobe St, Melbourne VIC 3000", iconName: "baseline_menu_book_black_18dp.png", latitude: -37.808121, longitude: 144.963522)
        let _ = addSight(name: "Old Melbourne Gaol", descripution: "The Gaol’s first cellblock was opened in 1845. Gold was discovered in 1851 and in the next four years Melbourne’s population increased from 23,000 to nearly 90,000. Overcrowding soon became a huge problem for the Gaol, with the Argus newspaper complaining in 1853 that the old cellblock was “literally crammed to suffocation”. A second cellblock was not completed until 1859. It was similar in design to the earlier cellblock but contained what the Argus described as “an aspect of greater airiness and cheerfulness”. This new cellblock had a modern, progressive design. It included innovations such as good ventilation, a clean water supply, a food hoist, adequate exercise yards and the use of steam in the bath-house, wash-house and kitchen.", shortDescripution: "377 Russell St, Melbourne VIC 3000", iconName: "baseline_party_mode_black_18dp.png", latitude: -37.807761, longitude: 144.965449)
        let _ = addSight(name: "SEA LIFE Melbourne Aquarium", descripution: "Dive into one of Melbourne's top attractions, SEA LIFE Melbourne Aquarium, and walk through our crowd-favourite oceanarium tunnels, get hands-on in the Discovery Rockpools and marvel as our King and Gentoo Penguins dive in and out of the water within their icy habitat. No matter your favourite underwater creature, our aquarium never fails to create lasting memories full of fun and adventure.", shortDescripution: "King St, Melbourne VIC 3000", iconName: "baseline_party_mode_black_18dp.png", latitude: -37.820797, longitude: 144.958229)
        let _ = addSight(name: "Carlton Gardens", descripution: "The Carlton Gardens is a World Heritage Site located on the northeastern edge of the Central Business District in the suburb of Carlton, in Melbourne, Australia.", shortDescripution: "1-111 Carlton St, Carlton VIC 3053", iconName: "baseline_party_mode_black_18dp.png", latitude: -37.806286, longitude: 144.970781)
        let _ = addSight(name: "Rod Laver Arena", descripution: "Rod Laver Arena at Melbourne Park was completed in 1988 as part of the original National Tennis Centre complex. The arena is the centrepiece of the Australian Open and plays host to a wide range of sports and entertainment events, from tennis matches to international rock stars and motorbike super-cross. The most dynamic transformation Rod Laver Arena has seen was in March 2007 with the FINA 2007 World Swimming Championships when a 50 metre temporary pool was built on the arena’s floor.", shortDescripution: "Olympic Blvd, Melbourne VIC 3001", iconName: "baseline_fitness_center_black_18dp.png", latitude: -37.822182, longitude: 144.978105)
    
    }
}
