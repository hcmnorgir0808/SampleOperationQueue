import UIKit

final class SampleOperation: Operation {
    let message: String

    init(message: String) {
        self.message = message
    }

    override func main() {
        if isCancelled {
            return
        }
        sleep(3)
        print("\(message) \(Date().timeIntervalSince1970)")
    }
}

//このコードでは、3つのAPIリクエストをカプセル化したOperationオブジェクトを作成し、依存関係を設定しています。また、全てのAPIリクエストが完了したことをチェックするためのBlockOperationを作成し、依存関係を設定しています。依存関係が設定されると、completionOperationは、3つのAPIリクエストが完了するまで開始されなくなります。

//completionBlock内で、全てのAPIリクエストが成功したかどうかをチェックし、結果に応じて処理を続行するかどうかを決定しています。各APIリクエストの成功/失敗を判断するために、各OperationのisFinishedプロパティをチェックしています。isFinishedがtrueであれば、APIリクエストは正常に終了したことを示します。

let queue = OperationQueue()
queue.maxConcurrentOperationCount = 2

let api1Operation = SampleOperation(message: "foo")
let api2Operation = SampleOperation(message: "bar")
let api3Operation = SampleOperation(message: "hoge")

let completionOperation = BlockOperation {
    let allRequestsSucceeded = api1Operation.isFinished && api2Operation.isFinished && api3Operation.isFinished

    if allRequestsSucceeded {
        print("All API requests completed successfully")
    } else {
        print("One or more API requests failed")
    }
}

completionOperation.addDependency(api1Operation)
completionOperation.addDependency(api2Operation)
completionOperation.addDependency(api3Operation)

queue.addOperations([api1Operation, api2Operation, api3Operation, completionOperation], waitUntilFinished: false)





