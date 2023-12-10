import 'dart:io';
import 'package:connect_1000/UI/custom_ctrl.dart';
import 'package:connect_1000/models/profile.dart';
import 'package:connect_1000/providers/diachimodel.dart';
import 'package:connect_1000/providers/profileviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../providers/mainviewmodel.dart';
import 'AppConstant.dart';


class SubPageProfile extends StatelessWidget {
  SubPageProfile({super.key});
  static int idpage = 1;
  XFile? image;

  Future<void> init(DiachiModel dcmodel, ProfileViewModel viewmodel) async {
    Profile profile = Profile();
    viewmodel.displaySpinner();

    if (dcmodel.listCity.isEmpty ||
        dcmodel.curCityId != profile.user.provinceid ||
        dcmodel.curDictId != profile.user.districtid ||
        dcmodel.curWardId != profile.user.wardid) {
      await dcmodel.initialize(profile.user.provinceid, profile.user.districtid,
          profile.user.wardid);
    }
    viewmodel.hideSpinner();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final profile = Profile();
    final dcmodel = Provider.of<DiachiModel>(context);
    final viewmodel = Provider.of<ProfileViewModel>(context);
    Future.delayed(Duration.zero, () => init(dcmodel, viewmodel));
    return GestureDetector(
        onTap: () => MainViewModel().closeMenu(),
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //--start header
                  createHeader(size, profile, viewmodel),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomInputTextFormField(
                              title: 'Điện thoại',
                              value: profile.user.phone,
                              width: size.width * 0.45,
                              callback: (output) {
                                profile.user.phone = output;
                                viewmodel.setModified();
                                viewmodel.updatescreen();
                              },
                              type: TextInputType.phone,
                            ),
                            CustomInputTextFormField(
                              title: 'Ngày sinh:',
                              value: profile.user.birthday,
                              width: size.width * 0.45,
                              callback: (output) {
                                if (AppConstant.isDate(output)) {
                                  profile.user.birthday = output;
                                }
                                viewmodel.setModified();
                                viewmodel.updatescreen();
                              },
                              type: TextInputType.datetime,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomPlaceDropDown(
                                width: size.width * 0.45,
                                title: "Thành phố/ Tỉnh: ",
                                valueid: profile.user.provinceid,
                                valuename: profile.user.provincename,
                                callback: ((outputId, outputName) async {
                                  viewmodel.displaySpinner();
                                  profile.user.provinceid = outputId;
                                  profile.user.provincename = outputName;
                                  await dcmodel.setCity(outputId);
                                  profile.user.districtid = 0;
                                  profile.user.wardid = 0;
                                  profile.user.districtname = "Không có";
                                  profile.user.wardname = "Không có";
                                  viewmodel.setModified();

                                  viewmodel.hideSpinner();
                                }),
                                list: dcmodel.listCity),
                            CustomPlaceDropDown(
                                width: size.width * 0.45,
                                title: "Quận/Huyện: ",
                                valueid: profile.user.districtid,
                                valuename: profile.user.districtname,
                                callback: ((outputId, outputName) async {
                                  viewmodel.displaySpinner();
                                  profile.user.districtid = outputId;
                                  profile.user.districtname = outputName;
                                  await dcmodel.setDictrict(outputId);
                                  profile.user.wardid = 0;
                                  profile.user.wardname = "Không có";
                                  viewmodel.setModified();
                                  viewmodel.hideSpinner();
                                }),
                                list: dcmodel.listDistrict)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomPlaceDropDown(
                                width: size.width * 0.45,
                                title: "Phường/Xã",
                                valueid: profile.user.wardid,
                                valuename: profile.user.wardname,
                                callback: ((outputId, outputName) async {
                                  viewmodel.displaySpinner();
                                  profile.user.wardid = outputId;
                                  profile.user.wardname = outputName;
                                  await dcmodel.setWardId(outputId);
                                  viewmodel.setModified();
                                  viewmodel.hideSpinner();
                                }),
                                list: dcmodel.listWard),
                            CustomInputTextFormField(
                              title: 'Tên đường/Số nhà',
                              value: profile.user.address,
                              width: size.width * 0.45,
                              callback: (output) {
                                profile.user.address = output;
                                viewmodel.setModified();
                                viewmodel.updatescreen();
                              },
                              type: TextInputType.streetAddress,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: size.width * 0.3,
                          width: size.width * 0.3,
                          child: QrImageView(
                            data: '{userid:' + profile.user.id.toString() + '}',
                            version: QrVersions.auto,
                            gapless: false,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              viewmodel.status == 1 ? CustomSpinner(size: size) : Container(),
            ],
          ),
        ));
  }

  Container createHeader(
      Size size, Profile profile, ProfileViewModel viewModel) {
    return Container(
      height: size.height * 0.20,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppConstant.mainColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60),
          bottomRight: Radius.circular(60),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                  Text(
                    profile.student.diem.toString(),
                    style: AppConstant.textbodywhite,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: viewModel.updateavartar == 1 && image != null
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.file(
                                File(image!.path),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                viewModel.uploadAvatar(image!);
                              },
                              child: Container(
                                  color: Colors.white,
                                  child: Icon(size: 30, Icons.save)),
                            ),
                          )
                        ],
                      )
                    : GestureDetector(
                        onTap: () async {
                          final ImagePicker _picker = ImagePicker();
                          image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          viewModel.setupdatedavartar();
                        },
                        child: CustomAvatar1(size: size)),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                profile.user.first_name,
                style: AppConstant.textbodyfocuswhite,
              ),
              Row(
                children: [
                  Text(
                    'MSSV: ',
                    style: AppConstant.textbodywhite,
                  ),
                  Text(
                    profile.student.mssv,
                    style: AppConstant.textbodywhitebold,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Lớp: ',
                    style: AppConstant.textbodywhitebold,
                  ),
                  Text(
                    profile.student.tenlop,
                    style: AppConstant.textbodywhitebold,
                  ),
                  profile.student.duyet == 0
                      ? Text(
                          "(Chưa Duyệt)",
                          style: AppConstant.textbodywhite,
                        )
                      : Text(''),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Vai trò: ',
                    style: AppConstant.textbodywhite,
                  ),
                  profile.user.role_id == 4
                      ? Text(
                          "Sinh viên",
                          style: AppConstant.textbodywhitebold,
                        )
                      : Text(
                          "Giảng viên",
                          style: AppConstant.textbodywhitebold,
                        ),
                ],
              ),
              SizedBox(
                width: size.width * 0.4,
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: viewModel.modified == 1
                        ? GestureDetector(
                            onTap: () {
                              viewModel.updateProfile();
                            },
                            child: Icon(Icons.save))
                        : Container()),
              )
            ],
          )
        ],
      ),
    );
  }
}
