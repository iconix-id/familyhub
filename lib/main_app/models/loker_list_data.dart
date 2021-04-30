class LokerListData {
  LokerListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.loker,
    this.link = '',
  });

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  List<String> loker;
  String link;

  static List<LokerListData> tabIconsList = <LokerListData>[
    LokerListData(
      imagePath: 'assets/main_app/breakfast.png',
      titleTxt: 'PERTAMINA',
      link: 'pertamina200601',
      loker: <String>['Manager,', 'Officer,', 'Chef'],
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    LokerListData(
      imagePath: 'assets/main_app/lunch.png',
      titleTxt: 'TELKOMSEL',
      link: 'telkomsel200529',
      loker: <String>['Staff,', 'Security,', 'Office Boy'],
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    LokerListData(
      imagePath: 'assets/main_app/snack.png',
      titleTxt: 'ICONIX',
      link: 'iconix200531',
      loker: <String>['Programmer', 'Resepsionis', 'Salesman'],
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
    LokerListData(
      imagePath: 'assets/main_app/dinner.png',
      titleTxt: 'MNC-CORP',
      link: 'mnccorp200603',
      loker: <String>['Manager', 'Marketing'],
      startColor: '#6F72CA',
      endColor: '#1E1466',
    ),
  ];
}
