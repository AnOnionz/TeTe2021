import 'dart:async';
import 'dart:io';
import 'package:flutter_better_camera/camera.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:uuid/uuid.dart';
import 'camera_button.dart';

class CameraPage extends StatefulWidget {

  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  final Completer<void> _initializeCompleter = Completer();
  final List<CameraDescription> _cameras = [];
  CameraController? controller;
  String? imagePath;
  FlashMode flashMode = FlashMode.off;

  final _photoViewController = StreamController<File?>.broadcast();

  @override
  void initState() {
    availableCameras().then((value) {
      _cameras.addAll(value);
      if (value.isNotEmpty) {
        onNewCameraSelected(value.first).then(
              (_) => _initializeCompleter.complete(),
        );
      }
    });
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _photoViewController.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller!.value.isInitialized!) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller!.description);
      }
    }
  }

  // void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
  //   final offset = Offset(
  //     details.localPosition.dx / constraints.maxWidth,
  //     details.localPosition.dy / constraints.maxHeight,
  //   );
  //   controller.setExposurePoint(offset);
  //   controller.setFocusPoint(offset);
  // }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }
    controller = CameraController(
        cameraDescription,
        ResolutionPreset.high,
        enableAudio: false,
        autoFocusEnabled: true,
        flashMode: FlashMode.off
    );

    // If the controller is updated then update the UI.
    controller!.addListener(() {
      if (mounted) setState(() {});
      if (controller!.value.hasError) {
        _showCameraException(
          CameraException(
              'Camera error', '${controller!.value.errorDescription}'),
        );
      }
    });

    try {
      await controller!.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> takePicture() async {
    if (!controller!.value.isInitialized!) {
      CameraException('NOT_INIT', 'Camera is not initialized');
      return ;
    }
    if (controller!.value.isTakingPicture!) {
      return ;
    }
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      final tempPath = appDocPath;
      final filename = 'camera_${const Uuid().v4()}.jpg';
      final path = [tempPath, filename].join(Platform.pathSeparator);

      try {
        await controller!.takePicture(path);
        _photoViewController.add(File(path));
      } on CameraException catch (e) {
        _showCameraException(e);
        return;
      }
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  /// Toggle Flash
  Future<void> _onFlashButtonPressed() async {
    bool hasFlash = false;
    if (flashMode == FlashMode.off || flashMode == FlashMode.torch) {
      // Turn on the flash for capture
      flashMode = FlashMode.alwaysFlash;
    } else if (flashMode == FlashMode.alwaysFlash) {
      // Turn on the flash for capture if needed
      flashMode = FlashMode.autoFlash;
    } else {
      // Turn off the flash
      flashMode = FlashMode.off;
    }
    // Apply the new mode
    await controller!.setFlashMode(flashMode);

    // Change UI State
    setState(() {});
  }
  // Future<void> switchFlashMode() async {
  //   if (controller == null) {
  //     print('SSSSSSSSSSSSSSSSSSSSSSSS');
  //     return;
  //   }
  //   try {
  //     final int index =
  //         controller.value.flashMode.index + 1 >= FlashMode.values.length
  //             ? 0
  //             : controller.value.flashMode.index + 1;
  //     await setFlashMode(FlashMode.values[index]);
  //   } on CameraException catch (e) {
  //     _showCameraException(e);
  //     rethrow;
  //   }
  // }

  void goBack() {
    Navigator.of(context).pop();
  }

  void flipCamera() {
    if (_cameras.isEmpty) {
      return;
    }
    final cameraIndex = _cameras.indexOf(controller!.description);
    final cameraDescription = cameraIndex < 0
        ? controller!.description
        : (_cameras.length > cameraIndex + 1
        ? _cameras[cameraIndex + 1]
        : _cameras[0]);
    onNewCameraSelected(cameraDescription);
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller!.value.isInitialized!) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return CameraPreview(controller!);
    }
  }

  Widget _cameraControlWidget() {
    return Positioned.fill(
      bottom: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              StatefulBuilder(
                builder: (context, setState) {
                  // IconData iconData = Icons.flash_off;
                  // FlashMode? flashMode = controller.value.flashMode;
                  // if (flashMode == FlashMode.torch) {
                  //   iconData = Icons.highlight;
                  // } else if (flashMode == FlashMode.always) {
                  //   iconData = Icons.flash_on;
                  // } else if (flashMode == FlashMode.auto) {
                  //   iconData = Icons.flash_auto;
                  // } else if (flashMode == FlashMode.off) {
                  //   iconData = Icons.flash_off;
                  // }
                  IconData iconData = Icons.flash_off;
                  Color color = Colors.black;
                  if (flashMode == FlashMode.alwaysFlash) {
                    iconData = Icons.flash_on;
                    color = Colors.blue;
                  } else if (flashMode == FlashMode.autoFlash) {
                    iconData = Icons.flash_auto;
                    color = Colors.red;
                  }
                  return Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(30.0),
                    child: IconButton(
                      splashRadius: 20,
                      iconSize: 24,
                      icon: Icon(
                        iconData,
                        color: Colors.white,
                      ),
                      onPressed: controller != null &&
                          controller!.value.isInitialized!
                          ? _onFlashButtonPressed
                          : null,
                    ),
                  );
                },
              ),
            ],
          ),
          Container(
            height: 130,
            color: Colors.black.withOpacity(1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30.0),
                  child: IconButton(
                    splashRadius: 20,
                    iconSize: 30,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: goBack,
                  ),
                ),
                CameraButton(
                  captureMode: CaptureMode.photo,
                  onTap: takePicture,
                ),
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30.0),
                  child: IconButton(
                    splashRadius: 20,
                    iconSize: 30,
                    icon: const Icon(
                      Icons.rotate_left_outlined,
                      color: Colors.white,
                    ),
                    onPressed: flipCamera,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoViewWidget(File file) {
    return Stack(
      fit: StackFit.expand,
      children: [
        PhotoView(
          imageProvider: FileImage(file),
        ),
        Positioned(
          height: 60,
          bottom: 0,
          width: MediaQuery.of(context).size.width,
          child: Container(
            color: Colors.black.withOpacity(0.6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30.0),
                  child: IconButton(
                    splashRadius: 20,
                    iconSize: 30,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _photoViewController.add(null);
                    },
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30.0),
                  child: IconButton(
                    splashRadius: 20,
                    iconSize: 30,
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Modular.to.pop(file);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showCameraException(CameraException e) {
    print('Error: ${e.code}\nError Message: ${e.description}');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cảnh báo'),
          content: Text('Error: ${e.code}\n${e.description}'),
          actions: [
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: _initializeCompleter.future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder<File?>(
            stream: _photoViewController.stream,
            builder: (context, snap) {
              if (snap.hasData) {
                return _photoViewWidget(snap.data!);
              }
              return Stack(
                alignment: AlignmentDirectional.topStart,
                fit: StackFit.loose,
                children: [
                  ZoomableWidget(
                      child: _cameraPreviewWidget(),
                      onTapUp: (scaledPoint) {
                        controller!.setPointOfInterest(scaledPoint);
                      },
                      onZoom: (zoom) {
                        print('zoom');
                        if (zoom < 11) {
                          controller!.zoom(zoom);
                        }
                      }),
                  _cameraControlWidget(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class ZoomableWidget extends StatefulWidget {
  final Widget? child;
  final Function? onZoom;
  final Function? onTapUp;

  const ZoomableWidget({Key? key, this.child, this.onZoom, this.onTapUp})
      : super(key: key);

  @override
  _ZoomableWidgetState createState() => _ZoomableWidgetState();
}

class _ZoomableWidgetState extends State<ZoomableWidget> {
  Matrix4 matrix = Matrix4.identity();
  double zoom = 1;
  double prevZoom = 1;
  bool showZoom = false;
  Timer? t1;

  bool handleZoom(newZoom) {
    if (newZoom >= 1) {
      if (newZoom > 10) {
        return false;
      }
      setState(() {
        showZoom = true;
        zoom = newZoom;
      });

      if (t1 != null) {
        t1!.cancel();
      }

      t1 = Timer(const Duration(milliseconds: 2000), () {
        setState(() {
          showZoom = false;
        });
      });
    }
    widget.onZoom!(zoom);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onScaleStart: (scaleDetails) {
          print('scalStart');
          setState(() => prevZoom = zoom);
          //print(scaleDetails);
        },
        onScaleUpdate: (ScaleUpdateDetails scaleDetails) {
          var newZoom = (prevZoom * scaleDetails.scale);

          handleZoom(newZoom);
        },
        onScaleEnd: (scaleDetails) {
          print('end');
          //print(scaleDetails);
        },
        onTapUp: (TapUpDetails det) {
          final RenderBox box = context.findRenderObject() as RenderBox;
          final Offset localPoint = box.globalToLocal(det.globalPosition);
          final Offset scaledPoint =
          localPoint.scale(1 / box.size.width, 1 / box.size.height);
          // TODO IMPLIMENT
          // widget.onTapUp(scaledPoint);
        },
        child: Stack(children: [
          Column(
            children: <Widget>[
              Expanded(
                child: widget.child!,
              ),
            ],
          ),
          Visibility(
            visible: showZoom, //Default is true,
            child: Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        valueIndicatorTextStyle: const TextStyle(
                            color: Colors.amber,
                            letterSpacing: 2.0,
                            fontSize: 30),
                        valueIndicatorColor: Colors.blue,
                        // This is what you are asking for
                        inactiveTrackColor: Color(0xFF8D8E98),
                        // Custom Gray Color
                        activeTrackColor: Colors.white,
                        thumbColor: Colors.red,
                        overlayColor: Color(0x29EB1555),
                        // Custom Thumb overlay Color
                        thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                        overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 20.0),
                      ),
                      child: Slider(
                        value: zoom,
                        onChanged: (double newValue) {
                          handleZoom(newValue);
                        },
                        label: "$zoom",
                        min: 1,
                        max: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //maintainSize: bool. When true this is equivalent to invisible;
            //replacement: Widget. Defaults to Sizedbox.shrink, 0x0
          )
        ]));
  }
}
