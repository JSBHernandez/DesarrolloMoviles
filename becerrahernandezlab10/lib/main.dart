import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(VideoApp());
}

class VideoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: VideoListScreen(),
    );
  }
}

class VideoListScreen extends StatelessWidget {
  final List<Map<String, String>> videos = [
    {
      'title': 'Daredevil vs Muse | Daredevil: Born Again | Fight Scene',
      'path': 'assets/video1.mp4',
      'thumbnail': 'assets/thumb1.jpg',
      'duration': '1:58',
      'size': '4.13 MB'
    },
    {
      'title': 'Video 2',
      'path': 'assets/video2.mp4',
      'thumbnail': 'assets/thumb2.jpg',
      'duration': '3:45',
      'size': '20MB'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Videos')),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(video: video),
                  ),
                );
              },
              child: Row(
                children: [
                  Image.asset(
                    video['thumbnail']!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video['title']!,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text('Duración: ${video['duration']}'),
                        Text('Tamaño: ${video['size']}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final Map<String, String> video;

  VideoPlayerScreen({required this.video});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.video['path']!)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.video['title']!)),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: _controller.value.isInitialized
                ? _controller.value.aspectRatio
                : 16 / 9,
            child: _controller.value.isInitialized
                ? VideoPlayer(_controller)
                : Center(child: CircularProgressIndicator()),
          ),
          VideoProgressIndicator(_controller, allowScrubbing: true),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
            child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
          ),
          InfoVideo(
            title: widget.video['title']!,
            duration: widget.video['duration']!,
            size: widget.video['size']!,
          ),
        ],
      ),
    );
  }
}

class InfoVideo extends StatelessWidget {
  final String title;
  final String duration;
  final String size;

  InfoVideo({required this.title, required this.duration, required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nombre: $title', style: TextStyle(fontSize: 16)),
          Text('Duración: $duration'),
          Text('Tamaño: $size'),
        ],
      ),
    );
  }
}
