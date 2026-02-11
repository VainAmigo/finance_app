import 'package:finance_app/modules/modules.dart';
import 'package:finance_app/themes/themes.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizing.defaultPadding),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                floating: false,
                elevation: 0,
                scrolledUnderElevation: 0,
                expandedHeight: height * 0.7,
                collapsedHeight: height * 0.15,
                flexibleSpace: FlexibleSpaceBar(
                  title: const HomeTopActionWidget(),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 200,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSizing.spaceBtwElements),
                  child: Container(
                    height: 600,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
