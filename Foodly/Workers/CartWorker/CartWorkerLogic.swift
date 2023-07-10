protocol CartWorkerLogic {
    func getCartItems() async throws -> [CartItem]
    func getCartItem(id: String) async throws -> CartItem
    func addToCart(item: CartItem) async throws
    func removeCartItem(id: String) async throws
    func changeCartItemAmount(item: CartItem, difference: Int) async throws
}
