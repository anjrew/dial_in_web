import 'package:dial_in_v1/classes/error_reporting.dart';
import 'package:dial_in_v1/data/flavour_descriptors.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:dial_in_v1/database_functions.dart';
import 'package:dial_in_v1/data/profile.dart';
import 'package:dial_in_v1/data/functions.dart';
import 'package:dial_in_v1/widgets/profile_page_widgets.dart';
import 'dart:async';
import 'package:dial_in_v1/data/strings.dart';
import 'package:dial_in_v1/data/item.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dial_in_v1/pages/profile_pages/profile_page.dart';
import 'package:dial_in_v1/blocs/main_bloc.dart';

class ProfilePageModel extends Model {

    MainBloc _mainBloc;
    String _userNameReferance;
    Profile _profile;
    RelatedProfilesListBloc relatedProfilesListBloc;
    bool fullyInitilised = false;

    BehaviorSubject<List<FlavourDescriptor>> _savedDescriptorListObservable =
        new BehaviorSubject<List<FlavourDescriptor>>();
    Stream<List<FlavourDescriptor>> get savedDescriptorsStream =>
        _savedDescriptorListObservable.stream;

    String heroTag;

    String get profileTypeTitle => _profile.getProfileTypeTitle();

    /// Image URL
    BehaviorSubject<String> _imageUrlObservable = new BehaviorSubject<String>();
    Stream<String> get imageUrlStream => _imageUrlObservable.stream;
    String get imageUrl => _profile.imageUrl;
    set imageUrl(String imageUrl) {
        _profile.imageUrl = imageUrl;
        _profileStreamController.add(_profile);
        _imageUrlObservable.add(imageUrl);
    }

    String get placeholder => _profile.placeholder;

    Item getItem(String databaseId) {
        return _profile.getItem(databaseId);
    }

    dynamic getItemValue(String databaseId) {
        return _profile.getItemValue(databaseId);
    }

    /// Profile
    BehaviorSubject<Profile> _profileStreamController;
    Stream<Profile> get profileStream => _profileStreamController.stream;

    /// Profile getters
    String get objectId => _profile.objectId;
    String get userId => _profile.userId;
    String get databaseId => _profile.databaseId;
    ProfileSavePermission get isValidForSave => _profile.isValidForSave();

    /// Isediting
    BehaviorSubject<bool> _isEditingStreamController;
    Stream<bool> get isEditingStream => _isEditingStreamController.stream;
    Sink<bool> get isEdtingSink => _isEditingStreamController.sink;

    /// Is public
    BehaviorSubject<bool> _isPublicObservable = new BehaviorSubject<bool>();
    Stream<bool> get isPublicStream => _isPublicObservable.stream;
    set isPublic(bool value) => _isPublicObservable.add(value);

    bool isFromUserFeed;
    bool isOldProfile;
    bool isCopying;
    bool _isNew;
    ProfileType type;

    bool get isEditing => _isEditingStreamController.value;
    bool isCalculating = false;

    ProfilePageModel(
            this._mainBloc,
            this._userNameReferance,
            ProfileType type,
            this.isFromUserFeed,
            _isEditing,
            this.isOldProfile,
            this.isCopying,
            this._isNew,
            {@required this.heroTag
        }) 
        {
            this.type = type;
            _profileStreamController = new BehaviorSubject<Profile>();
            _isEditingStreamController = new BehaviorSubject<bool>();
            _isEditingStreamController.add(_isEditing);
            if (type == ProfileType.recipe) {
                _savedDescriptorListObservable.add(new List<FlavourDescriptor>());
            }
        }

    Future initialiseProfile(Profile profile) async {
        this.profile = profile;
        isPublic = _profile.isPublic;

        if (this.type != ProfileType.recipe) {
            relatedProfilesListBloc = new RelatedProfilesListBloc(
            _mainBloc, this._profile, !isFromUserFeed);
        }
        else{
            sortOutIncomingFlavourDescriptorvalue(this._profile.getItemValue(DatabaseIds.descriptors));
        }
        _profileStreamController.add(_profile);
        _isPublicObservable.add(this._profile.isPublic);
        _imageUrlObservable.add(this._profile.imageUrl);
    }

    String appBarTitle(bool isEditing) {
        if (isFromUserFeed != null &&
            isFromUserFeed &&
            _userNameReferance != null &&
            _userNameReferance != '') {
        return "$_userNameReferance's ${_profile.getProfileTypeTitle()}";
        } else {
        if (_isNew || isCopying) {
            return StringLabels.newe +
                ' ' +
                Functions.getProfileTypeString(_profile.type);
        } else if (isEditing != null) {
            if (isEditing) {
            return StringLabels.editing +
                ' ' +
                Functions.getProfileTypeString(_profile.type);
            } else {
            return Functions.getProfileTypeString(_profile.type);
            }
        } else {
            return Functions.getProfileTypeString(_profile.type);
        }
        }
    }

    int getRatioValue(String type) {
        int result;

        switch (type) {
        case DatabaseIds.brewingDose:
            result = _profile.getItemValue(DatabaseIds.brewingDose);
            break;
        case DatabaseIds.yielde:
            result = _profile.getItemValue(DatabaseIds.yielde);
            break;
        case DatabaseIds.brewWeight:
            result = _profile.getItemValue(DatabaseIds.brewWeight);
            break;
        }
        return result ?? 0;
    }

    Future<Profile> saveProfile(Profile profile) async {
        return await Dbf.saveProfile(profile);
    }

    void dispose() {
        _isEditingStreamController.close();
        _isPublicObservable.close();
        _imageUrlObservable.close();
    }

    void estimateBrewRatio(BrewRatioType type) {
        isCalculating = true;

        double _dose =
            Functions.getIntValue(_profile.getItemValue(DatabaseIds.brewingDose))
                .toDouble();
        double _yielde =
            Functions.getIntValue(_profile.getItemValue(DatabaseIds.yielde))
                .toDouble();
        double _brewWeight =
            Functions.getIntValue(_profile.getItemValue(DatabaseIds.brewWeight))
                .toDouble();

        double result;

        if (type == BrewRatioType.doseYield) {
        result = (_brewWeight - (_dose * 1.9)).toDouble();
        setProfileItemValue(DatabaseIds.yielde, result);
        } else {
        result = ((_dose * 1.9) + _yielde).toDouble();
        setProfileItemValue(DatabaseIds.brewWeight, result);
        }
    }

        set profile(Profile profile) {
            _profile = profile;
            _profileStreamController.sink.add(_profile);
        }

        void setProfileItemValue(String id, dynamic value) {
            _profile.setItemValue(id, value);
            _profileStreamController.sink.add(_profile);
            if (id == DatabaseIds.country) {
            imageUrl = imageUrl;
            }else if(id == DatabaseIds.descriptors){
                sortOutIncomingFlavourDescriptorvalue(value);
            }
        }

        void setSubProfile(Profile profile) {
            _profile.setSubProfile(profile);
            _profileStreamController.add(_profile);
        }

        String getBrewRatioFromYielde(int yieldIn) {
            int result = Functions.getIntValue(
                    _profile.getItemValue(DatabaseIds.brewWeight)) -
                Functions.getIntValue(_profile.getItemValue(DatabaseIds.brewingDose));
            return result.toString();
        }

        void sortOutIncomingFlavourDescriptorvalue(dynamic incoming) {
            /// Check the format of the descriptor value.
            List<String> savedDescriptorList = new List<String>();

            if (incoming is String) {
                String descriptorsString = incoming;
                if (descriptorsString == null || descriptorsString == '') {
                _savedDescriptorListObservable.add([]);
                } else {
                savedDescriptorList = descriptorsString.split(',');
                }
                savedDescriptorList.removeWhere((value) => value == '' || value == ' ');
                savedDescriptorList = savedDescriptorList.map((i) => i.trim()).toList();

                _savedDescriptorListObservable
                    .add(convertStringsToFlaDes(savedDescriptorList));
            } else if (incoming is List<String>) {
                _savedDescriptorListObservable
                    .add(convertStringsToFlaDes(savedDescriptorList));
            } else {
                TypeError error = TypeError();
                Sentry.report(error);
            }
        }

    List<FlavourDescriptor> convertStringsToFlaDes(descriptors) {
        List<FlavourDescriptor> fla = new List<FlavourDescriptor>();
        List<FlavourDescriptor> existing =  _mainBloc.flavours;

        for (var i = 0; i < descriptors.length; i++) {
            bool wasFound = false;
            for (var x = 0; x < existing.length; x++) {
                if (descriptors[i] == existing[x].name) {
                    fla.add(existing[x]);
                    wasFound = true;
                }
            }
            if (!wasFound){
                fla.add(new FlavourDescriptor(
                        nameIn: descriptors[i],
                        descriptionIn: '',
                        typeIn: FlavourType.balance));
            }
        }
        return fla;
    }

    static ProfilePageModel of(BuildContext context) =>
        ScopedModel.of<ProfilePageModel>(context);
}
