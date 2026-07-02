class ProductSystem {
  final int id;
  final String title;
  final String? subtitle;
  final String? industry;
  final String? heroImage;
  final String? heroSlogan;
  final String? heroDescription;
  final String? mainSlogan;
  final String? mainDescription;
  final String? mainNote;
  final List<CoreValue>? coreValues;
  final List<KeyMetric>? keyMetrics;
  final List<SystemDevice>? devices;
  final List<Application>? applications;
  final List<String>? certifications;
  final List<String>? images;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductSystem({
    required this.id,
    required this.title,
    this.subtitle,
    this.industry,
    this.heroImage,
    this.heroSlogan,
    this.heroDescription,
    this.mainSlogan,
    this.mainDescription,
    this.mainNote,
    this.coreValues,
    this.keyMetrics,
    this.devices,
    this.applications,
    this.certifications,
    this.images,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductSystem.fromJson(Map<String, dynamic> json) {
    return ProductSystem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      subtitle: json['subtitle'],
      industry: json['industry'],
      heroImage: json['hero_image'] ?? json['heroImage'],
      heroSlogan: json['hero_slogan'] ?? json['heroSlogan'],
      heroDescription: json['hero_description'] ?? json['heroDescription'],
      mainSlogan: json['main_slogan'] ?? json['mainSlogan'],
      mainDescription: json['main_description'] ?? json['mainDescription'],
      mainNote: json['main_note'] ?? json['mainNote'],
      coreValues: (json['core_values'] as List<dynamic>?)
          ?.map((e) => CoreValue.fromJson(e as Map<String, dynamic>))
          .toList(),
      keyMetrics: (json['key_metrics'] as List<dynamic>?)
          ?.map((e) => KeyMetric.fromJson(e as Map<String, dynamic>))
          .toList(),
      devices: (json['devices'] as List<dynamic>?)
          ?.map((e) => SystemDevice.fromJson(e as Map<String, dynamic>))
          .toList(),
      applications: (json['applications'] as List<dynamic>?)
          ?.map((e) => Application.fromJson(e as Map<String, dynamic>))
          .toList(),
      certifications: (json['certifications'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}

class CoreValue {
  final String icon;
  final String title;
  final String description;

  CoreValue({
    required this.icon,
    required this.title,
    required this.description,
  });

  factory CoreValue.fromJson(Map<String, dynamic> json) {
    return CoreValue(
      icon: json['icon'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class KeyMetric {
  final String label;
  final String value;
  final String? unit;

  KeyMetric({
    required this.label,
    required this.value,
    this.unit,
  });

  factory KeyMetric.fromJson(Map<String, dynamic> json) {
    return KeyMetric(
      label: json['label'] ?? '',
      value: json['value'] ?? '',
      unit: json['unit'],
    );
  }
}

class SystemDevice {
  final int id;
  final String name;
  final String? model;
  final String? image;
  final String? description;

  SystemDevice({
    required this.id,
    required this.name,
    this.model,
    this.image,
    this.description,
  });

  factory SystemDevice.fromJson(Map<String, dynamic> json) {
    return SystemDevice(
      id: json['id'] ?? 0,
      name: json['name'] ?? json['title'] ?? '',
      model: json['model'],
      image: json['image'],
      description: json['description'],
    );
  }
}

class Application {
  final String title;
  final String description;
  final String? image;

  Application({
    required this.title,
    required this.description,
    this.image,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'],
    );
  }
}

class SystemListResponse {
  final List<ProductSystem> items;
  final int total;
  final int page;
  final int pageSize;

  SystemListResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory SystemListResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return SystemListResponse(
      items: (data['data'] as List<dynamic>?)
              ?.map((e) => ProductSystem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: data['total'] ?? 0,
      page: data['page'] ?? 1,
      pageSize: data['page_size'] ?? data['pageSize'] ?? 20,
    );
  }
}
