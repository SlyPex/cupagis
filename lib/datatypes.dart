// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<datatype> datatypeFromJson(String str) => List<datatype>.from(json.decode(str).map((x) => datatype.fromJson(x)));

String datatypeToJson(List<datatype> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class datatype {
    datatype({
        this.item,
        this.intitule,
        this.format,
        this.visible,
        this.uiType,
        this.uiReadOnly,
        this.values,
        this.subitems,
    });

    String? item;
    String? intitule;
    Format? format;
    String? visible;
    String? uiType;
    String? uiReadOnly;
    List<dynamic>? values;
    List<Subitem>? subitems;

    factory datatype.fromJson(Map<String, dynamic> json) => datatype(
        item: json["ITEM"],
        intitule: json["INTITULE"],
        format: formatValues.map[json["FORMAT"]],
        visible: json["VISIBLE"],
        uiType: json["UI_TYPE"],
        uiReadOnly: json["UI_READ_ONLY"],
        values: List<dynamic>.from(json["VALUES"].map((x) => x)),
        subitems: List<Subitem>.from(json["SUBITEMS"].map((x) => Subitem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ITEM": item,
        "INTITULE": intitule,
        "FORMAT": formatValues.reverse[format],
        "VISIBLE": visible,
        "UI_TYPE": uiType,
        "UI_READ_ONLY": uiReadOnly,
        "VALUES": List<dynamic>.from(values!.map((x) => x)),
        "SUBITEMS": List<dynamic>.from(subitems!.map((x) => x.toJson())),
    };
}

enum Format { THE_0000, EMPTY }

final formatValues = EnumValues({
    "": Format.EMPTY,
    "0000": Format.THE_0000
});

class Subitem {
    Subitem({
        this.subitem,
        this.intitule,
        this.format,
        this.visible,
        this.uiType,
        this.uiReadOnly,
        this.values,
        this.value,
        this.rubrique,
    });

    String? subitem;
    String? intitule;
    Format? format;
    String? visible;
    UiType? uiType;
    String? uiReadOnly;
    List<dynamic>? values;
    String? value;
    String? rubrique;

    factory Subitem.fromJson(Map<String, dynamic> json) => Subitem(
        subitem: json["SUBITEM"] == null ? null : json["SUBITEM"],
        intitule: json["INTITULE"],
        format: formatValues.map[json["FORMAT"]],
        visible: json["VISIBLE"],
        uiType: uiTypeValues.map[json["UI_TYPE"]],
        uiReadOnly: json["UI_READ_ONLY"],
        values: List<dynamic>.from(json["VALUES"].map((x) => x)),
        value: json["VALUE"],
        rubrique: json["RUBRIQUE"] == null ? null : json["RUBRIQUE"],
    );

    Map<String, dynamic> toJson() => {
        "SUBITEM": subitem == null ? null : subitem,
        "INTITULE": intitule,
        "FORMAT": formatValues.reverse[format],
        "VISIBLE": visible,
        "UI_TYPE": uiTypeValues.reverse[uiType],
        "UI_READ_ONLY": uiReadOnly,
        "VALUES": List<dynamic>.from(values!.map((x) => x)),
        "VALUE": value,
        "RUBRIQUE": rubrique == null ? null : rubrique,
    };
}

enum UiType { REAL, DATE, GPS }

final uiTypeValues = EnumValues({
    "DATE": UiType.DATE,
    "GPS": UiType.GPS,
    "REAL": UiType.REAL
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}
