class AddressResultEntry {
  String? province;
  String? provinceCode;
  String? city;
  String? cityCode;
  String? area;
  String? areaCode;

  AddressResultEntry({
    this.province,
    this.provinceCode,
    this.city,
    this.cityCode,
    this.area,
    this.areaCode,
  });

  @override
  String toString() {
    return 'AddressResultEntry{province: $province, provinceCode: $provinceCode, city: $city, cityCode: $cityCode, area: $area, areaCode: $areaCode}';
  }
}
