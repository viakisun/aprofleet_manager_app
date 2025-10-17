import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// High-quality Lucide icons for the AproFleet Manager app
class CustomIcons {
  // Private constructor to prevent instantiation
  CustomIcons._();

  // Icon sizes - Modern larger sizes
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 28.0;
  static const double iconXl = 32.0;
  static const double icon2xl = 36.0;

  // Navigation Icons
  static IconData get live => LucideIcons.mapPin;
  static IconData get liveFilled => LucideIcons.mapPin;
  static IconData get carts => LucideIcons.car;
  static IconData get cartsFilled => LucideIcons.car;
  static IconData get work => LucideIcons.wrench;
  static IconData get workFilled => LucideIcons.wrench;
  static IconData get alerts => LucideIcons.bell;
  static IconData get alertsFilled => LucideIcons.bell;
  static IconData get analytics => LucideIcons.barChart3;
  static IconData get analyticsFilled => LucideIcons.barChart3;

  // Action Icons
  static IconData get search => LucideIcons.search;
  static IconData get filter => LucideIcons.filter;
  static IconData get add => LucideIcons.plus;
  static IconData get refresh => LucideIcons.refreshCw;
  static IconData get download => LucideIcons.download;
  static IconData get fullscreen => LucideIcons.maximize;
  static IconData get settings => LucideIcons.settings;
  static IconData get menu => LucideIcons.menu;
  static IconData get back => LucideIcons.arrowLeft;
  static IconData get close => LucideIcons.x;
  static IconData get edit => LucideIcons.edit;
  static IconData get delete => LucideIcons.trash2;
  static IconData get save => LucideIcons.save;
  static IconData get cancel => LucideIcons.xCircle;

  // Status Icons
  static IconData get active => LucideIcons.playCircle;
  static IconData get idle => LucideIcons.pauseCircle;
  static IconData get charging => LucideIcons.battery;
  static IconData get maintenance => LucideIcons.wrench;
  static IconData get warning => LucideIcons.alertTriangle;
  static IconData get error => LucideIcons.alertCircle;
  static IconData get success => LucideIcons.checkCircle;
  static IconData get info => LucideIcons.info;

  // Utility Icons
  static IconData get qrCode => LucideIcons.qrCode;
  static IconData get timeline => LucideIcons.activity;
  static IconData get list => LucideIcons.list;
  static IconData get grid => LucideIcons.layoutGrid;
  static IconData get doneAll => LucideIcons.checkCircle2;
  static IconData get notificationsOff => LucideIcons.bellOff;
  static IconData get notificationsOn => LucideIcons.bell;
  static IconData get user => LucideIcons.user;
  static IconData get users => LucideIcons.users;
  static IconData get home => LucideIcons.home;
  static IconData get dashboard => LucideIcons.layoutDashboard;
  static IconData get calendar => LucideIcons.calendar;
  static IconData get clock => LucideIcons.clock;
  static IconData get location => LucideIcons.mapPin;
  static IconData get phone => LucideIcons.phone;
  static IconData get email => LucideIcons.mail;
  static IconData get link => LucideIcons.link;
  static IconData get externalLink => LucideIcons.externalLink;
  static IconData get copy => LucideIcons.copy;
  static IconData get share => LucideIcons.share;
  static IconData get print => LucideIcons.printer;
  static IconData get upload => LucideIcons.upload;
  static IconData get folder => LucideIcons.folder;
  static IconData get file => LucideIcons.file;
  static IconData get image => LucideIcons.image;
  static IconData get video => LucideIcons.video;
  static IconData get music => LucideIcons.music;
  static IconData get volume => LucideIcons.volume2;
  static IconData get volumeOff => LucideIcons.volumeX;
  static IconData get play => LucideIcons.play;
  static IconData get pause => LucideIcons.pause;
  static IconData get stop => LucideIcons.square;
  static IconData get skipBack => LucideIcons.skipBack;
  static IconData get skipForward => LucideIcons.skipForward;
  static IconData get repeat => LucideIcons.repeat;
  static IconData get shuffle => LucideIcons.shuffle;

  // Arrow Icons
  static IconData get arrowUp => LucideIcons.arrowUp;
  static IconData get arrowDown => LucideIcons.arrowDown;
  static IconData get arrowLeft => LucideIcons.arrowLeft;
  static IconData get arrowRight => LucideIcons.arrowRight;
  static IconData get arrowUpDown => LucideIcons.arrowUpDown;
  static IconData get arrowLeftRight => LucideIcons.arrowLeftRight;
  static IconData get chevronUp => LucideIcons.chevronUp;
  static IconData get chevronDown => LucideIcons.chevronDown;
  static IconData get chevronLeft => LucideIcons.chevronLeft;
  static IconData get chevronRight => LucideIcons.chevronRight;

  // Communication Icons
  static IconData get message => LucideIcons.messageCircle;
  static IconData get messageSquare => LucideIcons.messageSquare;
  static IconData get chat => LucideIcons.messageCircle;
  static IconData get comment => LucideIcons.messageSquare;
  static IconData get reply => LucideIcons.reply;
  static IconData get forward => LucideIcons.forward;
  static IconData get send => LucideIcons.send;

  // Security Icons
  static IconData get lock => LucideIcons.lock;
  static IconData get unlock => LucideIcons.unlock;
  static IconData get key => LucideIcons.key;
  static IconData get shield => LucideIcons.shield;
  static IconData get shieldCheck => LucideIcons.shieldCheck;
  static IconData get shieldAlert => LucideIcons.shieldAlert;
  static IconData get eye => LucideIcons.eye;
  static IconData get eyeOff => LucideIcons.eyeOff;

  // Data Icons
  static IconData get database => LucideIcons.database;
  static IconData get server => LucideIcons.server;
  static IconData get cloud => LucideIcons.cloud;
  static IconData get cloudUpload => LucideIcons.upload;
  static IconData get cloudDownload => LucideIcons.download;
  static IconData get wifi => LucideIcons.wifi;
  static IconData get wifiOff => LucideIcons.wifiOff;
  static IconData get bluetooth => LucideIcons.bluetooth;
  static IconData get signal => LucideIcons.signal;

  // Weather Icons
  static IconData get sun => LucideIcons.sun;
  static IconData get moon => LucideIcons.moon;
  static IconData get cloudSun => LucideIcons.cloudSun;
  static IconData get cloudRain => LucideIcons.cloudRain;
  static IconData get cloudSnow => LucideIcons.cloudSnow;
  static IconData get wind => LucideIcons.wind;
  static IconData get thermometer => LucideIcons.thermometer;

  // Transportation Icons
  static IconData get car => LucideIcons.car;
  static IconData get truck => LucideIcons.truck;
  static IconData get bus => LucideIcons.bus;
  static IconData get train => LucideIcons.train;
  static IconData get plane => LucideIcons.plane;
  static IconData get ship => LucideIcons.ship;
  static IconData get bike => LucideIcons.bike;
  static IconData get walking => LucideIcons.user;

  // Shopping Icons
  static IconData get shoppingCart => LucideIcons.shoppingCart;
  static IconData get shoppingBag => LucideIcons.shoppingBag;
  static IconData get creditCard => LucideIcons.creditCard;
  static IconData get dollarSign => LucideIcons.dollarSign;
  static IconData get euro => LucideIcons.euro;
  static IconData get poundSterling => LucideIcons.poundSterling;
  static IconData get yen =>
      LucideIcons.dollarSign; // Using dollarSign as fallback
  static IconData get receipt => LucideIcons.receipt;

  // Health Icons
  static IconData get heart => LucideIcons.heart;
  static IconData get heartBroken =>
      LucideIcons.heart; // Using heart as fallback
  static IconData get pulse =>
      LucideIcons.activity; // Using activity as fallback
  static IconData get activity => LucideIcons.activity;
  static IconData get zap => LucideIcons.zap;
  static IconData get battery => LucideIcons.battery;
  static IconData get batteryCharging => LucideIcons.batteryCharging;
  static IconData get batteryLow => LucideIcons.batteryLow;

  // Helper method to create icon widget
  static Widget icon(
    IconData iconData, {
    double size = iconMd,
    Color? color,
  }) {
    return Icon(
      iconData,
      size: size,
      color: color,
    );
  }
}

/// High-quality icon button widget using Lucide icons
class CustomIconButton extends StatelessWidget {
  final IconData icon;
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
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(
          isCircular ? size / 2 : 8.0,
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(
            isCircular ? size / 2 : 8.0,
          ),
          child: Container(
            width: size,
            height: size,
            padding: padding ?? EdgeInsets.all(size * 0.2),
            child: CustomIcons.icon(
              icon,
              size: size * 0.6,
              color: foregroundColor,
            ),
          ),
        ),
      ),
    );
  }
}
