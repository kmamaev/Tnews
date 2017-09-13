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

        configureContentTextView()
        setupViewModel()
    }
}

private extension NewsItemDetailsVC {
    func configureContentTextView() {
        contentTextView.textContainer.lineFragmentPadding = 0
        contentTextView.textContainerInset = .zero
    }

    func setupViewModel() {
        viewModel = NewsItemDetailsVM(newsItem: newsItem, newsService: context.newsService,
            dateFormatter: context.dateFormatter)

        viewModel.delegate = self

        titleLabel.text = viewModel.title
        dateLabel.text = viewModel.formattedDateString
        contentTextView.text = viewModel.content
    }
}

extension NewsItemDetailsVC: NewsItemDetailsVMDelegate {
    func newsItemsDetailsVMDidUpdateContent(_ newsItemDetailsVM: NewsItemDetailsVM) {
        contentTextView.text = viewModel.content
    }
}
