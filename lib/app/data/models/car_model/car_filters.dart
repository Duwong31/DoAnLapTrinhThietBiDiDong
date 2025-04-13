class CarFiltersResponse {
  final List<FilterCategory> data;
  final int status;

  CarFiltersResponse({required this.data, required this.status});

  factory CarFiltersResponse.fromJson(Map<String, dynamic> json) {
    return CarFiltersResponse(
      data: (json['data'] as List)
          .map((e) => FilterCategory.fromJson(e))
          .toList(),
      status: json['status'],
    );
  }
}

class FilterCategory {
  final String title;
  final String field;
  final String position;
  final String? minPrice;
  final String? maxPrice;
  final List<FilterOption>? data;

  FilterCategory({
    required this.title,
    required this.field,
    required this.position,
    this.minPrice,
    this.maxPrice,
    this.data,
  });

  factory FilterCategory.fromJson(Map<String, dynamic> json) {
    List<FilterOption>? filterData;
    
    if (json['data'] != null) {
      filterData = (json['data'] as List)
          .map((e) => FilterOption.fromJson(e))
          .toList();
    }

    return FilterCategory(
      title: json['title'],
      field: json['field'],
      position: json['position'],
      minPrice: json['min_price'],
      maxPrice: json['max_price'],
      data: filterData,
    );
  }
}

class FilterOption {
  final dynamic id;
  final String name;
  final int count;
  final String? slug;
  final String? logo;

  FilterOption({
    required this.id,
    required this.name,
    required this.count,
    this.slug,
    this.logo,
  });

  factory FilterOption.fromJson(Map<String, dynamic> json) {
    return FilterOption(
      id: json['id'],
      name: json['name'],
      count: json['count'] is int ? json['count'] : int.parse(json['count'].toString()),
      slug: json['slug'],
      logo: json['logo'],
    );
  }

  @override
  String toString() {
    return 'FilterOption{id: $id, name: $name, count: $count, slug: $slug, logo: $logo}';
  }
}