import UIKit

extension NewsListVC: NewsListVMRoutingDelegate {
    func newsListVM(_ newsListVM: NewsListVM, didStartAction action: NewsListVM.Action) {
        switch action {
            case .selectNewsItem(let newsItem):
                let newsStoryboard = UIStoryboard(name: "News", bundle: nil)
                let newsItemDetailsVC = newsStoryboard.instantiateViewController(withIdentifier: "NewsItemDetailsVC") as! NewsItemDetailsVC
                newsItemDetailsVC.context = context
                newsItemDetailsVC.newsItem = newsItem
                navigationController?.pushViewController(newsItemDetailsVC, animated: true)
        }
    }
}
