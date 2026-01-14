import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/utils/base_colors.dart';
import 'package:money_planning_app/utils/base_constants.dart';
import 'package:money_planning_app/widgets/item_list_widget.dart';

class SearchTransactionScreen extends StatelessWidget {
  const SearchTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: _buildAppbar(context),
        body:_buildBody()
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context){
    return AppBar(
      titleSpacing: 4,
      leading: IconButton(onPressed: (){ Get.back(); }, icon: Icon(Icons.arrow_back_ios_new)),
      title: TextFormField(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          filled: true,
          fillColor: BaseColors.primary,
          hintText: BaseConstants.searchHint,
          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: BaseColors.darkTextPrimary),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
          focusColor: BaseColors.appBarTitle
        ),
        cursorColor: BaseColors.background,
      ),
    );
  }

  Widget _buildBody() {
    return Expanded(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: List.generate(
            10,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: ItemListWidget(
                icons: Icons.payment,
                itemName: "School Payment",
                price: "\$300.00"
              ),
            )
          ),
        ),
      ),
    );
  }
}
