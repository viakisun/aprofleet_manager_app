import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Modern Phosphor icons for the AproFleet Manager app
///
/// Icon System:
/// - Regular: Default style for inactive/general use (clean, minimal)
/// - Fill: Active state emphasis (navigation, important actions)
/// - Bold: Special emphasis (buttons, key actions)
/// - Consistent, professional design language
class CustomIcons {
  // Private constructor to prevent instantiation
  CustomIcons._();

  // Icon sizes - Modern larger sizes (iOS style)
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 28.0;
  static const double iconXl = 32.0;
  static const double icon2xl = 36.0;

  // Navigation Icons - Regular for inactive, Fill for active
  static PhosphorIconData get live => PhosphorIconsRegular.mapPin;
  static PhosphorIconData get liveFilled => PhosphorIconsFill.mapPin;
  static PhosphorIconData get carts => PhosphorIconsRegular.car;
  static PhosphorIconData get cartsFilled => PhosphorIconsFill.car;
  static PhosphorIconData get work => PhosphorIconsRegular.wrench;
  static PhosphorIconData get workFilled => PhosphorIconsFill.wrench;
  static PhosphorIconData get alerts => PhosphorIconsRegular.bell;
  static PhosphorIconData get alertsFilled => PhosphorIconsFill.bell;
  static PhosphorIconData get analytics => PhosphorIconsRegular.chartBar;
  static PhosphorIconData get analyticsFilled => PhosphorIconsFill.chartBar;

  // Action Icons - Mix of Regular and Bold for clarity
  static PhosphorIconData get search => PhosphorIconsRegular.magnifyingGlass;
  static PhosphorIconData get filter => PhosphorIconsRegular.faders;
  static PhosphorIconData get add => PhosphorIconsBold.plus;
  static PhosphorIconData get refresh => PhosphorIconsRegular.arrowClockwise;
  static PhosphorIconData get download => PhosphorIconsRegular.downloadSimple;
  static PhosphorIconData get fullscreen => PhosphorIconsRegular.arrowsOut;
  static PhosphorIconData get settings => PhosphorIconsRegular.gear;
  static PhosphorIconData get route => PhosphorIconsRegular.path;
  static PhosphorIconData get moreVert => PhosphorIconsBold.dotsThreeVertical;

  // iOS-style navigation icons
  static PhosphorIconData get menu =>
      PhosphorIconsBold.list; // Modern list instead of hamburger
  static PhosphorIconData get back =>
      PhosphorIconsRegular.caretLeft; // iOS chevron style
  static PhosphorIconData get close => PhosphorIconsBold.x;
  static PhosphorIconData get edit => PhosphorIconsRegular.pencilSimple;
  static PhosphorIconData get delete => PhosphorIconsRegular.trash;
  static PhosphorIconData get save => PhosphorIconsRegular.floppyDisk;
  static PhosphorIconData get cancel => PhosphorIconsRegular.xCircle;

  // Status Icons - Regular for consistency
  static PhosphorIconData get active => PhosphorIconsRegular.playCircle;
  static PhosphorIconData get idle => PhosphorIconsRegular.pauseCircle;
  static PhosphorIconData get charging => PhosphorIconsRegular.batteryCharging;
  static PhosphorIconData get maintenance => PhosphorIconsRegular.wrench;
  static PhosphorIconData get warning => PhosphorIconsRegular.warningCircle;
  static PhosphorIconData get error => PhosphorIconsRegular.xCircle;
  static PhosphorIconData get success => PhosphorIconsRegular.checkCircle;
  static PhosphorIconData get info => PhosphorIconsRegular.info;

  // Utility Icons
  static PhosphorIconData get qrCode => PhosphorIconsRegular.qrCode;
  static PhosphorIconData get timeline => PhosphorIconsRegular.chartLine;
  static PhosphorIconData get list => PhosphorIconsRegular.list;
  static PhosphorIconData get grid => PhosphorIconsRegular.gridFour;
  static PhosphorIconData get doneAll => PhosphorIconsFill.checkCircle;
  static PhosphorIconData get notificationsOff =>
      PhosphorIconsRegular.bellSlash;
  static PhosphorIconData get notificationsOn => PhosphorIconsFill.bell;
  static PhosphorIconData get user => PhosphorIconsRegular.user;
  static PhosphorIconData get users => PhosphorIconsRegular.users;
  static PhosphorIconData get home => PhosphorIconsRegular.house;
  static PhosphorIconData get dashboard => PhosphorIconsRegular.squaresFour;
  static PhosphorIconData get calendar => PhosphorIconsRegular.calendar;
  static PhosphorIconData get clock => PhosphorIconsRegular.clock;
  static PhosphorIconData get location => PhosphorIconsRegular.mapPin;
  static PhosphorIconData get phone => PhosphorIconsRegular.phone;
  static PhosphorIconData get email => PhosphorIconsRegular.envelope;
  static PhosphorIconData get link => PhosphorIconsRegular.link;
  static PhosphorIconData get externalLink =>
      PhosphorIconsRegular.arrowSquareOut;
  static PhosphorIconData get copy => PhosphorIconsRegular.copy;
  static PhosphorIconData get share => PhosphorIconsRegular.shareNetwork;
  static PhosphorIconData get print => PhosphorIconsRegular.printer;
  static PhosphorIconData get upload => PhosphorIconsRegular.uploadSimple;
  static PhosphorIconData get folder => PhosphorIconsRegular.folder;
  static PhosphorIconData get file => PhosphorIconsRegular.file;
  static PhosphorIconData get image => PhosphorIconsRegular.image;
  static PhosphorIconData get video => PhosphorIconsRegular.videoCamera;
  static PhosphorIconData get music => PhosphorIconsRegular.musicNote;
  static PhosphorIconData get volume => PhosphorIconsRegular.speakerHigh;
  static PhosphorIconData get volumeOff => PhosphorIconsRegular.speakerSlash;
  static PhosphorIconData get play => PhosphorIconsFill.playCircle;
  static PhosphorIconData get pause => PhosphorIconsFill.pauseCircle;
  static PhosphorIconData get stop => PhosphorIconsFill.stopCircle;
  static PhosphorIconData get skipBack => PhosphorIconsRegular.skipBack;
  static PhosphorIconData get skipForward => PhosphorIconsRegular.skipForward;
  static PhosphorIconData get repeat => PhosphorIconsRegular.repeat;
  static PhosphorIconData get shuffle => PhosphorIconsRegular.shuffle;

  // Arrow Icons - iOS chevron style
  static PhosphorIconData get arrowUp => PhosphorIconsRegular.arrowUp;
  static PhosphorIconData get arrowDown => PhosphorIconsRegular.arrowDown;
  static PhosphorIconData get arrowLeft => PhosphorIconsRegular.arrowLeft;
  static PhosphorIconData get arrowRight => PhosphorIconsRegular.arrowRight;
  static PhosphorIconData get arrowUpDown => PhosphorIconsRegular.arrowsDownUp;
  static PhosphorIconData get arrowLeftRight =>
      PhosphorIconsRegular.arrowsLeftRight;
  static PhosphorIconData get chevronUp => PhosphorIconsBold.caretUp;
  static PhosphorIconData get chevronDown => PhosphorIconsBold.caretDown;
  static PhosphorIconData get chevronLeft => PhosphorIconsBold.caretLeft;
  static PhosphorIconData get chevronRight => PhosphorIconsBold.caretRight;

  // Communication Icons
  static PhosphorIconData get message => PhosphorIconsRegular.chatCircle;
  static PhosphorIconData get messageSquare => PhosphorIconsRegular.chatText;
  static PhosphorIconData get chat => PhosphorIconsRegular.chatCircle;
  static PhosphorIconData get comment => PhosphorIconsRegular.chatText;
  static PhosphorIconData get reply => PhosphorIconsRegular.arrowBendUpLeft;
  static PhosphorIconData get forward => PhosphorIconsRegular.arrowBendUpRight;
  static PhosphorIconData get send => PhosphorIconsFill.paperPlaneTilt;

  // Security Icons
  static PhosphorIconData get lock => PhosphorIconsRegular.lock;
  static PhosphorIconData get unlock => PhosphorIconsRegular.lockOpen;
  static PhosphorIconData get key => PhosphorIconsRegular.key;
  static PhosphorIconData get shield => PhosphorIconsRegular.shield;
  static PhosphorIconData get shieldCheck => PhosphorIconsRegular.shieldCheck;
  static PhosphorIconData get shieldAlert => PhosphorIconsRegular.shieldWarning;
  static PhosphorIconData get eye => PhosphorIconsRegular.eye;
  static PhosphorIconData get eyeOff => PhosphorIconsRegular.eyeSlash;

  // Data Icons
  static PhosphorIconData get database => PhosphorIconsRegular.database;
  static PhosphorIconData get server => PhosphorIconsRegular.hardDrives;
  static PhosphorIconData get cloud => PhosphorIconsRegular.cloud;
  static PhosphorIconData get cloudUpload => PhosphorIconsRegular.cloudArrowUp;
  static PhosphorIconData get cloudDownload =>
      PhosphorIconsRegular.cloudArrowDown;
  static PhosphorIconData get wifi => PhosphorIconsRegular.wifiHigh;
  static PhosphorIconData get wifiOff => PhosphorIconsRegular.wifiSlash;
  static PhosphorIconData get bluetooth =>
      PhosphorIconsRegular.bluetoothConnected;
  static PhosphorIconData get signal => PhosphorIconsRegular.waveform;

  // Weather Icons
  static PhosphorIconData get sun => PhosphorIconsRegular.sun;
  static PhosphorIconData get moon => PhosphorIconsRegular.moon;
  static PhosphorIconData get cloudSun => PhosphorIconsRegular.cloudSun;
  static PhosphorIconData get cloudRain => PhosphorIconsRegular.cloudRain;
  static PhosphorIconData get cloudSnow => PhosphorIconsRegular.cloudSnow;
  static PhosphorIconData get wind => PhosphorIconsRegular.wind;
  static PhosphorIconData get thermometer => PhosphorIconsRegular.thermometer;

  // Transportation Icons
  static PhosphorIconData get car => PhosphorIconsRegular.car;
  static PhosphorIconData get truck => PhosphorIconsRegular.truck;
  static PhosphorIconData get bus => PhosphorIconsRegular.bus;
  static PhosphorIconData get train => PhosphorIconsRegular.train;
  static PhosphorIconData get plane => PhosphorIconsRegular.airplane;
  static PhosphorIconData get ship => PhosphorIconsRegular.boat;
  static PhosphorIconData get bike => PhosphorIconsRegular.bicycle;
  static PhosphorIconData get walking => PhosphorIconsRegular.personSimpleWalk;

  // Shopping Icons
  static PhosphorIconData get shoppingCart => PhosphorIconsRegular.shoppingCart;
  static PhosphorIconData get shoppingBag => PhosphorIconsRegular.shoppingBag;
  static PhosphorIconData get creditCard => PhosphorIconsRegular.creditCard;
  static PhosphorIconData get dollarSign => PhosphorIconsRegular.currencyDollar;
  static PhosphorIconData get euro => PhosphorIconsRegular.currencyEur;
  static PhosphorIconData get poundSterling => PhosphorIconsRegular.currencyGbp;
  static PhosphorIconData get yen => PhosphorIconsRegular.currencyJpy;
  static PhosphorIconData get receipt => PhosphorIconsRegular.receipt;

  // Health Icons
  static PhosphorIconData get heart => PhosphorIconsFill.heart;
  static PhosphorIconData get heartBroken => PhosphorIconsRegular.heartBreak;
  static PhosphorIconData get pulse => PhosphorIconsRegular.heartbeat;
  static PhosphorIconData get activity => PhosphorIconsRegular.heartbeat;
  static PhosphorIconData get zap => PhosphorIconsRegular.lightning;
  static PhosphorIconData get battery => PhosphorIconsRegular.batteryFull;
  static PhosphorIconData get batteryCharging =>
      PhosphorIconsRegular.batteryCharging;
  static PhosphorIconData get batteryLow => PhosphorIconsRegular.batteryWarning;

  // Helper method to create icon widget
  static Widget icon(
    PhosphorIconData iconData, {
    double size = iconMd,
    Color? color,
    PhosphorIconsStyle? style,
  }) {
    return PhosphorIcon(
      iconData,
      size: size,
      color: color,
    );
  }
}

/// Modern icon button widget using Phosphor icons with iOS-inspired design
class CustomIconButton extends StatelessWidget {
  final PhosphorIconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double size;
  final EdgeInsetsGeometry? padding;
  final bool isCircular;

  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.size = CustomIcons.iconMd,
    this.padding,
    this.isCircular = true,
  });

  @override
  Widget build(BuildContext context) {
    final widget = Material(
      color: backgroundColor ?? Colors.transparent,
      borderRadius: BorderRadius.circular(
        isCircular ? size / 2 : 12.0,
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(
          isCircular ? size / 2 : 12.0,
        ),
        child: Container(
          width: size,
          height: size,
          padding: padding ?? EdgeInsets.all(size * 0.2),
          child: PhosphorIcon(
            icon,
            size: size * 0.6,
            color: foregroundColor,
          ),
        ),
      ),
    );

    if (tooltip != null && tooltip!.isNotEmpty) {
      return Tooltip(
        message: tooltip!,
        child: widget,
      );
    }

    return widget;
  }
}
