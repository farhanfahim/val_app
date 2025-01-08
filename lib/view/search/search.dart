import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/color/colors.dart';
import 'package:val_app/configs/components/custom_appbar.dart';
import 'package:val_app/configs/components/main_scaffold.dart';
import 'package:val_app/configs/routes/routes_name.dart';
import 'package:val_app/configs/utils.dart';
import 'package:val_app/view_model/search/search_view_model.dart';
import '../../configs/app_urls.dart';
import '../../configs/components/custom_text_field.dart';
import '../../configs/components/custom_text_widget.dart';
import '../../configs/components/svg_icons_component.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final SearchViewModel cnt = SearchViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {},
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: cnt,
      child: SafeArea(
        child: MainScaffold(
          floatingActionButton: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.pushNamed(context, RoutesName.filter).then((v){
                 cnt.onTapSearch(context, cnt.searchTextEditingController.text);
              });
            },
            child: SvgIconComponent(icon: "filter.svg"),
          ),
          appBar: CustomAppBar(
            title: "Search",
          ),
          body: Consumer<SearchViewModel>(
            builder: (context, sController, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      decoration: Utils.boxDecorationRounded,
                      child: CustomTextField(
                        readOnly: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        maxLines: 1,
                        onChangeFtn: (v) {
                          return "";
                        },
                        cursorColor: AppColors.primaryColor,
                        fillColor: sController.focusSearch.hasFocus ? AppColors.whiteColor : AppColors.whiteColor,
                        focusColor: Colors.transparent,
                        hint: "Search...",
                        hintFontSize: 14,
                        enableBorderColor: Colors.transparent,
                        textInputType: TextInputType.visiblePassword,
                        txtController: sController.searchTextEditingController,
                        textInputAction: TextInputAction.next,
                        node: sController.focusSearch,
                        onTap: () {
                          Navigator.pushNamed(context, RoutesName.recentSearch).then((v){
                            String query = v!=null?v as String:"";
                            sController.onTapSearch(context,query);
                          });
                        },
                        borderRadius: 70,
                        prefixIcon: SvgIconComponent(
                          icon: "search_icon.svg",
                          color: AppColors.grey3,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Visibility(
                      visible: sController.searchResults.isNotEmpty,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: CustomTextWidget(
                          text: "Popular Searches",
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SizedBox(height: 13),
                    sController.searchResults.isNotEmpty?Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.only(bottom: 50),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        shrinkWrap: true,
                        itemCount: sController.searchResults.length,
                        itemBuilder: (context, index) {
                          return searchBoxWidget(context, sController, index);
                        },
                      ),
                    ):!sController.isLoading?Expanded(child: Utils.noDataFoundMessage("No results found.")):SizedBox.shrink()
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget searchBoxWidget(BuildContext context, SearchViewModel sController, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pushNamed(context, RoutesName.userPostDetail, arguments: {
          "id": sController.searchResults[index].projectId.toString(),
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: AppColors.greyShadowColor.withOpacity(0.25), blurRadius: 15, offset: Offset(3, 10))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              child: Container(
                height: MediaQuery.of(context).size.height * 127 / 812,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(image: sController.searchResults[index].coverMedia != null
                    ? DecorationImage(
                  image: NetworkImage(
                    AppUrl.baseUrl + sController.searchResults[index].coverMedia!,
                  ),
                  fit: BoxFit.fitWidth,
                )
                    : DecorationImage(
                  image: AssetImage(Utils.getIconImage("placeholder.png")),
                  fit: BoxFit.fitHeight,
                ),)
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomTextWidget(
                textAlign: TextAlign.left,
                text: sController.searchResults[index].projectTitle,
                fontSize: 12,
                maxLines: 2,
                fontWeight: FontWeight.w800,
                overFlow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
