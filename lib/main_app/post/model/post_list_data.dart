class PostListData {
  PostListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.subTxt = "",
    this.oleh = '',
    this.reviews = 80,
    this.rating = 4.5,
    this.perNight = 180,
  });

  String imagePath;
  String titleTxt;
  String subTxt;
  String oleh;
  double rating;
  int reviews;
  int perNight;

  static List<PostListData> postList = <PostListData>[
    PostListData(
      imagePath: 'assets/hotel/hotel_1.png',
      titleTxt: 'Grand Royal Hotel',
      subTxt: 'Bogor',
      oleh: 'Much.Syamsul Arifin',
      reviews: 80,
      rating: 4.4,
      perNight: 180,
    ),
    PostListData(
      imagePath: 'assets/hotel/hotel_2.png',
      titleTxt: 'Queen Hotel',
      subTxt: 'Bandung',
      oleh: 'Hawna Imani Fauza',
      reviews: 74,
      rating: 4.5,
      perNight: 200,
    ),
    PostListData(
      imagePath: 'assets/hotel/hotel_3.png',
      titleTxt: 'Grand Royal Hotel',
      subTxt: 'Surabaya',
      oleh: 'Syarif Abdul Karim',
      reviews: 62,
      rating: 4.0,
      perNight: 60,
    ),
    PostListData(
      imagePath: 'assets/hotel/hotel_4.png',
      titleTxt: 'Queen Hotel',
      subTxt: 'Jakarta',
      oleh: 'Admin',
      reviews: 90,
      rating: 4.4,
      perNight: 170,
    ),
    PostListData(
      imagePath: 'assets/hotel/hotel_5.png',
      titleTxt: 'Grand Royal Hotel',
      subTxt: 'Bogor',
      oleh: 'Darti Mari',
      reviews: 240,
      rating: 4.5,
      perNight: 200,
    ),
  ];
}
