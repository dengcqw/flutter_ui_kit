import 'dart:async';
import 'package:flutter/material.dart';

import 'address_result_entry.dart';
import 'address_entry.dart';
import 'fixed_scroll_physics.dart';

Future showAddressPickerBottomSheet(
  BuildContext context, {
  String? province,
  String? city,
  String? area,
  List<AddressEntry>? addressEntries,
  ValueChanged<AddressResultEntry>? onAddressChanged,
}) {
  return showModalBottomSheet(
      context: context,
      builder: (ctx) => AddressPicker(
            addressEntries: addressEntries ?? [],
            province: province,
            city: city,
            area: area,
            onAddressChanged: onAddressChanged,
          ));
}

final EmptyAdddress = [AddressEntry(name: '请选择', code: '-10000')];

class AddressPicker extends StatefulWidget {
  /// 当前选中省份
  final String? province;

  /// 当前选中城市
  final String? city;

  /// 当前选中区域
  final String? area;

  /// 地址信息链表
  final List<AddressEntry> addressEntries;

  /// 返回选中的地址信息
  final ValueChanged<AddressResultEntry>? onAddressChanged;

  const AddressPicker({
    required this.addressEntries,
    this.province,
    this.city,
    this.area,
    this.onAddressChanged,
    Key? key,
  }) : super(key: key);

  @override
  AddressPickerState createState() => AddressPickerState();
}

class AddressPickerState extends State<AddressPicker> {
  late FixedScrollController provinceScrollCon;
  late FixedScrollController cityScrollCon;
  late FixedScrollController areaScrollCon;

  int provinceIndex = 0;
  int cityIndex = 0;
  int areaIndex = 0;

  @override
  void initState() {
    super.initState();

    provinceScrollCon = FixedScrollController(initialItem: 0);
    cityScrollCon = FixedScrollController(initialItem: 0);
    areaScrollCon = FixedScrollController(initialItem: 0);
  }

  @override
  void dispose() {
    provinceScrollCon.dispose();
    cityScrollCon.dispose();
    areaScrollCon.dispose();
    super.dispose();
  }

  List<AddressEntry> get provinceData {
    return widget.addressEntries ?? EmptyAdddress;
  }

  List<AddressEntry> get cityData {
    return provinceData[provinceIndex]?.children ?? EmptyAdddress;
  }

  List<AddressEntry> get areaData {
    return cityData[cityIndex]?.children ?? EmptyAdddress;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(
            height: 34,
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      '省份',
                      style: TextStyle(
                        color: Color(0xFF3C3C3C),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '城市',
                      style: TextStyle(
                        color: Color(0xFF3C3C3C),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '区县',
                      style: TextStyle(
                        color: Color(0xFF3C3C3C),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Picker(
                    data: provinceData,
                    controller: provinceScrollCon,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        if (provinceIndex != index) {
                          cityIndex = 0;
                          areaIndex = 0;
                        }
                        provinceIndex = index;
                      });
                      //widget.onAddressChanged?.call(AddressResultEntry(
                        //province: provinces[index].name,
                        //provinceCode: provinces[index].code,
                      //));
                    },
                  ),
                ),
                Expanded(
                  child: Picker(
                    data: cityData,
                    controller: cityScrollCon,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        if (cityIndex != index) {
                          areaIndex = 0;
                        }
                        cityIndex = index;
                      });
                      //widget.onAddressChanged?.call(
                        //AddressResultEntry(
                          //province:
                              //provinces[provinceScrollCon.selectedItem].name,
                          //provinceCode:
                              //provinces[provinceScrollCon.selectedItem].code,
                          //city: index == 0 ? null : cities[index].name,
                          //cityCode: index == 0 ? null : cities[index].code,
                        //),
                      //);
                    },
                  ),
                ),
                Expanded(
                  child: Picker(
                    data: areaData,
                    controller: areaScrollCon,
                    onSelectedItemChanged: (index) {
                      areaIndex = index;
                      //widget.onAddressChanged?.call(
                        //AddressResultEntry(
                          //province:
                              //provinces[provinceScrollCon.selectedItem].name,
                          //provinceCode:
                              //provinces[provinceScrollCon.selectedItem].code,
                          //city: cities[cityScrollCon.selectedItem].name,
                          //cityCode: cities[cityScrollCon.selectedItem].code,
                          //area: index == 0 ? null : areas[index].name,
                          //areaCode: index == 0 ? null : areas[index].code,
                        //),
                      //);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Picker extends StatefulWidget {
  final List<AddressEntry> data;
  final int showItemCount;
  final ValueChanged<int>? onSelectedItemChanged;
  final FixedScrollController controller;

  const Picker({
    required this.data,
    required this.controller,
    this.showItemCount = 10,
    this.onSelectedItemChanged,
    Key? key,
  }) : super(key: key);

  @override
  PickerState createState() => PickerState();
}

class PickerState extends State<Picker> {
  int? index;

  @override
  void initState() {
    super.initState();
    index = widget.controller.initialItem;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final itemCount = widget.showItemCount + widget.data.length - 1;
      final itemHeight = constraints.maxHeight / widget.showItemCount;
      return Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.depth == 0 &&
                  widget.onSelectedItemChanged != null &&
                  notification.metrics is FixedScrollMetrics) {
                final FixedExtentMetrics metrics =
                    notification.metrics as FixedExtentMetrics;
                final int currentItemIndex = metrics.itemIndex;

                if (notification is ScrollUpdateNotification) {
                  setState(() {
                    index = currentItemIndex;
                  });
                }

                if (notification is ScrollEndNotification) {
                  widget.onSelectedItemChanged!(currentItemIndex);
                }
              }
              return false;
            },
            child: ListView.builder(
              itemBuilder: (context, index) {
                if (index >= widget.data.length) return const SizedBox();

                final text = widget.data[index].name!;
                final isSelected = index != 0 && this.index == index;
                return GestureDetector(
                  onTap: () {
                    widget.controller.animateToItem(index,
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeIn);
                  },
                  child: Center(
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Color(isSelected ? 0xFFE6262C : 0xFF999999),
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
              itemCount: itemCount,
              itemExtent: itemHeight,
              controller: widget.controller,
              physics: FixedScrollPhysics(itemHeight),
            ),
          ),
          IgnorePointer(
            child: Container(
              height: itemHeight,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFEBEBEB), width: 0.5),
                  bottom: BorderSide(color: Color(0xFFEBEBEB), width: 0.5),
                ),
              ),
            ),
          )
        ],
      );
    });
  }
}
