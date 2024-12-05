import 'package:flutter/material.dart';
import 'package:latres/services/api_services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/content_model.dart';

class ContentDetailScreen extends StatefulWidget {
  final int contentId;
  final String contentType;

  ContentDetailScreen({
    required this.contentId,
    required this.contentType,
  });

  @override
  _ContentDetailScreenState createState() => _ContentDetailScreenState();
}

class _ContentDetailScreenState extends State<ContentDetailScreen> {
  final ApiService _apiService = ApiService();
  late Future<ContentItem> _contentFuture;

  @override
  void initState() {
    super.initState();
    _contentFuture = _apiService.getContentDetail(
      widget.contentType,
      widget.contentId,
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: FutureBuilder<ContentItem>(
        future: _contentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text('No data available'),
            );
          }

          final item = snapshot.data!;
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.imageUrl,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 250,
                          color: Colors.grey[300],
                          child: Icon(Icons.error),
                        );
                      },
                    ),
                  ),
                SizedBox(height: 16),
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Published: ${DateTime.parse(item.publishedAt).toString().split('.')[0]}',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  item.summary,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final item = await _contentFuture;
          _launchUrl(item.url);
        },
        child: Icon(Icons.launch),
        tooltip: 'Open in browser',
      ),
    );
  }
}
