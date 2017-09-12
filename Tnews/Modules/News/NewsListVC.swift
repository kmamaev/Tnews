import UIKit

private enum Constants {
    static let newsItemReuseId = "newsItemReuseId"
}

class NewsListVC: UIViewController {
    @IBOutlet fileprivate var tableView: UITableView!

    var context: Context!
    var viewModel: NewsListVMType!

    fileprivate let refreshControl = UIRefreshControl()
}

extension NewsListVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRefreshControl()
        configureTableView()
        configureViewModel()
    }
}

private extension NewsListVC {
    func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshAction(_:)), for: .valueChanged)
    }

    func configureTableView() {
        let cellNib = UINib(nibName: "NewsItemTVC", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: Constants.newsItemReuseId)
        
        tableView.estimatedRowHeight = 60

        tableView.refreshControl = refreshControl
    }
    
    func configureViewModel() {
        viewModel = NewsListVM(newsService: context.newsService, dateFormatter: context.dateFormatter)
        viewModel.delegate = self
    }

    @objc func refreshAction(_ sender: Any) {
        viewModel.refreshNews()
    }
}

extension NewsListVC: NewsListVMDelegate {
    func newsListVMDidUpdateNews(_ newsListVM: NewsListVM) {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }

    func newsListVMDidFailUpdatingNews(_ newsListVM: NewsListVM) {
        refreshControl.endRefreshing()
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
