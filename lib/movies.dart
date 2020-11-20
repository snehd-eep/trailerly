import 'networking.dart';



const APIurl = 'https://api.themoviedb.org/3/movie/now_playing?api_key=['Your API KEY']&language=en-US&page=1';



class Movies{

  Future<dynamic> getMovie() async {
    var url = APIurl;
    NetworkHelper networkHelper = NetworkHelper(url);
    var MoviesData = await networkHelper.getData();
    return MoviesData;
  }
}
