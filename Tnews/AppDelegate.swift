import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
        let context = AppDelegate.configuredContext()

        let newsStoryboard = UIStoryboard(name: "News", bundle: nil)
        let newsListVC = newsStoryboard.instantiateInitialViewController() as! NewsListVC
        newsListVC.context = context

        let navigationController = UINavigationController(rootViewController: newsListVC)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    
        return true
    }

    static func configuredContext() -> Context {
        let apiService = APIService()
        let storageService = StorageService()
        let newsService = NewsService(apiService: apiService, storageService: storageService)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy hh:mm"
        let context = Context(apiService: apiService, newsService: newsService, dateFormatter: dateFormatter)

        return context
    }
}

