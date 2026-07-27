import 'dart:core';
import 'package:flutter/material.dart';
import '../res/constants/toast_message.dart';

import '../model/available_order_model.dart';
import '../model/order_details_model.dart';
import '../model/rider_dashboard_model.dart';
import '../model/rider_history_model.dart';
import '../repository/rider_repository.dart';
import '../services/location_service.dart';
import '../services/rider_location_tracker.dart';

class RiderViewModel with ChangeNotifier {
  // --- Dashboard API State ---
  bool _dashboardLoading = false;
  bool get dashboardLoading => _dashboardLoading;

  RiderDashboardModel? _dashboardData;
  RiderDashboardModel? get dashboardData => _dashboardData;

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  void setOnlineStatus(bool value) {
    _isOnline = value;
    notifyListeners();
  }

  void setDashboardLoading(bool value) {
    _dashboardLoading = value;
    notifyListeners();
  }

  void setDashboardData(RiderDashboardModel? data) {
    _dashboardData = data;
    notifyListeners();

    // Check location tracking status based on current active delivery
    final currentDelivery = data?.data?.currentDelivery;
    if (currentDelivery != null &&
        (currentDelivery.status?.toLowerCase() == 'on the way' ||
         currentDelivery.status?.toLowerCase() == 'on_the_way')) {
      RiderLocationTracker().startTracking(currentDelivery.orderId);
    } else {
      RiderLocationTracker().stopTracking();
    }
  }

  Future<void> getRiderDashboardApi(BuildContext context) async {
    setDashboardLoading(true);
    try {
      final response = await RiderRepository.getRiderDashboard();
      setDashboardData(RiderDashboardModel.fromJson(response));
      setDashboardLoading(false);
    } catch (e) {
      setDashboardLoading(false);
      if (context.mounted) {
        ToastMessage.cherryMessage(
          context,
          e.toString(),
          ToastType.error,
        );
      }
    }
  }

  // --- Available Orders API State ---
  bool _availableOrdersLoading = false;
  bool get availableOrdersLoading => _availableOrdersLoading;

  AvailableOrdersResponse? _availableOrdersData;
  AvailableOrdersResponse? get availableOrdersData => _availableOrdersData;

  void setAvailableOrdersLoading(bool value) {
    _availableOrdersLoading = value;
    notifyListeners();
  }

  void setAvailableOrdersData(AvailableOrdersResponse? data) {
    _availableOrdersData = data;
    notifyListeners();
  }

  Future<void> getAvailableOrdersApi(BuildContext context) async {
    setAvailableOrdersLoading(true);
    try {
      final response = await RiderRepository.getAvailableOrders();
      setAvailableOrdersData(AvailableOrdersResponse.fromJson(response));
      setAvailableOrdersLoading(false);
    } catch (e) {
      setAvailableOrdersLoading(false);
      if (context.mounted) {
        ToastMessage.cherryMessage(
          context,
          e.toString(),
          ToastType.error,
        );
      }
    }
  }

  // --- Order Details API State ---
  bool _orderDetailsLoading = false;
  bool get orderDetailsLoading => _orderDetailsLoading;

  OrderDetailsModel? _orderDetailsData;
  OrderDetailsModel? get orderDetailsData => _orderDetailsData;

  void setOrderDetailsLoading(bool value) {
    _orderDetailsLoading = value;
    notifyListeners();
  }

  void setOrderDetailsData(OrderDetailsModel? data) {
    _orderDetailsData = data;
    notifyListeners();
  }

  Future<void> getOrderDetailsApi(BuildContext context, int orderId) async {
    setOrderDetailsLoading(true);
    try {
      final response = await RiderRepository.getOrderDetails(orderId);
      setOrderDetailsData(OrderDetailsModel.fromJson(response));
      setOrderDetailsLoading(false);
    } catch (e) {
      setOrderDetailsLoading(false);
      if (context.mounted) {
        ToastMessage.cherryMessage(
          context,
          e.toString(),
          ToastType.error,
        );
      }
    }
  }

  // --- History API State ---
  bool _historyLoading = false;
  bool get historyLoading => _historyLoading;

  RiderHistoryModel? _historyData;
  RiderHistoryModel? get historyData => _historyData;

  void setHistoryLoading(bool value) {
    _historyLoading = value;
    notifyListeners();
  }

  void setHistoryData(RiderHistoryModel? data) {
    _historyData = data;
    notifyListeners();
  }

  Future<void> getRiderHistoryApi(BuildContext context) async {
    setHistoryLoading(true);
    try {
      final response = await RiderRepository.getRiderHistory();
      setHistoryData(RiderHistoryModel.fromJson(response));
      setHistoryLoading(false);
    } catch (e) {
      setHistoryLoading(false);
      if (context.mounted) {
        ToastMessage.cherryMessage(
          context,
          e.toString(),
          ToastType.error,
        );
      }
    }
  }

  // --- Order Actions ---
  bool _actionLoading = false;
  bool get actionLoading => _actionLoading;

  void setActionLoading(bool value) {
    _actionLoading = value;
    notifyListeners();
  }

  Future<bool> acceptOrderApi(BuildContext context, int orderId, {double? pickupLat, double? pickupLng}) async {
    setActionLoading(true);
    try {
      // Enforce 80-meter radius restriction relative to outlet premises
      final locationResult = await LocationService.checkOutletRadius(
        radiusInMeters: 80.0,
        targetLat: pickupLat,
        targetLng: pickupLng,
      );

      if (!locationResult.allowed) {
        setActionLoading(false);
        if (context.mounted) {
          ToastMessage.cherryMessage(
            context,
            locationResult.message ?? 'You must be within an 80-meter radius of the outlet premises to accept orders.',
            ToastType.error,
          );
        }
        return false;
      }

      final response = await RiderRepository.acceptOrder(orderId);
      setActionLoading(false);
      if (context.mounted) {
        ToastMessage.cherryMessage(
          context,
          response['message'] ?? 'Order accepted successfully',
          ToastType.success,
        );
        getRiderDashboardApi(context);
        getAvailableOrdersApi(context);
      }
      return true;
    } catch (e) {
      setActionLoading(false);
      if (context.mounted) {
        ToastMessage.cherryMessage(
          context,
          e.toString(),
          ToastType.error,
        );
      }
      return false;
    }
  }

  Future<bool> rejectOrderApi(BuildContext context, int orderId) async {
    setActionLoading(true);
    try {
      final response = await RiderRepository.rejectOrder(orderId);
      setActionLoading(false);
      if (context.mounted) {
        ToastMessage.cherryMessage(
          context,
          response['message'] ?? 'Order rejected successfully',
          ToastType.success,
        );
        getRiderDashboardApi(context);
        getAvailableOrdersApi(context);
      }
      return true;
    } catch (e) {
      setActionLoading(false);
      if (context.mounted) {
        ToastMessage.cherryMessage(
          context,
          e.toString(),
          ToastType.error,
        );
      }
      return false;
    }
  }

  Future<bool> startDeliveryApi(BuildContext context, int orderId) async {
    setActionLoading(true);
    try {
      final response = await RiderRepository.startDelivery(orderId);
      setActionLoading(false);
      
      // Start 30-second periodic location tracking for the active delivery
      RiderLocationTracker().startTracking(orderId);

      if (context.mounted) {
        ToastMessage.cherryMessage(
          context,
          response['message'] ?? 'Delivery started',
          ToastType.success,
        );
        getRiderDashboardApi(context);
      }
      return true;
    } catch (e) {
      setActionLoading(false);
      if (context.mounted) {
        ToastMessage.cherryMessage(
          context,
          e.toString(),
          ToastType.error,
        );
      }
      return false;
    }
  }

  Future<bool> completeDeliveryApi(BuildContext context, int orderId, {required String otp}) async {
    setActionLoading(true);
    try {
      final response = await RiderRepository.completeDelivery(orderId, otp: otp);
      setActionLoading(false);

      // Stop periodic location tracking upon delivery completion
      RiderLocationTracker().stopTracking();

      if (context.mounted) {
        ToastMessage.cherryMessage(
          context,
          response['message'] ?? 'Delivery completed successfully',
          ToastType.success,
        );
        getRiderDashboardApi(context);
        getAvailableOrdersApi(context);
      }
      return true;
    } catch (e) {
      setActionLoading(false);
      if (context.mounted) {
        ToastMessage.cherryMessage(
          context,
          e.toString(),
          ToastType.error,
        );
      }
      return false;
    }
  }

  Future<bool> updateRiderStatusApi(BuildContext context, bool status) async {
    final statusString = status ? 'ON' : 'OFF';
    try {
      final response = await RiderRepository.updateStatus(statusString);
      setOnlineStatus(status);
      if (context.mounted) {
        ToastMessage.cherryMessage(
          context,
          response['message'] ?? 'Rider is now ${status ? "Online" : "Offline"}',
          ToastType.success,
        );
      }
      return true;
    } catch (e) {
      if (context.mounted) {
        ToastMessage.cherryMessage(
          context,
          e.toString(),
          ToastType.error,
        );
      }
      return false;
    }
  }
}
