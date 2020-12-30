// This file can be replaced during build by using the `fileReplacements` array.
// `ng build ---prod` replaces `environment.ts` with `environment.prod.ts`.
// The list of file replacements can be found in `angular.json`.

const LOCAL_MACHINE_URL = 'http://localhost:50422/'; // for local machine
const STAGE_ENV_URL = 'http://13.228.24.89:81/'; // Stage 81
const UTO_ENV_URL = 'http://192.168.0.114/musichubapi'; // UTO Envoirmrnt
//const UTO_ENV_URL = 'http://localhost:50422/'; // UTO Envoirmrnt

// const UTO_ENV_URL = 'http://163.182.171.194:8092/'; // UTO Envoirmrnt
const BETA_ENV_URL = ''; // Beta
const PROD_ENV_URL = ''; // Production

export const environment = {
    production: false,
    development: true,
  BASE_URL: LOCAL_MACHINE_URL,
    RATECARD_UPLOAD_URL: 'http://localhost:26736/api/Ratecard/UploadExcelData',
    USER_ADVERTISER_UPLOAD_URL: 'http://localhost:26736/api/Setting/UploadExcelData'
};

/*
 * In development mode, to ignore zone related error stack frames such as
 * `zone.run`, `zoneDelegate.invokeTask` for easier debugging, you can
 * import the following file, but please comment it out in production mode
 * because it will have performance impact when throw error
 */
// import 'zone.js/dist/zone-error';  // Included with Angular CLI.
