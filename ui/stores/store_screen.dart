import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:marquee/marquee.dart';
import 'store_manager.dart';
import 'store_detail.dart'; // Import StoreDetailScreen
import 'commentstore_manager.dart'; // Import CommentStoreManager

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final Map<String, double> _averageRatings = {};

  @override
  void initState() {
    super.initState();
    _fetchStores();
  }

  Future<void> _fetchStores() async {
    final storeManager = Provider.of<StoreManager>(context, listen: false);
    await storeManager.fetchAllStores();
    _fetchCommentsForStores();
  }

  Future<void> _fetchCommentsForStores() async {
    final commentStoreManager =
        Provider.of<CommentStoreManager>(context, listen: false);
    final storeManager = Provider.of<StoreManager>(context, listen: false);

    for (var store in storeManager.stores) {
      await commentStoreManager.fetchCommentStoresByStore(store.id);
      final comments = commentStoreManager.commentStores;
      if (comments.isNotEmpty) {
        final averageRating =
            comments.map((c) => c.rate).reduce((a, b) => a + b) /
                comments.length;
        setState(() {
          _averageRatings[store.id] = averageRating;
        });
      } else {
        setState(() {
          _averageRatings[store.id] = 0.0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final storeManager = Provider.of<StoreManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách cửa hàng'),
      ),
      body: storeManager.storeCount == 0
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: storeManager.storeCount,
              itemBuilder: (context, index) {
                final store = storeManager.stores[index];
                final averageRating = _averageRatings[store.id] ?? 0.0;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoreDetailScreen(store: store),
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
                              image: MemoryImage(base64Decode(store.picture)),
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
                                        store.opentime, 16, FontWeight.normal),
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
