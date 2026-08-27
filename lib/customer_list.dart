import 'package:flutter/material.dart';
import 'package:maa_tara/add_customer.dart';
import 'package:maa_tara/colors.dart';
import 'package:maa_tara/customer_details.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Customer Model & Work History Model
// ─────────────────────────────────────────────────────────────────────────────
class WorkHistoryItem {
  final String workId;
  final String service;
  final String status; // 'In Progress', 'Completed', 'On Hold', 'Pending'

  const WorkHistoryItem({
    required this.workId,
    required this.service,
    required this.status,
  });
}

class CustomerModel {
  final String id;
  final String name;
  final String phone;
  final String? altPhone;
  final String? email;
  final String address;
  final String vehiclePlate;
  final String vehicleBrand;
  final String carModel;
  final String vehicleType;
  final String vehicleColor;
  final String vehicleYear;
  final String customerSince;
  final String? notes;
  final String? requirement;
  final int totalWorks;
  final String lastVisit;
  final String status; // 'Active', 'Inactive'
  final List<WorkHistoryItem> workHistory;
  final List<String> photos;

  CustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    this.altPhone,
    this.email,
    required this.address,
    required this.vehiclePlate,
    required this.vehicleBrand,
    required this.carModel,
    this.vehicleType = 'Hatchback',
    this.vehicleColor = 'White',
    this.vehicleYear = '2019',
    this.customerSince = '12 Feb 2024',
    this.notes,
    this.requirement,
    required this.totalWorks,
    required this.lastVisit,
    this.status = 'Active',
    this.workHistory = const [],
    this.photos = const [],
  });

  // Helper for 2-letter Initials avatar
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.isEmpty || parts[0].isEmpty) return 'C';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Global In-Memory Customers Repository (Dynamic State)
// ─────────────────────────────────────────────────────────────────────────────
class CustomerRepository {
  static final List<CustomerModel> _customers = [
    CustomerModel(
      id: 'CUST-001',
      name: 'Rahul Sharma',
      phone: '9876543210',
      altPhone: '9876543211',
      email: 'rahulsharma@gmail.com',
      address: 'Dwarka, New Delhi - 110078',
      vehiclePlate: 'DL 8C AX 1234',
      vehicleBrand: 'Hyundai',
      carModel: 'Hyundai i20',
      vehicleType: 'Hatchback',
      vehicleColor: 'White',
      vehicleYear: '2019',
      customerSince: '12 Feb 2024',
      notes: 'Regular customer. Prefers morning appointments.',
      requirement:
          'Customer mentioned brake noise while applying brakes. Need to check front brakes and report.',
      totalWorks: 12,
      lastVisit: '23 May 2025',
      status: 'Active',
      workHistory: const [
        WorkHistoryItem(
          workId: 'WORK-1058',
          service: 'Brake Pad Replacement',
          status: 'In Progress',
        ),
        WorkHistoryItem(
          workId: 'WORK-1032',
          service: 'Full Service & Oil Change',
          status: 'Completed',
        ),
        WorkHistoryItem(
          workId: 'WORK-0987',
          service: 'AC Service',
          status: 'Completed',
        ),
        WorkHistoryItem(
          workId: 'WORK-0921',
          service: 'Engine Noise Issue',
          status: 'On Hold',
        ),
      ],
      photos: const [
        'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?w=300&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=300&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=300&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1486006920555-c77dce18193b?w=300&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1617814076367-b759c7d7e738?w=300&auto=format&fit=crop&q=80',
      ],
    ),
    CustomerModel(
      id: 'CUST-002',
      name: 'Amit Verma',
      phone: '9876501122',
      altPhone: '9876501133',
      email: 'amit.verma@yahoo.com',
      address: 'Sector 62, Noida - 201301',
      vehiclePlate: 'UP 16 AB 5678',
      vehicleBrand: 'Maruti Suzuki',
      carModel: 'Maruti Brezza',
      vehicleType: 'SUV / Compact SUV',
      vehicleColor: 'Silver',
      vehicleYear: '2021',
      customerSince: '18 Mar 2024',
      notes: 'Requested engine oil check on priority.',
      requirement: 'Oil change and wheel balancing needed.',
      totalWorks: 8,
      lastVisit: '20 May 2025',
      status: 'Active',
      workHistory: const [
        WorkHistoryItem(
          workId: 'WORK-1057',
          service: 'Full Service & Oil Change',
          status: 'Pending',
        ),
        WorkHistoryItem(
          workId: 'WORK-1014',
          service: 'Wheel Alignment',
          status: 'Completed',
        ),
      ],
      photos: const [
        'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=300&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=300&auto=format&fit=crop&q=80',
      ],
    ),
    CustomerModel(
      id: 'CUST-003',
      name: 'Neha Gupta',
      phone: '9876512345',
      altPhone: '9876512399',
      email: 'neha.gupta@outlook.com',
      address: 'Navrangpura, Ahmedabad - 380009',
      vehiclePlate: 'GJ 05 CD 6789',
      vehicleBrand: 'Honda',
      carModel: 'Honda City',
      vehicleType: 'Sedan',
      vehicleColor: 'Red',
      vehicleYear: '2020',
      customerSince: '05 Jan 2024',
      notes: 'AC cooling issue resolved last month.',
      requirement: 'AC filter cleaning and general checkup.',
      totalWorks: 6,
      lastVisit: '19 May 2025',
      status: 'Active',
      workHistory: const [
        WorkHistoryItem(
          workId: 'WORK-1056',
          service: 'AC Service & Gas Refilling',
          status: 'In Progress',
        ),
      ],
      photos: const [
        'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=300&auto=format&fit=crop&q=80',
      ],
    ),
    CustomerModel(
      id: 'CUST-004',
      name: 'Vikas Patel',
      phone: '9876523456',
      altPhone: '9876523400',
      email: 'vikas.patel@gmail.com',
      address: 'Mansarovar, Jaipur - 302020',
      vehiclePlate: 'RJ 14 XY 9876',
      vehicleBrand: 'Maruti Suzuki',
      carModel: 'Swift Dzire',
      vehicleType: 'Sedan',
      vehicleColor: 'Grey',
      vehicleYear: '2018',
      customerSince: '14 Nov 2023',
      notes: 'Suspension noisy on speed breakers.',
      requirement: 'Suspension repair & bushing replacement.',
      totalWorks: 10,
      lastVisit: '22 May 2025',
      status: 'Active',
      workHistory: const [
        WorkHistoryItem(
          workId: 'WORK-1055',
          service: 'Suspension Repair',
          status: 'On Hold',
        ),
      ],
      photos: const [
        'https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=300&auto=format&fit=crop&q=80',
      ],
    ),
    CustomerModel(
      id: 'CUST-005',
      name: 'Pooja Singh',
      phone: '9876534567',
      altPhone: '9876534511',
      email: 'pooja.singh@gmail.com',
      address: 'Cyber City, Gurugram - 122002',
      vehiclePlate: 'HR 26 EZ 1122',
      vehicleBrand: 'Maruti Suzuki',
      carModel: 'Maruti Ertiga',
      vehicleType: 'MUV / MPV',
      vehicleColor: 'Silver',
      vehicleYear: '2022',
      customerSince: '20 Dec 2023',
      notes: 'Fleet vehicle. Routine service maintenance.',
      requirement: 'Brake pads replacement and exterior foam wash.',
      totalWorks: 4,
      lastVisit: '21 May 2025',
      status: 'Active',
      workHistory: const [
        WorkHistoryItem(
          workId: 'WORK-1054',
          service: 'Brake Pad Replacement & Wash',
          status: 'Completed',
        ),
      ],
      photos: const [
        'https://images.unsplash.com/photo-1617814076367-b759c7d7e738?w=300&auto=format&fit=crop&q=80',
      ],
    ),
  ];

  static List<CustomerModel> get customers => _customers;

  static void addCustomer(CustomerModel customer) {
    _customers.insert(0, customer);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Customer List Page (List of all Customers)
// ─────────────────────────────────────────────────────────────────────────────
class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

// Backward compatibility alias
typedef CustomerPage = CustomerListPage;

class _CustomerListPageState extends State<CustomerListPage> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<CustomerModel> get _filteredCustomers {
    final list = CustomerRepository.customers;
    if (_searchQuery.isEmpty) return list;

    final query = _searchQuery.toLowerCase();
    return list.where((c) {
      return c.name.toLowerCase().contains(query) ||
          c.phone.toLowerCase().contains(query) ||
          c.vehiclePlate.toLowerCase().contains(query) ||
          c.carModel.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customers = _filteredCustomers;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header Row: Title & + Add Customer Button ──────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Customers',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Manage all your customers',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  // + Add Customer Button
                  ElevatedButton.icon(
                    onPressed: () => _openAddCustomerPage(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.card,
                      side: const BorderSide(color: AppColors.accent, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.add, color: AppColors.accent, size: 16),
                    label: const Text(
                      'Add Customer',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // ── Search Bar with Filter Icon ────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.divider, width: 1),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: AppColors.white, fontSize: 13),
                        cursorColor: AppColors.accent,
                        decoration: InputDecoration(
                          hintText: 'Search by name, phone or vehicle...',
                          hintStyle: TextStyle(
                            color: AppColors.muted.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.accent,
                            size: 18,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: AppColors.muted,
                                    size: 16,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _searchQuery = '';
                                      _searchController.clear();
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 11),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Filter Icon Button
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.divider, width: 1),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.filter_alt_outlined,
                        color: AppColors.muted,
                        size: 20,
                      ),
                      onPressed: () => _showFilterOptions(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Customer Cards List ─────────────────────────────────────────
              if (customers.isEmpty)
                _buildEmptyState()
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: customers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _buildCustomerCard(customers[index]);
                  },
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ── Customer Card Widget ────────────────────────────────────────────────────
  Widget _buildCustomerCard(CustomerModel c) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top Row: Initials Avatar, Name/Phone/Vehicle, More Vert ───────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Initials Avatar Circle
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.inputFill,
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  c.initials,
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Middle: Name, Phone with icon, Car Model • Number
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.name,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          c.phone,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 11.5,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.phone, color: AppColors.accent, size: 11),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${c.carModel} • ${c.vehiclePlate}',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // More Options Button
              PopupMenuButton<String>(
                color: AppColors.card,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                icon: const Icon(Icons.more_vert, color: AppColors.muted, size: 18),
                onSelected: (val) {
                  if (val == 'view') _openCustomerDetails(c);
                  if (val == 'call') _makeCall(c.phone);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'view', child: Text('View Details')),
                  const PopupMenuItem(value: 'call', child: Text('Call Customer')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Stats Row: Total Works, Last Visit, Active Status Pill ────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Works',
                    style: TextStyle(color: AppColors.muted, fontSize: 10),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${c.totalWorks}',
                    style: const TextStyle(
                      color: AppColors.blue,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Last Visit',
                    style: TextStyle(color: AppColors.muted, fontSize: 10),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    c.lastVisit,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.green.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Text(
                  c.status,
                  style: const TextStyle(
                    color: AppColors.green,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(color: AppColors.divider, height: 1, thickness: 1),
          const SizedBox(height: 8),

          // ── Bottom Action Buttons: View, Edit, Create Work ───────────────
          Row(
            children: [
              Expanded(
                child: _cardActionButton(
                  icon: Icons.visibility_outlined,
                  label: 'View',
                  onTap: () => _openCustomerDetails(c),
                ),
              ),
              Container(width: 1, height: 16, color: AppColors.divider),
              Expanded(
                child: _cardActionButton(
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  onTap: () => _editCustomer(c),
                ),
              ),
              Container(width: 1, height: 16, color: AppColors.divider),
              Expanded(
                child: _cardActionButton(
                  icon: Icons.work_outline,
                  label: 'Create Work',
                  onTap: () => _createWorkForCustomer(c),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Action Button inside Card Helper ────────────────────────────────────────
  Widget _cardActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: AppColors.accent),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Empty State ─────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Icon(Icons.person_search_outlined,
              size: 48, color: AppColors.muted.withValues(alpha: 0.6)),
          const SizedBox(height: 12),
          const Text(
            'No Customers Found',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Try changing the search query or add a new customer',
            style: TextStyle(color: AppColors.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ── Action Handlers ─────────────────────────────────────────────────────────
  Future<void> _openAddCustomerPage() async {
    final result = await Navigator.push<CustomerModel>(
      context,
      MaterialPageRoute(builder: (context) => const AddCustomerPage()),
    );

    if (result != null) {
      setState(() {
        CustomerRepository.addCustomer(result);
      });
    } else {
      setState(() {});
    }
  }

  void _openCustomerDetails(CustomerModel c) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerDetailsPage(customer: c),
      ),
    );
  }

  void _editCustomer(CustomerModel c) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editing details for ${c.name}...'),
        backgroundColor: AppColors.card,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _createWorkForCustomer(CustomerModel c) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Creating work order for ${c.name} (${c.vehiclePlate})...'),
        backgroundColor: AppColors.card,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _makeCall(String phone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling $phone...'),
        backgroundColor: AppColors.card,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Customers',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.sort_by_alpha, color: AppColors.accent),
                title: const Text('Sort A to Z', style: TextStyle(color: AppColors.white)),
                onTap: () {
                  setState(() {
                    CustomerRepository.customers
                        .sort((a, b) => a.name.compareTo(b.name));
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.history, color: AppColors.accent),
                title: const Text('Most Recent Visit', style: TextStyle(color: AppColors.white)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
