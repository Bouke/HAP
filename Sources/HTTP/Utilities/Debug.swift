internal func debugOnly(_ body: () -> Void) {
    assert({ body(); return true }())
}
