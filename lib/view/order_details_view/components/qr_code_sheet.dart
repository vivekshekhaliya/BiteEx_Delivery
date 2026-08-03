import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../res/components/custom_app_button.dart';
import '../../../res/components/custom_text.dart';
import '../../../res/constants/app_colors.dart';
import '../../../res/constants/toast_message.dart';
import '../../../services/web_socket_manager.dart';
import '../../../view_model/rider_view_model.dart';

class QrCodeSheet extends StatefulWidget {
  final int orderId;
  final double amount;
  const QrCodeSheet({super.key, required this.orderId, required this.amount});

  @override
  State<QrCodeSheet> createState() => _QrCodeSheetState();
}

class _QrCodeSheetState extends State<QrCodeSheet> {
  Timer? _countdownTimer;
  Timer? _pollingTimer;
  StreamSubscription? _socketSubscription;
  int _secondsRemaining = 0;
  bool _isExpired = false;
  bool _hasInitialRequestSent = false;

  @override
  void initState() {
    super.initState();
    // Mark QR payment as active
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final riderVM = Provider.of<RiderViewModel>(context, listen: false);
      riderVM.setQrActive(true);
      _fetchQrCode();
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _pollingTimer?.cancel();
    _socketSubscription?.cancel();
    super.dispose();
  }

  /// Request dynamic QR code from backend
  Future<void> _fetchQrCode() async {
    if (_countdownTimer != null) _countdownTimer!.cancel();
    setState(() {
      _isExpired = false;
      _secondsRemaining = 0;
    });

    final riderVM = Provider.of<RiderViewModel>(context, listen: false);
    final qrData = await riderVM.generatePaymentQrApi(context, widget.orderId);

    if (qrData != null && mounted) {
      _hasInitialRequestSent = true;
      _setupExpiryTimer(qrData);
      _startStatusListeners();
    }
  }

  /// Sets up countdown timer based on API response
  void _setupExpiryTimer(Map<String, dynamic> qrData) {
    final expiresAtStr =
        qrData['expires_at'] ?? qrData['expire_at'] ?? qrData['expiresAt'];
    final expiresInVal =
        qrData['expires_in'] ?? qrData['expire_in'] ?? qrData['expiresIn'];

    int seconds = 0;

    if (expiresAtStr != null) {
      try {
        final expiryTime = DateTime.parse(expiresAtStr.toString());
        seconds = expiryTime.difference(DateTime.now()).inSeconds;
      } catch (e) {
        debugPrint("Error parsing expiry timestamp: $e");
      }
    } else if (expiresInVal != null) {
      seconds = int.tryParse(expiresInVal.toString()) ?? 0;
    } else {
      // Default fallback if no expiry info returned: 5 minutes (300 seconds)
      seconds = 300;
    }

    if (seconds > 0) {
      setState(() {
        _secondsRemaining = seconds;
        _isExpired = false;
      });

      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        setState(() {
          if (_secondsRemaining > 1) {
            _secondsRemaining--;
          } else {
            _secondsRemaining = 0;
            _isExpired = true;
            _countdownTimer?.cancel();
            _pollingTimer?.cancel(); // Stop checking status once expired
          }
        });
      });
    }
  }

  /// Starts real-time WebSocket listening & periodic HTTP polling
  void _startStatusListeners() {
    _pollingTimer?.cancel();
    _socketSubscription?.cancel();

    // 1. WebSocket listener for order updates
    _socketSubscription = WebSocketManager().stream.listen((data) {
      if (data is Map) {
        final channel = data['channel'];
        final type = data['type'];
        if (channel == 'delivery-orders' || type == 'delivery_orders_updated') {
          debugPrint(
            "WebSocket update received in QrCodeSheet, checking payment...",
          );
          _checkPaymentStatus();
        }
      }
    });

    // 2. Periodic HTTP Polling (fallback & validation) every 5 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _checkPaymentStatus();
    });
  }

  /// Core logic to verify if order has been paid
  Future<void> _checkPaymentStatus({bool manualCheck = false}) async {
    if (!mounted || _isExpired) return;

    final riderVM = Provider.of<RiderViewModel>(context, listen: false);

    // Call the check payment status API
    final response = await riderVM.checkPaymentStatusApi(
      context,
      widget.orderId,
    );

    if (!mounted) return;

    if (response != null && response['success'] == true) {
      final status = response['status']?.toString().toLowerCase();

      // Check if payment is successful
      if (status == 'paid' || status == 'success' || status == 'completed') {
        _countdownTimer?.cancel();
        _pollingTimer?.cancel();
        _socketSubscription?.cancel();

        // Deactivate active QR flag
        riderVM.setQrActive(false);

        // Fetch full order details to refresh the main screen state
        await riderVM.getOrderDetailsApi(context, widget.orderId);

        if (mounted) {
          Navigator.pop(context); // Close bottom sheet
          ToastMessage.cherryMessage(
            context,
            "Payment Received Successfully",
            ToastType.success,
          );
        }
      } else {
        if (manualCheck && mounted) {
          ToastMessage.cherryMessage(
            context,
            "Payment is still pending...",
            ToastType.warning,
          );
        }
      }
    }
  }

  /// Build helper to render QR code from URL or Base64 data
  Widget _buildQrImage(String qrSource) {
    if (qrSource.isEmpty) {
      return const SizedBox(
        width: 280,
        height: 280,
        child: Center(
          child: CustomText(
            data: "No QR Code source provided",
            fontSize: 14,
            color: Colors.redAccent,
          ),
        ),
      );
    }

    if (qrSource.startsWith('data:image') && qrSource.contains('base64,')) {
      final base64Str = qrSource
          .split('base64,')
          .last
          .replaceAll(RegExp(r'\s+'), '');
      try {
        final bytes = base64Decode(base64Str);
        return Image.memory(bytes, width: 280, height: 280, fit: BoxFit.cover);
      } catch (e) {
        return const SizedBox(
          width: 280,
          height: 280,
          child: Icon(Icons.broken_image, size: 80, color: Colors.redAccent),
        );
      }
    } else if (qrSource.startsWith('http') || qrSource.startsWith('https')) {
      return CachedNetworkImage(
        imageUrl: qrSource,
        width: 280,
        height: 280,
        fit: BoxFit.cover,
        placeholder: (context, url) => const SizedBox(
          width: 280,
          height: 280,
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
        ),
        errorWidget: (context, url, error) => const SizedBox(
          width: 280,
          height: 280,
          child: Icon(Icons.broken_image, size: 80, color: Colors.redAccent),
        ),
      );
    } else {
      // Attempt decoding raw base64 if not HTTP URL
      try {
        final bytes = base64Decode(qrSource);
        return Image.memory(bytes, width: 280, height: 280, fit: BoxFit.cover);
      } catch (_) {
        return const SizedBox(
          width: 280,
          height: 280,
          child: Icon(Icons.broken_image, size: 80, color: Colors.redAccent),
        );
      }
    }
  }

  /// Formats duration to MM:SS style
  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds / 60).floor();
    final seconds = totalSeconds % 60;
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = seconds.toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }

  @override
  Widget build(BuildContext context) {
    final riderVM = Provider.of<RiderViewModel>(context);

    return WillPopScope(
      onWillPop: () async {
        // Safe reset QR active state when closed manually
        riderVM.setQrActive(false);
        return true;
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: const BoxDecoration(
          color: AppColors.darkGunmetalColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bottom sheet drag handle / Top line
              Container(
                width: 48,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.darkSlateGrayColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Title and manual close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    data: "Collect UPI Payment",
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.whiteColor,
                  ),
                  IconButton(
                    onPressed: () {
                      riderVM.setQrActive(false);
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.coolGrayColor,
                    ),
                  ),
                ],
              ),

              const Divider(color: AppColors.jetGrayColor, height: 24),

              if (riderVM.qrLoading && !_hasInitialRequestSent)
                const SizedBox(
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                )
              else if (riderVM.qrData == null)
                SizedBox(
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: AppColors.crimsonRedColor,
                      ),
                      const SizedBox(height: 12),
                      const CustomText(
                        data: "Failed to generate QR Code",
                        fontSize: 16,
                        color: AppColors.coolGrayColor,
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(height: 20),
                      CustomAppButton(text: "Retry", onPressed: _fetchQrCode),
                    ],
                  ),
                )
              else ...[
                // QR Wrapper with high contrast white background for easy scanning
                Container(
                  padding: const EdgeInsets.all(2),
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Render the QR image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: _buildQrImage(
                          riderVM.qrData?['qr_image'] ??
                              riderVM.qrData?['qr_code'] ??
                              riderVM.qrData?['qr_code_url'] ??
                              riderVM.qrData?['image'] ??
                              '',
                        ),
                      ),

                      // Expired cover/overlay
                      if (_isExpired)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.92),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.timer_off_outlined,
                                    color: AppColors.crimsonRedColor,
                                    size: 48,
                                  ),
                                  SizedBox(height: 8),
                                  CustomText(
                                    data: "QR Code Expired",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Order amount
                CustomText(
                  data: "₹${widget.amount.toStringAsFixed(2)}",
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.whiteColor,
                ),
                const SizedBox(height: 6),
                const CustomText(
                  data: "Scan using any UPI App (GPay, PhonePe, Paytm)",
                  fontSize: 14,
                  color: AppColors.coolGrayColor,
                ),

                const SizedBox(height: 24),

                if (_isExpired) ...[
                  CustomAppButton(
                    text: "Generate New QR",
                    onPressed: _fetchQrCode,
                    isLoading: riderVM.qrLoading,
                  ),
                ] else ...[
                  // Expiry timer
                  if (_secondsRemaining > 0) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          size: 18,
                          color: AppColors.amberColor,
                        ),
                        const SizedBox(width: 6),
                        CustomText(
                          data:
                              "Expires in: ${_formatDuration(_secondsRemaining)}",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.amberColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Waiting status indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const CustomText(
                        data: "Waiting for payment...",
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomAppButton(
                    text: "Check Payment Status",
                    isLoading: riderVM.paymentChecking,
                    onPressed: () => _checkPaymentStatus(manualCheck: true),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
