import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'order_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Pagination Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  OrderListModal modal = OrderListModal(
      count: 0,
      currentPage: 0,
      data: [],
      perPage: 0,
      totalPages: 0,
      totalRecords: 0);
  final int _numberOfPostsPerRequest = 10;

  // late List<OrderListModal> _posts;
  final int _nextPageTrigger = 3;
  var token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTY4MjMxNjU5NiwianRpIjoiYzk0MjIyOWItMTUxOS00OTIxLWFhNjItMWJkYTE3ODBiMmQ4IiwidHlwZSI6ImFjY2VzcyIsInN1YiI6NDUsIm5iZiI6MTY4MjMxNjU5NiwiZXhwIjoxNjgyOTIxMzk2LCJ1c2VyX2lkIjo0NSwidXNlcl90eXBlIjoyLCJlbnYiOiJkZXZlbG9wbWVudCJ9.M8qnTLkTJ1o-qXzDG2Nt6ln6I-66qNVxgRVm8lLntJ8";

  @override
  void initState() {
    super.initState();
    _pageNumber = 0;
    _isLastPage = false;
    _loading = true;
    _error = false;
    fetchData();
  }

  Future<OrderListModal?> fetchData() async {
    try {
      var response = await http.get(
          Uri.parse(
              "https://trust-api.trustmony.com/api/v1/orders-list?page_number=$_pageNumber&limit=$_numberOfPostsPerRequest"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': token,
          });
      if (response.statusCode == 200) {
        debugPrint("response.body" + response.body.toString());
        OrderListModal temp =
            OrderListModal.fromJson((jsonDecode(response.body)));
        modal.data.addAll(temp.data);
        debugPrint("data length  ${modal.data.length}");
        setState(() {
          _isLastPage = modal.data.length < _numberOfPostsPerRequest;
          _loading = false;
          _pageNumber = _pageNumber + 1;
        });
        return modal;
      } else {
        var temp = jsonDecode(response.body);
        debugPrint("this is error ${temp["error"]}");
      }
    } catch (e) {
      debugPrint("catch error ${e}");
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body:
            buildPostsView() // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget buildPostsView() {
    if (modal.data.isEmpty) {
      if (_loading) {
        return const Center(
            child: Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ));
      } else if (_error) {
        return const Center(child: Text("Opps! Page not found"));
      }
    }
    return ListView.builder(
        itemCount: modal.data.length + (_isLastPage ? 0 : 1),
        itemBuilder: (context, index) {
          if (index == modal.data.length - _nextPageTrigger) {
            fetchData();
          }
          if (index == modal.data.length) {
            if (_error) {
              return const Center(child: Text("sorry there are no data"));
            } else {
              return const Center(
                  child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ));
            }
          }
          // final Post post = modal!.data[index];
          return Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff00000029).withOpacity(0.08),
                    spreadRadius: 5,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              //  height: 120,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15.0, right: 15, left: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: Image.network(modal.data[index].bondLogo ?? "",
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.person)),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          modal.data[index].bondName ?? "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 77.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            await Clipboard.setData(ClipboardData(
                                text: modal.data[index].bondIsinNumber));
                          },
                          child: Container(
                            height: 30,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(12)),
                                color: Colors.grey),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: "ISIN : ",
                                      ),
                                      TextSpan(
                                        text:
                                            modal.data[index].bondIsinNumber ??
                                                "",
                                      ),
                                    ]),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Icon(
                                    Icons.file_copy,
                                    color: Color(0xffFF405A),
                                    size: 12,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Order no.",
                              ),
                              const SizedBox(
                                height: 1,
                              ),
                              Text(
                                modal.data[index].orderNumber ?? "N/A",
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Order Date",
                              ),
                              const SizedBox(
                                height: 1,
                              ),
                              Text(
                                modal.data[index].orderDatetime != null
                                    ? "${modal.data[index].orderDatetime}"
                                    : "",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Order Status",
                              ),
                              const SizedBox(
                                height: 1,
                              ),
                              Text(
                                modal.data[index].orderStatus != null ||
                                        modal.data[index].orderStatus != 0
                                    ? modal.data[index].orderStatus == 1
                                        ? "Placed"
                                        : modal.data[index].orderStatus == 2
                                            ? "Modified"
                                            : modal.data[index].orderStatus == 3
                                                ? "Cancelled"
                                                : modal.data[index]
                                                            .orderStatus ==
                                                        4
                                                    ? "Accepted"
                                                    : "Rejected"
                                    : "N/A",
                                style: TextStyle(
                                  color: modal.data[index].orderStatus == 1
                                      ? const Color(0xffFFC543)
                                      : modal.data[index].orderStatus == 2
                                          ? const Color(0xff488BFF)
                                          : modal.data[index].orderStatus == 3
                                              ? const Color(0xffFF0023)
                                              : modal.data[index].orderStatus ==
                                                      4
                                                  ? const Color(0xffFFC543)
                                                  : const Color(0xffFF0023),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Payment Status",
                                style: TextStyle(
                                  color: Color(0xffB0B1B9),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                height: 1,
                              ),
                              Text(
                                modal.data[index].orderPaymentStatus != null &&
                                        modal.data[index].orderPaymentStatus !=
                                            0
                                    ? modal.data[index].orderPaymentStatus == 1
                                        ? "Pending/Processing"
                                        : modal.data[index]
                                                    .orderPaymentStatus ==
                                                2
                                            ? "Successful"
                                            : modal.data[index]
                                                        .orderPaymentStatus ==
                                                    3
                                                ? "Failed"
                                                : "Refunded"
                                    : "N/A",
                                style: TextStyle(
                                  color: modal.data[index].orderPaymentStatus ==
                                          1
                                      ? const Color(0xff488BFF)
                                      : modal.data[index].orderPaymentStatus ==
                                              2
                                          ? const Color(0xffFFC543)
                                          : modal.data[index]
                                                      .orderPaymentStatus ==
                                                  3
                                              ? const Color(0xffFF0023)
                                              : const Color(0xffFFC543),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  modal.data[index].orderType == 3
                      ? detailsOfPurchaseOfGoldBond(modal.data[index])
                      : detailsOfPurchaseOfGoldBond(modal.data[index])
                ],
              ));
        });
  }

  detailsOfPurchaseOfGoldBond(Datum data) {
    return Container(
      color: const Color(0xffF7F7FA),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Price",
                style: TextStyle(
                  color: Color(0xffB0B1B9),
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                data.orderAmount != null
                    ? "₹ ${data.orderAmount.toString()}"
                    : "₹0",
                style: const TextStyle(
                  color: Color(0xff22263D),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Gold Quantity in Grams",
                style: const TextStyle(
                  color: Color(0xffB0B1B9),
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                data.orderQuantity != null
                    ? data.orderQuantity.toString()
                    : "N/A",
                style: const TextStyle(
                  color: Color(0xff22263D),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 60,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Yield %",
                style: const TextStyle(
                  color: Color(0xffB0B1B9),
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                data.bondsYeild != null ? data.bondsYeild.toString() : 'N/A',
                style: const TextStyle(
                  color: Color(0xff22263D),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Total Investment",
                style: const TextStyle(
                  color: Color(0xffB0B1B9),
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                data.orderAmount != null &&data.orderQuantity !=null
                    ? ((int.parse(double.parse(data.orderAmount!.toString())
                                    .toInt()
                                    .toString()) *
                                int.parse(data.orderQuantity!.toString()))
                            .toInt())
                        .toString()
                    : "₹0",
                //  ? format.format((int.parse(double.parse(data.bondsPricePerGram.toString()).toInt().toString())*data.orderQuantity)
                //.toInt())

                // data.orderAmount != null ? data.orderAmount.toString() : '₹0',
                style: const TextStyle(
                  color: Color(0xff22263D),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
