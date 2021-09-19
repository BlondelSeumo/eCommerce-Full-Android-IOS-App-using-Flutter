class BlogModel {
  // Model
  int id;
  String date, modified, slug, title, content, excerpt, author, link;
  List<BlogImageModel> blogImages;
  List<BlogCategoryModel> blogCategories;
  List<BlogCommentModel> blogCommentaries;

  BlogModel(
      {this.id,
      this.title,
      this.date,
      this.modified,
      this.content,
      this.excerpt,
      this.slug,
      this.author,
      this.blogImages,
      this.blogCategories,
      this.blogCommentaries,
      this.link});

  Map toJson() => {
        'id': id,
        'title': title,
        'date': date,
        'modified': modified,
        'content': content,
        'excerpt': excerpt,
        'slug': slug,
        'author': author,
        'blog_images': blogImages,
        'blog_categories': blogCategories,
        'blog_commentaries': blogCommentaries,
        'link': link,
      };

  BlogModel.fromJson(Map json) {
    id = json['id'];
    title = json['title']['rendered'];
    date = json['date'];
    modified = json['modified'];
    content = json['content']['rendered'];
    excerpt = json['excerpt']['rendered'];
    slug = json['slug'];
    author = json['_embedded']['author'][0]['name'];
    link = json['link'];
    if (json['_embedded']['wp:featuredmedia'] != null) {
      blogImages = [];
      json['_embedded']['wp:featuredmedia'].forEach((v) {
        blogImages.add(new BlogImageModel.fromJson(v));
      });
    }
    if (json['_embedded']['wp:term'][0] != null) {
      blogCategories = [];
      json['_embedded']['wp:term'][0].forEach((v) {
        blogCategories.add(new BlogCategoryModel.fromJson(v));
      });
    }
    if (json['_embedded']['replies'] != null) {
      blogCommentaries = [];
      json['_embedded']['replies'][0].forEach((v) {
        blogCommentaries.add(new BlogCommentModel.fromJson(v));
      });
    }
  }
}

class BlogImageModel {
  int id;
  String srcImg;

  BlogImageModel({this.id, this.srcImg});

  Map toJson() => {'id': id, 'source_url': srcImg};

  BlogImageModel.fromJson(Map json)
      : id = json['id'],
        srcImg = json['source_url'];
}

class BlogCategoryModel {
  int id;
  String categoryName;

  BlogCategoryModel({this.id, this.categoryName});

  Map toJson() => {'id': id, 'name': categoryName};

  BlogCategoryModel.fromJson(Map json)
      : id = json['id'],
        categoryName = json['name'];
}

class BlogCommentModel {
  int id, parent;
  String authorName, date, content, authorAvatar;

  BlogCommentModel(
      {this.id,
      this.parent,
      this.authorAvatar,
      this.authorName,
      this.date,
      this.content});

  Map toJson() => {
        'id': id,
        'parent': parent,
        'author_avatar': authorAvatar,
        'author_name': authorName,
        'date': date,
        'content': content
      };

  BlogCommentModel.fromJson(Map json)
      : id = json['id'],
        parent = json['parent'],
        authorName = json['author_name'],
        authorAvatar = json['author_avatar_urls']['48'],
        date = json['date'],
        content = json['content']['rendered'];
}
