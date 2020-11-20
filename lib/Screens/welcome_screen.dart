import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trailerly/movies.dart';
import 'package:trailerly/Screens/trailer.dart';
import 'package:trailerly/MovieData.dart';




class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String posterUrl;
  var movieData;
  var movig;
  String videotag;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUI();

  }
  void GetVideoUrl(String movieh) async
  {
    MoviesInfo moviesInfo = MoviesInfo(movieh);
    var Data = await moviesInfo.getMoviesInfo();
    videotag = Data['items'][0]['id']['videoId'];
  }
  void updateUI() async{
    Movies movies = Movies();
    movieData =  await movies.getMovie();
    posterUrl =  movieData['results'][0]['poster_path'];
    movig = movieData['results'];

    setState(() {
      posterUrl;
    });

  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;




    return Scaffold(


       backgroundColor: Colors.black,
       body: SafeArea(
         child: new GridView.builder(
           itemCount: movig == null ? 0:movig.length,
           gridDelegate:  new SliverGridDelegateWithFixedCrossAxisCount(
               crossAxisCount: 2,
           crossAxisSpacing: 10,
           mainAxisSpacing: 10,
           ),
           itemBuilder: ( BuildContext context, int index){
               return new GestureDetector(
                 onTap: () async{
                   videotag = null;
                   await GetVideoUrl(movieData['results'][index]['title']);
                   if(videotag != null)
                     {
                   Navigator.push(context, MaterialPageRoute(
                     builder: (context) {
                       return TrailerVideo(videotag);
                     }
                   ));
                 }},
                   child: new MovieCell(movig, index),
                           );

           },
           padding: EdgeInsets.all(5.0),


           ),
       ),




         );

  }
}


class MovieCell extends StatelessWidget {

  final movies;
  final i;

  String url = "http://image.tmdb.org/t/p/w500/";
  MovieCell(this.movies, this.i);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(

        height: size.height/3,
        child: Image(
          image: NetworkImage(
             url+movies[i]['poster_path']
          ),
          fit: BoxFit.cover,
        ),

      ),
    );
  }
}
