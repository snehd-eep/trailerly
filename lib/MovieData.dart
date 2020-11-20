import 'package:flutter/cupertino.dart';

import 'networking.dart';

const baseAPIurl = 'https://youtube.googleapis.com/youtube/v3/search?part=snippet&channelId=UCi8e0iOVk1fEOogdfu4YgfA&maxResults=1&safeSearch=none&key=AIzaSyAL3vhy-iycV9oehN8nKSoEefREGLmZYL4';


class MoviesInfo{
  
  final movieName;
  MoviesInfo(@required this.movieName);
  
  Future<dynamic> getMoviesInfo()  async {
    var url = baseAPIurl+'&q=$movieName';
    NetworkHelper networkHelper = NetworkHelper(url);
    var moviesInfo = networkHelper.getData();
    return moviesInfo;
    
    
    
  }
  
  
}