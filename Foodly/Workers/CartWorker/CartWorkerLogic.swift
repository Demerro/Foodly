protocol CartWorkerLogic {
    func getCartItems() async throws -> [CartItem]
    func addToCart(item: CartItem) async throws
    func removeCartItem(id: String) async throws
}
