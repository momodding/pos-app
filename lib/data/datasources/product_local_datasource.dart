import 'package:flutter_posresto_app/data/models/response/product_response_model.dart';
import 'package:sqflite/sqflite.dart';

class ProductLocalDataSource {
  ProductLocalDataSource.__init();

  static final ProductLocalDataSource instance =
      ProductLocalDataSource.__init();

  final String tableName = 'products';

  static Database? _database;

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
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
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + filePath;
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('dbresto01.db');
    return _database!;
  }

  // insert data product
  Future<int> insertProduct(Product product) async {
    final db = await instance.database;
    return await db.insert(tableName, product.toLocalMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // insert list of data product
  Future<void> insertProducts(List<Product> products) async {
    final db = await instance.database;
    final batch = db.batch();
    for (final product in products) {
      batch.insert(tableName, product.toLocalMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  // get all data product
  Future<List<Product>> getProducts() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Product.fromLocalMap(maps[i]);
    });
  }

  //delete all products
  Future<void> deleteAllProducts() async {
    final db = await instance.database;
    await db.delete(tableName);
  }
}
