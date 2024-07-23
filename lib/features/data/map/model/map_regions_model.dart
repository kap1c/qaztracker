// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class RegionsData extends Equatable {
  final List<RegionItem> items;
  final int page;
  final int total;
  final int pages;

  const RegionsData({
    required this.items,
    required this.page,
    required this.total,
    required this.pages,
  });

  factory RegionsData.fromJson(Map<String, dynamic> json) => RegionsData(
      items: List<RegionItem>.from(
          json["items"].map((x) => RegionItem.fromJson(x))),
      page: json["page"],
      total: json["total"],
      pages: json["pages"]);

  @override
  List<Object?> get props => [items];
}

class RegionItem extends Equatable {
  final int id;
  final String name;
  bool isSelected;

  RegionItem({
    required this.id,
    required this.name,
    this.isSelected = false,
  });

  factory RegionItem.fromJson(Map<String, dynamic> json) => RegionItem(
        id: json["id"],
        name: json["name"],
      );
  @override
  List<Object?> get props => [isSelected, id, name];
}
