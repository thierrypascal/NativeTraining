import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:native_training/models/ad_state.dart';

/// A white page that displays text and then redirects to a new page
class WorkoutFinishedRedirectPage extends StatefulWidget {
  /// The text which will be displayed
  final String text;

  /// the Page which you will be redirected to after the timeout
  final Widget route;

  /// A page that displays text, plays a sound and then shows ad before redirecting to a new page
  WorkoutFinishedRedirectPage(this.text, this.route, {Key key}) : super(key: key);

  @override
  State<WorkoutFinishedRedirectPage> createState() => _WorkoutFinishedRedirectPageState();
}

class _WorkoutFinishedRedirectPageState extends State<WorkoutFinishedRedirectPage> {
  InterstitialAd ad;

  void _createAd(){
    InterstitialAd.load(
      adUnitId: AdState.finishedWorkoutAdId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd loadedAd) {
          // Keep a reference to the ad so you can show it later.
          ad = loadedAd;
          print('ad loaded');
          print(loadedAd.toString());
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void _showAd(){
    if (ad != null){
      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) => print('$ad onAdShowedFullScreenContent.'),
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          print('$ad onAdDismissedFullScreenContent.');
          ad.dispose();
          _createAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          print('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
          _createAd();
        },
        onAdImpression: (InterstitialAd ad) => print('$ad impression occurred.'),
      );

      ad.show();
    }else{
      print('null');
    }
  }

  @override
  void initState() {
    super.initState();
    _createAd();
  }

  @override
  void dispose() {
    super.dispose();
    if (ad != null){
      ad.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    //TODO: play sound
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
            child: Center(
                child: Text(
              widget.text,
              style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 24),
              textAlign: TextAlign.center,
            )),
          ),
          ElevatedButton(
            onPressed: () {
              _showAd();
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget.route));
            },
            child: Text("Weiter"),
          ),
        ]),
      ),
    );
  }
}
