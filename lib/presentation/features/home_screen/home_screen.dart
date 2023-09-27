import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery/presentation/features/home_screen/bloc/home_bloc.dart';
import 'package:gallery/presentation/features/home_screen/widgets/home_appbar.dart';
import 'package:gallery/presentation/features/home_screen/widgets/home_post_tile.dart';
import 'package:gallery/service_locator.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 245, 255),
      body: BlocProvider<HomeBloc>(
        create: (context) => services<HomeBloc>()..add(HomeInitialEvent()),
        lazy: true,
        child: _buildBody(),
      )
    );
  }
  
  Widget _buildBody() {
    return CustomScrollView(
      slivers: [
        const HomeAppBar(),
        BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) => {},
          builder: (context, state) {
            switch(state.runtimeType) {
              case HomeInitial:
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator()
                  ),
                );
              case HomeSuccessState:
                return SliverFillRemaining(
                  child: Stack(
                    children: [
                      HomePostTile(state.posts!),
                      Positioned(
                        right: 20,
                        bottom: 20,
                        child: FloatingActionButton(
                          onPressed: () => Navigator.of(context).pushNamed('/post', arguments: BlocProvider.of<HomeBloc>(context)),
                          backgroundColor: const Color.fromARGB(255, 114, 72, 252),
                          child: const Icon(Icons.add_rounded),
                        ),
                      )
                    ])
                );
              case HomeNoDataFound:
                return SliverFillRemaining(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Align(
                        alignment: Alignment.center,
                        child: Text("No Posts Found", style: TextStyle(fontWeight: FontWeight.w500)),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pushNamed('/post', arguments: BlocProvider.of<HomeBloc>(context)),
                          child: const Text('Add post'),
                        ),
                      )
                    ]
                  ),
                );
              default:
                return SliverFillRemaining(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Something went wrong', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                      TextButton(
                        onPressed: () => BlocProvider.of<HomeBloc>(context).add(GetAllPosts()),
                        child: const Text('Try again')
                      )
                    ],
                  ),
                );
            }
          },
        )
      ]
    );
  }
}