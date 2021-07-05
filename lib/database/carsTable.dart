class CarsTable {
  // name of the table
  static const String tableName = 'cars';

  // columns of the table
  static const String idColumn = 'id';
  static const String manufacturerColumn = 'manufacturer';
  static const String modelColumn = 'model';
  static const String constructionYearColumn = 'constructionYear';
  static const String fuelTypeColumn = 'fuelType';
  static const String engineDisplacementColumn = 'engineDisplacement';

  // query to create the table
  static const String carsTableQuery = '''
      CREATE TABLE ${CarsTable.tableName} (
        ${CarsTable.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${CarsTable.manufacturerColumn} TEXT NOT NULL,
        ${CarsTable.modelColumn} TEXT NOT NULL,
        ${CarsTable.constructionYearColumn} INTEGER NOT NULL,
        ${CarsTable.fuelTypeColumn} TEXT NOT NULL,
        ${CarsTable.engineDisplacementColumn} INTEGER NOT NULL
      )
      ''';
}
