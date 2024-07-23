import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_bloc_builder.dart';
import 'package:provider/provider.dart';
import 'package:qaz_tracker/common/widgets/app_loading_widget.dart';
import 'package:qaz_tracker/common/widgets/table/cubit/table_cubit.dart';
import 'package:qaz_tracker/common/widgets/table/ui/table_entry.dart';
import 'package:qaz_tracker/features/data/farm/model/tracking_diagram.dart';
import 'package:qaz_tracker/features/data/farm/model/trackings_model.dart';

class CustomTable extends StatefulWidget {
  final String category;
  Function()? callbackEdit;
  Function()? callbackDelete;
  bool isEditable;
  ValueNotifier<dynamic>? valueListenable;
  ValueNotifier<Map<String, dynamic>>? queryParams;
  
    StreamController<List<FarmTracking>>? stream 
      ;
  bool isDataBase;
  CustomTable({
    required this.category,
    this.isEditable = false,
    this.isDataBase = false,
    this.callbackEdit,
    this.callbackDelete,
    this.valueListenable,
    this.queryParams,
    this.stream
  });

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  late TableCubit _tableCubit;

  @override
  void initState() {
    super.initState();

    _tableCubit = TableCubit(category: widget.category, dataStream: widget.stream);
    if (widget.queryParams != null) {
      widget.queryParams!.addListener(
        () {
          _tableCubit.fetchData(queryParams: widget.queryParams!.value);
        },
        );
      if(widget.queryParams!.value.isEmpty && widget.category!="tracking"){
        _tableCubit.fetchData();
      }
    
    } else {
      _tableCubit.fetchData();
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => _tableCubit,
      child: CoreUpgradeBlocBuilder<TableCubit, TableState>(
        buildWhen: (prevState, curState) => curState is TableState,
        builder: ((context, state) {
          if (state is TableState) {
            if (state.isLoading == true) {
              return const AppLoaderWidget();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                (state.tableItems != null && state.tableItems!.isNotEmpty)
                    ? buildTableRows(
                        state.tableItems!,
                        isEditable: widget.isEditable,
                        callbackEdit: widget.callbackEdit,
                        callbackDelete: widget.callbackDelete,
                        valueListenable: widget.valueListenable,
                        isDataBase: widget.isDataBase,
                      )
                    : const Center(
                        child: Text("Нет данных для отображения, попробуйте "
                            "изменить параметры фильтра.")),
                const SizedBox(height: 24.0),
                (state.tableItems != null && state.tableItems!.isNotEmpty)
                        ? WebsitePaginator(
                            currentPage: state.currentPage!,
                            totalPages: state.maximumPages!,
                            totalItems: state.totalItems!,
                            onPageSelected: (page) {
                              _tableCubit.fetchData(page: page, queryParams: widget.queryParams!.value);
                            },
                          )
                        : const SizedBox()
                    ,
              ],
            );
          } else {
            return const SizedBox();
          }
        }),
      ),
    );
  }
}

class WebsitePaginator extends StatefulWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final Function(int) onPageSelected;

  WebsitePaginator({
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
    required this.totalItems,
  });

  @override
  State<WebsitePaginator> createState() => _WebsitePaginatorState();
}

class _WebsitePaginatorState extends State<WebsitePaginator> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 24.0),
          child: Text("Total ${widget.totalItems} items"),
        ),
        SizedBox(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Container(
                    height: 32,
                    width: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.0),
                      border: Border.all(
                        width: 1,
                        color: const Color(0XFFE8E9EE),
                      ),
                    ),
                    child: const Icon(
                      Icons.chevron_left,
                      size: 12,
                    ),
                  ),
                  onTap: () {
                    if (widget.currentPage > 0) {
                      setState(() {
                        (widget.currentPage - 1);
                      });
                      widget.onPageSelected(widget.currentPage - 1);
                    }
                  },
                ),
                ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.totalPages + 1,
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 8,
                  ),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const SizedBox();
                    } else {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            (widget.currentPage);
                          });
                          widget.onPageSelected(index);
                        },
                        child: Container(
                          height: 32,
                          width: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.0),
                              border: Border.all(
                                width: 1,
                                color: widget.currentPage == index
                                    ? const Color(0XFF3772FF)
                                    : const Color(0XFFE8E9EE),
                              )),
                          child: Text(
                            index.toString(),
                            style: TextStyle(
                              color: widget.currentPage == index
                                  ? const Color(0XFF3772FF)
                                  : const Color(0XFF32384A),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  child: Container(
                    height: 32,
                    width: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.0),
                      border: Border.all(
                        width: 1,
                        color: const Color(0XFFE8E9EE),
                      ),
                    ),
                    child: const Icon(
                      Icons.chevron_right,
                      size: 16,
                    ),
                  ),
                  onTap: () {
                    if (widget.currentPage < widget.totalPages) {
                      setState(() {
                        (widget.currentPage + 1);
                      });
                      widget.onPageSelected(widget.currentPage + 1);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
