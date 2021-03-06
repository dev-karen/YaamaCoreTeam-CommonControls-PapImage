# Pap Firebase remote config package

this document contains items regarding PapFirebaseRemoteConfig package.

## Development

package itself stored in `/pap_firebase_remote_config`.
sample project is available in `/firebase_remote_config_app`.

## How to use package

1.  add / install Firebase to your flutter project.
2.  create a `service_account_key.json` google firebase console in your project and put this file to `/assets/googlekey/service_account_key.json`.
3.  add PapRemoteConfig package in pubspect.yaml
4.  initialize your dependency inejction / create an instace of PapFirebaseRemoteConfig :

```markdown
PlatformService ps = new PlatformService();
var remoteConfigService =
PapFirebaseRemoteConfig(platformService: ps).getInstance();
locator.registerSingleton(remoteConfigService);
```

5.  initialize Firebase :

```markdown
if (!kIsWeb) {
await Firebase.initializeApp();
}
```

6.  initialize PapRemoteConfig base on web or mobile :

```markdown
final IPapRemoteConfigService \_remoteConfigService =
locator<IPapRemoteConfigService>();

if (kIsWeb) {
await \_remoteConfigService.initialize(projectName: 'testremoteconfigapp');
} else {
await \_remoteConfigService.initialize();
}
```

7.  to get a value from remoteConfig, only call the appropriate method :

```markdown
bool value = \_remoteConfigService.getBoolean(variableName: 'enable_eoi');
print('enable EOI is = ' + value.toString());
```
