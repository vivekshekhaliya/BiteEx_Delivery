import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../res/constants/app_colors.dart';

class MapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String address;

  const MapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Build Google Maps URL with coordinates
    final mapUrl =
        'https://www.google.com/maps/search/?api=1&query=${widget.latitude},${widget.longitude}';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            _controller.runJavaScript('''
              (function() {
                const hideElements = () => {
                  const elements = document.querySelectorAll('button, a, div, span, p');
                  for (const el of elements) {
                    if (el.textContent) {
                      const text = el.textContent.trim();
                      if (text === 'Open app' || text === 'Open App' || text === 'Google Maps') {
                        let parent = el;
                        for (let i = 0; i < 5; i++) {
                          if (parent.parentElement && parent.parentElement.tagName !== 'BODY') {
                            parent = parent.parentElement;
                          } else {
                            break;
                          }
                        }
                        parent.style.setProperty('display', 'none', 'important');
                      }
                    }
                  }

                  const selectors = ['header', '[class*="promotion"]', '[class*="banner"]', '[class*="promo"]'];
                  for (const sel of selectors) {
                    const items = document.querySelectorAll(sel);
                    for (const item of items) {
                      const rect = item.getBoundingClientRect();
                      if (rect.top >= 0 && rect.top < 100 && rect.height > 0 && rect.height < 150) {
                        item.style.setProperty('display', 'none', 'important');
                      }
                    }
                  }
                };

                hideElements();
                const interval = setInterval(hideElements, 300);
                setTimeout(() => clearInterval(interval), 6000);
              })();
            ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;
            if (!url.startsWith('http://') && !url.startsWith('https://')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(mapUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),

          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),

          /// Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 16,
            child: SafeArea(
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(150),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
