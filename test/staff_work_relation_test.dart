import 'package:flutter_test/flutter_test.dart';
import 'package:maa_tara/features/staff/staff_list.dart';
import 'package:maa_tara/features/work/job.dart';

void main() {
  group('Staff & Work Dynamic Relationship Tests', () {
    setUp(() {
      // Ensure test staff exists in StaffRepository
      if (StaffRepository.getStaffByName('Test Staff Member') == null) {
        StaffRepository.addStaff(
          StaffModel(
            id: 'STF-TEST-99',
            name: 'Test Staff Member',
            role: 'Senior Mechanic',
            phone: '9998887770',
            email: 'test.mechanic@maara.com',
            avatarUrl: 'https://example.com/avatar.jpg',
            status: 'Active',
            activityStatus: 'Offline',
            todayWorks: 0,
            completedWorks: 0,
            pendingWorks: 0,
          ),
        );
      }
    });

    test('1. Adding work card dynamically assigns it to Staff and updates metrics', () {
      final staffBefore = StaffRepository.getStaffByName('Test Staff Member')!;
      final initialToday = staffBefore.todayWorks;
      final initialPending = staffBefore.pendingWorks;

      final testWork = WorkModel(
        workId: 'WORK-DYNAMIC-01',
        customerName: 'Test Customer',
        phone: '9876500000',
        vehiclePlate: 'DL 01 ZZ 9999',
        carModel: 'Maruti Swift',
        service: 'Brake Disc Replacement',
        assignedStaff: 'Test Staff Member',
        date: '03 Sep 2026',
        time: '02:00 PM',
        status: WorkStatus.inProgress,
        carImageUrl: '',
        staffAvatarUrl: '',
      );

      WorkRepository.addWork(testWork);

      final staffAfter = StaffRepository.getStaffByName('Test Staff Member')!;
      expect(staffAfter.todayWorks, equals(initialToday + 1));
      expect(staffAfter.pendingWorks, equals(initialPending + 1));
      expect(staffAfter.currentWorkId, equals('WORK-DYNAMIC-01'));
      expect(staffAfter.currentWork, equals('Brake Disc Replacement'));
      expect(staffAfter.currentCustomer, equals('Test Customer'));
      expect(staffAfter.currentVehicle, equals('DL 01 ZZ 9999'));
      expect(staffAfter.activityStatus, equals('Working'));
    });

    test('2. Completing work updates completedWorks and decrements pendingWorks', () {
      final staffBefore = StaffRepository.getStaffByName('Test Staff Member')!;
      final initialCompleted = staffBefore.completedWorks;
      final initialPending = staffBefore.pendingWorks;

      WorkRepository.updateWorkStatus('WORK-DYNAMIC-01', WorkStatus.completed);

      final staffAfter = StaffRepository.getStaffByName('Test Staff Member')!;
      expect(staffAfter.completedWorks, equals(initialCompleted + 1));
      expect(staffAfter.pendingWorks, equals(initialPending - 1));
      expect(staffAfter.currentWork, equals('Completed'));
    });

    test('3. Reassigning work shifts assignment from old staff to new staff', () {
      final targetStaff = StaffRepository.staffList.firstWhere(
        (s) => s.name != 'Test Staff Member',
      );
      final targetBefore = targetStaff.todayWorks;
      final testStaffBefore = StaffRepository.getStaffByName('Test Staff Member')!.todayWorks;

      WorkRepository.reassignStaff(
        'WORK-DYNAMIC-01',
        targetStaff.name,
        targetStaff.avatarUrl,
      );

      final updatedWork = WorkRepository.works.firstWhere((w) => w.workId == 'WORK-DYNAMIC-01');
      expect(updatedWork.assignedStaff, equals(targetStaff.name));

      final targetAfter = StaffRepository.getStaffByName(targetStaff.name)!;
      final testStaffAfter = StaffRepository.getStaffByName('Test Staff Member')!;

      expect(targetAfter.todayWorks, equals(targetBefore + 1));
      expect(testStaffAfter.todayWorks, equals(testStaffBefore - 1));
    });

    test('4. WorkRepository.updateWork updates all fields dynamically', () {
      final existingWork = WorkRepository.works.firstWhere((w) => w.workId == 'WORK-DYNAMIC-01');
      final updated = existingWork.copyWith(
        customerName: 'Updated Customer Name',
        carModel: 'Hyundai Creta 2026',
        service: 'Full AC Repair & Compressor',
      );

      WorkRepository.updateWork(updated);

      final fetched = WorkRepository.works.firstWhere((w) => w.workId == 'WORK-DYNAMIC-01');
      expect(fetched.customerName, equals('Updated Customer Name'));
      expect(fetched.carModel, equals('Hyundai Creta 2026'));
      expect(fetched.service, equals('Full AC Repair & Compressor'));
    });
  });
}
