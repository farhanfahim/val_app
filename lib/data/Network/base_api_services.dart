import 'dart:io'; 
import 'package:val_app/model/media_file_model.dart'; 

abstract class BaseApiServices {
  Future<dynamic> getGetApiResponse(String url, {var headers});
  Future<dynamic> getGetApiResponse2(String url, dynamic data, {var headers});
  Future<dynamic> getPostApiResponse(String url, dynamic data, var headers);
  Future<dynamic> getPutApiResponse(String url, dynamic data, var headers);
  Future<dynamic> getDeleteApiResponse({required String url, dynamic data, required var headers});
  Future<dynamic> getPostMultipartApiResponse(
    String url,
    Map<String, String> Fields,
    var headers, {
    File? mainImg,
    File? coverImg,
    List<MediaFile>? media,
    List<File>? file,
    String? multipartkey,
    int? index,
  });
  Future<dynamic> getPutMultipartApiResponse(
    String url,
    Map<String, String> Fields,
    var headers, {
    File? mainImg,
    File? coverImg,
    List<MediaFile>? media,
    List<File>? file,
    String? multipartkey,
    int? index,
  });
}
