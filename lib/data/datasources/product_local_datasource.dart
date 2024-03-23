import 'package:flutter_posresto_app/data/models/response/product_response_model.dart';
import 'package:flutter_posresto_app/presentation/home/models/order_model.dart';
import 'package:flutter_posresto_app/presentation/home/models/product_quantity.dart';
import 'package:sqflite/sqflite.dart';

class ProductLocalDataSource {
  ProductLocalDataSource.__init();

  static final ProductLocalDataSource instance =
      ProductLocalDataSource.__init();

  final String tableProduct = 'products';
  final String tableOrder = 'orders';
  final String tableOrderItem = 'order_items';

  static Database? _database;

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableProduct (
        id INTEGER PRIMARY KEY,
        productId INTEGER,
        categoryId INTEGER,
        categoryName TEXT,
        name TEXT,
        description TEXT,
        image TEXT,
        price TEXT,
        stock INTEGER,
        status INTEGER,
        isFavorite INTEGER,
        createdAt TEXT,
        updatedAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableOrder (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        payment_amount INTEGER,
        sub_total INTEGER,
        tax INTEGER,
        discount INTEGER,
        service_charge INTEGER,
        total INTEGER,
        payment_method TEXT,
        total_item INTEGER,
        id_kasir INTEGER,
        nama_kasir TEXT,
        transaction_time TEXT,
        is_sync INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableOrderItem (
        id INTEGER PRIMARY KEY,
        id_order INTEGER,
        id_product INTEGER,
        quantity INTEGER,
        price INTEGER
      )
    ''');
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + filePath;
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('dbresto02.db');
    return _database!;
  }

  // save order
  Future<void> saveOrder(OrderModel order) async {
    final db = await instance.database;
    int id = await db.insert(tableOrder, order.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    for (var item in order.orderItems) {
      await db.insert(tableOrderItem, item.toLocalMap(id),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  //get data order
  Future<List<OrderModel>> getOrdersByIsNotSync() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query(tableOrder, where: 'is_sync = ?', whereArgs: [0]);
    return List.generate(maps.length, (i) {
      return OrderModel.fromMap(maps[i]);
    });
  }

  // get order item by order id
  Future<List<ProductQuantity>> getOrderItemsByOrderId(int orderId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query(tableOrderItem, where: 'id_order = ?', whereArgs: [orderId]);
    return List.generate(maps.length, (i) {
      return ProductQuantity.fromLocalMap(maps[i]);
    });
  }

  // update order is_sync
  Future<void> updateOrderIsSync(int orderId) async {
    final db = await instance.database;
    await db.update(tableOrder, {'is_sync': 1}, where: 'id = ?', whereArgs: [orderId]);
  }

  // insert data product
  Future<int> insertProduct(Product product) async {
    final db = await instance.database;
    return await db.insert(tableProduct, product.toLocalMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // insert list of data product
  Future<void> insertProducts(List<Product> products) async {
    final db = await instance.database;
    final batch = db.batch();
    for (final product in products) {
      batch.insert(tableProduct, product.toLocalMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  // get all data product
  Future<List<Product>> getProducts() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableProduct);
    return List.generate(maps.length, (i) {
      return Product.fromLocalMap(maps[i]);
    });
  }

  //delete all products
  Future<void> deleteAllProducts() async {
    final db = await instance.database;
    await db.delete(tableProduct);
  }
}
