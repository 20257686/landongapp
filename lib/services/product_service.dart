import '../config/api_config.dart';
import '../models/device.dart';
import '../models/product_system.dart';
import 'api_service.dart';

class ProductService {
  final ApiService _api = ApiService();

  // 获取设备列表
  Future<DeviceListResponse> getDevices({
    int page = 1,
    int pageSize = 20,
    String? keyword,
    String? deviceType,
    int? systemId,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };
    if (keyword != null && keyword.isNotEmpty) params['keyword'] = keyword;
    if (deviceType != null && deviceType.isNotEmpty) {
      params['device_type'] = deviceType;
    }
    if (systemId != null) params['system_id'] = systemId;

    final response = await _api.get('/products/devices', queryParameters: params);
    return DeviceListResponse.fromJson(_api.handleResponse(response));
  }

  // 获取设备详情
  Future<Device> getDeviceDetail(int id) async {
    final response = await _api.get('/products/devices/$id');
    final data = _api.handleResponse(response);
    return Device.fromJson(data['data'] as Map<String, dynamic>);
  }

  // 获取系统列表
  Future<SystemListResponse> getSystems({
    int page = 1,
    int pageSize = 20,
    String? keyword,
    String? industry,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };
    if (keyword != null && keyword.isNotEmpty) params['keyword'] = keyword;
    if (industry != null && industry.isNotEmpty) params['industry'] = industry;

    final response = await _api.get('/products/systems', queryParameters: params);
    return SystemListResponse.fromJson(_api.handleResponse(response));
  }

  // 获取系统详情
  Future<ProductSystem> getSystemDetail(int id) async {
    final response = await _api.get('/products/systems/$id');
    final data = _api.handleResponse(response);
    return ProductSystem.fromJson(data['data'] as Map<String, dynamic>);
  }
}
