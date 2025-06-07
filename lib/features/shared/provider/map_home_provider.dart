import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

//==============================================================================
// 1. ESTADO INMUTABLE DEL MAPA (MapState)
//==============================================================================

// @immutable
class MapState {
  final LatLng? currentLocation;
  final GoogleMapController? mapController;
  final bool isLoading;
  final String? errorMessage;

  const MapState({
    this.currentLocation,
    this.mapController,
    this.isLoading = true,
    this.errorMessage,
  });

  MapState copyWith({
    LatLng? currentLocation,
    GoogleMapController? mapController,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MapState(
      currentLocation: currentLocation ?? this.currentLocation,
      mapController: mapController ?? this.mapController,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'MapState(currentLocation: $currentLocation, mapController: $mapController, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MapState &&
        other.currentLocation == currentLocation &&
        other.mapController == mapController &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return currentLocation.hashCode ^
        mapController.hashCode ^
        isLoading.hashCode ^
        errorMessage.hashCode;
  }
}

//==============================================================================
// 2. NOTIFICADORES DE ESTADO (MapNotifier, GpsStatusNotifier y sus Providers)
//==============================================================================

class MapNotifier extends StateNotifier<MapState> {
  final Ref _ref;

  MapNotifier(this._ref) : super(const MapState()) {
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    await fetchCurrentLocation();
  }

  void setMapController(GoogleMapController controller) {
    state = state.copyWith(mapController: controller);
    if (state.currentLocation != null) {
      moveCamera(state.currentLocation!);
    }
  }

  void moveCamera(LatLng newLocation) {
    // state = state.copyWith(currentLocation: newLocation); // Ya se actualiza en fetchCurrentLocation
    state.mapController?.animateCamera(CameraUpdate.newLatLng(newLocation));
  }

  Future<void> fetchCurrentLocation() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception(
            'Los servicios de ubicación están deshabilitados. Por favor, actívalos.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception(
              'Los permisos de ubicación fueron denegados por el usuario.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Los permisos de ubicación están permanentemente denegados. Por favor, habilítalos desde la configuración de tu dispositivo.');
      }

      Position posicionActual = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final newLatLng =
          LatLng(posicionActual.latitude, posicionActual.longitude);

      state = state.copyWith(
        currentLocation: newLatLng,
        isLoading: false,
        errorMessage: null,
      );

      if (state.mapController != null) {
        moveCamera(newLatLng);
      } else {
        print(
            'MapController es null al intentar mover la cámara después de obtener la ubicación. Se moverá cuando el mapa se inicialice.');
      }
    } catch (e) {
      print('Error al obtener la ubicación actual: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al obtener la ubicación: ${e.toString()}',
      );
    }
  }
}

final mapNotifierProvider = StateNotifierProvider<MapNotifier, MapState>((ref) {
  return MapNotifier(ref);
});

// Providers y Notificador de GPS y Permisos
final isGpsEnabledProvider = StateProvider<bool>((ref) => false);
final isPermissionGrantedProvider = StateProvider<bool>((ref) => false);

class GpsStatusNotifier extends StateNotifier<void> {
  final Ref _ref;
  GpsStatusNotifier(this._ref) : super(null);

  Future<void> checkGpsStatus() async {
    final isEnabled = await Geolocator.isLocationServiceEnabled();
    _ref.read(isGpsEnabledProvider.notifier).state = isEnabled;
  }

  Future<void> checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    final isGranted = permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
    _ref.read(isPermissionGrantedProvider.notifier).state = isGranted;
  }
}

final gpsStatusNotifierProvider =
    StateNotifierProvider<GpsStatusNotifier, void>((ref) {
  return GpsStatusNotifier(ref);
});
