import Foundation
import CoreData

enum StorageServiceError: Error {
    case saveDataFailure
    case fetchDataFailure
    case deleteDataFailure
}

protocol StorageServiceObserver: class {
    func storageServiceDidUpdateNews(_ storageService: StorageService)
    func storageService(_ storageService: StorageService, didFailUpdatingNewsWithError error: Error)
}

class StorageService: NSObject {
    fileprivate var observers: [StorageServiceObserver] = []
    
    fileprivate(set) var newsItems: [NewsItem] = [] {
        didSet {
            newsItemsSet = NSSet(array: newsItems)
        }
    }
    fileprivate var newsItemsSet: NSSet = NSSet()
    
    fileprivate lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "Tnews")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                    if let error = error as NSError? {
                        fatalError("Unresolved error \(error), \(error.userInfo)")
                    }
                })
            return container
        }()

    fileprivate var managedObjectContext: NSManagedObjectContext {
            return persistentContainer.viewContext
        }

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<CDNewsItem> = { [unowned self] in
            let fetchRequest: NSFetchRequest<CDNewsItem> = CDNewsItem.fetchRequest()
            fetchRequest.fetchBatchSize = 20
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "publicationDate", ascending: false)]

            let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
            return fetchedResultsController
        }()
}

extension StorageService {
    func fetchNews() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            notifyStorageServiceDidFailUpdatingNews(withError: StorageServiceError.fetchDataFailure)
        }
        
        guard let fetchedNewsItems = fetchedResultsController.fetchedObjects else {
            return
        }
        newsItems = fetchedNewsItems.map { NewsItem(coreDataObject: $0) }
        notifyStorageServiceDidUpdateNews()
    }

    func saveNews(_ news: [NewsItem]) {
        let context = fetchedResultsController.managedObjectContext

        let newsToSave = NSMutableSet(array: news)
        newsToSave.minus(newsItemsSet as! Set<NewsItem>)
        
        let newsToDelete: NSMutableSet = newsItemsSet.mutableCopy() as! NSMutableSet
        newsToDelete.minus(NSSet(array: news) as! Set<NewsItem>)
        
        let newsToSaveAsArray = Array(newsToSave) as! [NewsItem]
        let newsToDeleteAsArray = Array(newsToDelete) as! [NewsItem]

        if newsToSaveAsArray.isEmpty, newsToDeleteAsArray.isEmpty {
            notifyStorageServiceDidUpdateNews()
        } else {
            newsToSaveAsArray.forEach { StorageService.createCDNewsItem(withNewsItem: $0, context: context) }
            deleteNewsItems(newsToDeleteAsArray, context: context)
            do {
                try context.save()
            } catch {
                notifyStorageServiceDidFailUpdatingNews(withError: StorageServiceError.saveDataFailure)
            }
        }
    }
    
    func getDetailsOfNewsItem(_ newsItem: NewsItem) -> NewsItemDetails? {
        let fetchRequest: NSFetchRequest<CDNewsItem> = CDNewsItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", newsItem.id)

        var newsItemDetails: NewsItemDetails? = nil
        do {
            let fetchedNewsItems = try managedObjectContext.fetch(fetchRequest)
            if let cdNewsItem = fetchedNewsItems.first,
                let cdNewsItemDetails = cdNewsItem.details {
                newsItemDetails = NewsItemDetails(coreDataObject: cdNewsItemDetails)
            }
        } catch {
            notifyStorageServiceDidFailUpdatingNews(withError: StorageServiceError.fetchDataFailure)
        }
        
        return newsItemDetails
    }
    
    func saveDetails(_ newsItemDetails: NewsItemDetails, forNewsItem newsItem: NewsItem) {
        let fetchRequest: NSFetchRequest<CDNewsItem> = CDNewsItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", newsItem.id)

        do {
            let fetchedNewsItems = try managedObjectContext.fetch(fetchRequest)
            if let cdNewsItem = fetchedNewsItems.first {
                let cdNewsItemDetails = StorageService.cdNewsItemDetails(withDetails: newsItemDetails,
                    context: managedObjectContext)
                cdNewsItem.details = cdNewsItemDetails
                try managedObjectContext.save()
            }
        } catch {
            notifyStorageServiceDidFailUpdatingNews(withError: StorageServiceError.saveDataFailure)
        }
    }
}

private extension StorageService {
    func deleteNewsItems(_ newsItems: [NewsItem], context: NSManagedObjectContext) {
        let idsToDelete = newsItems.map { $0.id }
        let fetchRequest: NSFetchRequest<CDNewsItem> = CDNewsItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", idsToDelete)
        
        do {
            let newsItems = try context.fetch(fetchRequest)
            for newsItem in newsItems {
                context.delete(newsItem)
            }
        } catch {
            notifyStorageServiceDidFailUpdatingNews(withError: StorageServiceError.deleteDataFailure)
        }
    }
    
    static func createCDNewsItem(withNewsItem newsItem: NewsItem, context: NSManagedObjectContext) {
        let cdNewsItem = CDNewsItem(context: context)
        cdNewsItem.id = newsItem.id
        cdNewsItem.text = newsItem.text
        cdNewsItem.publicationDate = newsItem.publicationDate as NSDate
    }
    
    static func cdNewsItemDetails(withDetails newsItemDetails: NewsItemDetails, context: NSManagedObjectContext)
        -> CDNewsItemDetails
    {
        let cdNewsItemDetails = CDNewsItemDetails(context: context)
        cdNewsItemDetails.content = newsItemDetails.content
        return cdNewsItemDetails
    }
}

extension StorageService: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let sectionInfo = fetchedResultsController.sections?.first,
            let cdNewsItems = sectionInfo.objects as? [CDNewsItem] else {
            return
        }

        let updatedItems = cdNewsItems.map { NewsItem(coreDataObject: $0) }
        newsItems = updatedItems

        notifyStorageServiceDidUpdateNews()
    }
}

extension StorageService {
    func addObserver(_ observer: StorageServiceObserver){
        observers.append(observer)
    }
    
    func removeObserver(_ observer: StorageServiceObserver) {
        if let index = observers.index(where: { observer === $0 }) {
            observers.remove(at: index)
        }
    }
}

private extension StorageService {
    func notifyStorageServiceDidUpdateNews() {
        observers.forEach { $0.storageServiceDidUpdateNews(self) }
    }
    
    func notifyStorageServiceDidFailUpdatingNews(withError error: StorageServiceError) {
        observers.forEach { $0.storageService(self, didFailUpdatingNewsWithError: error) }
    }
}
