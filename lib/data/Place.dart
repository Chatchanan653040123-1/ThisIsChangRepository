class Place {
  final String place;
  final String placeImage;
  // final String numRat;
  // final String numLon;

  const Place(
      {required this.place,
      required this.placeImage,
      // required this.numRat,
      // required this.numLon
      });
}

const List<Place> allPlace = [
  Place(place: "ตึกภาควิศวกรรมเครื่องกล EN10", placeImage: "assets/images/en10.jpg"),
  Place(place: "ตึกภาควิศวกรรมไฟฟ้า EN11", placeImage: "assets/images/en18.jpg"),
  // Place(
  //     place: "อาคารปฏิบัติการวิศวกรรมเกษตร EN12", ),
  // Place(place: "ตึกภาควิศวกรรมสิ่งแวดล้อม EN13", ),
  // Place(place: "ตึกภาควิศวกรรมเคมี EN14", numRat: "", numLon: "numLon"),
  // Place(place: "ตึกเพียรวิจิตร EN16", numRat: "", numLon: "numLon"),
  // Place(
  //     place: "อาคารปฏิบัติการวิศวกรรมอุตสาหการ EN17",
  //     numRat: "",
  //     numLon: "numLon"),
  Place(place: "อาคาร 50 ปี วิศวกรรมรวมใจ EN18", placeImage:  "assets/images/en18.jpg"),
];
