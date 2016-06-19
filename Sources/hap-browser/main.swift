import Foundation

class Delegate: NSObject, NetServiceBrowserDelegate {
    func netServiceBrowser(_ browser: NetServiceBrowser, didFindDomain domainString: String, moreComing: Bool) {
        print("didFindDomain", domainString)
    }

    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        print("netServiceBrowserWillSearch")
    }

    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        print("netServiceBrowserDidStopSearch")
    }

    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        print("netServiceBrowser:didNotSearch", errorDict)
    }

    func netServiceBrowser(_ browser: NetServiceBrowser, didRemoveDomain domainString: String, moreComing: Bool) {
        print("netServiceBrowser:didRemoveDomain")
    }

    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        print("didFind", service, service.txtRecordData())
    }

    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        print("didRemove", service)
    }
}

let delegate: NetServiceBrowserDelegate = Delegate()
let browser = NetServiceBrowser()
browser.schedule(in: RunLoop.current(), forMode: RunLoopMode.defaultRunLoopMode)
browser.delegate = delegate
browser.searchForServices(ofType: "_hap._tcp.", inDomain: "local.")

withExtendedLifetime((delegate, browser)) {
    RunLoop.current().run()
}

//print(delegate)
