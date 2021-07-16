class Song {
  String imagePath;
  String name;
  String id;

  Song({this.id, this.imagePath, this.name});
}

List<Song> songs = [
  Song(imagePath: 'images/1.jpg', name: 'First song', id: '1'),
  Song(imagePath: 'images/2.jpg', name: 'Second song', id: '2'),
  Song(imagePath: 'images/3.jpg', name: 'Third song', id: '3'),
  Song(imagePath: 'images/4.jpg', name: 'Fourth song', id: '4'),
];
