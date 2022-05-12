const LOCAL_MACHINE_URL = 'http://192.168.0.114/UTONotificationUI/UTONotificationAPI'; //'http://localhost:52972/'
const STAGE_ENV_URL = ''; // Stage 81
const UTO_ENV_URL = ''; // UTO Envoirmrnt
const BETA_ENV_URL = ''; // Beta
const PROD_ENV_URL = ''; // Production
const AuthKey = '';
declare var require: any

export const environment = {
  appVersion: require('../../package.json').version,
  production: true,
  development: false,
   BASE_URL: LOCAL_MACHINE_URL,
  
 
};
