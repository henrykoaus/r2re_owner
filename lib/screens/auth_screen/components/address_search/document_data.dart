class Address {
  final String addressName;
  final String region1DepthName;
  final String region2DepthName;
  final String region3DepthName;
  final String region3DepthHName;
  final String hCode;
  final String bCode;
  final String mountainYN;
  final String mainAddressNo;
  final String subAddressNo;
  final String x;
  final String y;

  Address({
    required this.addressName,
    required this.region1DepthName,
    required this.region2DepthName,
    required this.region3DepthName,
    required this.region3DepthHName,
    required this.hCode,
    required this.bCode,
    required this.mountainYN,
    required this.mainAddressNo,
    required this.subAddressNo,
    required this.x,
    required this.y,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressName: json['address_name'] ?? '',
      region1DepthName: json['region_1depth_name'] ?? '',
      region2DepthName: json['region_2depth_name'] ?? '',
      region3DepthName: json['region_3depth_name'] ?? '',
      region3DepthHName: json['region_3depth_h_name'] ?? '',
      hCode: json['h_code'] ?? '',
      bCode: json['b_code'] ?? '',
      mountainYN: json['mountain_yn'] ?? '',
      mainAddressNo: json['main_address_no'] ?? '',
      subAddressNo: json['sub_address_no'] ?? '',
      x: json['x'] ?? '',
      y: json['y'] ?? '',
    );
  }
}

class RoadAddress {
  final String addressName;
  final String region1DepthName;
  final String region2DepthName;
  final String region3DepthName;
  final String roadName;
  final String undergroundYN;
  final String mainBuildingNo;
  final String subBuildingNo;
  final String buildingName;
  final String zoneNo;
  final String x;
  final String y;

  RoadAddress({
    required this.addressName,
    required this.region1DepthName,
    required this.region2DepthName,
    required this.region3DepthName,
    required this.roadName,
    required this.undergroundYN,
    required this.mainBuildingNo,
    required this.subBuildingNo,
    required this.buildingName,
    required this.zoneNo,
    required this.x,
    required this.y,
  });

  factory RoadAddress.fromJson(Map<String, dynamic> json) {
    return RoadAddress(
      addressName: json['address_name'] ?? '',
      region1DepthName: json['region_1depth_name'] ?? '',
      region2DepthName: json['region_2depth_name'] ?? '',
      region3DepthName: json['region_3depth_name'] ?? '',
      roadName: json['road_name'] ?? '',
      undergroundYN: json['underground_yn'] ?? '',
      mainBuildingNo: json['main_building_no'] ?? '',
      subBuildingNo: json['sub_building_no'] ?? '',
      buildingName: json['building_name'] ?? '',
      zoneNo: json['zone_no'] ?? '',
      x: json['x'] ?? '',
      y: json['y'] ?? '',
    );
  }
}

class DocumentData {
  final String addressName;
  final String y;
  final String x;
  final Address address;
  final RoadAddress roadAddress;

  DocumentData({
    required this.addressName,
    required this.y,
    required this.x,
    required this.address,
    required this.roadAddress,
  });

  factory DocumentData.fromJson(Map<String, dynamic> json) {
    return DocumentData(
      addressName: json['address_name'] ?? '',
      y: json['y'] ?? '',
      x: json['x'] ?? '',
      address: json['address'] != null
          ? Address.fromJson(json['address'])
          : Address(
              addressName: '',
              region1DepthName: '',
              region2DepthName: '',
              region3DepthName: '',
              region3DepthHName: '',
              hCode: '',
              bCode: '',
              mountainYN: '',
              mainAddressNo: '',
              subAddressNo: '',
              x: '',
              y: '',
            ),
      roadAddress: json['road_address'] != null
          ? RoadAddress.fromJson(json['road_address'])
          : RoadAddress(
              addressName: '',
              region1DepthName: '',
              region2DepthName: '',
              region3DepthName: '',
              roadName: '',
              undergroundYN: '',
              mainBuildingNo: '',
              subBuildingNo: '',
              buildingName: '',
              zoneNo: '',
              x: '',
              y: '',
            ),
    );
  }
}
