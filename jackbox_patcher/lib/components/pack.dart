import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/model/jackboxpack.dart';

class PackWidget extends StatefulWidget {
  PackWidget({Key? key, required this.pack}) : super(key: key);

  final JackboxPack pack;
  @override
  State<PackWidget> createState() => _PackWidgetState();
}

class _PackWidgetState extends State<PackWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      _buildHeader()
    ]);
  }

  Widget _buildHeader(){
    return Container(
      height: 200,
      child: Stack(
        children: [
          Container(height:200,child:Image.network(widget.pack.background)),
          
        ],
      ),
    );
  }
}
