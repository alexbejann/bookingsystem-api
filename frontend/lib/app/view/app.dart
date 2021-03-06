// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frontend/app/bloc/authentication_bloc.dart';
import 'package:frontend/app/repositories/authentication_repository.dart';
import 'package:frontend/home/bloc/workspace_bloc.dart';
import 'package:frontend/home/repositories/workspace_repository.dart';
import 'package:frontend/l10n/l10n.dart';
import 'package:frontend/new_edit_office/repositories/office_repository.dart';
import 'package:frontend/utils/beamer_locations.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final beamerDelegate = BeamerDelegate(
    guards: [
      // Guard /home/* by beaming to /login if the user is unauthenticated:
      BeamGuard(
        pathPatterns: ['/home'],
        check: (context, state) =>
            context.read<AuthenticationBloc>().isAuthenticated(),
        beamToNamed: (_, __) => '/login',
      ),
      // Guard /login by beaming to /home if the user is authenticated:
      BeamGuard(
        pathPatterns: ['/login'],
        check: (context, state) =>
        !context.read<AuthenticationBloc>().isAuthenticated(),
        beamToNamed: (_, __) => '/home',
      ),
    ],
    initialPath: '/login',
    locationBuilder: (routeInformation, _) => BeamerLocations(routeInformation),
  );

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<OfficeRepository>(
          create: (context) => OfficeRepository(),
        ),
        RepositoryProvider<AuthenticationRepository>(
          create: (context) => AuthenticationRepository(),
        ),
        RepositoryProvider<WorkspaceRepository>(
          create: (context) => WorkspaceRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
              authenticationRepository:
                  context.read<AuthenticationRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => WorkspaceBloc(
              workspaceRepository: context.read<WorkspaceRepository>(),
            ),
          ),
        ],
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) => beamerDelegate.update(),
          child: MaterialApp.router(
            routerDelegate: beamerDelegate,
            routeInformationParser: BeamerParser(),
            theme: ThemeData(
              appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
              colorScheme: ColorScheme.fromSwatch(
                accentColor: const Color(0xFF13B9FF),
              ),
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            // home: const HomePage(),
          ),
        ),
      ),
    );
  }
}
