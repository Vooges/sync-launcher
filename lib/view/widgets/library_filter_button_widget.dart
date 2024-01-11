import 'package:flutter/material.dart';
import 'package:sync_launcher/controllers/filter_controller.dart';
import 'package:sync_launcher/view/widgets/library_filter_dialog_widget.dart';

class LibraryFilterButtonWidget extends StatelessWidget {
  final FilterController _filterController = FilterController();
  final Function callback;

  LibraryFilterButtonWidget({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _filterController.getFilters(), 
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if (!snapshot.hasData){
          return const CircularProgressIndicator();
        }

        return TextButton(
          onPressed: () {
            showDialog(
              context: context, 
              builder: (BuildContext context){
                return LibraryFilterDialogWidget(callback: callback);
              }
            );
          }, 
          child: const Text('Filter'),
        );
      }
    );
  }
}