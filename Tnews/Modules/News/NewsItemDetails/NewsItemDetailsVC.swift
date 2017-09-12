import UIKit

class NewsItemDetailsVC: UIViewController {
    @IBOutlet fileprivate var titleLabel: UILabel!
    @IBOutlet fileprivate var dateLabel: UILabel!
    @IBOutlet fileprivate var contentTextView: UITextView!

    var context: Context!
    var newsItem: NewsItem!
    var viewModel: NewsItemDetailsVMType!
}

extension NewsItemDetailsVC {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewModel()
        configureUI()
    }
}

private extension NewsItemDetailsVC {
    func configureViewModel() {
        viewModel = NewsItemDetailsVM(newsService: context.newsService, dateFormatter: context.dateFormatter)
    }

    func configureUI() {
        titleLabel.text = newsItem.text
        dateLabel.text = context.dateFormatter.string(from: newsItem.publicationDate)
        contentTextView.text = nil
    }
}
