import Foundation

class APITask {
    private let dataTask: URLSessionDataTask

    init(_ dataTask: URLSessionDataTask) {
        self.dataTask = dataTask
    }

    func cancel() {
        dataTask.cancel()
    }
}
