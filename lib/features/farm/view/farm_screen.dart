import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/farm_viewmodel.dart';

class FarmScreen extends StatelessWidget {
  const FarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FarmViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Overview'),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: viewModel.farms.length,
              itemBuilder: (context, index) {
                final farm = viewModel.farms[index];
                return ListTile(
                  title: Text(farm.name ?? 'Unnamed Farm'),
                  subtitle: Text('Location: ${farm.location ?? "Unknown"}'),
                );
              },
            ),
    );
  }
}