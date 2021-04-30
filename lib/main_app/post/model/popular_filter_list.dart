class PopularFilterListData {
  PopularFilterListData({
    this.titleTxt = '',
    this.isSelected = false,
  });

  String titleTxt;
  bool isSelected;

  static List<PopularFilterListData> popularFList = <PopularFilterListData>[
    PopularFilterListData(
      titleTxt: 'Generasi Ayah/Ibu',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Generasi Kakek',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Generasi Buyut',
      isSelected: false,
    ),
  ];

  static List<PopularFilterListData> accomodationList = [
    PopularFilterListData(
      titleTxt: 'Semua',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Online saja',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Offline saja',
      isSelected: false,
    ),
  ];
}
