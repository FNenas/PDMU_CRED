import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/alphabetical_section_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/loading_skeleton_widget.dart';
import './widgets/search_filter_bar_widget.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  String _searchQuery = '';
  Map<String, List<String>> _selectedFilters = {};
  List<String> _activeFilterChips = [];
  bool _isLoading = false;
  bool _isRefreshing = false;

  // Mock student data
  final List<Map<String, dynamic>> _allStudents = [
    {
      "id": 1,
      "name": "Ana María González Rodríguez",
      "enrollmentNumber": "MIL2024001",
      "state": "Ciudad de México",
      "academicYear": "2024-2025",
      "status": "enrolled",
      "photo":
          "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400",
      "credentialStatus": "generated",
      "dateEnrolled": "2024-08-15",
      "grade": "3°",
      "section": "A"
    },
    {
      "id": 2,
      "name": "Carlos Eduardo Martínez López",
      "enrollmentNumber": "MIL2024002",
      "state": "Jalisco",
      "academicYear": "2024-2025",
      "status": "enrolled",
      "photo":
          "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400",
      "credentialStatus": "pending",
      "dateEnrolled": "2024-08-16",
      "grade": "2°",
      "section": "B"
    },
    {
      "id": 3,
      "name": "Beatriz Alejandra Hernández Silva",
      "enrollmentNumber": "MIL2024003",
      "state": "Nuevo León",
      "academicYear": "2024-2025",
      "status": "pending",
      "photo":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "credentialStatus": "not_generated",
      "dateEnrolled": "2024-08-17",
      "grade": "1°",
      "section": "A"
    },
    {
      "id": 4,
      "name": "Diego Fernando Ramírez Torres",
      "enrollmentNumber": "MIL2024004",
      "state": "Guanajuato",
      "academicYear": "2024-2025",
      "status": "enrolled",
      "photo":
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
      "credentialStatus": "generated",
      "dateEnrolled": "2024-08-18",
      "grade": "3°",
      "section": "C"
    },
    {
      "id": 5,
      "name": "Elena Patricia Morales Jiménez",
      "enrollmentNumber": "MIL2024005",
      "state": "Puebla",
      "academicYear": "2023-2024",
      "status": "graduated",
      "photo":
          "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=400",
      "credentialStatus": "generated",
      "dateEnrolled": "2023-08-15",
      "grade": "Graduado",
      "section": ""
    },
    {
      "id": 6,
      "name": "Fernando José Castillo Mendoza",
      "enrollmentNumber": "MIL2024006",
      "state": "Veracruz",
      "academicYear": "2024-2025",
      "status": "inactive",
      "photo":
          "https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=400",
      "credentialStatus": "expired",
      "dateEnrolled": "2024-08-19",
      "grade": "2°",
      "section": "A"
    },
    {
      "id": 7,
      "name": "Gabriela Sofía Vargas Ruiz",
      "enrollmentNumber": "MIL2024007",
      "state": "Michoacán",
      "academicYear": "2024-2025",
      "status": "enrolled",
      "photo":
          "https://images.pexels.com/photos/1036623/pexels-photo-1036623.jpeg?auto=compress&cs=tinysrgb&w=400",
      "credentialStatus": "generated",
      "dateEnrolled": "2024-08-20",
      "grade": "1°",
      "section": "B"
    },
    {
      "id": 8,
      "name": "Héctor Manuel Delgado Peña",
      "enrollmentNumber": "MIL2024008",
      "state": "Chihuahua",
      "academicYear": "2024-2025",
      "status": "enrolled",
      "photo":
          "https://images.pexels.com/photos/1043474/pexels-photo-1043474.jpeg?auto=compress&cs=tinysrgb&w=400",
      "credentialStatus": "pending",
      "dateEnrolled": "2024-08-21",
      "grade": "3°",
      "section": "A"
    },
    {
      "id": 9,
      "name": "Isabel Cristina Flores Aguilar",
      "enrollmentNumber": "MIL2024009",
      "state": "Sonora",
      "academicYear": "2024-2025",
      "status": "pending",
      "photo":
          "https://images.pexels.com/photos/1065084/pexels-photo-1065084.jpeg?auto=compress&cs=tinysrgb&w=400",
      "credentialStatus": "not_generated",
      "dateEnrolled": "2024-08-22",
      "grade": "2°",
      "section": "C"
    },
    {
      "id": 10,
      "name": "Javier Alejandro Sánchez Cruz",
      "enrollmentNumber": "MIL2024010",
      "state": "Yucatán",
      "academicYear": "2024-2025",
      "status": "enrolled",
      "photo":
          "https://images.pexels.com/photos/1040880/pexels-photo-1040880.jpeg?auto=compress&cs=tinysrgb&w=400",
      "credentialStatus": "generated",
      "dateEnrolled": "2024-08-23",
      "grade": "1°",
      "section": "A"
    }
  ];

  List<Map<String, dynamic>> _filteredStudents = [];
  Map<String, List<Map<String, dynamic>>> _groupedStudents = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    _filteredStudents = List.from(_allStudents);
    _groupStudentsAlphabetically();
    _loadStudents();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadStudents() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _groupStudentsAlphabetically() {
    _groupedStudents.clear();
    for (var student in _filteredStudents) {
      final firstLetter =
          (student['name'] as String).substring(0, 1).toUpperCase();
      if (!_groupedStudents.containsKey(firstLetter)) {
        _groupedStudents[firstLetter] = [];
      }
      _groupedStudents[firstLetter]!.add(student);
    }

    // Sort each group by name
    _groupedStudents.forEach((key, value) {
      value
          .sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
    });
  }

  void _filterStudents() {
    setState(() {
      _filteredStudents = _allStudents.where((student) {
        // Search query filter
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          final name = (student['name'] as String).toLowerCase();
          final enrollment =
              (student['enrollmentNumber'] as String).toLowerCase();
          final state = (student['state'] as String).toLowerCase();

          if (!name.contains(query) &&
              !enrollment.contains(query) &&
              !state.contains(query)) {
            return false;
          }
        }

        // Apply filters
        if (_selectedFilters.containsKey('states') &&
            (_selectedFilters['states']?.isNotEmpty ?? false)) {
          if (!(_selectedFilters['states']?.contains(student['state']) ??
              false)) {
            return false;
          }
        }

        if (_selectedFilters.containsKey('academicYears') &&
            (_selectedFilters['academicYears']?.isNotEmpty ?? false)) {
          if (!(_selectedFilters['academicYears']
                  ?.contains(student['academicYear']) ??
              false)) {
            return false;
          }
        }

        if (_selectedFilters.containsKey('enrollmentStatus') &&
            (_selectedFilters['enrollmentStatus']?.isNotEmpty ?? false)) {
          final statusMap = {
            'enrolled': 'Inscrito',
            'pending': 'Pendiente',
            'inactive': 'Inactivo',
            'graduated': 'Graduado'
          };
          final studentStatusText =
              statusMap[student['status']] ?? 'Desconocido';
          if (!(_selectedFilters['enrollmentStatus']
                  ?.contains(studentStatusText) ??
              false)) {
            return false;
          }
        }

        if (_selectedFilters.containsKey('credentialStatus') &&
            (_selectedFilters['credentialStatus']?.isNotEmpty ?? false)) {
          final credentialMap = {
            'generated': 'Generada',
            'pending': 'Pendiente',
            'expired': 'Vencida',
            'not_generated': 'No generada'
          };
          final studentCredentialText =
              credentialMap[student['credentialStatus']] ?? 'No generada';
          if (!(_selectedFilters['credentialStatus']
                  ?.contains(studentCredentialText) ??
              false)) {
            return false;
          }
        }

        return true;
      }).toList();

      _groupStudentsAlphabetically();
      _updateActiveFilterChips();
    });
  }

  void _updateActiveFilterChips() {
    _activeFilterChips.clear();
    _selectedFilters.forEach((key, values) {
      _activeFilterChips.addAll(values);
    });
  }

  Future<void> _refreshStudents() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate refresh delay
    await Future.delayed(Duration(milliseconds: 1000));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
        _filteredStudents = List.from(_allStudents);
        _groupStudentsAlphabetically();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          SearchFilterBarWidget(
            searchQuery: _searchQuery,
            activeFilters: _activeFilterChips,
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
              _filterStudents();
            },
            onFilterTap: _showFilterBottomSheet,
            onFilterRemoved: (filter) {
              setState(() {
                _selectedFilters.forEach((key, values) {
                  values.remove(filter);
                  if (values.isEmpty) {
                    _selectedFilters.remove(key);
                  }
                });
              });
              _filterStudents();
            },
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildStudentsList(),
                _buildPlaceholderTab('Profesores'),
                _buildPlaceholderTab('Administración'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/student-registration'),
        child: CustomIconWidget(
          iconName: 'person_add',
          color: AppTheme.lightTheme.colorScheme.onTertiary,
          size: 6.w,
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('Registro Militar'),
      actions: [
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/settings'),
          icon: CustomIconWidget(
            iconName: 'settings',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 6.w,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'school',
                  color: _tabController.index == 0
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text('Estudiantes'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'person',
                  color: _tabController.index == 1
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text('Profesores'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'admin_panel_settings',
                  color: _tabController.index == 2
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text('Admin'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsList() {
    if (_isLoading) {
      return LoadingSkeletonWidget();
    }

    if (_filteredStudents.isEmpty) {
      return EmptyStateWidget(
        title: _searchQuery.isNotEmpty || _activeFilterChips.isNotEmpty
            ? 'No se encontraron estudiantes'
            : 'No hay estudiantes registrados',
        subtitle: _searchQuery.isNotEmpty || _activeFilterChips.isNotEmpty
            ? 'Intenta ajustar los filtros de búsqueda o agregar un nuevo estudiante.'
            : 'Comienza agregando el primer estudiante al sistema de registro militar.',
        buttonText: _searchQuery.isNotEmpty || _activeFilterChips.isNotEmpty
            ? 'Limpiar filtros'
            : 'Agregar primer estudiante',
        onButtonPressed:
            _searchQuery.isNotEmpty || _activeFilterChips.isNotEmpty
                ? () {
                    setState(() {
                      _searchQuery = '';
                      _selectedFilters.clear();
                      _activeFilterChips.clear();
                    });
                    _filterStudents();
                  }
                : () => Navigator.pushNamed(context, '/student-registration'),
        isSearchResult:
            _searchQuery.isNotEmpty || _activeFilterChips.isNotEmpty,
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshStudents,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final letters = _groupedStudents.keys.toList()..sort();
                final letter = letters[index];
                final students = _groupedStudents[letter]!;

                return AlphabeticalSectionWidget(
                  letter: letter,
                  students: students,
                  onStudentTap: (student) => _navigateToStudentProfile(student),
                  onViewProfile: (student) =>
                      _navigateToStudentProfile(student),
                  onGenerateCredential: (student) =>
                      _navigateToCredentialGenerator(student),
                  onEditDetails: (student) => _navigateToEditStudent(student),
                  onMarkInactive: (student) => _markStudentInactive(student),
                  onDelete: (student) => _deleteStudent(student),
                );
              },
              childCount: _groupedStudents.keys.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderTab(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'construction',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20.w,
          ),
          SizedBox(height: 4.h),
          Text(
            '$title en desarrollo',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Esta funcionalidad estará disponible próximamente.',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 1, // Student list is active
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'login',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 6.w,
          ),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'list',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 6.w,
          ),
          label: 'Estudiantes',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 6.w,
          ),
          label: 'Perfil',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'badge',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 6.w,
          ),
          label: 'Credenciales',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'settings',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 6.w,
          ),
          label: 'Configuración',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/login-screen');
            break;
          case 1:
            // Already on student list
            break;
          case 2:
            Navigator.pushNamed(context, '/student-profile');
            break;
          case 3:
            Navigator.pushNamed(context, '/credential-generator');
            break;
          case 4:
            Navigator.pushNamed(context, '/settings');
            break;
        }
      },
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) => FilterBottomSheetWidget(
        selectedFilters: _selectedFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _selectedFilters = filters;
          });
          _filterStudents();
        },
      ),
    );
  }

  void _navigateToStudentProfile(Map<String, dynamic> student) {
    Navigator.pushNamed(context, '/student-profile');
  }

  void _navigateToCredentialGenerator(Map<String, dynamic> student) {
    Navigator.pushNamed(context, '/credential-generator');
  }

  void _navigateToEditStudent(Map<String, dynamic> student) {
    Navigator.pushNamed(context, '/student-registration');
  }

  void _markStudentInactive(Map<String, dynamic> student) {
    setState(() {
      final index = _allStudents.indexWhere((s) => s['id'] == student['id']);
      if (index != -1) {
        _allStudents[index]['status'] = 'inactive';
      }
    });
    _filterStudents();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${student['name']} marcado como inactivo'),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () {
            setState(() {
              final index =
                  _allStudents.indexWhere((s) => s['id'] == student['id']);
              if (index != -1) {
                _allStudents[index]['status'] = 'enrolled';
              }
            });
            _filterStudents();
          },
        ),
      ),
    );
  }

  void _deleteStudent(Map<String, dynamic> student) {
    setState(() {
      _allStudents.removeWhere((s) => s['id'] == student['id']);
    });
    _filterStudents();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${student['name']} eliminado del sistema'),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
      ),
    );
  }
}
