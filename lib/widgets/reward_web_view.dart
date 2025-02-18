import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:webview_flutter/webview_flutter.dart';
class WebViewPage extends StatefulWidget {
  final String title;
  final int points;
  final String imagePath;
  final int recycledCount;

  const WebViewPage({
    super.key,
    required this.title,
    required this.points,
    required this.imagePath,
    required this.recycledCount,
  });

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  String? base64Image;
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _loadImage();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.dataFromString(
        _buildHtmlContent(''),
        mimeType: 'text/html',
      ));
  }

  Future<void> _loadImage() async {
    try {
      ByteData bytes = await rootBundle.load(widget.imagePath);
      Uint8List imageBytes = bytes.buffer.asUint8List();
      String base64String = base64Encode(imageBytes);

      setState(() {
        base64Image = base64String;
      });

      // Reload the WebView with the correct image
      _controller.loadRequest(Uri.dataFromString(
        _buildHtmlContent(base64String),
        mimeType: 'text/html',
      ));
    } catch (e) {
      print("Error loading image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(widget.title),backgroundColor: Colors.white,),
      body: base64Image == null
          ? const Center(child: CircularProgressIndicator(color: Colors.black,))
          : WebViewWidget(controller: _controller), // Correct WebView usage
    );
  }

  String _buildHtmlContent(String base64Image) {
    return '''
      <!DOCTYPE html>
      <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>${widget.title}</title>
          <style>
              body { font-family: Arial, sans-serif; text-align: center; padding: 20px; background: #F7F6F5; }
              .container { max-width: 600px; margin: auto; padding: 20px; border-radius: 12px; background: white; box-shadow: 0px 4px 6px rgba(0,0,0,0.1); }
              img { width: 80%; max-width: 300px; height: auto; border-radius: 10px; }
              h1 { font-size: 24px; color: #333; }
              p { font-size: 18px; color: #666; }
              .counter { 
                display: inline-block; background-color: green; color: white; padding: 10px 20px; 
                border-radius: 20px; font-size: 16px; font-weight: bold;
              }
          </style>
      </head>
      <body>
          <div class="container">
              <img src="data:image/png;base64,$base64Image" alt="${widget.title}">
              <h1>${widget.title}</h1>
              <p>Points: ${widget.points}</p>
              <p class="counter">Recycled Items: ${widget.recycledCount}</p>
          </div>
      </body>
      </html>
    ''';
  }
}

