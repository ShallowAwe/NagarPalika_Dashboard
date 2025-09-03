import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_nagarpalika_dashboard/model/wards_model.dart';

import 'package:smart_nagarpalika_dashboard/services/wards_services.dart';

class WardsNotifier extends AsyncNotifier<List<Wards>> {

   @override
  FutureOr<List<Wards>> build()  async{
    // TODO: implement build
    return await WardsServices.fetchWards();
  }

  Future<void> refresh() async{
    state = const AsyncLoading();
    state = await AsyncValue.guard(()=> WardsServices.fetchWards());
  }
  
}

final wardProvider = 
  AsyncNotifierProvider<WardsNotifier, List<Wards>> (
     WardsNotifier.new,
  );