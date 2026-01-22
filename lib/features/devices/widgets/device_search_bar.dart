import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/core/theme/theme_data.dart';

class DeviceSearchBar extends ConsumerStatefulWidget {
  const DeviceSearchBar({super.key});

  @override
  ConsumerState<DeviceSearchBar> createState() => _DeviceSearchBarState();
}

class _DeviceSearchBarState extends ConsumerState<DeviceSearchBar> {
  @override
  Widget build(BuildContext context) {
  
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SearchBar(
        hintText: 'Buscar...',
        textStyle: WidgetStatePropertyAll(AppTextStyles.h4),
        backgroundColor: WidgetStatePropertyAll(AppColors.card2),
        elevation: WidgetStatePropertyAll(6),
      
      //TODO IMPLEMENTAR CONSULTA SIMPLE CON EL SEARCHBAR
      
       
        leading: const Icon(Icons.search),
        onChanged: (query) {
        
        },
      ),
    );
  }
}
