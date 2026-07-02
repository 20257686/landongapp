import 'package:flutter/foundation.dart';
import '../models/device.dart';
import '../models/product_system.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _service = ProductService();

  // 设备列表
  List<Device> _devices = [];
  bool _devicesLoading = false;
  int _devicesPage = 1;
  bool _devicesHasMore = true;
  String? _deviceKeyword;
  String? _deviceType;

  List<Device> get devices => _devices;
  bool get devicesLoading => _devicesLoading;
  bool get devicesHasMore => _devicesHasMore;
  bool get hasMoreDevices => _devicesHasMore;

  // 系统列表
  List<ProductSystem> _systems = [];
  bool _systemsLoading = false;
  int _systemsPage = 1;
  bool _systemsHasMore = true;
  String? _systemKeyword;

  List<ProductSystem> get systems => _systems;
  bool get systemsLoading => _systemsLoading;
  bool get systemsHasMore => _systemsHasMore;
  bool get hasMoreSystems => _systemsHasMore;

  // 详情
  Device? _currentDevice;
  ProductSystem? _currentSystem;
  bool _detailLoading = false;

  Device? get currentDevice => _currentDevice;
  ProductSystem? get currentSystem => _currentSystem;
  bool get isLoading => _devicesLoading || _systemsLoading || _detailLoading;

  // 当前选中的Tab
  int _currentTab = 0;
  int get currentTab => _currentTab;

  void setCurrentTab(int index) {
    _currentTab = index;
    notifyListeners();
  }

  // 加载设备列表
  Future<void> loadDevices({bool refresh = false}) async {
    if (_devicesLoading) return;

    if (refresh) {
      _devicesPage = 1;
      _devicesHasMore = true;
      _devices = [];
    }

    if (!_devicesHasMore) return;

    _devicesLoading = true;
    notifyListeners();

    try {
      final result = await _service.getDevices(
        page: _devicesPage,
        keyword: _deviceKeyword,
        deviceType: _deviceType,
      );

      if (refresh) {
        _devices = result.items;
      } else {
        _devices.addAll(result.items);
      }

      _devicesPage++;
      _devicesHasMore = result.items.length >= 20 && _devices.length < result.total;
    } catch (e) {
      debugPrint('加载设备列表失败: $e');
    } finally {
      _devicesLoading = false;
      notifyListeners();
    }
  }

  // 加载更多设备
  Future<void> loadMoreDevices() => loadDevices();

  // 加载系统列表
  Future<void> loadSystems({bool refresh = false}) async {
    if (_systemsLoading) return;

    if (refresh) {
      _systemsPage = 1;
      _systemsHasMore = true;
      _systems = [];
    }

    if (!_systemsHasMore) return;

    _systemsLoading = true;
    notifyListeners();

    try {
      final result = await _service.getSystems(
        page: _systemsPage,
        keyword: _systemKeyword,
      );

      if (refresh) {
        _systems = result.items;
      } else {
        _systems.addAll(result.items);
      }

      _systemsPage++;
      _systemsHasMore = result.items.length >= 20 && _systems.length < result.total;
    } catch (e) {
      debugPrint('加载系统列表失败: $e');
    } finally {
      _systemsLoading = false;
      notifyListeners();
    }
  }

  // 加载更多系统
  Future<void> loadMoreSystems() => loadSystems();

  // 加载设备详情
  Future<void> loadDeviceDetail(int id) async {
    _detailLoading = true;
    notifyListeners();

    try {
      _currentDevice = await _service.getDeviceDetail(id);
    } catch (e) {
      debugPrint('加载设备详情失败: $e');
    } finally {
      _detailLoading = false;
      notifyListeners();
    }
  }

  // 加载系统详情
  Future<void> loadSystemDetail(int id) async {
    _detailLoading = true;
    notifyListeners();

    try {
      _currentSystem = await _service.getSystemDetail(id);
    } catch (e) {
      debugPrint('加载系统详情失败: $e');
    } finally {
      _detailLoading = false;
      notifyListeners();
    }
  }

  // 搜索设备
  void searchDevices(String keyword) {
    _deviceKeyword = keyword;
    loadDevices(refresh: true);
  }

  // 搜索系统
  void searchSystems(String keyword) {
    _systemKeyword = keyword;
    loadSystems(refresh: true);
  }
}
