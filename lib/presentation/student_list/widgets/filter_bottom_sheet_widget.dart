import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, List<String>> selectedFilters;
  final ValueChanged<Map<String, List<String>>> onFiltersChanged;

  const FilterBottomSheetWidget({
    Key? key,
    required this.selectedFilters,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, List<String>> _tempFilters;

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
    'Zacatecas'
  ];

  final List<String> _academicYears = [
    '2024-2025',
    '2023-2024',
    '2022-2023',
    '2021-2022',
    '2020-2021'
  ];

  final List<String> _enrollmentStatuses = [
    'Inscrito',
    'Pendiente',
    'Inactivo',
    'Graduado'
  ];

  final List<String> _credentialStatuses = [
    'Generada',
    'Pendiente',
    'Vencida',
    'No generada'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tempFilters = Map<String, List<String>>.from(widget.selectedFilters);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(child: _buildTabBarView()),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(1.w),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filtros',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              TextButton(
                onPressed: _clearAllFilters,
                child: Text('Limpiar todo'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabs: [
          Tab(text: 'Estados'),
          Tab(text: 'Año académico'),
          Tab(text: 'Estado inscripción'),
          Tab(text: 'Credenciales'),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildFilterList('states', _mexicanStates),
        _buildFilterList('academicYears', _academicYears),
        _buildFilterList('enrollmentStatus', _enrollmentStatuses),
        _buildFilterList('credentialStatus', _credentialStatuses),
      ],
    );
  }

  Widget _buildFilterList(String filterKey, List<String> options) {
    final selectedOptions = _tempFilters[filterKey] ?? [];

    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        final isSelected = selectedOptions.contains(option);
        final count = _getOptionCount(filterKey, option);

        return CheckboxListTile(
          title: Text(
            option,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          subtitle: count > 0 ? Text('$count estudiantes') : null,
          value: isSelected,
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                if (!selectedOptions.contains(option)) {
                  selectedOptions.add(option);
                }
              } else {
                selectedOptions.remove(option);
              }
              _tempFilters[filterKey] = selectedOptions;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          dense: true,
        );
      },
    );
  }

  int _getOptionCount(String filterKey, String option) {
    // Mock count data - in real app, this would come from database
    switch (filterKey) {
      case 'states':
        return [
          15,
          23,
          8,
          12,
          45,
          67,
          34,
          19,
          28,
          41,
          52,
          33,
          18,
          29,
          38,
          25,
          14,
          31,
          47,
          22,
          36,
          17,
          26,
          39,
          21,
          44,
          16,
          35,
          27,
          42,
          20,
          37
        ][_mexicanStates.indexOf(option) % 32];
      case 'academicYears':
        return [156, 142, 98, 67, 23][_academicYears.indexOf(option)];
      case 'enrollmentStatus':
        return [234, 45, 23, 67][_enrollmentStatuses.indexOf(option)];
      case 'credentialStatus':
        return [189, 78, 12, 90][_credentialStatuses.indexOf(option)];
      default:
        return 0;
    }
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: ElevatedButton(
              onPressed: _applyFilters,
              child: Text('Aplicar filtros'),
            ),
          ),
        ],
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _tempFilters.clear();
    });
  }

  void _applyFilters() {
    widget.onFiltersChanged(_tempFilters);
    Navigator.pop(context);
  }
}
