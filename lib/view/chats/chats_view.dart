import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/color/colors.dart';
import 'package:val_app/configs/components/custom_appbar.dart';
import 'package:val_app/configs/components/main_scaffold.dart';
import 'package:val_app/configs/components/svg_icons_component.dart';
import 'package:val_app/configs/routes/routes_name.dart';
import 'package:val_app/configs/utils.dart';
import 'package:val_app/view_model/chats/chats_view_model.dart';
import '../../configs/components/custom_text_field.dart';
import '../../configs/components/custom_text_widget.dart';
import '../../configs/date_time_util.dart';
import '../../configs/sharedPerfs.dart';
import '../../firestore/chat_constants.dart';
import '../../firestore/chat_strings.dart';

class ChatsView extends StatefulWidget {
  const ChatsView({super.key});

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  late FocusNode _focusNode;
  final ChatsViewModel controller = ChatsViewModel();
  String? userID;
  String searchQuery = "";
  List<DocumentSnapshot> allChats = []; // List to hold all chats


  Map<int, String> userNames = {};

  void _fetchUserNames() async {
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection(ChatStrings.usersCollectionReference)
        .get();

    for (var doc in userSnapshot.docs) {
      userNames[int.parse(doc.id)] = doc.get(ChatStrings.name)??"";
    }
  }

  @override
  void initState() {
    super.initState();
    userID = SharedPrefs.instance.getString("userId") ?? "";
    print(userID);
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        Provider.of<ChatsViewModel>(context, listen: false).hideSearch();
      }
    });

    _fetchUserNames();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: MainScaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SizedBox(height: 50),
              Consumer<ChatsViewModel>(
                builder: (context, cnt, child) {
                  return cnt.isSearchActive
                      ? CustomTextField(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    maxLines: 1,
                    cursorColor: AppColors.primaryColor,
                    fillColor: AppColors.whiteColor,
                    focusColor: AppColors.borderColor.withOpacity(.4),
                    hint: "Search...",
                    hintFontSize: 16,
                    textInputType: TextInputType.visiblePassword,
                    txtController: controller.searchController,
                    textInputAction: TextInputAction.next,
                    node: _focusNode,
                    autofocus: true,
                    borderRadius: 41,
                    onChangeFtn: (value) {
                      setState(() {
                        searchQuery = value!.trim().toLowerCase();
                      });
                      return "";
                    },
                    suffixIcon: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          searchQuery = "";
                          controller.searchController.clear();
                        });
                        Provider.of<ChatsViewModel>(context, listen: false).hideSearch();
                        _focusNode.unfocus();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: SvgIconComponent(icon: "close_circle.svg"),
                      ),
                    ),
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.blackColor,
                        ),
                      ),
                      CustomTextWidget(
                        text: "Messages",
                        color: AppColors.blackColor,
                        textAlign: TextAlign.center,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Provider.of<ChatsViewModel>(context, listen: false).toggleSearch();
                          Future.delayed(Duration(milliseconds: 100), () {
                            if (Provider.of<ChatsViewModel>(context, listen: false).isSearchActive) {
                              _focusNode.requestFocus();
                            }
                          });
                        },
                        child: SvgIconComponent(icon: "search_icon.svg"),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 18),
              Divider(color: AppColors.grey2.withOpacity(.3), height: 0, thickness: 1),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(ChatStrings.chatsCollectionReference)
                      .orderBy(ChatStrings.updatedAt, descending: true)
                      .snapshots(),
                  builder: (context, chatListSnapshot) {
                    if (chatListSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Utils().spinkit);
                    }

                    if (!chatListSnapshot.hasData || chatListSnapshot.data!.size == 0) {
                      return Center(child: const Text(ChatConstants.noChatFound));
                    }

                    // Store all chats
                    allChats = chatListSnapshot.data!.docs;

                    // Filter chats based on search query
                    List<DocumentSnapshot> filteredChats = searchQuery.isEmpty
                        ? allChats
                        : allChats.where((chat) {
                      List<int> userIds = List<int>.from(chat.get(ChatStrings.userIds));
                      userIds.remove(int.parse(userID!)); // Remove current user's ID

                      if (userIds.isEmpty) return false; // Skip if no other users

                      int otherUserId = userIds.first; // Take the first one
                      return userNames[otherUserId]?.toLowerCase().contains(searchQuery) ?? false;
                    }).toList();


                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: filteredChats.isEmpty?Center(child: const Text(ChatConstants.noChatFound)):ListView.builder(
                        itemCount: filteredChats.length,
                        itemBuilder: (context, index) {
                          var chatDocument = filteredChats[index];

                          List<int> userIds = List<int>.from(chatDocument.get(ChatStrings.userIds));
                          userIds.remove(int.parse(userID!));

                          if (userIds.isEmpty) return Container(); // Skip if no other users
                          int otherUserId = userIds.first;

                          return StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection(ChatStrings.usersCollectionReference)
                                .doc(otherUserId.toString())
                                .snapshots(),
                            builder: (context, userSnapshot) {
                              if (!userSnapshot.hasData) {
                                return Container(); // Handle loading or no user data
                              }

                              return StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection(ChatStrings.chatsCollectionReference)
                                    .doc(chatDocument.id)
                                    .collection(ChatStrings.threadsCollectionReference)
                                    .where(ChatStrings.senderId, isNotEqualTo: int.parse(userID!))
                                    .where(ChatStrings.isRead, isEqualTo: false)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  var userIds = List<int>.from(chatDocument.get(ChatStrings.userIds));
                                  return  Visibility(
                                    visible: userIds.contains(int.parse(userID!)),
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.pushNamed(context, RoutesName.chatDetail, arguments: {
                                          "userId": userSnapshot.data!.get(ChatStrings.id),
                                          "documentId": chatDocument.id,
                                        });
                                      },
                                      contentPadding: EdgeInsets.zero,
                                      leading: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.grey,
                                              backgroundImage: CachedNetworkImageProvider(userSnapshot.data!.get(ChatStrings.image)),
                                              radius: 25,
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: SvgIconComponent(
                                                icon: "online_icon.svg",
                                                color: userSnapshot.data!.get(ChatStrings.isOnline) ? null : AppColors.grey3,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      title: Padding(
                                        padding: const EdgeInsets.only(bottom: 6),
                                        child: Row(
                                          children: [
                                            CustomTextWidget(
                                              text: userSnapshot.data!.get(ChatStrings.name),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            const Spacer(),
                                            CustomTextWidget(
                                              text: chatDocument[ChatStrings.updatedAt] == null
                                                  ? ""
                                                  : DateTimeUtil.timeAgoSinceDateFirebase(((chatDocument[ChatStrings.updatedAt]) as Timestamp).toDate()),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: AppColors.grey4,
                                            ),
                                          ],
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(bottom: 5),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: CustomTextWidget(
                                                text: chatDocument.get(ChatStrings.lastMessage),
                                                fontSize: 14,
                                                maxLines: 1,
                                                fontWeight: FontWeight.normal,
                                                color: AppColors.grey3,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            (snapshot.hasData ? snapshot.data!.size : 0) == 0
                                                ? const SizedBox()
                                                : Container(
                                              alignment: Alignment.center,
                                              height: 20,
                                              width: 20,
                                              decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
                                              child: CustomTextWidget(
                                                text: (snapshot.hasData ? snapshot.data!.size : 0).toString(),
                                                fontSize: 12,
                                                maxLines: 2,
                                                fontWeight: FontWeight.w800,
                                                textAlign: TextAlign.center,
                                                color: AppColors.whiteColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    debugPrint("dispose called");
    _focusNode.dispose();
    super.dispose();
  }
}