class Pagination {
  int? totalItems;
  int? perPage;
  int? currentPage;
  int? totalPages;

  Pagination({
    this.totalItems,
    this.perPage,
    this.currentPage,
    this.totalPages,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    totalItems = json['total_items'];
    perPage = json['per_page'];
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_items'] = totalItems;
    data['per_page'] = perPage;
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    return data;
  }
}
