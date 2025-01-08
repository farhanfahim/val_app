import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:val_app/Repository/auth_api/auth_http_api_repository.dart';
import 'package:val_app/Response/api_response.dart';
import 'package:val_app/configs/color/colors.dart';
import 'package:val_app/configs/routes/routes_name.dart';
import 'package:val_app/configs/utils.dart';
import 'package:val_app/model/AuthModels/CreateProfileModel.dart';
import 'package:val_app/model/AuthModels/MyProfileModel.dart';
import 'package:val_app/model/city_model.dart';

import '../../configs/app_urls.dart';
import '../../configs/components/custom_snackbar.dart';
import '../../configs/sharedPerfs.dart';
import '../../firestore/firestore_controller.dart';
import '../../model/occupation_model.dart';
import '../../model/signup_skill_model.dart';
import '../../model/skills_model.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/country.dart';

class CreateProfileViewModel extends ChangeNotifier {
  bool? isEdit;
  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController cityTextEditingController = TextEditingController();
  TextEditingController countryTextEditingController = TextEditingController();
  TextEditingController occupationTextEditingController =
      TextEditingController();
  TextEditingController skillsTextEditingController = TextEditingController();
  TextEditingController aboutTextEditingController = TextEditingController();
  TextEditingController searchTextEditingController = TextEditingController();

  final createProfileFormKey = GlobalKey<FormState>();
  FocusNode focusSearch = FocusNode();
  FocusNode focusUsername = FocusNode();
  FocusNode focusCity = FocusNode();
  FocusNode focusOccupation = FocusNode();
  FocusNode focusSkills = FocusNode();
  FocusNode focusAbout = FocusNode();
  File? selectedFile;
  File? selectedBackgroundFile;
  String? selectedFileEdit;
  String? selectedBackgroundFileEdit;

  // List<String> selectedSkills = [];
  // List<String> selectedSkillNames = [];
  // List<String> selectedSkillsList = [];
  List<OccupationList> occupationList = [];
  List<OccupationList> filteredOccupationList = [];
  List<FilteredSkillsDataList> skillsList = [];
  List<SignupSkillsData> filteredSkillsList = [];
  List<FilteredSkillsDataList> selectedSkillList = [];
  List<SignupSkillsData> selectedSignupSkillList = [];
  List<SignupSkillsData> signupSkillsList = [];
  String address = "";
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";

  int selectedOccupationIndex = -1;
  MyProfileModel? myProfile;

  onCountryChanged(String? value) {
    ///store value in country variable
    print(value);
    countryValue = value ?? "";
    stateValue = "";
    cityValue = "";
    notifyListeners();
  }

  ///triggers once state selected in dropdown
  onStateChanged(String? value) {
    ///store value in state variable
    stateValue = value ?? "";
    cityValue = "";
    notifyListeners();
  }

  ///triggers once city selected in dropdown
  onCityChanged(String? value) {
    ///store value in city variable
    cityValue = value ?? "";
    notifyListeners();
  }

  Future<void> camPick() async {
    if (await Utils().permissionCameraCheckMethod()) {
      final XFile? result = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 20);
      if (result != null) {
        selectedFile = File(result.path);
        notifyListeners();
      } else {
        CustomSnackBar.show('No image picked from camera.');
      }
    }
  }

  Future<void> galleryPick() async {
    if (await Utils().permissionCheckMethod()) {
      final XFile? result = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (result != null) {
        selectedFile = File(result.path);
        notifyListeners();
      } else {
        CustomSnackBar.show('No image picked from gallery.');
      }
    }
  }

  Future<void> backgroundPick() async {
    if (await Utils().permissionCheckMethod()) {
      final XFile? result = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (result != null) {
        selectedBackgroundFile = File(result.path);
        notifyListeners();
      } else {
        CustomSnackBar.show('No image picked from gallery.');
      }
    }
  }

  void openCountryPickerDialog(context) => showDialog(
        context: context,
        builder: (context) => Theme(
          data:
              Theme.of(context).copyWith(primaryColor: AppColors.primaryColor),
          child: CountryPickerDialog(
            titlePadding: const EdgeInsets.all(8.0),
            searchCursorColor: AppColors.primaryColor,
            searchInputDecoration: const InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: const Text('Select your country'),
            onValuePicked: (Country country) {
              // selectedDialogCountry = country;
              countryTextEditingController.text = country.name.toString();
              notifyListeners();
            },
            itemBuilder: _buildDialogItem,
            priorityList: [
              CountryPickerUtils.getCountryByIsoCode('TR'),
              CountryPickerUtils.getCountryByIsoCode('US'),
            ],
          ),
        ),
      );

  Widget _buildDialogItem(Country country) {
    return Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        // const SizedBox(width: 8.0),
        // Text("+${country.phoneCode}"),
        const SizedBox(width: 8.0),
        Flexible(child: Text(country.name))
      ],
    );
  }

  List<CityModel> cities = [
    CityModel(id: 1, name: 'Alabama'),
    CityModel(id: 2, name: 'California'),
    CityModel(id: 3, name: 'Florida'),
    CityModel(id: 4, name: 'Georgia'),
    CityModel(id: 5, name: 'Kentucky'),
    CityModel(id: 6, name: 'West Virgina'),
    CityModel(id: 7, name: 'Fontana'),
    CityModel(id: 8, name: 'Oxnard'),
  ];

  int? selectedCityId;
  String? selectedCity;
  String? city;
  String selectedOccupationId = "";
  List occuIDList = [];
  String? selectedOccupation;
  String? occupation;

  bool loading = true;
  bool occupationLoading = true;
  bool skillLoading = false;

  void selectCity(CityModel city) {
    selectedCityId = city.id;
    selectedCity = city.name;
    notifyListeners();
  }

  void updateCity(String city) {
    city = city;
    cityTextEditingController.text = city;
    notifyListeners();
  }

  void selectOccupation(String occupation, String occuID) {
    selectedOccupationId = occuID;
    selectedOccupation = occupation;
    occupationTextEditingController.text = occupation;

    occuIDList.clear();
    selectedSignupSkillList.clear();
    occuIDList.add(occuID);
    notifyListeners();
  }

  void selectOccupationNew(String occupation, String occuID) {
    selectedOccupationId = occuID;
    notifyListeners();
  }

  void updateOccupation(String occupation) {
    occupation = occupation;
    occupationTextEditingController.text = occupation;
    selectedSignupSkillList.clear();
    notifyListeners();
  }

  void skillsSelection(FilteredSkillsDataList selectedSkill) {
    if (selectedSkillList.contains(selectedSkill)) {
      selectedSkillList.remove(selectedSkill);
    } else {
      selectedSkillList.add(selectedSkill);
    }
    notifyListeners();
  }

  void removeSkills(FilteredSkillsDataList selectedSkill) {
    selectedSkillList.removeWhere((element) => element == selectedSkill);

    notifyListeners();
  }

  void signupSkillsSelection(SignupSkillsData selectedSkill) {
    if (selectedSignupSkillList.contains(selectedSkill)) {
      selectedSignupSkillList.remove(selectedSkill);
    } else {
      selectedSignupSkillList.add(selectedSkill);
      skillsTextEditingController.text = selectedSkill.tool!;
    }
    notifyListeners();
  }

  void removeSignupSkills(SignupSkillsData selectedSkill) {
    selectedSignupSkillList.remove(selectedSkill);
    if (selectedSignupSkillList.isEmpty) {
      skillsTextEditingController.clear();
    }
    notifyListeners();
  }

  void removeEditSkills(Skills selectedSkill) {
    selectedSkillList.removeWhere((element) => element == selectedSkill);

    notifyListeners();
  }

  CreateProfileViewModel() {
    focusUsername.addListener(notifyListeners);
    focusCity.addListener(notifyListeners);
    focusOccupation.addListener(notifyListeners);
    focusSkills.addListener(notifyListeners);
    focusAbout.addListener(notifyListeners);
    focusSearch.addListener(notifyListeners);
  }

  @override
  void dispose() {
    focusUsername.dispose();
    focusCity.dispose();
    // usernameTextEditingController.dispose();
    cityTextEditingController.dispose();
    occupationTextEditingController.dispose();
    skillsTextEditingController.dispose();
    aboutTextEditingController.dispose();
    focusOccupation.dispose();
    focusSkills.dispose();
    focusAbout.dispose();
    super.dispose();
  }

  Future<void> getSkills(BuildContext context) async {
    Utils().loadingDialog(context);
    // setSkillsApiResponse(ApiResponse.loading());

    try {
      final response = await authRepository.getSkills();

      if (response != null) {
        setSkillsApiResponse(ApiResponse.completed(response));
        // skillsList.clear();
        // skillsList = response.data??[];
        loading = false;
        Navigator.pop(context); // Close the loading dialog
        notifyListeners();

        if (skillsList.isNotEmpty) {
          print("skill: ${skillsList[0].skills}");
        }
        print("length: ${skillsList.length}");
      }
    } catch (error) {
      Navigator.pop(context); // Ensure the loading dialog is closed on error
      setSkillsApiResponse(ApiResponse.error("Error"));
      print("error: $error");
      notifyListeners();
    }
  }

  Future<void> getSignupSkills(BuildContext context, bool isEdit) async {
    Utils().loadingDialog(context);
    if(isEdit == false) {
      skillsTextEditingController.text = '';
    }
    //notifyListeners();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? accessToken = _prefs.getString("accessToken") ?? "";
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {"occupations": selectedOccupationId};

    try {
      final response = await authRepository.getSignupSkills(data, headers);

      if (response!.status == "success") {
        setSignupSkillsApiResponse(ApiResponse.completed(response));
        signupSkillsList.clear();
        signupSkillsList = response.data ?? [];
        filteredSkillsList = response.data ?? [];
        skillLoading = false;
        // Navigator.pop(context); // Close the loading dialog
        notifyListeners();

        if (signupSkillsList.isNotEmpty) {
          print("skill: ${signupSkillsList[0].tool}");
        }
        print("length: ${signupSkillsList.length}");
        Navigator.pop(context);
        if (isEdit == false) {
          onBackPress(context);
        }
        notifyListeners();
        //Navigator.pop(context);
      }
    } catch (error) {
      // Navigator.pop(context); // Ensure the loading dialog is closed on error
      setSignupSkillsApiResponse(ApiResponse.error("Error"));
      print("error: $error");
      notifyListeners();
    }
  }

  getOccupations(context) async {
    // Utils().loadingDialog(context);

    try {
      final response = await authRepository.getOccupation();

      if (response != null) {
        setOccupationsApiResponse(ApiResponse.completed(response));
        occupationList.clear();
        occupationList = response.data ?? [];
        filteredOccupationList = response.data ?? [];
        occupationLoading = false;
        // Navigator.pop(context); // Close the loading dialog
        notifyListeners();

        if (occupationList.isNotEmpty) {
          print("occupations: ${occupationList[0].occupations}");
        }
        print("length: ${occupationList.length}");
      }
    } catch (error) {
      // Navigator.pop(context); // Ensure the loading dialog is closed on error
      setOccupationsApiResponse(ApiResponse.error("Error"));
      print("error: $error");
      notifyListeners();
    }
  }

  onBackPress(context){
    searchTextEditingController.text = '';
    occupationLoading = true;
    filteredOccupationList.clear();
    occupationList.clear();
    notifyListeners();
    Navigator.pop(context);
  }

  void filterOccupation(String query) {
    if (query.isEmpty) {
      filteredOccupationList = occupationList;
    } else {
      filteredOccupationList = occupationList
          .where((item) => item.occupations!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    searchTextEditingController.text = query;
    notifyListeners();
  }

  void filterSkills(String query) {
    if (query.isEmpty) {
      filteredSkillsList = signupSkillsList;
    } else {
      filteredSkillsList = signupSkillsList
          .where((item) => item.tool!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    searchTextEditingController.text = query;
    notifyListeners();
  }


  postOccupation(context) async {
    Utils().loadingDialog(context);
    setFilterSkillApiResponse(ApiResponse.loading());
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? accessToken = _prefs.getString("accessToken") ?? "";
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());

    var data = {
      "occupations": selectedOccupationId,
    };
    try {
      final response = await authRepository.postOccupation(data, headers);

      if (response != null) {
        // occupationList.clear();
        // occupationList = response.data ?? [];
        setFilterSkillApiResponse(ApiResponse.completed(response));
        loading = false;
        skillsList.clear();
        skillsList = response.data ?? [];
        Navigator.pop(context); // Close the loading dialog
        notifyListeners();

        // if (occupationList.isNotEmpty) {
        //   print("occupations: ${occupationList[0].occupations}");
        // }
        // print("length: ${occupationList.length}");
      }
    } catch (error) {
      Navigator.pop(context); // Ensure the loading dialog is closed on error
      setFilterSkillApiResponse(ApiResponse.error("Error"));
      print("error: $error");
      notifyListeners();
    }
  }

  CreateProfilePost(context) async {
    if (createProfileFormKey.currentState!.validate()) {
      // Perform login logic here
      if (countryValue.isEmpty) {
        Utils.toastMessage('Country is Required');
      } else if (stateValue.isEmpty) {
        Utils.toastMessage('State is Required');
      } else if (cityValue.isEmpty) {
        Utils.toastMessage('City is Required');
      } else {
        Utils().loadingDialog(context);
        final credentials = await Utils.getUserCredentials();
        String? accessToken =
            credentials['accessToken']; //_prefs.getString("accessToken") ?? "";
        var headers = {'Authorization': 'Bearer ${accessToken}'};
        print("headers:" + headers.toString());
        Map<String, String> data = {
          "username": usernameTextEditingController.text.trim().toString(),
          "about": aboutTextEditingController.text.trim().toString(),
          'country': countryValue.toString(),
          'state': stateValue.toString(),
          "city": cityValue,
          "occupations[0]": selectedOccupationId ?? ""
        };
        for (var i = 0; i < selectedSignupSkillList.length; i++) {
          data['skills[$i]'] = selectedSignupSkillList[i].id.toString();
        }
        print(data.toString());

        try {
          authRepository
              .createProfileApi(
                  data, headers, selectedBackgroundFile, selectedFile)
              .then(
            (value) {
              if (value != null) {

                Utils.toastMessage("Profile Created Sucessfully");
                Navigator.pop(context);
                usernameTextEditingController.clear();
                occupationTextEditingController.clear();
                skillsTextEditingController.clear();
                aboutTextEditingController.clear();
                occuIDList.clear();
                skillsList.clear();
                selectedSkillList.clear();

                SharedPrefs.instance.setBool("isDone", true);
                clearData();
                Navigator.pushReplacementNamed(context, RoutesName.interest);
              } else {
                setCreateProfileApiResponse(
                    ApiResponse.error("Error creating profile"));
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
      }
    }
  }

  EditProfilePost(context) async {
    if (createProfileFormKey.currentState!.validate()) {
      // Perform login logic here
      if (countryValue.isEmpty) {
        Utils.toastMessage('Country is Required');
      } else if (stateValue.isEmpty) {
        Utils.toastMessage('State is Required');
      } else if (cityValue.isEmpty) {
        Utils.toastMessage('City is Required');
      } else {
        Utils().loadingDialog(context);
        final credentials = await Utils.getUserCredentials();
        String? accessToken =
            credentials['accessToken']; //_prefs.getString("accessToken") ?? "";
        var headers = {'Authorization': 'Bearer ${accessToken}'};
        print("headers:" + headers.toString());
        Map<String, String> data = {
          "username": usernameTextEditingController.text.trim().toString(),
          "about": aboutTextEditingController.text.trim().toString(),
          "city": cityValue,
          'country': countryValue,
          'state': stateValue,
          "occupations[0]": selectedOccupationId,
        };
        for (var i = 0; i < selectedSignupSkillList.length; i++) {
          data['skills[$i]'] = selectedSignupSkillList[i].id.toString();
        }
        print(data.toString());

        try {
          authRepository
              .editProfileApi(
                  data, headers, selectedBackgroundFile, selectedFile)
              .then(
            (value) {
              if (value != null) {
                FirestoreController.instance.updateUserData(
                    int.parse(
                        SharedPrefs.instance.getString("userId").toString()),
                    value.username,
                    value.mainImage != null
                        ? AppUrl.baseUrl + value.mainImage!
                        : "");

                Navigator.pop(context);
                clearData();
                Navigator.pop(context,value);
              } else {
                setCreateProfileApiResponse(
                    ApiResponse.error("Error Updating profile"));
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
      }
    }
  }

  clearData(){
    myProfile = null;
    usernameTextEditingController.text ="";
    occupationTextEditingController.text = "";
    aboutTextEditingController.text ="";
    skillsTextEditingController.text = "";
    selectedFileEdit = "";
    selectedBackgroundFileEdit = "";
    cityValue = "";
    countryValue = "";
    stateValue = "";
    selectedOccupationId = "";
    selectedBackgroundFile = null;
    selectedFile = null;
    selectedSignupSkillList.clear();
    notifyListeners();
  }

  AuthHttpApiRepository authRepository = AuthHttpApiRepository();
  ApiResponse<CreateProfileModel> createProfile = ApiResponse.notStarted();
  ApiResponse<SkillsModel> skills_res = ApiResponse.loading();
  ApiResponse<SignupSkillsModel> signupSkills_res = ApiResponse.loading();
  ApiResponse<FilteredSkillsModel> flitered_skills_res = ApiResponse.loading();
  ApiResponse<OccupationModel> occupation_res = ApiResponse.notStarted();

  setFilterSkillApiResponse(ApiResponse<FilteredSkillsModel> response) {
    flitered_skills_res = response;
    notifyListeners();
  }

  setCreateProfileApiResponse(ApiResponse<CreateProfileModel> response) {
    createProfile = response;
    notifyListeners();
  }

  setSkillsApiResponse(ApiResponse<SkillsModel> response) {
    skills_res = response;
    notifyListeners();
  }

  setSignupSkillsApiResponse(ApiResponse<SignupSkillsModel> response) {
    signupSkills_res = response;
    notifyListeners();
  }

  setOccupationsApiResponse(ApiResponse<OccupationModel> response) {
    occupation_res = response;
    notifyListeners();
  }

  Future<void> getMyProfile(BuildContext context) async {
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    try {
      Utils().loadingDialog(context);
      MyProfileModel response = await authRepository.getMyProfile(headers);

      if (response.status == true) {
        myProfile = response;
        usernameTextEditingController.text =
            myProfile!.data!.valProfile!.username.toString();
        occupationTextEditingController.text =
            myProfile!.data!.occupations![0].occupations.toString();
        aboutTextEditingController.text =
            myProfile!.data!.valProfile!.about.toString();
        skillsTextEditingController.text = myProfile!.data!.skills!.isEmpty
            ? ""
            : myProfile!.data!.skills![0].tool.toString();
        selectedFileEdit = myProfile!.data!.valProfile!.mainImage.toString();
        selectedBackgroundFileEdit =
            myProfile!.data!.valProfile!.coverImage.toString();
        cityValue = myProfile!.data!.valProfile!.city.toString();
        countryValue = myProfile!.data!.valProfile!.country.toString();
        stateValue = myProfile!.data!.valProfile!.state.toString();
        selectedOccupationId = myProfile!.data!.occupations![0].id.toString();
        selectedSignupSkillList.clear();

        for (var skill in myProfile!.data!.skills!) {
          selectedSignupSkillList.add(
            SignupSkillsData(
              id: skill.id,
              tool: skill.tool,
              iCategory: null,
            ),
          );
        }
        Navigator.pop(context);
        notifyListeners();
      }
    } catch (error) {
      Navigator.pop(context);
      Utils.toastMessage(error.toString());

      print("error: $error");
    }
  }
}
