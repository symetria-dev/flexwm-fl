class SoFilters {
  late String? filterMethod;
  late String? kind;
  late String? field;
  late String? fieldLabel;
  late String? operator;
  late String? value;
  late String? valueLabel;
  late String? filterType;
  late String? sqlType;

  static String METHOD_SETVALUELABELFILTER = "setValueFilter";
  static String VALUE = 'V';
  static String EQUALS = "=";
  static String MINOR = "<";
  static String MAYOR = ">";
  static String NOTEQUALS = "<>";
  static String MINOREQUAL = "<=";
  static String MAJOREQUAL = ">=";
  static String ISNOTNULL = "IS NOT NULL";
  static String ISNULL = "IS NULL";
  static String STRING = 'S';
  static String NUMBER = "N";

  SoFilters(
      {this.filterMethod,
      this.kind,
      this.field,
      this.fieldLabel,
      this.operator,
      this.value,
      this.valueLabel,
      this.filterType,
      this.sqlType});

  Map<String, dynamic> toJson() {
    return {
      'kind': kind,
      'field': field,
      'value': value,
      'filterMethod': filterMethod
    };
  }
}
