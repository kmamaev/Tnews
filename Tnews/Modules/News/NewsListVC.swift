import UIKit

private enum Constants {
    static let newsItemReuseId = "newsItemReuseId"
}

class NewsListVC: UIViewController {
    @IBOutlet fileprivate var tableView: UITableView!
    
    let viewModel = NewsListVM()
}

extension NewsListVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    func configureTableView() {
        let cellNib = UINib(nibName: "NewsItemTVC", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: Constants.newsItemReuseId)
        
        tableView.estimatedRowHeight = 60
    }
}

extension NewsListVC: UITableViewDelegate {
    // TODO: implement this
}

extension NewsListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.newsItemReuseId, for: indexPath) as! NewsItemTVC
        
        let newsItemVM = viewModel.news[indexPath.row]
        cell.configure(withViewModel: newsItemVM)
        
        return cell
    }
}
