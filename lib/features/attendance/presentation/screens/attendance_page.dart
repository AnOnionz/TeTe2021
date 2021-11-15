import 'dart:async';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:tete2021/core/common/widgets/form_item.dart';
import 'package:tete2021/core/common/widgets/separator.dart';
import 'package:tete2021/core/platform/package_info.dart';
import 'package:tete2021/core/utils/dialogs.dart';
import '../../../../core/common/constants.dart';
import '../../../../features/attendance/domain/entities/attendance_type.dart';
import '../../../../features/attendance/presentation/blocs/attendance_bloc.dart';
import '../../../../features/attendance/presentation/blocs/map_bloc.dart';
import '../../../../core/common/widgets/preview_image_dialog.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final Completer<GoogleMapController> _mapController = Completer();
  TextEditingController ctlMaNV = TextEditingController();
  LocationData? location;
  bool _mapLoading = true;
  late final MapBloc _mapBloc = Modular.get<MapBloc>()..add(MapStarted());
  late final CheckAttendanceBloc _checkAttendanceBloc =
      Modular.get<CheckAttendanceBloc>();
  late final AttendanceBloc _attendanceBloc = Modular.get<AttendanceBloc>();
  File? _image;
  String maNV = '';
  List<String> listSp = [];
  final picker = ImagePicker();
  late int id = 1;
  List<AttendanceType> rdList = [CheckIn(), CheckOut()];

  //ios
//   Future getImage() async {
//     final pickedFile = await picker.getImage(
//         source: ImageSource.camera, maxHeight: 480, maxWidth: 640);
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//   void previewImage(File image) async {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         return PreviewImageDialog(
//           textButton: 'Chụp lại',
//           image: image,
//           onTap: () {
//             getImage();
//             Navigator.pop(context);
//           },
//         );
//       },
//     );
//   }

  //android
  Future getImage() async {
    final image = await Modular.to.pushNamed('/image');
    setState(() {
      if (image != null) {
        _image = image as File;
      } else {
        print('No image selected.');
      }
    });
  }

  void previewImage(File image) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return PreviewImageDialog(
          textButton: 'Chụp lại',
          image: image,
          onTap: () {
            getImage();
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _attendanceBloc.close();
    _checkAttendanceBloc.close();
    _mapBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Stack(
              children: [
                BlocConsumer<MapBloc, MapState>(
                  listener: (context, state) {
                    if (state is MapLoaded) {
                      setState(() {
                        location = state.position;
                      });
                      _mapController.future.then((value) => value.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                              bearing: 10,
                              target: LatLng(state.position!.latitude! - .0006,
                                  state.position!.longitude!),
                              zoom: 18))));
                    }
                  },
                  bloc: _mapBloc,
                  builder: (context, state) {
                    if (state is MapLocationDenied) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              IconlyBold.danger,
                              color: kRedColor,
                              size: 30,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 320,
                                ),
                                child: const Text(
                                  "Quyền vị trí bị từ chối, vui lòng cấp lại quyền trong phần cài đặt của thiết bị",
                                  style: kStyleBlack16,
                                  textAlign: TextAlign.center,
                                )),
                          ],
                        ),
                      );
                    }
                    if (state is MapFailed) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              IconlyBold.danger,
                              color: kRedColor,
                              size: 30,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Không thể xác định vị trí",
                              style: kStyleBlack16,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _mapBloc.add(MapStarted());
                              },
                              child: const Text("Thử lại"),
                            ),
                          ],
                        ),
                      );
                    }
                    return Stack(
                      children: [
                        AnimatedOpacity(
                          curve: Curves.fastOutSlowIn,
                          opacity: _mapLoading ? 0 : 1.0,
                          duration: const Duration(milliseconds: 600),
                          child: GoogleMap(
                            mapType: MapType.normal,
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            initialCameraPosition: const CameraPosition(
                              target: LatLng(14.2829724, 107.4188084),
                              zoom: 6,
                            ),
                            onMapCreated:
                                (GoogleMapController controller) async {
                              _mapController.complete(controller);
                              setState(() {
                                _mapLoading = false;
                              });
                            },
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            zoomControlsEnabled: false,
                            compassEnabled: false,
                          ),
                        ),
                        Positioned(
                          bottom: 50,
                          left: 50,
                          right: 50,
                          child: location == null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    CupertinoActivityIndicator(
                                      radius: 15,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Đang định vị...",
                                      style: kStyleBlack16,
                                    )
                                  ],
                                )
                              : const SizedBox(),
                        ),
                      ],
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: FadeInUp(
                    animate: location != null,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      constraints: const BoxConstraints(
                        minHeight: 100,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text('Loại chấm công: ',
                                    style: kStyleBlack17),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                SizedBox(
                                  height: 20,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: rdList.map((data) {
                                      return Theme(
                                        data: ThemeData(
                                          unselectedWidgetColor:
                                              const Color(0xff205527),
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: Radio(
                                                value: data.index,
                                                groupValue: id,
                                                activeColor: kRedColor,
                                                onChanged: (val) {
                                                  if (listSp.isEmpty) {
                                                    setState(() {
                                                      id = data.index;
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            GestureDetector(
                                              onTap: () {
                                                if (listSp.isEmpty) {
                                                  setState(() {
                                                    id = data.index;
                                                  });
                                                }
                                              },
                                              child: Text(
                                                data.name,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xff205527),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: MySeparator(color: Color(0XFFC5C5C5)),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Thời gian: ' +
                                        DateFormat('hh:mm dd/MM/yyyy')
                                            .format(DateTime.now()),
                                    style: const TextStyle(
                                        fontFamily: 'Helvetica-regular',
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: <Widget>[
                                        const Text(
                                          'Tọa độ: ',
                                          style: kStyleBlack17,
                                        ),
                                        BlocBuilder(
                                          bloc: _mapBloc,
                                          builder: (context, state) {
                                            if (state is MapLoaded) {
                                              return const Text(
                                                'Đã xác định vị trí',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xff205527),
                                                ),
                                              );
                                            }
                                            return const Text(
                                              "Đang định vị...",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  _image == null
                                      ? getImage()
                                      : previewImage(_image!);
                                },
                                child: _image == null
                                    ? Container(
                                        width: 48,
                                        height: 48,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF6F6F6),
                                          border: Border.all(
                                              color: const Color(0XFFDBDBDB),
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        child: const Icon(
                                          IconlyLight.camera,
                                          size: 35,
                                        ))
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        child: Image.file(_image!,
                                            width: 48,
                                            height: 48,
                                            fit: BoxFit.cover),
                                      ),
                              )
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: MySeparator(color: Color(0XFFC5C5C5)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                listSp.isEmpty
                                    ? const Text(
                                        'Danh sách chấm công: chưa có PG',
                                        style: kStyleBlack16,
                                      )
                                    : const Text(
                                        'Danh sách chấm công: ',
                                        style: kStyleBlack16,
                                      ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: listSp
                                      .map((e) => Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(e,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color:
                                                          Color(0xff205527))),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 5),
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      listSp.removeAt(
                                                          listSp.indexOf(e));
                                                    });
                                                  },
                                                  child: const Icon(
                                                    IconlyBold.closeSquare,
                                                    color: kRedColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: FormItem(
                                  hint: 'Mã PG',
                                  controller: ctlMaNV,
                                  inputFormatter: [
                                    FilteringTextInputFormatter.deny(
                                        RegExp("[ ]")),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: BlocConsumer<CheckAttendanceBloc,
                                        CheckAttendanceState>(
                                    bloc: _checkAttendanceBloc,
                                    listener: (context, state) {
                                      if (state is CheckAttendanceSuccess) {
                                        setState(() {
                                          ctlMaNV.clear();
                                          listSp.add(
                                              '${state.info.spCode}    ${state.info.fullName}');
                                        });
                                      }
                                      if (state is CheckAttendanceFailure) {
                                        setState(() {
                                          ctlMaNV.clear();
                                        });
                                      }
                                    },
                                    builder: (context, state) {
                                      if (state is CheckAttendanceLoading) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Material(
                                            color: const Color(0xff205527)
                                                .withOpacity(0.38),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: InkWell(
                                                onTap: () {},
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  alignment: Alignment.center,
                                                  child:
                                                      const CupertinoActivityIndicator(),
                                                )),
                                          ),
                                        );
                                      }
                                      return Material(
                                        borderRadius: BorderRadius.circular(5.0),
                                        child: InkWell(

                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              if (id <= 0) {
                                                showMessage(message:"Vui lòng chọn loại chấm công", type: DialogType.shock);

                                                return;
                                              }
                                              if (ctlMaNV.text.isEmpty) {
                                                showMessage(message: "Vui lòng nhập mã PG", type: DialogType.shock);
                                                return;
                                              }
                                              if (listSp.firstWhere(
                                                      (code) =>
                                                          code.split(' ')[0] ==
                                                          ctlMaNV.text,
                                                      orElse: () => '') !=
                                                  '') {
                                                showMessage(message: "PG đã được thêm vào danh sách chấm công", type: DialogType.shock);
                                                return;
                                              }

                                              _checkAttendanceBloc.add(
                                                  CheckAttendance(
                                                      type: rdList[id - 1],
                                                      spCode: ctlMaNV.text
                                                          .toUpperCase()));
                                            },
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            child:
                                            Container(
                                                width: 40,
                                                height: 40,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: rdList[id - 1] is CheckIn
                                                      ? kGreenColor.withOpacity(0.2)
                                                      : kRedColor.withOpacity(0.2),
                                                  border: Border.all(
                                                      color: rdList[id - 1] is CheckIn
                                                          ? kGreenColor.withOpacity(0.2)
                                                          : kRedColor.withOpacity(0.2),
                                                      width: 1),
                                                  borderRadius:
                                                  BorderRadius.circular(5.0),
                                                ),
                                                child: const Icon(
                                                  IconlyLight.addUser, size: 28,)
                                            )),
                                      );
                                    }),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          BlocBuilder<AttendanceBloc, AttendanceState>(
                            bloc: _attendanceBloc,
                            builder: (context, state) {
                              if (state is AttendanceLoading) {
                                return Container(
                                    height: 40,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: rdList[id - 1] is CheckIn
                                          ? kGreenColor
                                          : kRedColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: CupertinoActivityIndicator(
                                        radius: 15,
                                      ),
                                    ));
                              }
                              return Material(
                                color: rdList[id - 1] is CheckIn
                                    ? kGreenColor
                                    : kRedColor,
                                borderRadius: BorderRadius.circular(5),
                                child: InkWell(
                                  onTap: () async {
                                    if (_image == null) {
                                      showMessage(message:"Vui lòng chụp hình để thực hiện chấm công", type: DialogType.shock);
                                      return;
                                    }
                                    if (location == null) {
                                      showMessage(message: "Tọa dộ chưa được xác định", type: DialogType.shock);
                                    }
                                    if (listSp.isEmpty) {
                                      showMessage(message: "Vui lòng thêm PG để chấm công", type: DialogType.shock);
                                      return;
                                    }
                                    _attendanceBloc.add(Attendance(
                                        type: rdList[id - 1],
                                        spCode: listSp,
                                        position: location!,
                                        img: _image!));
                                  },
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                    height: 40,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      rdList[id - 1].name,
                                      style: kStyleWhite16,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      Modular.to.pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(MyPackageInfo.version, style: kStyleBlack14,),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
