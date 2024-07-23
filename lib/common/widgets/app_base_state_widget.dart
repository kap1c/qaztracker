// ignore_for_file: import_of_legacy_library_into_null_safe, depend_on_referenced_packages

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_bloc_builder.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:qaz_tracker/common/widgets/app_loading_widget.dart';
import 'package:qaz_tracker/config/routes/app_route_list.dart';

class BaseUpgradeBlocBuilder<C extends Cubit<S>, S extends CoreState>
    extends StatelessWidget {
  /// Функция [builder], которая будет вызываться при каждой сборке виджета.
  /// [Builder] принимает `BuildContext` и текущее` состояние` и
  /// должен возвращать виджет.
  /// Это аналог функции [builder] в [StreamBuilder].
  final BlocWidgetBuilder<S>? builder;

  /// Функция [builder], которая будет вызываться в случае отсутвия интернета при первичном запуске,
  /// для того чтобы пользователь мог, позвторно сделать запрос,
  /// послудущие разы, данные кульбэк вызываться не будет
  /// [Builder] принимает `BuildContext` и текущее` состояние` и
  /// должен возвращать виджет.
  /// Это аналог функции [builder] в [StreamBuilder].
  final BlocWidgetBuilder<S>? notInternetConnectionBuilder;

  /// Функция [builder], которая будет вызываться при первом перестроении в случае ошибки,
  /// для того чтобы пользователь мог, позвторно сделать запрос
  /// [Builder] принимает `BuildContext` и текущее` состояние` и
  /// должен возвращать виджет.
  /// Это аналог функции [builder] в [StreamBuilder].
  final BlocWidgetBuilder<S>? errorBuilder;

  /// [Cubit], с которым будет взаимодействовать [BlocConsumer].
  /// Если не указано, [BlocConsumer] автоматически выполнит поиск, используя
  /// `BlocProvider` и текущий` BuildContext`.
  final C? cubit;

  /// Принимает `BuildContext` вместе с [cubit]` state`
  /// и отвечает за выполнение в ответ на изменения состояния.
  final BlocWidgetListener<S?>? listener;

  /// Принимает предыдущее `состояние` и текущее` состояние` и отвечает за
  /// возвращаем [bool], который определяет, запускать или нет
  /// [строитель] с текущим `состоянием`.
  final BlocBuilderCondition<Object?>? buildWhen;

  /// Принимает предыдущее `состояние` и текущее` состояние` и отвечает за
  /// возвращаем [bool], который определяет, вызывать ли [listener] из
  /// [BlocConsumer] с текущим `состоянием`.
  final BlocListenerCondition<S?>? listenWhen;

  /// Функция [builder], которая будет вызываться при первичной загрузке.
  /// [Builder] принимает `BuildContext` и текущее` состояние` и
  /// должен возвращать виджет.
  /// Это аналог функции [builder] в [StreamBuilder].
  final BlocWidgetBuilder<S>? loadingBuilder;

  /// Функция которая будет вызываться при отсутствии интернета, то есть
  /// когда пользователь нажимает на кнопку "Повторить попытку"
  /// С помощью данного каллбэка можно переотправить запрос на сервер
  final Function(BuildContext context)? onRetryConnection;

  const BaseUpgradeBlocBuilder({
    this.builder,
    this.notInternetConnectionBuilder,
    this.errorBuilder,
    this.cubit,
    this.listenWhen,
    this.buildWhen,
    this.listener,
    this.loadingBuilder,
    this.onRetryConnection,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => CoreUpgradeBlocBuilder<C, S>(
        disableNetworkErrorMessages: false,
        builder: (context, state) {
          if (state is CoreLoadingState) {
            if (loadingBuilder != null) {
              return loadingBuilder!.call(context, state);
            }
            return const Center(child: AppLoaderWidget());
          }
          return builder!.call(context, state!);
        },
        cubit: cubit,
        listenWhen: listenWhen,
        listener: listener,
        redirectLoginListener: () {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.loginScreen, (Route route) => false);
          // context.read<HomeCubit>().logoutAndExit();
        },
        errorListener: (error) {
          log('Error ---> $error');
        },
        buildWhen: buildWhen,
        applicationExeptionBuilder: (context, state) {
          log('Error ---> $state');

          return errorBuilder!.call(context, state!);
        },
        notInternetConnectionBuilder: (context, state) =>
            notInternetConnectionBuilder!.call(context, state!),
        errorBuilder: (context, state) {
          return errorBuilder!.call(context, state!);
        },
      );
}
