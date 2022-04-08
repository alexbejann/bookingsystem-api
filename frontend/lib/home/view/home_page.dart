// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/home/cubit/counter_cubit.dart';
import 'package:frontend/l10n/l10n.dart';
import 'package:frontend/timeslots/timeslots.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            print("text");
          },
        ),
        appBar: AppBar(
          title: const Text('Tabs Demo'),
          bottom: TabBar(
            onTap: (value) {
              print(value);
            },
            tabs: [
              Tab(
                text: 'Floor 1',
              ),
              Tab(
                text: 'Floor 2',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            WorkArea(),
            Icon(Icons.directions_transit),
          ],
        ),
      ),
    );
  }
}

class WorkArea extends StatelessWidget {
  const WorkArea({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(height: 1),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Workspace $index'),
          onTap: () {
            Navigator.push<MaterialPageRoute>(
              context,
              MaterialPageRoute(builder: (context) => const TimeSlotsPage()),
            );
          },
        );
      },
    );
  }
}
