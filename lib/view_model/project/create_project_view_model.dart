import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:val_app/Repository/auth_api/auth_http_api_repository.dart';
import 'package:val_app/Repository/project_api/project_api_repo.dart';
import 'package:val_app/Response/api_response.dart';
import 'package:val_app/configs/app_urls.dart';
import 'package:val_app/configs/components/custom_snackbar.dart';
import 'package:val_app/configs/utils.dart';
import 'package:val_app/model/categories_model.dart';
import 'package:val_app/model/tools_model.dart';
import 'package:http/http.dart' as http;
import 'package:video_compress/video_compress.dart';
import '../../Repository/home_api/home_api_repo.dart';
import '../../model/media_file_model.dart';
import '../../model/my_post_detail_model.dart';
import '../../view/bottom_nav_bar.dart';

class CreateProjectViewModel extends ChangeNotifier {
  bool isImageLoading = true;
  void loadProjectData(context,MyPostDetailModel project) async {
    isImageLoading = true;
    notifyListeners();
    titleTextEditingController.text = project.data!.title ?? "";
    descriptionTextEditingController.text = project.data!.description ?? "";
    final futures = (project.data?.media ?? []).map((media) async {
      final file = await urlToFile(AppUrl.baseUrl + media.media!);
      if (file != null) {
        return MediaFile(file.path, isVideo: false);
      }
      return null;
    }).toList();
    final downloadedMediaFiles = await Future.wait(futures);
    _mediaFiles = downloadedMediaFiles.whereType<MediaFile>().toList();
    _selectedMediaFile = _mediaFiles.isNotEmpty ? _mediaFiles.first : null;

    for (var category in project.data!.categories!) {
      selectedCategories.add(
        CategoriesData(id: category.id, category: category.categoryName),
      );

    }
    for (var tools in project.data!.tools!) {
      selectedTools.add(
        ToolsDataList(id: tools.id, tool: tools.toolName,isSelected: true, iCategory: tools.categoryId),
      );
    }

    List<int> selectedCatIds = [];
    for(var item in selectedCategories){
      selectedCatIds.add(item.id!);
    }
    var data = {
      "categories":  selectedCatIds,
    };
    callApiOnRemoveCat(context, jsonEncode(data));


    for (var tags in project.data!.tags!) {
      fieldtags.add(Tag(tags.tag!));
    }
    isImageLoading = false;
    notifyListeners();
  }

  Future<bool> onWillPop() async {

    return false;
  }

  bool isLoading() {
    return isImageLoading;
  }

  Future<File?> urlToFile(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/${url.split('/').last}';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        print('Failed to download file: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error downloading file: $e');
      return null;
    }
  }

  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController categoryTextEditingController = TextEditingController();
  TextEditingController toolsTextEditingController = TextEditingController();
  TextEditingController tagsTextEditingController = TextEditingController();
  TextEditingController searchTextEditingController = TextEditingController();

  final createProjectFormKey = GlobalKey<FormState>();
  FocusNode focusSearch = FocusNode();

  FocusNode focusTitle = FocusNode();
  FocusNode focusDescription = FocusNode();
  FocusNode focusCategory = FocusNode();
  FocusNode focusTools = FocusNode();
  FocusNode focusTags = FocusNode();

  final ImagePicker _picker = ImagePicker();
  MediaFile? _selectedMediaFile;

  List<MediaFile> _mediaFiles = [];
  set mediaFileEdit(List<MediaFile>? files) {
    _mediaFiles = files ?? [];
    notifyListeners();
  }

  set selectedMediaFileEdit(MediaFile files) {
    _selectedMediaFile = files;
    notifyListeners();
  }

  List<MediaFile> get mediaFiles => _mediaFiles;

  MediaFile? get selectedMediaFile => _selectedMediaFile;
  Future<void> pickImageFromCamera(context) async {
    if (await Utils().permissionCameraCheckMethod()) {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera,imageQuality: 50);
      if (image != null) {
        _addMediaFile(context,image.path);
      }
    }
  }

  Future<void> pickVideoFromGallery(context) async {
    if (await Utils().permissionCheckMethod()) {

      // Pick video
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        _addMediaFile(context,video.path, isVideo: true);
      }
    }
  }

  Future<void> pickImageFromGallery(context) async {
    if (await Utils().permissionCheckMethod()) {
      // Pick images
      final List<XFile>? images = await _picker.pickMultiImage(imageQuality: 50);
      if (images != null) {
        for (var image in images) {
          _addMediaFile(context,image.path);
        }
      }
    }
  }

  void _addMediaFile(context,String filePath, {bool isVideo = false}) {
    final fileSize = File(filePath).lengthSync();
    final fileName = filePath.split('/').last.toLowerCase();
    final isImage = _isImage(filePath);
    final isGif = fileName.endsWith('.gif');
    final videoFile = isVideo || _isVideo(filePath);

    if(videoFile){
      var contextt;
      showDialog(
          context: context,
          builder: (ctx) {
            contextt = ctx;
            return AlertDialog(
              title: const Center(child: Text('Compressing Video')),
              content: VideoCompress.isCompressing
                  ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  LinearProgressIndicator(),
                  const SizedBox(height: 10),
                ],
              )
                  : const Text('Upload completed!'),
            );
          });
      VideoCompress.compressVideo(
        filePath,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false, // It's false by default
      ).then((compressedVideo){
        Navigator.pop(contextt);
        final mediaFile = MediaFile(compressedVideo!.path!, isVideo: videoFile);
        _mediaFiles.add(mediaFile);
        if (_mediaFiles.length == 1) {
          _selectedMediaFile = mediaFile;
        }
        notifyListeners();
      });
    }else{
      final mediaFile = MediaFile(filePath, isVideo: videoFile);
      _mediaFiles.add(mediaFile);
      if (_mediaFiles.length == 1) {
        _selectedMediaFile = mediaFile;
      }
      notifyListeners();

    }
  }

  bool _isImage(String filePath) {
    final fileName = filePath.split('/').last.toLowerCase();
    return fileName.endsWith('.jpg') || fileName.endsWith('.jpeg') || fileName.endsWith('.png') || fileName.endsWith('.gif');
  }

  bool _isVideo(String filePath) {
    final fileName = filePath.split('/').last.toLowerCase();
    return fileName.endsWith('.mp4');
  }

  void removeMedia(MediaFile mediaFile) {
    _mediaFiles.remove(mediaFile);
    if (_selectedMediaFile == mediaFile && _mediaFiles.isNotEmpty) {
      _selectedMediaFile = _mediaFiles.first;
    } else if (_mediaFiles.isEmpty) {
      _selectedMediaFile = null;
    }
    notifyListeners();
  }

  void selectMedia(MediaFile mediaFile) {
    _selectedMediaFile = mediaFile;
    notifyListeners();
  }

  List<CategoriesData> categoriesList = [];
  List<CategoriesData> filteredCategoriesList = [];
  List<ToolsDataList> filteredToolsList = [];
  List<ToolsDataList> toolsList = [];
  List<CategoriesData> selectedCategories = [];
  List<ToolsDataList> selectedTools = [];
  List<String> tagsss = [];

  void CategoriesSelection(CategoriesData category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
      category.isSelected = false;
    } else {
      selectedCategories.add(category);
      category.isSelected = true;
    }
    notifyListeners();
  }

  void removeCategories(context,CategoriesData category) {

    selectedTools.removeWhere((item2) => item2.iCategory == category.id);
    selectedCategories.remove(category);
    category.isSelected = false;

    //recall filteredTools api with updated selected category list
    List<int> selectedCatIds = [];
    for(var item in selectedCategories){
      selectedCatIds.add(item.id!);
    }
    var data = {
      "categories":  selectedCatIds,
    };
    callApiOnRemoveCat(context, jsonEncode(data));
    notifyListeners();
  }

  void ToolsSelection(ToolsDataList tools,bool isSelected) {
    print(isSelected);
    if(isSelected){
      selectedTools.removeWhere((tool) => tool.id == tools.id);
      tools.isSelected = false;
    }else{
      selectedTools.add(tools);
      tools.isSelected = true;
    }
    notifyListeners();
  }


  void removeTools(ToolsDataList tools) {
    filteredToolsList.where((e) => e.id == tools.id).first.isSelected = false;
    selectedTools.remove(tools);
    tools.isSelected = false;
    notifyListeners();
  }

  List<Tag> _fieldtags = [];

  List<Tag> get fieldtags => _fieldtags;

  void addTag(String tagName) {
    if (tagName.isNotEmpty && !_fieldtags.any((tag) => tag.name == tagName)) {
      _fieldtags.add(Tag(tagName));
      notifyListeners();
    }
  }

  void removeFieldTag(Tag tag) {
    _fieldtags.remove(tag);
    notifyListeners();
  }

  CreateProjectViewModel() {
    focusTitle.addListener(notifyListeners);
    focusDescription.addListener(notifyListeners);
    focusCategory.addListener(notifyListeners);
    focusTools.addListener(notifyListeners);
    focusTags.addListener(notifyListeners);
    focusSearch.addListener(notifyListeners);
  }

  @override
  void dispose() {
    focusSearch.dispose();
    focusTitle.dispose();
    focusDescription.dispose();
    titleTextEditingController.dispose();
    categoryTextEditingController.dispose();
    descriptionTextEditingController.dispose();
    toolsTextEditingController.dispose();
    tagsTextEditingController.dispose();
    focusCategory.dispose();
    focusTools.dispose();
    focusTags.dispose();
    super.dispose();
  }

  AuthHttpApiRepository authRepository = AuthHttpApiRepository();
  ApiResponse<CategoriesModel> categories_res = ApiResponse.loading();
  MyPostDetailModel? myPostDetailModel;
  HomeHttpApiRepository homeRepo = HomeHttpApiRepository();

  Future<void> getDraftedProjectDetail(BuildContext context, {String? id}) async {
    // Utils().loadingDialog(context);
    isImageLoading = true;
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {
      'timezone' : DateTime.now().timeZoneOffset.toString()
    };
    try {
      var response = await homeRepo.getMyProfileDetail(headers, data, id: id);

      if (response['status'] == "success") {
        final post = MyPostDetailModel.fromJson(response);
        // Navigator.pop(context);
        isImageLoading = false;

        myPostDetailModel = post;
        // loadDraftedData(myPostDetailModel!);
        // Safely assign text fields with null checks
        titleTextEditingController.text = myPostDetailModel!.data?.title ?? "";
        descriptionTextEditingController.text = myPostDetailModel!.data?.description ?? "";

        // Map and download media files safely
        final futures = (myPostDetailModel!.data?.media ?? []).map((media) async {
          if (media.media != null) {
            // Check if media URL is not null
            final file = await urlToFile(AppUrl.baseUrl + media.media!);
            if (file != null) {
              return MediaFile(file.path, isVideo: false);
            }
          }
          return null; // Return null if media URL is null
        }).toList();

        final downloadedMediaFiles = await Future.wait(futures);
        _mediaFiles = downloadedMediaFiles.whereType<MediaFile>().toList();
        _selectedMediaFile = _mediaFiles.isNotEmpty ? _mediaFiles.first : null;

        // Safely iterate categories, tools, and tags with null checks
        if (myPostDetailModel!.data?.categories != null) {
          for (var category in myPostDetailModel!.data!.categories!) {
            selectedCategories.add(
              CategoriesData(id: category.id ?? 0, category: category.categoryName ?? ""),
            );
          }
        }

        if (myPostDetailModel!.data?.tools != null) {
          for (var tools in myPostDetailModel!.data!.tools!) {
            selectedTools.add(
              ToolsDataList(id: tools.id ?? 0, tool: tools.toolName ?? "",isSelected: true, iCategory: tools.categoryId),
            );
          }
        }
        List<int> selectedCatIds = [];
        for(var item in selectedCategories){
          selectedCatIds.add(item.id!);
        }
        var data = {
          "categories":  selectedCatIds,
        };
        callApiOnRemoveCat(context, jsonEncode(data));

        if (myPostDetailModel!.data?.tags != null) {
          for (var tags in myPostDetailModel!.data!.tags!) {
            if (tags.tag != null) {
              fieldtags.add(Tag(tags.tag!));
            }
          }
        }

        notifyListeners();
      } else {
        Navigator.pop(context);
      }
    } catch (error) {
      Navigator.pop(context);
      Utils.toastMessage(error.toString());
      print("error: $error");
    } finally {
      isImageLoading = false;
    }
  }

  setCategoriesApiResponse(ApiResponse<CategoriesModel> response) {
    categories_res = response;
    notifyListeners();
  }

  bool catLoader = true;
  Future<void> getCategory(BuildContext context) async {
    print("api calling");
    filteredCategoriesList.clear();
    catLoader = true;
    notifyListeners();
      Utils().loadingDialog(context);
      // setCategoriesApiResponse(ApiResponse.loading());
      try {
        final response = await projectRepository.getCategories();

        if (response != null) {
          setCategoriesApiResponse(ApiResponse.completed(response));
          categoriesList.clear();
          categoriesList = response.data ?? [];
          filteredCategoriesList = response.data ?? [];
          for(var item in selectedCategories){
            for(var item2 in filteredCategoriesList){
              if( item.id == item2.id){
                item2.isSelected = true;
              }
            }
          }
          List<int> selectedCatIds = [];
          for(var item in selectedCategories){
            selectedCatIds.add(item.id!);
          }
          var data = {
            "categories":  selectedCatIds,
          };
          callApiOnRemoveCat(context, jsonEncode(data));
          Navigator.pop(context); // Close the loading dialog
          notifyListeners();
        }
      } catch (error) {
        Navigator.pop(context); // Ensure the loading dialog is closed on error
        setCategoriesApiResponse(ApiResponse.error("Error"));
        print("error: $error");
        notifyListeners();
      }finally{
        catLoader = false;
        notifyListeners();
      }

  }

  Future<void> postCategory(BuildContext context, var data) async {
    Utils().loadingDialog(context);

    final credentials = await Utils.getUserCredentials();

    String? accessToken = credentials['accessToken'];
    var headers = {
      'Authorization': 'Bearer ${accessToken}',
      'Content-Type': 'application/json'
    };
    try {
      final response = await projectRepository.postCategory(data, headers);

      if (response != null) {
        // setCategoriesApiResponse(ApiResponse.completed(response));
        toolsList.clear();
        filteredToolsList = response.data ?? [];
        toolsList = response.data ?? [];
        searchTextEditingController.text = "";

        for(var item in selectedTools){
          for(var item2 in filteredToolsList){
            if( item.id == item2.id){
              item2.isSelected = true;
            }
          }
        }
        Navigator.pop(context);
        Navigator.pop(context); // Close the loading dialog
        notifyListeners();
      }
    } catch (error) {
      Navigator.pop(context); // Ensure the loading dialog is closed on error
      setCategoriesApiResponse(ApiResponse.error("Error"));
      print("error: $error");
      notifyListeners();
    }
  }
  Future<void> callApiOnRemoveCat(BuildContext context, var data) async {
    final credentials = await Utils.getUserCredentials();
    Utils().loadingDialog(context);
    String? accessToken = credentials['accessToken'];
    var headers = {
      'Authorization': 'Bearer ${accessToken}',
      'Content-Type': 'application/json'
    };
    try {
      final response = await projectRepository.postCategory(data, headers);

      if (response != null) {
        toolsList.clear();
        filteredToolsList = response.data ?? [];
        toolsList = response.data ?? [];
        searchTextEditingController.text = "";
        for(var item in selectedTools){
          for(var item2 in filteredToolsList){
            if( item.id == item2.id){
              item2.isSelected = true;
            }
          }
        }
        notifyListeners();
      }
    } catch (error) { // Ensure the loading dialog is closed on error
      setCategoriesApiResponse(ApiResponse.error("Error"));
      print("error: $error");
      notifyListeners();
    }finally{
      Navigator.pop(context);
      notifyListeners();
    }
  }

  ProjectHttpApiRepository projectRepository = ProjectHttpApiRepository();

  CreateProjectPost(context, {bool? isDraft, bool? isPosted}) async {
    bool isAllFieldValid = checkValidation();
    if (isDraft!) {
      isAllFieldValid = true;
    }
    if (isAllFieldValid) {
      int totalSize = await calculateTotalFileSize(mediaFiles);

      print("size ${convertBytesToMB(totalSize)}");
      if(convertBytesToMB(totalSize)<=25){
        // Perform login logic here
        Utils().loadingDialog(context);
        final credentials = await Utils.getUserCredentials();
        String? accessToken = credentials['accessToken'];
        var headers = {'Authorization': 'Bearer ${accessToken}'};
        print("headers:" + headers.toString());

        Map<String, String> data = {"title": titleTextEditingController.text.trim().toString(), "description": descriptionTextEditingController.text.trim().toString(), "is_posted": isPosted.toString(), "is_drafted": isDraft.toString()};
        for (var i = 0; i < mediaFiles.length; i++) {
          // data['media'] = mediaFiles[i].path.toString();
          if (selectedMediaFile!.path == mediaFiles[i].path) {
            data['is_cover_$i'] = "True";
          } else {
            data['is_cover_$i'] = "False";
          }
        }

        for (var i = 0; i < selectedCategories.length; i++) {
          data['categories[$i]'] = selectedCategories[i].id.toString() ?? "";
        }

        for (var i = 0; i < fieldtags.length; i++) {
          data['tags[$i]'] = fieldtags[i].name;
        }
        for (var i = 0; i < selectedTools.length; i++) {
          data['tools[$i]'] = selectedTools[i].id.toString();
        }
        print(data);
        try {
          projectRepository.createProjectApi(data, headers, media: mediaFiles, multipartkey: "media").then(
                (value) {
              if (value != null) {
                // Utils.toastMessage("project Created Successfully");
                selectedCategories.clear();
                selectedTools.clear();
                fieldtags.clear();
                titleTextEditingController.text = "";
                descriptionTextEditingController.text = "";
                _selectedMediaFile = null;
                mediaFiles.clear();
                notifyListeners();
                Navigator.pop(context);
                Navigator.pop(context);
                if(isDraft){
                  Navigator.pop(context);
                }


              } else {
                setCreateProjectApiResponse(ApiResponse.error("Error creating profile"));
                Utils.toastMessage("Error Creating Project");
                Navigator.pop(context);
              }
            },
          ).onError(
                (error, stackTrace) {
              Utils.toastMessage("Profile ${error.toString()}");
              Navigator.pop(context);
            },
          );
        } catch (e) {
          print("Profile Exception" + e.toString());
          Navigator.pop(context);
        }
      }else{
        Utils.toastMessage("Your file is too large. Please keep it under 25MB.");
      }

    } else {
      Utils.toastMessage("All fields are required");
    }
  }

  EditProjectPost(context, {bool? isDraft, bool? isPosted, String? id}) async {
    bool isAllFieldValid = checkValidation();
    if (isDraft!) {
      isAllFieldValid = true;
    }
    if (isAllFieldValid) {
      // Perform login logic here
      int totalSize = await calculateTotalFileSize(mediaFiles);
      if(convertBytesToMB(totalSize)<=25){
        Utils().loadingDialog(context);
        final credentials = await Utils.getUserCredentials();
        String? accessToken = credentials['accessToken'];
        var headers = {'Authorization': 'Bearer ${accessToken}'};
        print("headers:" + headers.toString());

        Map<String, String> data = {
          "title": titleTextEditingController.text.trim().toString(),
          "description": descriptionTextEditingController.text.trim().toString(),
          "is_posted": isPosted.toString(),
          "is_drafted": isDraft.toString(),
        };
        for (var i = 0; i < mediaFiles.length; i++) {
          // data['media'] = mediaFiles[i].path.toString();
          if (selectedMediaFile!.path == mediaFiles[i].path) {
            data['is_cover_$i'] = "True";
          } else {
            data['is_cover_$i'] = "False";
          }
        }
        for (var i = 0; i < selectedCategories.length; i++) {
          data['categories'] = selectedCategories[i].id.toString() ?? "";
        }
        for (var i = 0; i < fieldtags.length; i++) {
          data['tags'] = fieldtags[i].name;
        }
        for (var i = 0; i < selectedTools.length; i++) {
          data['tools'] = selectedTools[i].id.toString();
        }
        print('farhan edit');
        print(data);
        try {
          projectRepository.editProject(data, headers, media: mediaFiles, multipartkey: "media", id: id).then(
                (value) {
              if (value != null) {
                print('Edit $value');
                // Utils.toastMessage("project Created Successfully");
                selectedCategories.clear();
                selectedTools.clear();
                fieldtags.clear();
                titleTextEditingController.text = "";
                descriptionTextEditingController.text = "";
                _selectedMediaFile = null;
                mediaFiles.clear();
                notifyListeners();
                Navigator.pop(context);
                Navigator.pop(context,true);
              } else {
                setCreateProjectApiResponse(ApiResponse.error("Error updating project"));
                Utils.toastMessage("Error updating project");
                print('Edit $value');

                Navigator.pop(context);
              }
            },
          ).onError(
                (error, stackTrace) {
              Utils.toastMessage("project cache ${error.toString()}");
              Navigator.pop(context);
            },
          );
        } catch (e) {
          print("Profile Exception" + e.toString());
          Navigator.pop(context);
        }
      }else{
        Utils.toastMessage("Your file is too large. Please keep it under 25MB.");
      }

    } else {
      Utils.toastMessage("All fields are required");
    }
  }

  ProjectDelete(context, isDraft,{String? id}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());

    Map<String, String> data = {};
    try {
      projectRepository.projectDelete(data: data, headers: headers, id: id).then(
        (value) {
          if (value != null) {
            print('delete $value');
            selectedCategories.clear();
            selectedTools.clear();
            fieldtags.clear();
            titleTextEditingController.text = "";
            descriptionTextEditingController.text = "";
            _selectedMediaFile = null;
            mediaFiles.clear();
            notifyListeners();
            Navigator.pop(context);
            Navigator.pop(context);
            if(isDraft == false){
              Navigator.pop(context);
            }
            Navigator.pop(context,true);
          } else {
            setCreateProjectApiResponse(ApiResponse.error("Error deleting project"));
            Utils.toastMessage("Error deleting project");
            print('delete $value');

            Navigator.pop(context);
          }
        },
      ).onError(
        (error, stackTrace) {
          Utils.toastMessage("project cache ${error.toString()}");
          Navigator.pop(context);
        },
      );
    } catch (e) {
      print("Profile Exception" + e.toString());
      Navigator.pop(context);
    }
  }

  discardProject(context) {
    selectedCategories.clear();
    selectedTools.clear();
    fieldtags.clear();
    titleTextEditingController.text = "";
    descriptionTextEditingController.text = "";
    _selectedMediaFile = null;
    mediaFiles.clear();
    notifyListeners();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  onBackPress(context){
      selectedCategories.clear();
      selectedTools.clear();
      fieldtags.clear();
      titleTextEditingController.text = "";
      descriptionTextEditingController.text = "";
      _selectedMediaFile = null;
      mediaFiles.clear();
      notifyListeners();
      Navigator.pop(context);
  }

  checkBeforeExit(){
    if(selectedCategories.isNotEmpty){
      return true;
    }else if(selectedTools.isNotEmpty){
      return true;
    }else if(fieldtags.isNotEmpty){
      return true;
    }else if(descriptionTextEditingController.text.isNotEmpty){
      return true;
    }else if(titleTextEditingController.text.isNotEmpty){
      return true;
    }else if(selectedMediaFile !=null){
      return true;
    }else if(mediaFiles.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }

  bool checkValidation() {
    bool check = true;
    if (mediaFiles.isEmpty) {
      check = false;
    }
    if (titleTextEditingController.text.isEmpty) {
      check = false;
    }
    if (descriptionTextEditingController.text.isEmpty) {
      check = false;
    }
    if (selectedCategories.isEmpty) {
      check = false;
    }
    if (selectedTools.isEmpty) {
      check = false;
    }
    if (fieldtags.isEmpty) {
      check = false;
    }
    return check;
  }

  ApiResponse createProject = ApiResponse.notStarted();

  setCreateProjectApiResponse(ApiResponse response) {
    createProject = response;
    notifyListeners();
  }

  void filterItems(String query) {
    if (query.isEmpty) {
      filteredCategoriesList = categoriesList;
    } else {
      filteredCategoriesList = categoriesList
          .where((item) => item.category!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    searchTextEditingController.text = query;
    notifyListeners();
  }

  void filterToolsItems(String query) {
    if (query.isEmpty) {
      filteredToolsList = toolsList;
    } else {
      filteredToolsList = toolsList
          .where((item) => item.tool!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    searchTextEditingController.text = query;
    notifyListeners();
  }

  Future<int> calculateTotalFileSize(List<MediaFile> files) async {
    int totalSize = 0;

    for (var file in files) {
      try {
        // Get the size of the file in bytes
        int fileSize = await File(file.path).length();
        totalSize += fileSize;
      } catch (e) {
        print("Error getting size for file: ${file.path}, error: $e");
      }
    }

    return totalSize;
  }

  double convertBytesToMB(int bytes) {
    return bytes / (1024 * 1024); // Convert bytes to megabytes
  }

  Future<XFile?> compressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, targetPath,
      quality: 50,
      rotate: 180,
    );
    print(file.lengthSync());

    return result;
  }


}



