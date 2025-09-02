import 'package:flutter/material.dart';
import 'services/tvmaze_api_service.dart';
import 'models/show.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TV Maze Shows',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: ShowListScreen(),
    );
  }
}

class ShowListScreen extends StatefulWidget {
  @override
  _ShowListScreenState createState() => _ShowListScreenState();
}

class _ShowListScreenState extends State<ShowListScreen> {
  late Future<List<Show>> _futureShows;
  final apiService = TvMazeApiService();

  @override
  void initState() {
    super.initState();
    _futureShows = apiService.fetchShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TV Maze Shows'),
        elevation: 2,
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Show>>(
        future: _futureShows,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Show> shows = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: shows.length,
                itemBuilder: (context, index) {
                  final show = shows[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ShowDetailScreen(show: show),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: show.imageMedium != null
                                  ? Image.network(
                                      show.imageMedium!,
                                      width: 80,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: 80,
                                      height: 120,
                                      color: Colors.grey[300],
                                      child: Icon(Icons.tv, size: 40),
                                    ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                show.name,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ShowDetailScreen extends StatelessWidget {
  final Show show;

  const ShowDetailScreen({Key? key, required this.show}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final summaryText = show.summary != null
        ? show.summary!.replaceAll(RegExp(r'<[^>]*>'), '')
        : 'No summary available';

    return Scaffold(
      appBar: AppBar(
        title: Text(show.name),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (show.imageMedium != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(show.imageMedium!),
                ),
              ),
            SizedBox(height: 16),
            Text(
              show.name,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              summaryText,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
