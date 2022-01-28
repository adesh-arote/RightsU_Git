// This file can be replaced during build by using the `fileReplacements` array.
// `ng build --prod` replaces `environment.ts` with `environment.prod.ts`.
// The list of file replacements can be found in `angular.json`.


const LOCAL_MACHINE_URL = 'http://192.168.0.114/UTONotificationUI/UTONotificationAPI'; // 'http://localhost:65453/' //
const STAGE_ENV_URL = ''; // Stage 81
const UTO_ENV_URL = ''; // UTO Envoirmrnt
const BETA_ENV_URL = ''; // Beta
const PROD_ENV_URL = ''; // Production
const AuthKey = '';
declare var require: any

export const environment = {
  appVersion: require('../../package.json').version,
  production: false,
  development: true,
  BASE_URL: LOCAL_MACHINE_URL,
  AuthKey: 'EalzbkJtZSdV1PydZ9xVzQ=='
}
/*
 * In development mode, to ignore zone related error stack frames such as
 * `zone.run`, `zoneDelegate.invokeTask` for easier debugging, you can
 * import the following file, but please comment it out in production mode
 * because it will have performance impact when throw error
 */
// import 'zone.js/dist/zone-error';  // Included with Angular CLI.
