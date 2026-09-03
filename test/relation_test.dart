import 'package:flutter_test/flutter_test.dart';
import 'package:maa_tara/features/categories/category_model.dart';
import 'package:maa_tara/features/inventory/inventory_models.dart';
import 'package:maa_tara/features/suppliers/supplier_model.dart';

void main() {
  group('Category ↔ Product ↔ Supplier Dynamic Relationship Tests', () {
    test('Adding product dynamically updates Category product count', () {
      final initialCat = CategoryRepository.categories.firstWhere(
        (c) => c.name == 'Engine Parts',
      );
      final initialCount = initialCat.productsCount;

      CategoryRepository.incrementProductCount('Engine Parts');

      final updatedCat = CategoryRepository.categories.firstWhere(
        (c) => c.name == 'Engine Parts',
      );
      expect(updatedCat.productsCount, equals(initialCount + 1));

      // Test decrement on deletion
      CategoryRepository.decrementProductCount('Engine Parts');
      final decrementedCat = CategoryRepository.categories.firstWhere(
        (c) => c.name == 'Engine Parts',
      );
      expect(decrementedCat.productsCount, equals(initialCount));
    });

    test('Adding product with non-existent category dynamically creates category', () {
      const customCategory = 'Turbochargers';
      expect(
        CategoryRepository.categories.any((c) => c.name == customCategory),
        isFalse,
      );

      CategoryRepository.incrementProductCount(customCategory);

      expect(
        CategoryRepository.categories.any((c) => c.name == customCategory),
        isTrue,
      );
      final newCat = CategoryRepository.categories.firstWhere(
        (c) => c.name == customCategory,
      );
      expect(newCat.productsCount, equals(1));
    });

    test('Adding product links product and category to Supplier dynamically', () {
      const supplierName = 'Bosch Automotive';
      const newProduct = 'Bosch Dynamic Spark Plug X1';
      const productCategory = 'Engine Parts';

      SupplierRepository.linkProductToSupplier(
        supplierName,
        newProduct,
        productCategory,
      );

      final supplier = SupplierRepository.suppliers.firstWhere(
        (s) => s.companyName == supplierName,
      );
      expect(supplier.suppliedProducts.contains(newProduct), isTrue);

      // Unlink on deletion
      SupplierRepository.unlinkProductFromSupplier(supplierName, newProduct);
      final updatedSupplier = SupplierRepository.suppliers.firstWhere(
        (s) => s.companyName == supplierName,
      );
      expect(updatedSupplier.suppliedProducts.contains(newProduct), isFalse);
    });

    test('Adding product with brand new supplier dynamically registers the supplier', () {
      const newSupplierName = 'Brembo Official India';
      const productName = 'Brembo Ceramic Rotors';
      const categoryName = 'Brake System';

      expect(
        SupplierRepository.suppliers.any((s) => s.companyName == newSupplierName),
        isFalse,
      );

      SupplierRepository.linkProductToSupplier(
        newSupplierName,
        productName,
        categoryName,
      );

      final registeredSupplier = SupplierRepository.suppliers.firstWhere(
        (s) => s.companyName == newSupplierName,
      );
      expect(registeredSupplier.companyName, equals(newSupplierName));
      expect(registeredSupplier.suppliedProducts.contains(productName), isTrue);
      expect(registeredSupplier.categories.contains(categoryName), isTrue);
    });

    test('Adding item to InventoryRepository stores product correctly', () {
      final newItem = InventoryItemModel(
        id: 'TEST-PRD-001',
        branchId: 'BR-TEST',
        name: 'Test Turbo Part',
        category: 'Engine Parts',
        brand: 'Bosch',
        partNumber: 'TP-001',
        quantity: 5,
        minQuantity: 2,
        purchasePrice: 1000,
        sellingPrice: 1500,
        supplier: 'Bosch Automotive',
        lastUpdated: 'Just now',
      );

      InventoryRepository.addItem(newItem);
      expect(InventoryRepository.items.any((i) => i.id == 'TEST-PRD-001'), isTrue);

      InventoryRepository.deleteItem('TEST-PRD-001');
      expect(InventoryRepository.items.any((i) => i.id == 'TEST-PRD-001'), isFalse);
    });
  });
}
