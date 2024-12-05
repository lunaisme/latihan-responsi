import 'package:flutter/material.dart';
import 'package:latres/screens/detail/detail_content_screen.dart';
import 'package:latres/services/api_services.dart';
import '../../models/content_model.dart';

class ContentListScreen extends StatefulWidget {
  final String contentType;
  final String title;

  ContentListScreen({
    required this.contentType,
    required this.title,
  });

  @override
  _ContentListScreenState createState() => _ContentListScreenState();
}

class _ContentListScreenState extends State<ContentListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<ContentItem>> _contentFuture;

  @override
  void initState() {
    super.initState();
    _contentFuture = _apiService.getContentList(widget.contentType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<ContentItem>>(
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

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No ${widget.contentType} available'),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(20), // Menambahkan padding
            child: Column(
              children: [
                // Banner untuk berita pertama
                _buildBanner(snapshot
                    .data![0]), // Mengambil berita pertama sebagai banner
                SizedBox(height: 8),
                // Daftar berita
                ListView.builder(
                  shrinkWrap: true, // Menghindari overflow
                  physics:
                      NeverScrollableScrollPhysics(), // Menonaktifkan scroll untuk ListView
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    if (index == 0)
                      return SizedBox(); // Melewatkan berita pertama
                    final item = snapshot.data![index];
                    return ContentListItem(
                      item: item,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContentDetailScreen(
                              contentId: item.id,
                              contentType: widget.contentType,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBanner(ContentItem item) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(item.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContentDetailScreen(
                contentId: item.id,
                contentType: widget.contentType,
              ),
            ),
          );
        },
        child: Container(
          alignment: Alignment.bottomLeft,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black54, Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Text(
            item.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class ContentListItem extends StatelessWidget {
  final ContentItem item;
  final VoidCallback onTap;

  const ContentListItem({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // Gambar di kiri
              if (item.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.imageUrl,
                    height: 100, // Mengubah tinggi gambar
                    width: 100, // Mengatur lebar gambar
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 100,
                        width: 100,
                        color: Colors.grey[300],
                        child: Icon(Icons.error),
                      );
                    },
                  ),
                ),
              SizedBox(width: 16), // Memberikan jarak antara gambar dan teks
              // Teks di kanan
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      item.summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Published: ${DateTime.parse(item.publishedAt).toString().split('.')[0]}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
