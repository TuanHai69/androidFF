import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:marquee/marquee.dart';
import 'store_manager.dart';
import 'store_detail.dart'; // Import StoreDetailScreen
import 'commentstore_manager.dart'; // Import CommentStoreManager
import '../../models/store.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final Map<String, double> _averageRatings = {};
  bool _isFetching = false;
  List<Store> _filteredStores = [];
  List<Store> _originalStores = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchStores();
  }

  Future<void> _fetchStores() async {
    final storeManager = Provider.of<StoreManager>(context, listen: false);
    await storeManager.fetchAllStores();
    _filterStores(storeManager.stores);
    _fetchCommentsForStores();
  }

  void _filterStores(List<Store> stores) {
    setState(() {
      _originalStores = stores.where((store) => store.state == 'show').toList();
      _filteredStores = List.from(_originalStores);
    });
  }

  void _searchStores(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredStores = List.from(_originalStores);
      } else {
        _filteredStores = _originalStores
            .where((store) =>
                store.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _fetchCommentsForStores() async {
    if (_isFetching) return;
    _isFetching = true;

    final commentStoreManager =
        Provider.of<CommentStoreManager>(context, listen: false);

    for (var store in _filteredStores) {
      if (!mounted) return;
      await commentStoreManager.fetchCommentStoresByStore(store.id);
      if (!mounted) return;

      final comments = commentStoreManager.commentStores;

      if (comments.isNotEmpty) {
        final averageRating =
            comments.map((c) => c.rate).reduce((a, b) => a + b) /
                comments.length;
        if (mounted) {
          setState(() {
            _averageRatings[store.id] = averageRating;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _averageRatings[store.id] = 0.0;
          });
        }
      }
    }

    if (mounted) {
      setState(() {
        _isFetching = false;
      });
    }
  }

  @override
  void dispose() {
    _isFetching = false;
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storeManager = Provider.of<StoreManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách cửa hàng'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm cửa hàng...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _filteredStores = List.from(_originalStores);
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (query) => _searchStores(query),
            ),
          ),
          Expanded(
            child: storeManager.storeCount == 0
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredStores.length,
                    itemBuilder: (context, index) {
                      final store = _filteredStores[index];
                      final averageRating = _averageRatings[store.id] ?? 0.0;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  StoreDetailScreen(store: store),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Stack(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height / 3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: MemoryImage(
                                        base64Decode(store.picture)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height / 3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.7),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Row(
                                  children: List.generate(5, (index) {
                                    if (index < averageRating.floor()) {
                                      return const Icon(Icons.star,
                                          color: Colors.amber, size: 20);
                                    } else if (index < averageRating) {
                                      return const Icon(Icons.star_half,
                                          color: Colors.amber, size: 20);
                                    } else {
                                      return const Icon(Icons.star_border,
                                          color: Colors.amber, size: 20);
                                    }
                                  }),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                right: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildMarqueeOrText(
                                        store.name, 24, FontWeight.bold),
                                    const SizedBox(height: 5),
                                    _buildMarqueeOrText(
                                        store.address, 16, FontWeight.normal),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: _buildMarqueeOrText(
                                              store.phonenumber,
                                              16,
                                              FontWeight.normal),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: _buildMarqueeOrText(
                                              store.opentime,
                                              16,
                                              FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarqueeOrText(
      String text, double fontSize, FontWeight fontWeight) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: text,
            style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
          ),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(minWidth: 0, maxWidth: constraints.maxWidth);

        if (textPainter.didExceedMaxLines) {
          return SizedBox(
            height: fontSize + 10,
            child: Marquee(
              text: text,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
              scrollAxis: Axis.horizontal,
              blankSpace: 20.0,
              velocity: 50.0,
              pauseAfterRound: const Duration(seconds: 1),
              startPadding: 10.0,
              accelerationDuration: const Duration(seconds: 1),
              accelerationCurve: Curves.linear,
              decelerationDuration: const Duration(milliseconds: 500),
              decelerationCurve: Curves.easeOut,
            ),
          );
        } else {
          return Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          );
        }
      },
    );
  }
}
