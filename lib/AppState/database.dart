import 'dart:convert';
import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:paradise_gases/services/dcServices.dart';
import 'package:paradise_gases/services/itemServices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
// import '../models/challanModel.dart';
import '../models/ChallanModel.dart';
import '../models/item_model.dart';
import '../models/requestModel.dart';
import '../services/challanServices.dart';

class DataBase with ChangeNotifier {
  List<Map<String, dynamic>> sales = [];

  void addSale(Map<String, dynamic> sale) {
    sales.add(sale);
    notifyListeners();
  }

  final _dcservice = Dcsservices();
  final _cservice = ChallanService();

  bool isLoading = false;
  List<DcsModel> _dcs = [];
  List<DcsModel> get requests => _dcs;

  List<ChallanModel> _challanItems = [];

  List<ChallanModel> get challanItems => _challanItems;

  Future<void> fetchChallanDetails(String challanId) async {
    print(
        'fetching challan details func : fetchChallanDetails(string challanId)');
    isLoading = true;
    _challanItems = []; // Reset at the start
    notifyListeners();

    try {
      final response = await _cservice.getChallanDetails(challanId);
      _challanItems = response.isNotEmpty ? response : [];
    } catch (e) {
      debugPrint("Error fetching challan details: ${e.runtimeType}: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fillCylinders(challanId, item_name, filled_qty) async {
    print('challan id = ' + challanId);
    print('item _name = ' + item_name);
    print('filled qty = ' + filled_qty);

    var url =
        "https://bingo-agency.com/paradisegases.com/admin/api/fillCylinders?challan_id=" +
            challanId +
            "&item_name=" +
            item_name +
            "&filled_qty=" +
            filled_qty;

    try {
      final response = await http.get(
        Uri.parse(url),
      );
      print(url);
      print(response.body.toString());
    } catch (e) {
      debugPrint("Error fetching empties: ${e.runtimeType}: $e");
    }
  }

  List<Map<String, dynamic>> _customers = [];

  List<Map<String, dynamic>> get customers => _customers;

  Future<void> fetchCustomers() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(
            "https://bingo-agency.com/paradisegases.com/admin/api/getCustomerData.php"),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Ensure the expected key exists
        if (responseData.containsKey("customers") &&
            responseData["customers"] is List) {
          _customers =
              List<Map<String, dynamic>>.from(responseData["customers"]);
        } else {
          debugPrint("Unexpected JSON structure: $responseData");
          _customers = [];
        }
      } else {
        debugPrint("Failed to load customers: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching customers: ${e.runtimeType}: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> _empties = [];

  List<Map<String, dynamic>> get empties => _empties;

  Future<void> fetchEmpties(challanId) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(
            "https://bingo-agency.com/paradisegases.com/admin/api/getEmpties?challan_id=" +
                challanId),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey("empties") &&
            responseData["empties"] is List) {
          _empties = List<Map<String, dynamic>>.from(responseData["empties"]);
          debugPrint("Updated empties: $_empties"); // ✅ Debugging line
        } else {
          debugPrint("Unexpected JSON structure: $responseData");
          _empties = [];
        }
      } else {
        debugPrint("Failed to load empties: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching empties: ${e.runtimeType}: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> _cylinderUpdateStatus = [];

  List<Map<String, dynamic>> get cylinderUpdateStatus => _cylinderUpdateStatus;
  bool isLoadingCylinderUpdate = false;
  Future<void> updateCylinderStatus(String cylinderId, String selectedStatus,
      String fillerId, String challanId, BuildContext context) async {
    isLoadingCylinderUpdate = true;
    notifyListeners();

    var url =
        "https://bingo-agency.com/paradisegases.com/admin/api/updateCylinderStatus?cylinder_id=" +
            cylinderId +
            '&status=' +
            selectedStatus +
            '&filler_id=' +
            fillerId;

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey("cylinder_status")) {
          int index = _empties.indexWhere((c) => c['id'] == cylinderId);
          if (index != -1) {
            _empties[index]['status'] = selectedStatus;
            debugPrint(
                "Updated cylinder status: ${_empties[index]}"); // ✅ Debugging
            notifyListeners();
            showSuccessSnackbar(context, 'Cylinder status updated.');
          }
        } else {
          debugPrint("Unexpected JSON structure: $responseData");
        }
      } else {
        debugPrint("Failed to Update Status: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error Updating Status: ${e.runtimeType}: $e");
    } finally {
      isLoadingCylinderUpdate = false;
      getAllEmpties();
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> saveSale({
    required int userId,
    required int customerId,
    required double total,
    required List<Map<String, dynamic>> items,
    String? remarks,
  }) async {
    print('here we go');
    final url = Uri.parse(
        "https://bingo-agency.com/paradisegases.com/admin/api/save_sale.php");

    // ✅ Debugging: Print values
    print('User ID: $userId');
    print('Customer ID: $customerId');
    print('Total: $total');
    print('Items: ${jsonEncode(items)}');
    print('Remarks: ${remarks ?? ""}');
    print('API URL: $url');

    final Map<String, dynamic> requestData = {
      "user_id": userId,
      "customer_id": customerId,
      "total": total,
      "items": items,
      "remarks": remarks ?? "",
    };

    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(requestData),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        print("HTTP Error: ${response.statusCode} - ${response.body}");
        return null;
      }

      late Map<String, dynamic> responseData;
      try {
        responseData = jsonDecode(response.body);
        print(responseData);
      } catch (e) {
        print("Invalid JSON response: ${response.body}");
        return null;
      }

      // ✅ Process API response
      if (responseData['success'] == true) {
        print("Sale saved successfully! Sale ID: ${responseData['sale_id']}");
        notifyListeners();
        return responseData;
      } else {
        print("Failed to save sale: ${responseData['error']}");
        return null;
      }
    } catch (e) {
      print("Error saving sale: $e");
      return null;
    }
  }

  List<Map<String, dynamic>> _allEmpties = [];
  List<Map<String, dynamic>> get allEmpties => _allEmpties;

  bool isLoadingallEmpties = false;

  Future<void> getAllEmpties() async {
    isLoadingallEmpties = true;
    notifyListeners();
    String api_link =
        "https://bingo-agency.com/paradisegases.com/admin/api/getAllEmpties.php";
    try {
      final response = await http.get(
        Uri.parse(api_link),
      );

      print(api_link);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);

        if (data["all_empties"] is List) {
          _allEmpties = List<Map<String, dynamic>>.from(data["all_empties"]);
          print("Fetched ${_allEmpties.length} empties"); // Debugging
          notifyListeners();
        } else {
          _allEmpties = [];
          print("No empties found in API response");
        }
      } else {
        print("Error: Server returned status ${response.statusCode}");
        _allEmpties = [];
      }
    } catch (e) {
      print("Error fetching Empties: $e");
      _allEmpties = [];
    }

    isLoadingallEmpties = false;
    notifyListeners(); // Notify UI that loading finished
  }

  List<Map<String, dynamic>> _challanOut = [];
  List<Map<String, dynamic>> get challanOut => _challanOut;

  bool isLoadingchallanOut = false;

  Future<void> challan_Out(String challan_id) async {
    isLoadingchallanOut = true;
    notifyListeners();
    String api_link =
        "https://bingo-agency.com/paradisegases.com/admin/api/challan_out.php?challan_id=" +
            challan_id;
    try {
      final response = await http.get(
        Uri.parse(api_link),
      );

      print(api_link);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);

        if (data["challanOut"] is List) {
          _challanOut = List<Map<String, dynamic>>.from(data["challanOut"]);
          print("Fetched ${_challanOut.length} challanOut"); // Debugging
          notifyListeners();
        } else {
          _challanOut = [];
          print("No challanOut found in API response");
        }
      } else {
        print("Error: Server returned status ${response.statusCode}");
        _challanOut = [];
      }
    } catch (e) {
      print("Error fetching Empties: $e");
      _challanOut = [];
    }

    isLoadingchallanOut = false;
    notifyListeners(); // Notify UI that loading finished
  }

  List<Map<String, dynamic>> _addedParts = [];
  List<Map<String, dynamic>> get addedParts => _addedParts;

  bool isLoadingAddedParts = false;

  Future<void> getAddedPartsToSale(String challanId) async {
    isLoadingAddedParts = true;
    notifyListeners();
    print('laodingAddedParts');

    try {
      final response = await http.get(
        Uri.parse(
            "https://bingo-agency.com/paradisegases.com/admin/api/getAddedPartsToSale?challan_id=$challanId"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["success"] == true) {
          _addedParts = List<Map<String, dynamic>>.from(data["parts"]);
          print('PRINTING ADDED PARTS FOR SALE !!!');
          print(_addedParts);
        } else {
          _addedParts = [];
        }
      } else {
        _addedParts = [];
      }
    } catch (e) {
      print("Error fetching parts: $e");
      _addedParts = [];
    }

    isLoadingAddedParts = false;
    notifyListeners();
  }

  // List<Map<String, dynamic>> checkOutParts = [];
  // List<Map<String, dynamic>> _checkOutDetails = [];
  // List<Map<String, dynamic>> get checkOutDetails => _checkOutDetails;

  // bool isLoadingcheckOutDetails = false;

  // Future<void> getcheckOutDetails(String challanId) async {
  //   isLoadingcheckOutDetails = true;
  //   notifyListeners();
  //   print('LOADING CHECKOUT DETAILS');

  //   try {
  //     final response = await http.get(
  //       Uri.parse(
  //           "https://bingo-agency.com/paradisegases.com/admin/api/getcheckOutDetails?challan_id=$challanId"),
  //     );

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> data = json.decode(response.body);

  //       if (data["success"] == true && data["checkOutDetails"] is List) {
  //         _checkOutDetails =
  //             List<Map<String, dynamic>>.from(data["checkOutDetails"]);
  //         print('PRINTING CHECKOUT DETAILS !!!');
  //         print(_checkOutDetails);
  //       } else {
  //         print("API Response does not contain expected data.");
  //         _checkOutDetails = [];
  //       }
  //     } else {
  //       print("HTTP Error: ${response.statusCode}");
  //       _checkOutDetails = [];
  //     }
  //   } catch (e) {
  //     print("Error fetching parts: $e");
  //     _checkOutDetails = [];
  //   }

  //   isLoadingcheckOutDetails = false;
  //   notifyListeners();
  // }

  List<Map<String, dynamic>> _checkOutDetails = [];
  List<Map<String, dynamic>> get checkOutDetails => _checkOutDetails;

  bool isLoadingcheckOutDetails = false;

  Future<void> getcheckOutDetails(String challanId) async {
    isLoadingcheckOutDetails = true;
    notifyListeners();
    print('LOADING CHECKOUT DETAILS');

    try {
      final response = await http.get(
        Uri.parse(
            "https://bingo-agency.com/paradisegases.com/admin/api/getcheckOutDetails?challan_id=$challanId"),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data["success"] == true && data["checkOutDetails"] is List) {
          _checkOutDetails = List<Map<String, dynamic>>.from(
            data["checkOutDetails"].map((item) {
              return {
                "id": int.tryParse(item["id"].toString()) ?? 0,
                "challan_id": int.tryParse(item["challan_id"].toString()) ?? 0,
                "details": (item["details"] is List)
                    ? item["details"]
                    : _parseDetails(item["details"]),
              };
            }),
          );
          print('PRINTING CHECKOUT DETAILS !!!');
          print(_checkOutDetails);
        } else {
          print("API Response does not contain expected data.");
          _checkOutDetails = [];
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
        _checkOutDetails = [];
      }
    } catch (e) {
      print("Error fetching checkout details: $e");
      _checkOutDetails = [];
    }

    isLoadingcheckOutDetails = false;
    notifyListeners();
  }

  List<dynamic> _parseDetails(dynamic details) {
    try {
      if (details is String) {
        return jsonDecode(details);
      } else if (details is List) {
        return details;
      } else {
        return [];
      }
    } catch (e) {
      print("Error parsing details: $e");
      return [];
    }
  }

  Future<void> checkOutAddedItems(context, challanId, userid) async {
    final String apiUrl =
        "https://bingo-agency.com/paradisegases.com/admin/api/checkOutAddedItems?challan_id=" +
            challanId.toString() +
            "&user_id=" +
            userid; // Change to your actual API URL

    print(apiUrl);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {"challan_id": challanId.toString()},
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        print("Part added successfully: ${responseData['checkout']}");
      } else {
        showErrorSnackbar(context, 'Price not found.');
        print("Error: ${responseData['message']}");
      }

      showSuccessSnackbar(context, challanId + ' has been checkedout.');
      isLoadingAddedParts = true;
      notifyListeners();
    } catch (error) {
      print("Exception: $error");
    }
  }

  Future<void> getDcs() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _dcservice.getDcs();

      // Debug: Print response
      debugPrint("Fetched requests: ${response.length}");

      if (response.isNotEmpty) {
        _dcs = response;
      } else {
        _dcs = [];
        debugPrint("No requests received from API.");
      }
    } catch (e) {
      _dcs = [];
      debugPrint("Error fetching requests: ${e.runtimeType}: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateChallanItem(
    String id, // This is sold_item_id
    String saleId,
    String userId,
    String remarks,
    String partUsed,
    int filledQty,
    int unfilledQty,
  ) async {
    isLoading = true;
    notifyListeners();

    try {
      var url =
          "https://bingo-agency.com/paradisegases.com/admin/api/add_filler_details?sold_item_id=" +
              id;

      final Map<String, dynamic> bodyData = {
        "sale_id": saleId,
        "user_id": userId,
        "remarks": remarks,
        "part_used": partUsed,
        "filled_qty": filledQty,
        "unfilled_qty": unfilledQty,
      };

      print("Request URL: $url");
      print("Request Body: ${jsonEncode(bodyData)}");

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode(bodyData),
      );

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        await fetchChallanDetails(saleId); // Refresh list
      } else {
        debugPrint("Failed to update Challan Item: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  List<ItemModel> _items = [];
  bool isLoadingItems = false;

  List<ItemModel> get items => _items;
  Future<List<ItemModel>> fetchInventoryItems(String customerId) async {
    isLoadingItems = true;
    notifyListeners();

    try {
      _items = await ItemService.fetchItems(customerId);
    } catch (e) {
      _items = []; // Reset list on failure
      debugPrint("Error fetching inventory items: $e");
    }

    isLoadingItems = false;
    notifyListeners();
    return _items;
  }

  List<String> tempPartsList = ["None"]; // Default part list

  Future<void> addPartToSale(
      context, String saleId, String partName, String userId) async {
    final String apiUrl =
        "https://bingo-agency.com/paradisegases.com/admin/api/addPartsToSale.php?challan_id=" +
            saleId; // Change to your actual API URL

    print(apiUrl);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {"challan_id": saleId, "item_name": partName, "user_id": userId},
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        print("Part added successfully: ${responseData['redirect']}");
      } else {
        showErrorSnackbar(context, 'Price not found.');
        print("Error: ${responseData['message']}");
      }

      showSuccessSnackbar(context, partName + ' has been added.');
      isLoadingAddedParts = true;
      getAddedPartsToSale(saleId);
      notifyListeners();
    } catch (error) {
      print("Exception: $error");
    }
    isLoadingAddedParts = true;
    getAddedPartsToSale(saleId);
    notifyListeners();
  }

  Future<void> deleteAddedPart(
      context, int addedPartId, String challanId) async {
    final String apiUrl =
        'https://bingo-agency.com/paradisegases.com/admin/api/deleteAddedPart.php?addedPartId=$addedPartId';
    print(apiUrl);
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {},
      );

      final responseData = json.decode(response.body);
      print(response.body.toString());

      if (response.statusCode == 200 && responseData['success'] == true) {
        print("Part added successfully: ${responseData['redirect']}");
      } else {
        print("Error: ${responseData['message']}");
      }

      notifyListeners(); // Notify UI of changes
    } catch (error) {
      print("Exception: $error");
    }
    showSuccessSnackbar(context, 'Added part has been removed.');
    getAddedPartsToSale(challanId);
  }

  String initialCity = 'Select City';
  bool postedAd = false;

  List<File> propertyImages = [];

  double latitude = 33.628092;
  double longitude = 72.880933;

  bool isLoggedIn = false;

  Future<bool> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('id') ?? '';

    if (id.isEmpty || id == '0') {
      isLoggedIn = false;
    } else {
      prefs.setString('id', id);
      debugPrint('Auth is true!');
      isLoggedIn = true;
    }

    notifyListeners();
    return isLoggedIn;
  }

  Future<void> setLoggedIn(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', value);
  }

  Map<String, dynamic> _mapLocation = {};
  bool _errorLocation = false;
  String _errorMessageLocation = '';

  Map<String, dynamic> get mapLocation => _mapLocation;

  bool get errorLocation => _errorLocation;

  String get errorMessageLocation => _errorMessageLocation;

  Future<void> Getlocation(String lat, String lng) async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyCb3U_z-owpRwGS321AP0JX09crvvQj4dw&sensor=false'));

    if (response.statusCode == 200) {
      try {
        _mapLocation = jsonDecode(response.body);
        print('its coming from here....');
        print(_mapLocation.toString());

        _errorLocation = false;
        if (_mapLocation.isNotEmpty) {
          getCityLocation();

          // addlocation( lat , lng);
        }
      } catch (e) {
        _errorLocation = true;
        _errorMessageLocation = e.toString();
        _mapLocation = {};
      }
    } else {
      _errorLocation = true;
      _errorMessageLocation = 'Error : It could be your Internet connection.';
      _mapLocation = {};
    }
    notifyListeners();
  }

  var formattedAddress = '';
  var initial_city = 'Islamabad';
  Future<void> getCityLocation() async {
    var gottenAddress = _mapLocation['results'][0]['formatted_address'];
    var gottenCity = _mapLocation['results'][0]['address_components'][5]
            ['long_name']
        .toString();
    initial_city = gottenCity;
    formattedAddress = gottenAddress;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('initial_city', gottenCity);
    initial_city = prefs.getString('initial_city') ?? '';
    // print('printing city name$initial_city');
    // SetCityForSearchbar(Cityname.toString());
    // adLocation = formattedAddress;
    // if(adLocation==""){

    // }

    notifyListeners();
  }

  Future<void> loadAssets() async {
    // List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {} on Exception catch (e) {
      error = e.toString();
    }

    error = error;

    notifyListeners();
  }

  bool showSpinner = false;
  Future getSpinnerValue() async {
    var spinVal = showSpinner;
    return spinVal;
  }

  // Dio dio = Dio();

  String post_id = '0';
  List<dynamic> finalResImages = [];

  Future<void> setPostId(String id) async {
    post_id = id;
    notifyListeners();
  }

  File? primaryImage;

  Future setPrimaryImage(img) async {
    primaryImage = img;
    // imagetoupload = img;
    notifyListeners();
  }

  Future<void> addPrefval(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = (prefs.getString(key) ?? value);
    // print('added to pref ' + key + ' - ' + value);
    notifyListeners();
  }

  Future<String> getPrefval(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = (prefs.getString(key) ?? value);
    // print('gotten from pref ' + key + ' - ' + value);
    notifyListeners();
    return stringValue;
  }

  Future<String> getCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = (prefs.getString('initial_city') ?? 'Islamabad');
    initial_city = stringValue;
    notifyListeners();
    return stringValue;
  }

  void setCity(city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('initial_city', city);
    // print('new city set');
    // print(city);
    initial_city = city;
    notifyListeners();
  }

  String name = '';
  String title = '';
  String avatar = '';
  String amount_pending = '';
  String amount_payable = '';
  String id = '';
  String number = '';
  String email = '';
  String password = '';
  String city = '';
  String type = '';
  String ntn = '';
  String cnic = '';
  String status = '';
  String timestamp = '';

  addCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('initial_city', "Islamabad");
    notifyListeners();
  }

  void _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    initial_city = prefs.getString('initial_city') ?? 'Islamabad';
    notifyListeners();
  }

  void _getAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    title = prefs.getString('title') ?? '';
    type = prefs.getString('type') ?? '';
    ntn = prefs.getString('ntn') ?? '';
    cnic = prefs.getString('cnic') ?? '';
    amount_pending = prefs.getString('amount_pending') ?? '';
    amount_payable = prefs.getString('amount_payable') ?? '';
    name = prefs.getString('name') ?? '';
    email = prefs.getString('email') ?? '';
    password = prefs.getString('password') ?? '';
    id = prefs.getString('id') ?? '';
    avatar = prefs.getString('avatar') ?? '';
    number = prefs.getString('number') ?? '';
    timestamp = prefs.getString('timestamp') ?? '';
    notifyListeners();
  }

  void addAuth(id, name, title, avatar, amount_pending, amount_payable, number,
      email, password, city, type, ntn, cnic, status, timestamp) async {
    print(id + ' AUTH BEEN ADDED !!!');
    print(id + ' id is being printed');
    print(id +
        name +
        title +
        avatar +
        amount_pending +
        amount_payable +
        number +
        email +
        password +
        city +
        type +
        ntn +
        cnic +
        status +
        timestamp +
        ' id is being printed');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('id', id);
    isLoggedIn = true;

    prefs.setString('id', id.toString());
    prefs.setString('name', name.toString());
    prefs.setString('title', title.toString());
    prefs.setString('avatar', avatar.toString());
    prefs.setString('amount_pending', amount_pending.toString());
    prefs.setString('amount_payable', amount_payable.toString());
    prefs.setString('number', number.toString());
    prefs.setString('email', email.toString());
    prefs.setString('password', password.toString());
    prefs.setString('city', city.toString());
    prefs.setString('type', type.toString());
    prefs.setString('status', status.toString());
    prefs.setString('timestamp', timestamp.toString());
    print('auth added ');
    notifyListeners();
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("id");
    prefs.remove("name");
    prefs.remove("title");
    prefs.remove("avatar");
    prefs.remove("amount_pending");
    prefs.remove("amount_payable");
    prefs.remove("number");
    prefs.remove("email");
    prefs.remove("password");
    prefs.remove("city");
    prefs.remove("type");
    prefs.remove("status");
    prefs.remove("timestamp");
    notifyListeners();
  }

  void confirmUser() async {
    login(number, password);
    print('printing from confirmuser. type is ' + type);
  }

  Future<String> getName() async {
    _getAuth();
    // notifyListeners();
    return name;
  }

  Future<String> getEmail() async {
    _getAuth();
    return email;
  }

  Future<String> getPhone() async {
    _getAuth();
    return number;
  }

  Future<String> getPassword() async {
    _getAuth();
    return password;
  }

  Future<String> getAvatar() async {
    _getAuth();

    return avatar;
  }

  Future<String> getId() async {
    _getAuth();

    return id;
  }

  Future<String> getTimestamp() async {
    _getAuth();
    return timestamp;
  }

  Future<String> getCurrentCity() async {
    return initial_city;
  }

  String _loginError = '';

  String get loginError => _loginError;

  set loginError(String value) {
    _loginError = value;
    notifyListeners();
  }

  Future<void> login(number, password) async {
    String url =
        '${'https://bingo-agency.com/paradisegases.com/admin/api/login?number=' + number}&password=' +
            password;
    print(url);
    final response = await http.get((Uri.parse(url)));
    if (response.statusCode == 200) {
      var userJson = jsonDecode(response.body);
      print(userJson);
      print(userJson['message']);
      print(userJson['error']);
      print(userJson['user']);
      addAuth(
          userJson['user']['id'],
          userJson['user']['name'],
          userJson['user']['title'],
          userJson['user']['avatar'],
          userJson['user']['amount_pending'],
          userJson['user']['amount_payable'],
          userJson['user']['number'],
          userJson['user']['email'],
          userJson['user']['password'],
          userJson['user']['city'],
          userJson['user']['type'],
          userJson['user']['ntn'],
          userJson['user']['cnic'],
          userJson['user']['status'],
          userJson['user']['timestamp']);
      notifyListeners();
    } else {
      var errJson = jsonDecode(response.body);
      loginError = errJson['error'].toString();

      if (errJson['message'].toString() == 'Login successful.') {
        print('registered.');
        var userJson = jsonDecode(response.body);
        print(userJson);
        print(userJson['message']);
        print(userJson['user']);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true); // Set the login status to true
        addAuth(
            userJson['user']['id'],
            userJson['user']['name'],
            userJson['user']['title'],
            userJson['user']['avatar'],
            userJson['user']['amount_pending'],
            userJson['user']['amount_payable'],
            userJson['user']['number'],
            userJson['user']['email'],
            userJson['user']['password'],
            userJson['user']['city'],
            userJson['user']['type'],
            userJson['user']['ntn'],
            userJson['user']['cnic'],
            userJson['user']['status'],
            userJson['user']['timestamp']);
        notifyListeners();
      } else {
        print(errJson['message']);
      }
      notifyListeners();
    }
  }

  String selectedAdCity = 'Islamabad';
  List<String> adCityOptions = [
    "Islamabad",
    "Lahore",
    "Rawalpindi",
    "Karachi",
    "Abbottabad",
    "Murree",
    "Ahmed Nager Chatha",
    "Ahmadpur East",
    "Ali Khan Abad",
    "Alipur",
    "Arifwala",
    "Attock",
    "Bhera",
    "Babusar Pass",
    "Bhalwal",
    "Bahawalnagar",
    "Bahawalpur",
    "Bhakkar",
    "Burewala",
    "Chillianwala",
    "Chakwal",
    "Chichawatni",
    "Chiniot",
    "Chishtian",
    "Daska",
    "Darya Khan",
    "Dera Ghazi Khan",
    "Dhaular",
    "Dina",
    "Dinga",
    "Dipalpur",
    "Faisalabad",
    "Ferozewala",
    "Fateh Jhang",
    "Ghakhar Mandi",
    "Gojra",
    "Gujranwala",
    "Gujrat",
    "Gujar Khan",
    "Hafizabad",
    "Haroonabad",
    "Hasilpur",
    "Haveli Lakha",
    "Jatoi",
    "Jalalpur",
    "Jattan",
    "Jampur",
    "Jaranwala",
    "Jhang",
    "Jhelum",
    "Kalabagh",
    "Karor Lal Esan",
    "Kasur",
    "Kamalia",
    "Kamoke",
    "Khanewal",
    "Khanpur",
    "Kharian",
    "Khushab",
    "Kot Addu",
    "Jauharabad",
    "Lalamusa",
    "Layyah",
    "Liaquat Pur",
    "Lodhran",
    "Malakwal",
    "Mamoori",
    "Mailsi",
    "Mandi Bahauddin",
    "Mian Channu",
    "Mianwali",
    "Multan",
    "Muridke",
    "Mianwali Bangla",
    "Muzaffargarh",
    "Narowal",
    "Nankana Sahib",
    "Okara",
    "Renala Khurd",
    "Pakpattan",
    "Pattoki",
    "Pir Mahal",
    "Qaimpur",
    "Qila Didar Singh",
    "Rabwah",
    "Raiwind",
    "Rajanpur",
    "Rahim Yar Khan",
    "Sadiqabad",
    "Safdarabad",
    "Sahiwal",
    "Sangla Hill",
    "Sarai Alamgir",
    "Sargodha",
    "Shakargarh",
    "Sheikhupura",
    "Sialkot",
    "Sohawa",
    "Soianwala",
    "Siranwali",
    "Talagang",
    "Taxila",
    "Toba Tek Singh",
    "Vehari",
    "Wah Cantonment",
    "Wazirabad",
    "Badin",
    "Bhirkan",
    "Rajo Khanani",
    "Chak",
    "Dadu",
    "Digri",
    "Diplo",
    "Dokri",
    "Ghotki",
    "Haala",
    "Hyderabad",
    "Islamkot",
    "Jacobabad",
    "Jamshoro",
    "Jungshahi",
    "Kandhkot",
    "Kandiaro",
    "Kashmore",
    "Keti Bandar",
    "Khairpur",
    "Kotri",
    "Kaghan",
    "Larkana",
    "Matiari",
    "Mehar",
    "Mirpur Khas",
    "Mithani",
    "Mithi",
    "Mehrabpur",
    "Moro",
    "Nagarparkar",
    "Naudero",
    "Naushahro Feroze",
    "Naushara",
    "Nawabshah",
    "Nazimabad",
    "Naran",
    "Qambar",
    "Qasimabad",
    "Ranipur",
    "Ratodero",
    "Rohri",
    "Sakrand",
    "Sanghar",
    "Shahbandar",
    "Shahdadkot",
    "Shahdadpur",
    "Shahpur Chakar",
    "Shikarpaur",
    "Sukkur",
    "Tangwani",
    "Tando Adam Khan",
    "Tando Allahyar",
    "Tando Muhammad Khan",
    "Thatta",
    "Umerkot",
    "Warah",
    "Adezai",
    "Alpuri",
    "Akora Khattak",
    "Ayubia",
    "Banda Daud Shah",
    "Bannu",
    "Batkhela",
    "Battagram",
    "Birote",
    "Chakdara",
    "Charsadda",
    "Chitral",
    "Daggar",
    "Dargai",
    "Darya Khan",
    "Dera Ismail Khan",
    "Doaba",
    "Dir",
    "Drosh",
    "Hangu",
    "Haripur",
    "Karak",
    "Kohat",
    "Kulachi",
    "Lakki Marwat",
    "Latamber",
    "Madyan",
    "Mansehra",
    "Mardan",
    "Mastuj",
    "Mingora",
    "Nowshera",
    "Paharpur",
    "Pabbi",
    "Peshawar",
    "Saidu Sharif",
    "Shorkot",
    "Shewa Adda",
    "Swabi",
    "Swat",
    "Tangi",
    "Tank",
    "Thall",
    "Timergara",
    "Tordher",
    "Awaran",
    "Barkhan",
    "Chagai",
    "Dera Bugti",
    "Gwadar",
    "Harnai",
    "Jafarabad",
    "Jhal Magsi",
    "Kacchi",
    "Kalat",
    "Kech",
    "Kharan",
    "Khuzdar",
    "Killa Abdullah",
    "Killa Saifullah",
    "Kohlu",
    "Lasbela",
    "Lehri",
    "Loralai",
    "Mastung",
    "Musakhel",
    "Nasirabad",
    "Nushki",
    "Panjgur",
    "Pishin Valley",
    "Quetta",
    "Sherani",
    "Sibi",
    "Sohbatpur",
    "Washuk",
    "Zhob",
    "Ziarat",
  ];
  String finalAdCity = '';

  void setAdCity(newAdCity) {
    finalAdCity = newAdCity;
    notifyListeners();
  }

  String selectedSearchType = 'Any';
  List<String> typeSearchOptions = [
    'Any',
    'House',
    'Studio',
    'Apartment',
    'Plot',
    'Shop',
    'Restaurant',
    'Building',
    'Land',
    'Vehicle',
    'Other'
  ];
  String finalSearchType = '';

  void setSearchType(newSearchType) {
    finalSearchType = newSearchType;
    notifyListeners();
  }

  String selectedType = 'House';
  List<String> typeOptions = [
    'House',
    'Studio',
    'Apartment',
    'Plot',
    'Shop',
    'Restaurant',
    'Building',
    'Land',
    'Vehicle',
    'Other'
  ];
  String finalType = '';

  void setType(newType) {
    finalType = newType;
    notifyListeners();
  }

  String selectedUnit = 'Marla';
  List<String> unitOptions = ['Marla', 'Sqft'];
  String finalUnit = '';

  void setUnit(newUnit) {
    finalUnit = newUnit;
    notifyListeners();
  }

  String uploadStatus = 'Posting...';
  bool uploadValue = false;

// new login
  final bool _isLoading = false;

  final Map<String, dynamic> _mapForgotten = {};

  Map<String, dynamic> get mapForgotten => _mapForgotten;

  Future checkUser(email) async {
    var response = await http.post(Uri.parse(
        'http://teamworkpk.com/API/forget_password.php?email=$email'));

    var link = jsonDecode(response.body);

    if (link == "true") {
      // print('User has been sent an email for reset password.');
    } else {}
    // print(link);
    return link;
  }

  Map<String, dynamic> _mapAccount = {};
  bool _errorAccount = false;
  String _errorMessageAccount = '';

  Map<String, dynamic> get mapAccount => _mapAccount;

  bool get errorAccount => _errorAccount;

  String get errorMessageAccount => _errorMessageAccount;

  Future<void> fetchAccount(String id) async {
    final response = await http.get(
      Uri.parse(
          'https://teamworkpk.com/API/account.php?public_user_id=$id&selected=ads'),
    );
    // print('https://teamworkpk.com/API/account.php?public_user_id=' +
    //     id +
    //     '&selected=ads');
    if (response.statusCode == 200) {
      try {
        _mapAccount = jsonDecode(response.body);
        _errorAccount = false;
      } catch (e) {
        _errorAccount = true;
        _errorMessageAccount = e.toString();
        _mapAccount = {};
      }
    } else {
      _errorAccount = true;
      _errorMessageAccount = 'Error : It could be your Internet connection.';
      _mapAccount = {};
    }
    notifyListeners();
  }

  void showErrorSnackbar(context, msg) {
    final snackBar = SnackBar(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Error!',
        message: msg,

        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
        contentType: ContentType.failure,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void showSuccessSnackbar(context, msg) {
    final snackBar = SnackBar(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Success!',
        message: msg,

        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
        contentType: ContentType.success,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void initialValues() {
    _mapAccount = {};
    _errorAccount = false;
    _errorMessageAccount = '';

    notifyListeners();
  }
}
