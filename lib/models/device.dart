class Device {
  final int id;
  final String title;
  final String model;
  final String? subtitle;
  final String? industry;
  final String deviceType;
  final String? description;
  final String? features;
  final String? certNo;
  final String? explosionCert;
  final List<String> images;
  final int? systemId;
  final String? systemName;
  final List<SpecItem>? specs;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Device({
    required this.id,
    required this.title,
    required this.model,
    this.subtitle,
    this.industry,
    required this.deviceType,
    this.description,
    this.features,
    this.certNo,
    this.explosionCert,
    this.images = const [],
    this.systemId,
    this.systemName,
    this.specs,
    this.createdAt,
    this.updatedAt,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      model: json['model'] ?? '',
      subtitle: json['subtitle'],
      industry: json['industry'],
      deviceType: json['device_type'] ?? json['deviceType'] ?? '未知',
      description: json['description'],
      features: json['features'],
      certNo: json['cert_no'] ?? json['certNo'],
      explosionCert: json['explosion_cert'] ?? json['explosionCert'],
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      systemId: json['system_id'] ?? json['systemId'],
      systemName: json['system_name'] ?? json['systemName'],
      specs: (json['specs'] as List<dynamic>?)
          ?.map((e) => SpecItem.fromJson(e as Map<String, dynamic>))
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

class SpecItem {
  final String label;
  final String value;
  final String? note;
  final String group;

  SpecItem({
    required this.label,
    required this.value,
    this.note,
    required this.group,
  });

  factory SpecItem.fromJson(Map<String, dynamic> json) {
    return SpecItem(
      label: json['label'] ?? '',
      value: json['value'] ?? '',
      note: json['note'],
      group: json['group'] ?? 'basic',
    );
  }
}

class DeviceListResponse {
  final List<Device> items;
  final int total;
  final int page;
  final int pageSize;

  DeviceListResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory DeviceListResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return DeviceListResponse(
      items: (data['data'] as List<dynamic>?)
              ?.map((e) => Device.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: data['total'] ?? 0,
      page: data['page'] ?? 1,
      pageSize: data['page_size'] ?? data['pageSize'] ?? 20,
    );
  }
}
