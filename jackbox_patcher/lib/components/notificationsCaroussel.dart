import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/components/dialogs/newsReadingDialog.dart';
import 'package:jackbox_patcher/model/news.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';

import 'blurhashimage.dart';

class NotificationCaroussel extends StatefulWidget {
  NotificationCaroussel({Key? key, required this.news}) : super(key: key);

  final List<News> news;

  @override
  State<NotificationCaroussel> createState() => _NotificationCarousselState();
}

class _NotificationCarousselState extends State<NotificationCaroussel> {
  bool moveButtonVisible = false;
  int imageIndex = 0;

  List<String> images = [];

  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    for (var news in widget.news) {
      images.add(APIService().assetLink(news.image));
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          height: 130,
          child: AspectRatio(
            aspectRatio: 1.778,
            child: CarouselSlider.builder(
              itemCount: images.length,
              carouselController: _controller,
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 1.778,
                height: 130,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    imageIndex = index;
                  });
                },
              ),
              itemBuilder: (context, index, realIdx) {
                return GestureDetector(onTap: () => _openNotificationsWindow(index), child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                      child: Center(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Stack(children: [
                                AspectRatio(
                                    aspectRatio: 1.778,
                                    child: CachedNetworkImage(
                                        imageUrl: images[index],
                                        fit: BoxFit.cover,
                                        height: 130)),
                                Container(
                                    width: double.maxFinite,
                                    color: Colors.black.withOpacity(0.7),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        widget.news[index].title,
                                        textAlign: TextAlign.center,
                                      ),
                                    ))
                              ])))),
                ));
              },
            ),
          )),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: images.asMap().entries.map((entry) {
          return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (FluentTheme.of(context).brightness ==
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(imageIndex == entry.key ? 0.9 : 0.4)),
                ),
              ));
        }).toList(),
      ),
    ]);
  }

  void _openNotificationsWindow(int newsIndex) {
    showDialog(context: context, builder: (context) => NewsReadingDialog(news : widget.news[newsIndex]));
  }
}
