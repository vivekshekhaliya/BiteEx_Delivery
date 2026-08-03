class AppUrl {
  /// Base api url
  static var baseUrl = 'https://site.biteexchange.com/api';

  // static var baseUrl = 'https://stage.biteexchange.com/api';

  static const String razorpayKeyId = String.fromEnvironment(
    'RAZORPAY_KEY_ID',
    defaultValue: 'rzp_live_SiQrfrHe3V0yZK',
  );

  static var socketUrl = 'wss://site.biteexchange.com/app/local';

  /// Auth flow api url

  static var signInUrl = '$baseUrl/rider/login';
  static var verifyUrl = '$baseUrl/rider/verify-otp';
  static var signUpUrl = '$baseUrl/rider/login';
  static var getUserUrl = '$baseUrl/get-profile';
  static var editProfileUrl = '$baseUrl/edit-profile';
  static var deleteProfileUrl = '$baseUrl/delete-profile';

  /// Over flow api url

  static var getBannerUrl = '$baseUrl/get-banner';
  static var getGalleryUrl = '$baseUrl/image-gallery?per_page=100&page=1';
  static var getProductSectionsUrl = '$baseUrl/featured-product-sections';
  static var getCategoryUrl = '$baseUrl/get-category';
  static var getProductUrl = '$baseUrl/get-product';
  static var getProductDetailsUrl = '$baseUrl/get-product-detail';
  static var addCartUrl = '$baseUrl/manageCart';
  static var getCartUrl = '$baseUrl/get-cart';
  static var getNotificationUrl = '$baseUrl/notifications?per_page=100&page=1';

  /// Order api url
  static var createOrderUrl = '$baseUrl/razorpay/create-order';
  static var addOrderUrl = '$baseUrl/add-order';
  static var userCouponsUrl = '$baseUrl/user-coupons';
  static var applyCouponUrl = '$baseUrl/apply';
  static var getOrderUrl = '$baseUrl/get-order';
  static var orderDetailsUrl = '$baseUrl/order-details';
  static var clearCartUrl = '$baseUrl/clear-cart';
  static var orderRateUrl = '$baseUrl/orders';
  static var walletUrl = '$baseUrl/wallet';
  static var nearestOutletUrl = '$baseUrl/nearest-outlet';
  static var getInProgressOrdersUrl = '$baseUrl/get-in-progress-orders';

  // Config
  static var configApiUrl = '$baseUrl/config-api';

  /// Rider APIs
  static var riderDashboardUrl = '$baseUrl/rider/dashboard';
  static var riderAvailableOrdersUrl = '$baseUrl/rider/available-orders';
  static String riderOrderDetailsUrl(int id) => '$baseUrl/rider/orders/$id';
  static String acceptOrderUrl(int id) => '$baseUrl/rider/orders/$id/accept';
  static String rejectOrderUrl(int id) => '$baseUrl/rider/orders/$id/reject';
  static String startDeliveryUrl(int id) => '$baseUrl/rider/orders/$id/start-delivery';
  static String completeDeliveryUrl(int id) => '$baseUrl/rider/orders/$id/complete';
  static String riderGenerateQrUrl(int id) => '$baseUrl/orders/$id/generate-qr';
  static String riderPaymentStatusUrl(int id) => '$baseUrl/orders/$id/payment-status';
  static var updateLocationUrl = '$baseUrl/rider/update-location';
  static var updateStatusUrl = '$baseUrl/rider/update-status';
  static var riderHistoryUrl = '$baseUrl/rider/history';
}
