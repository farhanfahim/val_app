import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/app_urls.dart';
import 'package:val_app/configs/color/colors.dart';
import 'package:val_app/configs/components/custom_appbar.dart';
import 'package:val_app/configs/components/custom_text_widget.dart';
import 'package:val_app/configs/components/main_scaffold.dart';
import 'package:val_app/configs/utils.dart';
import '../../configs/routes/routes_name.dart';
import '../../view_model/categories_view_model.dart';

class CategoriesView extends StatefulWidget {
  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  final CategoriesViewModel controller = CategoriesViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        controller.getCategories(context, isPullToRefresh: false);
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: MainScaffold(
        appBar: CustomAppBar(
          leading: true,
          title: "Categories",
          backButtonColor: AppColors.blackColor,
        ),
        body: SafeArea(
          child: Consumer<CategoriesViewModel>(
            builder: (context, _cc, child) {
              return _cc.isLoading
                  ? const SizedBox.shrink()
                  : _cc.categoriesList.isEmpty
                      ? Utils.noDataFoundMessage("No Categories found.")
                      : RefreshIndicator(
                          backgroundColor: AppColors.whiteColor,
                          color: AppColors.primaryColor,
                          onRefresh: () async {
                            await _cc.getCategories(context, isPullToRefresh: true);
                          },
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 24),
                              child: GridView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 18,
                                  childAspectRatio: 1,
                                ),
                                shrinkWrap: true,
                                itemCount: _cc.categoriesList.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      //  _cc.getCategoriesById(context, id: _cc.categoriesList[index].id.toString(), index: index);
                                      Navigator.pushNamed(context, RoutesName.categoryDetail, arguments: {
                                        'title': _cc.categoriesList[index].name,
                                        'id': _cc.categoriesList[index].id.toString(),
                                      });
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(17),
                                            child: _cc.categoriesList[index].image == null ? Image.asset(Utils.getIconImage("placeholder.png")) : Utils().customCachedNetworkImage(height: 294, width: MediaQuery.of(context).size.width, shape: BoxShape.rectangle, url: AppUrl.baseUrl + _cc.categoriesList[index].image.toString()),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        CustomTextWidget(
                                          text: _cc.categoriesList[index].name,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
            },
          ),
        ),
      ),
    );
  }
}
