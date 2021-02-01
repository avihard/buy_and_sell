// Copyright (c) 2019, the dealitin.com.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// dealitin.com license that can be found in the LICENSE file.

import 'package:flutterbuyandsell/viewobject/common/language.dart';

class PsConfig {
  PsConfig._();

  ///
  /// AppVersion
  /// For your app, you need to change according based on your app version
  ///
  static const String app_version = '1.9';

  ///
  /// API Key
  /// If you change here, you need to update in server.
  ///
  ///
  ///

  static const String ps_api_key = 'dealitin';

  ///
  static const String ps_app_url = 'http://dealitin.com/index.php/';

  static const String ps_app_image_url = 'http://dealitin.com/uploads/';

  static const String ps_app_image_thumbs_url =
      'http://dealitin.com/uploads/thumbnail/';

  // Old one

/*
  static const String ps_api_key = 'teampsisthebest';

  ///
  /// API URL
  /// Change your backend url
  ///
  static const String ps_app_url =
      'https://www.dealitin.com/flutter-buysell/index.php/';

  static const String ps_app_image_url =
      'https://www.dealitin.com/flutter-buysell/uploads/';

  static const String ps_app_image_thumbs_url =
      'https://www.dealitin.com/flutter-buysell/uploads/thumbnail/';
*/

  ///
  /// Chat Setting
  ///

  static const String iosGoogleAppId =
      '1:286520446210:ios:478abf1ed0ce40a8fa061b';
  static const String iosGcmSenderId = '286520446210';
  static const String iosProjectId = 'Dealit';
  static const String iosDatabaseUrl = 'https://dealit-a1714.firebaseio.com';
  static const String iosApiKey = 'AIzaSyD8PwK1WMVfAr6HxxGqZT57nUyTf7senPg';

  static const String androidGoogleAppId =
      '1:286520446210:android:edf10378123eb1f8fa061b';
  static const String androidGcmSenderId = '000000000000';
  static const String androidProjectId = 'Dealit';
  static const String androidApiKey = 'AIzaSyB14GQ1JSmEIG_4d7bn3wo_kqvknID6Dq4';
  static const String androidDatabaseUrl =
      'https://dealit-a1714.firebaseio.com';

  ///
  /// Facebook Key
  ///
  static const String fbKey = '000000000000000';

  ///
  ///Admob Setting
  ///
  static bool showAdMob = true;
  static String androidAdMobAdsIdKey = 'ca-app-pub-0000000000000000~0000000000';
  static String androidAdMobUnitIdApiKey =
      'ca-app-pub-0000000000000000/0000000000';
  static String iosAdMobAdsIdKey = 'ca-app-pub-0000000000000000~0000000000';
  static String iosAdMobUnitIdApiKey = 'ca-app-pub-0000000000000000/0000000000';

  ///
  /// Animation Duration
  ///
  static const Duration animation_duration = Duration(milliseconds: 500);

  ///
  /// Fonts Family Config
  /// Before you declare you here,
  /// 1) You need to add font under assets/fonts/
  /// 2) Declare at pubspec.yaml
  /// 3) Update your font family name at below
  ///
  static const String ps_default_font_family = 'Product Sans';

  /// Default Language
// static const ps_default_language = 'en';

// static const ps_language_list = [Locale('en', 'US'), Locale('ar', 'DZ')];
  static const String ps_app_db_name = 'ps_db.db';

  ///
  /// For default language change, please check
  /// LanguageFragment for language code and country code
  /// ..............................................................
  /// Language             | Language Code     | Country Code
  /// ..............................................................
  /// "English"            | "en"              | "US"
  /// "Arabic"             | "ar"              | "DZ"
  /// "India (Hindi)"      | "hi"              | "IN"
  /// "German"             | "de"              | "DE"
  /// "Spainish"           | "es"              | "ES"
  /// "French"             | "fr"              | "FR"
  /// "Indonesian"         | "id"              | "ID"
  /// "Italian"            | "it"              | "IT"
  /// "Japanese"           | "ja"              | "JP"
  /// "Korean"             | "ko"              | "KR"
  /// "Malay"              | "ms"              | "MY"
  /// "Portuguese"         | "pt"              | "PT"
  /// "Russian"            | "ru"              | "RU"
  /// "Thai"               | "th"              | "TH"
  /// "Turkish"            | "tr"              | "TR"
  /// "Chinese"            | "zh"              | "CN"
  /// ..............................................................
  ///
  static final Language defaultLanguage =
      Language(languageCode: 'en', countryCode: 'US', name: 'English US');

  static final List<Language> psSupportedLanguageList = <Language>[
    Language(languageCode: 'en', countryCode: 'US', name: 'English'),
    Language(languageCode: 'ar', countryCode: 'DZ', name: 'Arabic'),
    Language(languageCode: 'hi', countryCode: 'IN', name: 'Hindi'),
    Language(languageCode: 'de', countryCode: 'DE', name: 'German'),
    Language(languageCode: 'es', countryCode: 'ES', name: 'Spainish'),
    Language(languageCode: 'fr', countryCode: 'FR', name: 'French'),
    Language(languageCode: 'id', countryCode: 'ID', name: 'Indonesian'),
    Language(languageCode: 'it', countryCode: 'IT', name: 'Italian'),
    Language(languageCode: 'ja', countryCode: 'JP', name: 'Japanese'),
    Language(languageCode: 'ko', countryCode: 'KR', name: 'Korean'),
    Language(languageCode: 'ms', countryCode: 'MY', name: 'Malay'),
    Language(languageCode: 'pt', countryCode: 'PT', name: 'Portuguese'),
    Language(languageCode: 'ru', countryCode: 'RU', name: 'Russian'),
    Language(languageCode: 'th', countryCode: 'TH', name: 'Thai'),
    Language(languageCode: 'tr', countryCode: 'TR', name: 'Turkish'),
    Language(languageCode: 'zh', countryCode: 'CN', name: 'Chinese'),
  ];

  ///
  /// Price Format
  /// Need to change according to your format that you need
  /// E.g.
  /// ",##0.00"   => 2,555.00
  /// "##0.00"    => 2555.00
  /// ".00"       => 2555.00
  /// ",##0"      => 2555
  /// ",##0.0"    => 2555.0
  ///
  static const String priceFormat = ',###.00';

  ///
  /// Date Time Format
  ///
  static const String dateFormat = 'dd-MM-yyyy hh:mm:ss';

  ///
  /// iOS App No
  ///
  static const String iOSAppStoreId = '000000000';

  ///
  /// Tmp Image Folder Name
  ///
  static const String tmpImageFolderName = 'FlutterBuySell';

  ///
  /// Image Loading
  ///
  /// - If you set "true", it will load thumbnail image first and later it will
  ///   load full image
  /// - If you set "false", it will load full image directly and for the
  ///   placeholder image it will use default placeholder Image.
  ///
  static const bool USE_THUMBNAIL_AS_PLACEHOLDER = false;

  ///
  /// Token Id
  ///
  /// "true" = it will show token id under setting
  static const bool isShowTokenId = true;

  ///
  /// ShowSubCategory
  ///
  static const bool isShowSubCategory = true;

  ///
  /// Promote Item
  ///
  static const String PROMOTE_FIRST_CHOICE_DAY_OR_DEFAULT_DAY = '7 ';
  static const String PROMOTE_SECOND_CHOICE_DAY = '14 ';
  static const String PROMOTE_THIRD_CHOICE_DAY = '30 ';
  static const String PROMOTE_FOURTH_CHOICE_DAY = '60 ';

  ///
  /// Image Size
  ///
  static const int uploadImageSize = 1024;
  static const int profileImageSize = 512;
  static const int chatImageSize = 650;

  ///
  /// Default Limit
  ///
  static const int DEFAULT_LOADING_LIMIT = 30;
  static const int CATEGORY_LOADING_LIMIT = 10;
  static const int RECENT_ITEM_LOADING_LIMIT = 10;
  static const int POPULAR_ITEM_LOADING_LIMIT = 10;
  static const int BLOCK_SLIDER_LOADING_LIMIT = 10;
  static const int FOLLOWER_ITEM_LOADING_LIMIT = 10;

  ///
  ///Login Setting
  ///
  static bool showFacebookLogin = true;
  static bool showGoogleLogin = true;
  static bool showPhoneLogin = true;

  ///
  /// Map Filter Setting
  ///
  static bool noFilterWithLocationOnMap = false;

  ///
  /// Razor Currency
  ///
  /// If you set true, your razor account must support multi-currency.
  static bool isRazorSupportMultiCurrency = false;
  static String defaultRazorCurrency = 'INR'; // Don't change
}
