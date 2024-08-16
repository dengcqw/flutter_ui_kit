import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'dart:convert';
import 'package:ui_kit/widget/address_picker/address_picker.dart';
import 'package:ui_kit/widget/address_picker/address_entry.dart';

typedef AddressJon = Map<String, dynamic>;

AddressEntry convertToEntry(AddressJon json) {
  List<dynamic> children = json['children'] ?? [];

  return AddressEntry(
    name: json['name'],
    code: '${json['code']}',
    children: children.map((e) {
      return convertToEntry(e);
    }).toList(),
  );
}

@UseCase(
  name: 'AddressPicker',
  type: AddressPicker,
)
Widget buildAddressPickerUseCase(BuildContext context) {
  return FutureBuilder(
      initialData: EmptyAdddress,
      future: rootBundle.loadString('assets/area_code_2024.json').then((str) {
        List<dynamic> res = json.decode(str);
        final addressEntries = res.map((e) {
          return convertToEntry(e);
        }).toList();
        print('---->xxx addressEntries: ${addressEntries.toString()}');

        return addressEntries;
      }),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.done) {
          print('---->addressEntries: ${snap.data.toString()}');
          return InkWell(
            onTap: () {
              showAddressPickerBottomSheet(
                context,
                onAddressChanged: (result) {
                  print('---->result: ${result.toString()}');
                },
                addressEntries: snap.data,
              );
            },
            child: Text(
              'Show Picker',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
          );
        }
        if (snap.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snap.hasError) {
          return const Text('Error');
        }
        return Container();
      });
}
