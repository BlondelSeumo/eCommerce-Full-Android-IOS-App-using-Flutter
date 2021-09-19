import 'package:nyoba/constant/constants.dart';
import 'package:nyoba/constant/global_url.dart';
import 'package:nyoba/services/Session.dart';

class BlogAPI {
  fetchBlog(search, page) async {
    var response = await baseAPI.getAsync(
        '$blog?search=$search&page=$page&per_page=6&_embed',
        version: 2);
    return response;
  }

  postCommentBlog(String postId, String comment) async {
    Map data = {
      'cookie': Session.data.getString('cookie'),
      'post': postId,
      'comment': comment
    };
    var response = await baseAPI.postAsync(
      '$postComment',
      data,
      isCustom: true,
    );
    return response;
  }

  fetchBlogComment(postId) async {
    var response =
        await baseAPI.getAsync('$listComment?post=$postId', version: 2);
    return response;
  }

  fetchBlogDetailById(postId) async {
    var response = await baseAPI.getAsync(
        '$blog/$postId?_embed',
        version: 2);
    return response;
  }

  fetchBlogDetailBySlug(slug) async {
    var response = await baseAPI.getAsync(
        '$blog/?_embed&slug=$slug',
        version: 2);
    return response;
  }
}
