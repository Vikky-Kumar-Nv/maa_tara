import 'package:flutter/material.dart';
import 'package:maa_tara/colors.dart';
import 'package:maa_tara/create_work.dart';
import 'package:maa_tara/customer_list.dart';
import 'package:maa_tara/job_view.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Customer Details Page
// ─────────────────────────────────────────────────────────────────────────────
class CustomerDetailsPage extends StatefulWidget {
  final CustomerModel customer;

  const CustomerDetailsPage({super.key, required this.customer});

  @override
  State<CustomerDetailsPage> createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  late CustomerModel _c;

  @override
  void initState() {
    super.initState();
    _c = widget.customer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Header Bar (Close X + Title) ─────────────────────────────
            _buildTopHeader(),

            // ── Scrollable Details Content ───────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header Card
                    _buildProfileHeaderCard(),
                    const SizedBox(height: 14),

                    // Quick Action Buttons (Call, WhatsApp, Edit, Create Work)
                    _buildQuickActionButtons(),
                    const SizedBox(height: 18),

                    // 1. Personal Information Section
                    _buildSectionHeader(
                      icon: Icons.person_outline_rounded,
                      title: 'Personal Information',
                    ),
                    const SizedBox(height: 10),
                    _buildInfoCard([
                      _InfoRow('Full Name', _c.name),
                      _InfoRow('Phone Number', _c.phone),
                      _InfoRow('Alternate Phone', _c.altPhone ?? '-'),
                      _InfoRow('Email', _c.email ?? '-'),
                      _InfoRow('Address', _c.address),
                      _InfoRow('Customer Since', _c.customerSince),
                      _InfoRow(
                        'Notes',
                        _c.notes ?? 'Regular customer. Prefers morning appointments.',
                      ),
                    ]),
                    const SizedBox(height: 18),

                    // 2. Vehicle Information Section
                    _buildSectionHeader(
                      icon: Icons.directions_car_outlined,
                      title: 'Vehicle Information',
                    ),
                    const SizedBox(height: 10),
                    _buildInfoCard([
                      _InfoRow('Vehicle Number', _c.vehiclePlate),
                      _InfoRow('Brand', _c.vehicleBrand),
                      _InfoRow(
                        'Model',
                        _c.carModel.replaceAll(_c.vehicleBrand, '').trim().isNotEmpty
                            ? _c.carModel.replaceAll(_c.vehicleBrand, '').trim()
                            : _c.carModel,
                      ),
                      _InfoRow('Type', _c.vehicleType),
                      _InfoRow('Color', _c.vehicleColor),
                      _InfoRow('Year', _c.vehicleYear),
                    ]),
                    const SizedBox(height: 18),

                    // 3. Work History Section
                    _buildWorkHistorySection(),
                    const SizedBox(height: 18),

                    // 4. Before / After Photos Section
                    _buildPhotosSection(),
                    const SizedBox(height: 18),

                    // 5. Customer Notes Section
                    _buildSectionHeader(
                      icon: Icons.edit_note_rounded,
                      title: 'Customer Notes',
                    ),
                    const SizedBox(height: 10),
                    _buildNotesCard(),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Top Header Bar ──────────────────────────────────────────────────────────
  Widget _buildTopHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.muted.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close, color: AppColors.white, size: 22),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Customer Details',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Profile Header Card ─────────────────────────────────────────────────────
  Widget _buildProfileHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar Initials Circle
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.inputFill,
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.7),
                width: 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              _c.initials,
              style: const TextStyle(
                color: AppColors.accent,
                fontSize: 19,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name, Phone, Location
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _c.name,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2.5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.green.withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _c.status,
                        style: const TextStyle(
                          color: AppColors.green,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _c.phone,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.phone, color: AppColors.accent, size: 12),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _c.address,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 11.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.location_on_outlined,
                      color: AppColors.accent,
                      size: 13,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Quick Action Buttons (Call, WhatsApp, Edit, Create Work) ────────────────
  Widget _buildQuickActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _quickActionButton(
            icon: Icons.phone_outlined,
            label: 'Call',
            onTap: () => _showActionFeedback('Calling ${_c.phone}...'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _quickActionButton(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'WhatsApp',
            onTap: () => _showActionFeedback('Opening WhatsApp for ${_c.phone}...'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _quickActionButton(
            icon: Icons.edit_outlined,
            label: 'Edit',
            onTap: () => _showActionFeedback('Editing ${_c.name}...'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _quickActionButton(
            icon: Icons.work_outline,
            label: 'Create Work',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateWorkPage(preselectedCustomer: _c),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _quickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        splashColor: AppColors.accent.withValues(alpha: 0.2),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.divider, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.accent, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Section Header ──────────────────────────────────────────────────────────
  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    Widget? trailing,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.accent, size: 18),
            const SizedBox(width: 7),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        ?trailing,
      ],
    );
  }

  // ── Info Card Helper ────────────────────────────────────────────────────────
  Widget _buildInfoCard(List<_InfoRow> rows) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(
        children: rows.map((r) {
          final isLast = rows.indexOf(r) == rows.length - 1;
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 115,
                  child: Text(
                    r.label,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    r.value,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Work History Section ────────────────────────────────────────────────────
  Widget _buildWorkHistorySection() {
    final history = _c.workHistory;

    return Column(
      children: [
        _buildSectionHeader(
          icon: Icons.work_outline_rounded,
          title: 'Work History',
          trailing: InkWell(
            onTap: () => _showActionFeedback('Viewing all work history...'),
            child: Row(
              children: const [
                Text(
                  'View All',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 2),
                Icon(Icons.chevron_right, color: AppColors.accent, size: 16),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider, width: 1),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: history.length,
            separatorBuilder: (_, __) => const Divider(
              color: AppColors.divider,
              height: 1,
              thickness: 1,
            ),
            itemBuilder: (context, index) {
              final item = history[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WorkViewPage(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.workId,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.service,
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                      _buildStatusPill(item.status),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Status Pill ─────────────────────────────────────────────────────────────
  Widget _buildStatusPill(String status) {
    Color bg;
    Color text;

    switch (status) {
      case 'In Progress':
        bg = AppColors.blue.withValues(alpha: 0.15);
        text = AppColors.blue;
        break;
      case 'Completed':
        bg = AppColors.green.withValues(alpha: 0.15);
        text = AppColors.green;
        break;
      case 'On Hold':
        bg = AppColors.amber.withValues(alpha: 0.15);
        text = AppColors.amber;
        break;
      default:
        bg = AppColors.muted.withValues(alpha: 0.15);
        text = AppColors.muted;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: text,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ── Before / After Photos Section ───────────────────────────────────────────
  Widget _buildPhotosSection() {
    final photos = _c.photos;

    return Column(
      children: [
        _buildSectionHeader(
          icon: Icons.photo_library_outlined,
          title: 'Before / After Photos',
          trailing: InkWell(
            onTap: () => _showActionFeedback('Viewing all photos...'),
            child: Row(
              children: const [
                Text(
                  'View All',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 2),
                Icon(Icons.chevron_right, color: AppColors.accent, size: 16),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 64,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: (photos.length > 4 ? 4 : photos.length) + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index < (photos.length > 4 ? 4 : photos.length)) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    photos[index],
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 64,
                      height: 64,
                      color: AppColors.card,
                      child: const Icon(
                        Icons.directions_car,
                        color: AppColors.muted,
                        size: 24,
                      ),
                    ),
                  ),
                );
              }

              // Last +8 badge thumbnail
              return Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.divider, width: 1),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '+8',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Customer Notes Card ─────────────────────────────────────────────────────
  Widget _buildNotesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Text(
        _c.requirement ??
            'Customer mentioned brake noise while applying brakes. Need to check front brakes and report.',
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 12.5,
          height: 1.4,
        ),
      ),
    );
  }

  // ── Feedback Toast Helper ───────────────────────────────────────────────────
  void _showActionFeedback(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.card,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

class _InfoRow {
  final String label;
  final String value;
  _InfoRow(this.label, this.value);
}
