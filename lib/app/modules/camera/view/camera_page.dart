import 'package:camera/camera.dart';
import 'package:cliente/app/modules/cadastro/controller/cadastro_controller.dart';
import 'package:cliente/app/modules/camera/view/camera_preview_page.dart';
import 'package:cliente/app/shared/components/cliente_circular_icon_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class CameraPage extends StatelessWidget {
  final List<CameraDescription> cameras;
  final CadastroController controller;

  const CameraPage(
    this.cameras,
    this.controller, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            FontAwesome.arrow_left,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: CameraContent(cameras, controller),
    );
  }
}

class CameraContent extends StatefulWidget {
  final List<CameraDescription> cameras;
  final CadastroController controller;

  const CameraContent(this.cameras, this.controller, {Key key})
      : super(key: key);

  @override
  _CameraContentState createState() => _CameraContentState();
}

class _CameraContentState extends State<CameraContent> {
  CameraController cameraController;

  @override
  void initState() {
    super.initState();
    cameraController =
        CameraController(widget.cameras[1], ResolutionPreset.medium);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!cameraController.value.isInitialized) {
      return Center(
        child: Text(
          ':(\nA camera não foi iniciada\nTente novamente',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return Stack(
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: cameraController.value.aspectRatio,
            child: CameraPreview(cameraController),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ClienteCircularIconButton(
                Theme.of(context).primaryColor,
                FontAwesome.camera,
                padding: EdgeInsets.all(16),
                onPressed: () => _capturarImagem(context),
              ),
              Text(
                'Toque para tirar foto',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      blurRadius: 4.0,
                      color: Colors.black,
                      offset: Offset(0.3, 0.3),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  void _capturarImagem(BuildContext context) async {
    try {
      final caminho = join((await getTemporaryDirectory()).path,
          '${Timestamp.now().microsecondsSinceEpoch}.png');

      await cameraController.takePicture(caminho);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraPreviewPage(caminho, widget.controller),
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}
