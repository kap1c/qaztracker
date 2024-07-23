import 'dart:html';

import 'package:flutter/material.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';
import 'package:qaz_tracker/features/data/add_farm/add_tracking_model.dart';
import 'package:qaz_tracker/features/data/auth/model/manager_model.dart';
import 'package:qaz_tracker/features/data/farm/model/farm_model.dart';
import 'package:qaz_tracker/features/data/logs/model/log_model.dart';
import 'package:qaz_tracker/features/data/map/model/map_item_model.dart';
import 'package:qaz_tracker/features/data/map/model/map_regions_model.dart';
import 'package:qaz_tracker/features/data/sensors/sensor_mode.dart';

class CustomDataTableSource extends DataTableSource {
  final List<dynamic> tableData;
  final bool isEditable;
  final bool isDatabase;
  Function()? callbackEdit;
  Function()? callbackDelete;
  ValueNotifier<dynamic>? valueListenable;

  CustomDataTableSource({
    required this.tableData,
    this.isEditable = false,
    this.isDatabase = false,
    this.callbackEdit,
    this.callbackDelete,
    this.valueListenable,
  });

  @override
  DataRow? getRow(int index) {
    final rowData = tableData[index];
    List<DataCell> cells = [];
    if (rowData is FarmModel) {
      if (isDatabase) {
        cells = buildDatabaseCell(rowData);
      } else {
        cells = buildFarmCell(rowData);
      }
    } else if (rowData is LogModel) {
      cells = buildLogsCell(rowData);
    } else if (rowData is RegionItem) {
      cells = buildRegionCell(rowData);
    } else if (rowData is Breed) {
      cells = buildBreedCells(rowData);
    } else if (rowData is ManagerModel) {
      cells = buildUserCell(rowData);
    } else if (rowData is FarmAnimalModel) {
      cells = buildFarmAnimalCell(rowData);
    } else if (rowData is SensorModel) {
      cells = buildSensorsCell(rowData);
    }

    if (isEditable) {
      cells.add(
        DataCell(
          PopupMenuButton(
            icon: const Icon(
              Icons.more_horiz,
              color: Colors.black,
            ),
            onSelected: (value) {
              if (callbackEdit != null) {
                valueListenable!.value = rowData;
                switch (value) {
                  case ("edit"):
                    callbackEdit!();
                    break;
                  case ("delete"):
                    callbackDelete!();
                }
              }
              ;
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 'edit',
                  // onTap: callbackEdit!(),
                  child: Text(
                    callbackEdit != null
                        ? 'Редактировать'
                        : "No callback passed to popmenuitem",
                    style: const TextStyle(
                        color: Color(0XFF1C202C),
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  // onTap: callbackDelete != null ? callbackDelete!() : () {},
                  child: Text(
                    callbackDelete != null
                        ? 'Удалить'
                        : "No callback passed to popmenuitem",
                    style: const TextStyle(
                        color: Color(0XFFFF5656),
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ];
            },
          ),
        ),
      );
    }

    return DataRow(cells: cells);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => tableData.length;

  @override
  int get selectedRowCount => 0;
}

Widget buildTableRows(
  List<dynamic> tableData, {
  bool isEditable = false,
  Function()? callbackEdit,
  Function()? callbackDelete,
  ValueNotifier<dynamic>? valueListenable,
  bool isDataBase = false,
}) {
  final customDataTableSource = CustomDataTableSource(
    tableData: tableData,
    isEditable: isEditable,
    callbackEdit: callbackEdit,
    callbackDelete: callbackDelete,
    valueListenable: valueListenable,
    isDatabase: isDataBase,
  );

  return DataTable(
    columns: _buildColumns(tableData, isEditable, isDatabase: isDataBase),
    rows: _buildRows(customDataTableSource),
    dataTextStyle: const TextStyle(
      color: Color(0XFF444B5F),
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
    headingRowColor: MaterialStateColor.resolveWith(
      (states) => const Color.fromRGBO(240, 241, 245, 0.2),
    ),
    border: TableBorder.all(
      width: 1.0,
      color: AppColors.secondaryTextFieldBorderColor,
      borderRadius: BorderRadius.circular(8.0),
    ),
  );
}

List<DataColumn> _buildColumns(List<dynamic> tableData, bool isEditable,
    {bool isDatabase = false}) {
  List<DataColumn> columns = [];

  if (tableData.isNotEmpty) {
    final rowData = tableData.first;

    if (rowData is FarmModel) {
      if (!isDatabase) {
        columns.addAll(getFarmTableHeaders());
      } else {
        columns.addAll(getDatabaseHeaders());
      }
    } else if (rowData is RegionItem) {
      columns.addAll(getRegionHeaders());
    } else if (rowData is LogModel) {
      columns.addAll(getLogsHeaders());
    } else if (rowData is Breed) {
      columns.addAll(getBreedHeaders());
    } else if (rowData is ManagerModel) {
      columns.addAll(getUserHeaders());
    } else if (rowData is FarmAnimalModel) {
      columns.addAll(getFarmAnimalHeaders());
    } else if (rowData is SensorModel) {
      columns.addAll(getSensorsHeader());
    }
  }

  // if (isEditable) {
  //   columns.add(const DataColumn(label: Text("")));
  // }

  return columns;
}

List<DataRow> _buildRows(CustomDataTableSource source) {
  return List.generate(source.rowCount, (index) => source.getRow(index)!);
}

List<DataColumn> getFarmTableHeaders() {
  return [
    getColumn("Наименование фермы"),
    getColumn("БИН/ИИН"),
    getColumn("Кол-во животных"),
    getColumn("Кол-во трекеров"),
    getColumn("Площадь фермы"),
    getColumn("Менеджер"),
  ];
}

List<DataCell> buildFarmCell(FarmModel model) {
  return [
    DataCell(Row(children: [Text(model.name!)])),
    DataCell(Text(model.bin!)),
    DataCell(Text((model.trackersCount!).toString())),
    DataCell(Text((model.trackersCount!).toString())),
    DataCell(Text((model.area!).toString())),
    DataCell(Text(model.managerName != null ? model.managerName! : '')),
  ];
}

List<DataCell> buildDatabaseCell(FarmModel model) {
  return [
    DataCell(Row(children: [Text(model.name!)])),
    DataCell(Text(model.regionName ?? "")),
    DataCell(Text(model.bin!)),
    DataCell(Text((model.trackersCount!).toString())),
    DataCell(Text((model.trackersCount!).toString())),
    DataCell(Text((model.area!).toString())),
    DataCell(Text(model.managerName != null ? model.managerName! : '')),
  ];
}

List<DataColumn> getDatabaseHeaders() {
  return [
    getColumn("Наименование фермы"),
    getColumn("Область"),
    getColumn("БИН/ИИН"),
    getColumn("Кол-во животных"),
    getColumn("Кол-во трекеров"),
    getColumn("Площадь фермы"),
    getColumn("Менеджер"),
  ];
}

List<DataColumn> getTrackingsHeaders() {
  return [
    getColumn('КРС'),
    getColumn('Уровень сигнала'),
    getColumn('Уровень акк-я'),
    getColumn('Включен'),
  ];
}

// List<DataCell> buildTrackingsCell(TrackingsModel model) {
//   return [
//     DataCell(Text(model.name!)),
//     DataCell(Text(model.signalLevel!)),
//     DataCell(Text(model.batteryLevel!)),
//     DataCell(Text(model.isEnabled!)),
//   ];
// }

List<DataColumn> getLogsHeaders() {
  return [
    getColumn('Дата и время'),
    getColumn('Пользователь'),
    getColumn('Роль'),
    getColumn('Действия '),
    getColumn('IP'),
  ];
}

List<DataCell> buildLogsCell(LogModel model) {
  return [
    DataCell(Text((model.createdAt!).toString())),
    DataCell(Text(model.userName!)),
    DataCell(Text(model.role!)),
    DataCell(Text(model.message!)),
    DataCell(Text(model.submitterIp!)),
  ];
}

List<DataColumn> getBreedHeaders() {
  return [
    getColumn("ID"),
    getColumn('Порода'),
    getColumn("Тип животного"),
    getColumn(""),
  ];
}

List<DataCell> buildBreedCells(Breed model) {
  return [
    DataCell(Text(model.id.toString())),
    DataCell(Text(model.name!)),
    DataCell(Text(model.animalTypeName.toString())),
  ];
}

List<DataColumn> getRegionHeaders() {
  return [
    getColumn("ID"),
    getColumn('Области'),
    getColumn(""),
  ];
}

List<DataCell> buildRegionCell(RegionItem model) {
  return [
    DataCell(Text(model.id.toString())),
    DataCell(Text(model.name)),
  ];
}

List<DataColumn> getUserHeaders() {
  return [
    getColumn("ID"),
    getColumn('ФИО'),
    getColumn('Телефон'),
    getColumn('Пароль'),
    getColumn('Роль'),
    getColumn(""),
  ];
}

List<DataCell> buildUserCell(ManagerModel model) {
  return [
    DataCell(Text(model.id.toString())),
    DataCell(Text(model.fio!)),
    DataCell(Text(model.phone!)),
    const DataCell(Text("1234567Aa")),
    DataCell(Text(model.role!)),
  ];
}

List<DataColumn> getFarmAnimalHeaders() {
  return [
    getColumn('Имя'),
    getColumn('Возраст'),
    getColumn('Вес'),
    getColumn('Пол'),
    getColumn('Тип животного'),
    getColumn('Порода'),
    getColumn('ID Трекерa'),
    getColumn(""),
  ];
}

List<DataCell> buildFarmAnimalCell(FarmAnimalModel model) {
  return [
    DataCell(Text(model.name!)),
    DataCell(Text((model.age!).toString())),
    DataCell(Text((model.weight!).toString())),
    DataCell(Text(model.gender!)),
    DataCell(Text((model.animalTypeName!).toString())),
    DataCell(Text((model.breedName!).toString())),
    DataCell(Text(model.trackerId!)),
  ];
}

List<DataColumn> getSensorsHeader() {
  return [
    getColumn("ID трекера"),
    getColumn("Уровень сигнала"),
    getColumn("Уровень акк-я"),
    getColumn("Включен"),
  ];
}

List<DataCell> buildSensorsCell(SensorModel model) {
  return [
    DataCell(Row(children: [
      // Icon(
      //   Icons.check_box_outline_blank_rounded,
      //   color: Colors.grey.shade300,
      // ),
      // const SizedBox(
      //   width: 8,
      // ),
      Text((model.trackerId!).toString())
    ])),
    DataCell(Row(children: [
      Icon(
        Icons.signal_cellular_alt,
        color: model.networkSignalColor(),
      ),
      const SizedBox(
        width: 8,
      ),
      Text(model.networkSignalDescription()!)
    ])),
    DataCell(Text(
      (model.battery!).toString(),
    )),
    DataCell(Row(children: [
      Icon(
        Icons.circle,
        color: model.isTurnedOn! ? Colors.green.shade700 : Colors.red.shade600,
        size: 10,
      ),
      const SizedBox(
        width: 8,
      ),
      Text(model.isTurnedOn == true ? "Да" : "Нет")
    ])),
  ];
}

DataColumn getColumn(String label) {
  return DataColumn(
    onSort: (columnIndex, sortAscending) {},
    label: Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}
