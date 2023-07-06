import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location_geocoder/location_geocoder.dart';
import 'package:panda/function/global_snackbar.dart';
import 'package:panda/models/add_service_request_model.dart';
import 'package:panda/provider/service_provider.dart';
import 'package:panda/provider/service_request_provider.dart';
import 'package:panda/provider/uploader_provider.dart';
import 'package:panda/screens/home/services/service_request/componets/assistance_form.dart';
import 'package:panda/screens/home/services/service_request/componets/estimated_cost.dart';
import 'package:panda/screens/home/services/service_request/componets/finding_ur_technician.dart';
import 'package:panda/screens/home/services/service_request/componets/select_paymnet_method.dart';
import 'package:panda/screens/home/services/service_request/componets/service_request_form.dart';
import 'package:panda/screens/home/services/service_request/componets/where_are_you_form.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../function/time_picker.dart';
import '../../../../provider/nearby_provider.dart';
import '../../../../util/api.dart';
import '../../../../util/constants.dart';
import 'componets/assigned_technician.dart';

class RequestBottomSheetWidget extends StatefulWidget {
  final String title;
  final String? currentPosition;
  final Function(String value) onClickNext;
  final Function(String value) onClickBack;
  final Function onClickClose;
  double latitude;
  double longtude;

   RequestBottomSheetWidget({
     required this.onClickClose,
    required this.title,
     required this.currentPosition,
    required this.onClickNext,
    required this.onClickBack,
    required this.latitude,
    required this.longtude,

    Key? key}) : super(key: key);

  @override
  State<RequestBottomSheetWidget> createState() => _RequestBottomSheetWidgetState();
}

class _RequestBottomSheetWidgetState extends State<RequestBottomSheetWidget> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final LocatitonGeocoder geocoder = LocatitonGeocoder(googleAPIkey);
  String serviceType = "";
  String serviceId = "";
  bool isScrolled = false;
  String vehicleId = "";
  String paymentId = "";
  double requestLat = 0;
  double requestLong = 0;

  String assistanceType = 'I need my Vehicle towed';
  String? dropdownValue;
  String? currentPlaceAddress;
  String serviceLocation = "";
  String distinationLocation = "";
  bool isNotePressed = false;
  late  TextEditingController locationController;
  late  TextEditingController destinationController;
  late  TextEditingController noteController;

  final ImagePicker imagePicker = ImagePicker();
  List<XFile> images = [];
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);



  DateTime dateTime = DateTime.now();

  void setDropdownValue(String value){
    setState(() {
      dropdownValue = value;
    });
  }
  

  Future pickDateTime() async{
    DateTime? date = await pickDate(context,dateTime);
    if(date == null) return;

    TimeOfDay? time = await pickTime(context,dateTime,date.day);
    if(time == null) return;
    final newDateTime = DateTime
      (date.year,date.month,date.day,time.hour,time.minute);
      setState(() {
        dateTime = newDateTime;
      });
   }


  void notePressed(bool value){
    setState(() {
      isNotePressed = value;
    });
  }

  void onClickSave(){
    setState(() {
      isNotePressed = !isNotePressed;
    });
  }

  void currentServiceLocationSetter () async{
    final address = await geocoder.findAddressesFromCoordinates(Coordinates(widget.latitude,widget.longtude));
    setState(() {
      currentPlaceAddress = address.first.addressLine;
    });
  }

  void onClickNext(){


    if(widget.title == whereAreYou  ){

      if (true )  {
        FocusScope.of(context).unfocus();
        if(vehicleId.isEmpty){
          displayInfoSnackBar(context, "please select vehicle first");
        }else{
          if(locationController.text.isEmpty){
            displayInfoSnackBar(context, "please enter your location");
          } else if(dropdownValue == null){
            displayInfoSnackBar(context, "please select service type");
          }else{

            if(context.read<UploaderProvider>().uploadedFileList.length != images.length )
            {
              displayInfoSnackBar(context, "please wait until your attachments uploaded ");
            }else{
              widget.onClickNext(serviceType);
            }
          }
        }

      }
    }else if(widget.title == selectPaymentMethod ){
      if(paymentId == ""){
        displayInfoSnackBar(context, "please select payment method first");
      }else{
        requestService();
      }
    } else{
      widget.onClickNext(serviceType);
    }
  }

  void requestService() async {

    if(currentPlaceAddress == null ){
      final address = await geocoder.findAddressesFromQuery(locationController.text);
      setState(() {
        requestLat = address.first.coordinates.longitude ?? 0.0;
        requestLong = address.first.coordinates.latitude ?? 0.0;
      });
    }else{
      requestLat = widget.latitude;
      requestLong = widget.longtude;
    }
    AddServiceRequestModel addServiceRequestModel =
      AddServiceRequestModel(
          serviceId: serviceId,
          longitude:  requestLong,
          latitude: requestLat,
          name: locationController.text,
          date: dateTime.toIso8601String(),
          time: dateTime.toIso8601String(),
          note: noteController.text,
          title: dropdownValue ?? "",
          paymentId: paymentId
      );

      await context.read<ServiceRequestProvider>().sendServiceRequest(context, addServiceRequestModel, context.read<UploaderProvider>().uploadedFileList,vehicleId);
      widget.onClickNext(serviceType);


  }

  void onClickBack(){
    if(isNotePressed){
      setState(() {
        isNotePressed = false;
      });
    }else{
      setState(() {
        isScrolled = false;
        widget.onClickBack(serviceType);
      });
    }

  }


  setLocation(String serviceLocation,String distinationLocation){
    setState((){
      serviceLocation = serviceLocation;
      distinationLocation = distinationLocation;
    });
  }


  void setServiceTypeForm(String val){
    currentServiceLocationSetter();

    setState(() {
      serviceType = val;
    });
    widget.onClickNext(serviceType);
  }

  void setServiceId(String val){
    setState(() {
      serviceId = val;
    });
  }

  void setPaymentId(String val){
    setState(() {
      paymentId = val;
    });
  }

  void setVehicleId(String val){
    setState(() {
      vehicleId = val;
      // vehicleId.insert(0, val);
    });
  }

  void removeVehicleId(String index){
    setState(() {
      // vehicleId.remove(index);
    });
  }

  void setAssistanceTypeForm(String val){
    setState(() {
      assistanceType = val;
    });
  }

  void cancelServiceRequest(){
    context.read<ServiceRequestProvider>().cancelServiceRequest(context, serviceId);
  }

  void sendServiceRequest(String id) async {
    await context.read<ServiceRequestProvider>().updateServiceRequestByStatus(context, id);
    widget.onClickNext(serviceType);
    Timer(const Duration(seconds: 3), assignTechnicianShower);
  }

  void imageInit(){
    setState((){
      images = [];
    });
  }
  void noNearBy() async {
     widget.onClickClose();
  }

@override
  void initState() {
  locationController = TextEditingController();
  destinationController = TextEditingController();
  noteController = TextEditingController();

  super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<ServiceProvider>().getAllServices(context,false);
      context.read<UploaderProvider>().initialValue();
    });
  }

  void assignTechnicianShower(){
    widget.onClickClose();
  }


  void currentLocationSetter() {
    setState(() {
      currentPlaceAddress = null;
    });
  }

  @override
  void dispose() {
    locationController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  void backToHome(){
    noNearBy();
  }

  void refreshNearByTech(){
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<NearByProvider>().nearBy(context, widget.latitude, widget.longtude,backToHome,false);
    });
  }

  void _onRefresh() async{
    await Future.delayed(const Duration(milliseconds: 1000));
    refreshNearByTech();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Container(
        color: Colors.white,
        child: SizedBox(
                height: widget.title == assignedTechnician?  height * 0.15   : height * 0.85,
                child:SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  header: WaterDropHeader(),
                  footer: CustomFooter(
                    builder: (BuildContext context,LoadStatus? mode){
                      Widget body ;
                      if(mode==LoadStatus.idle){
                        body =  const Text("pull up load");
                      }
                      else if(mode==LoadStatus.loading){
                        body =  const CupertinoActivityIndicator();
                      }
                      else if(mode == LoadStatus.failed){
                        body = const Text("Load Failed!Click retry!");
                      }
                      else if(mode == LoadStatus.canLoading){
                        body = const Text("release to load more");
                      }
                      else{
                        body = const Text("No more Data");
                      }
                      return  Container(
                        height: 55.0,
                        child: Center(child:body),
                      );
                    },
                  ),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                        children: [

                          Column(
                                children: [

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Visibility(
                                          visible:widget.title == assignedTechnician? false:
                                          widget.title == estimatedCost? false: widget.title == findingYourTechnician? false:true,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              IconButton(
                                                  onPressed: (){
                                                    onClickBack();
                                                  },
                                                  icon: const Icon(Icons.arrow_back_ios)
                                              ),
                                            ],
                                          )
                                      ),

                                      const Spacer(),

                                      Visibility(
                                        visible: (widget.title == assistance || widget.title == whereAreYou) &&  !isNotePressed,
                                        child: Image.asset(
                                          "lib/assets/mechanic.png",
                                          height: 120,
                                          width: 170,
                                        ),
                                      ),

                                      const Spacer(),

                                    ],
                                  ),


                                  Visibility(
                                    visible: widget.title == serviceRequest,
                                      child: serviceRequestForm(
                                        setServiceId: setServiceId,
                                        serviceType: serviceType,
                                        getFunc: setServiceTypeForm,)
                                  ),

                                  Visibility(
                                      visible: widget.title == assistance,
                                      child: AssistanceForm(assistanceType: assistanceType,getFunc: setAssistanceTypeForm)
                                  ),

                                  Visibility(
                                      visible: widget.title == whereAreYou,
                                      child:
                                          Form(
                                            key:_formKey ,
                                              child:
                                          WhereAreYou(removeVehicleId:removeVehicleId,currentLocationSetter:currentLocationSetter, dateTime: dateTime,pickDateTime: pickDateTime, images: images, setVehicleId: setVehicleId ,vehicleId: vehicleId,  serviceType: serviceType, dropdownValue: dropdownValue,getSetDropdownFunc: setDropdownValue, isNotePressed: isNotePressed, getNotePressedFunc:notePressed, getFunc: onClickNext, locationController: locationController,destinationController: destinationController, noteController: noteController, currentPlaceAddress: currentPlaceAddress, imageInit: imageInit,))),


                                  Visibility(
                                      visible: widget.title == findingYourTechnician,
                                      child: FindingYourTechnician(noNearBy:noNearBy,sendServiceRequest:sendServiceRequest,cancelServiceRequest: cancelServiceRequest , longitude: widget.longtude, latitude: widget.latitude)
                                  ),
                                  Visibility(
                                    visible: widget.title == assignedTechnician,
                                    child: const AssignedTechnician()
                                  ),
                                  Visibility(
                                      visible: widget.title == selectPaymentMethod,
                                      child:  SelectPaymentMethod(paymentId: paymentId,setPaymentId: setPaymentId,)
                                  ),

                                  Visibility(
                                    visible:widget.title == assignedTechnician? false:
                                    widget.title == estimatedCost? false: widget.title == findingYourTechnician? false:true,
                                    child: Visibility(
                                      visible: serviceId != "",
                                    child: ElevatedButton(
                                        onPressed: () {
                                          isNotePressed?
                                          onClickSave()
                                              :
                                          onClickNext();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: const Color.fromARGB(255, 48, 226, 152),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 10),
                                        ),
                                        child: isNotePressed?  const Text('Save') : const Text('Next') ,
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                        ],
                      ),
                  ),
                ),
                ),
    );
  }
}
