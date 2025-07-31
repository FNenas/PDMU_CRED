import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StateSelectorBottomSheet extends StatefulWidget {
  final String? selectedState;
  final Function(String) onStateSelected;

  const StateSelectorBottomSheet({
    super.key,
    required this.selectedState,
    required this.onStateSelected,
  });

  @override
  State<StateSelectorBottomSheet> createState() =>
      _StateSelectorBottomSheetState();
}

class _StateSelectorBottomSheetState extends State<StateSelectorBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredStates = [];

  final List<String> _mexicanStates = [
    'Aguascalientes',
    'Baja California',
    'Baja California Sur',
    'Campeche',
    'Chiapas',
    'Chihuahua',
    'Ciudad de México',
    'Coahuila',
    'Colima',
    'Durango',
    'Estado de México',
    'Guanajuato',
    'Guerrero',
    'Hidalgo',
    'Jalisco',
    'Michoacán',
    'Morelos',
    'Nayarit',
    'Nuevo León',
    'Oaxaca',
    'Puebla',
    'Querétaro',
    'Quintana Roo',
    'San Luis Potosí',
    'Sinaloa',
    'Sonora',
    'Tabasco',
    'Tamaulipas',
    'Tlaxcala',
    'Veracruz',
    'Yucatán',
    'Zacatecas',
  ];

  @override
  void initState() {
    super.initState();
    _filteredStates = List.from(_mexicanStates);
    _searchController.addListener(_filterStates);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterStates() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStates = _mexicanStates
          .where((state) => state.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildSearchField(),
          Expanded(child: _buildStatesList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'location_on',
            color: AppTheme.lightTheme.primaryColor,
            size: 24,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              'Seleccionar Estado',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.textMediumEmphasisLight,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar estado...',
          prefixIcon: Padding(
            padding: EdgeInsets.all(12),
            child: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.textMediumEmphasisLight,
              size: 20,
            ),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    _filterStates();
                  },
                  icon: CustomIconWidget(
                    iconName: 'clear',
                    color: AppTheme.textMediumEmphasisLight,
                    size: 20,
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppTheme.lightTheme.dividerColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppTheme.lightTheme.dividerColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppTheme.lightTheme.primaryColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatesList() {
    if (_filteredStates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.textDisabledLight,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'No se encontraron estados',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.textMediumEmphasisLight,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      itemCount: _filteredStates.length,
      separatorBuilder: (context, index) => Divider(
        color: AppTheme.lightTheme.dividerColor,
        height: 1,
      ),
      itemBuilder: (context, index) {
        final state = _filteredStates[index];
        final isSelected = state == widget.selectedState;

        return ListTile(
          title: Text(
            state,
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: isSelected
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.textHighEmphasisLight,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
          trailing: isSelected
              ? CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                )
              : null,
          onTap: () {
            widget.onStateSelected(state);
            Navigator.pop(context);
          },
          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0.5.h),
        );
      },
    );
  }
}
