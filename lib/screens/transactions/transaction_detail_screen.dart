import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/controllers/transaction_detail_controller.dart';
import 'package:money_planning_app/utils/base_colors.dart';

class TransactionDetailScreen extends StatelessWidget {
  TransactionDetailScreen({super.key});

  final controller = Get.put(TransactionDetailController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(28)),
        backgroundColor: BaseColors.primary,
        onPressed: (){},
        child: Icon(Icons.edit, color: BaseColors.appBarTitle),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(){
    return AppBar(leading: IconButton(onPressed: (){ Get.back(); }, icon: Icon(Icons.arrow_back)));
  }

  Widget _buildBody(BuildContext context){
    return Container(
      color: BaseColors.primary,
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50, 
            backgroundColor: BaseColors.appBarTitle,
            child: Icon(Icons.keyboard_double_arrow_down, size: 70, color: BaseColors.primary),
          ),
          Text("Item Name", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
          Text("Price", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Text("Transaction Type", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(26),
                  topRight: Radius.circular(26)
                )
              ),
              child: Column(
                children: _itemList(icon: controller.icons, name: controller.names, value: controller.values)
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _itemList({
    required List<IconData> icon, 
    required List<String> name, 
    required List<dynamic> value
  }) {
    return List.generate(controller.names.length, (index){
      return Container(
        margin: EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            CircleAvatar(radius: 22, backgroundColor: Colors.grey.shade200, child: Icon(icon[index])),
            const SizedBox(width: 10),
            Text(name[index]),
            const Spacer(),
            Text(value[index])
          ],
        ),
      );
    });
  }

}
