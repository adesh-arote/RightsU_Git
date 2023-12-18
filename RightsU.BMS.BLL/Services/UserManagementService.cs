using RightsU.BMS.Entities;
using RightsU.BMS.Entities.LogClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using System.DirectoryServices;
using RightsU.BMS.Entities.FrameworkClasses;

namespace RightsU.BMS.BLL.Services
{
    public class UserManagementService: UserServices
    {
        //private readonly UserManagementService objUserManagementService;
        private readonly ServiceLogServices objServiceLogServices = new ServiceLogServices();
        private readonly SystemParameterServices objSystemParameterServices = new SystemParameterServices();

        public Return GetLogin(LoginDetails objLoginDetails)
        {
            Error.WriteLog("GetLogin", includeTime: true, addSeperater: true);
            string errMsg = string.Empty;
            Return objRet = new Return();
            User objUser = null;
            long Token = DateTime.Now.Ticks;

            ServiceLog serviceLog = new ServiceLog()
            {
                LogType = 0,
                MethodName = "GetLogin step 1",
                Request = "",
                Response = "",
                RequestTime = DateTime.Now,
                ResponseTime = DateTime.Now
            };

            //objServiceLogServices.AddEntity(serviceLog);

            if (!string.IsNullOrEmpty(objLoginDetails.UserName) && !string.IsNullOrEmpty(objLoginDetails.Password))
            {
                bool IsSystemUser = IfSystemUser(objLoginDetails);
                string IsLdapUser = "N";

                if (!IfLoginNameExist(objLoginDetails.UserName))
                {
                    objRet.IsSuccess = false;
                    objRet.Message = "Invalid login name";
                    objRet.Token = null;
                    objRet.UserName = "";
                    objRet.SecurityGroupCode = null;
                    return objRet;
                }

                if (Convert.ToString(ConfigurationManager.AppSettings["IsLDAPAuthReq"]).Trim() == "Y" && IsSystemUser == false)//
                {
                    serviceLog.MethodName = "Step 2 INSIDE LDAP";
                    objServiceLogServices.AddEntity(serviceLog);
                    //Error.WriteLog_Conditional("STEP 2 A: inside get login");

                    IsLdapUser = "Y";
                    if (LDAPValidation(objLoginDetails.UserName, objLoginDetails.Password, out errMsg))
                    {

                        serviceLog.MethodName = "Step 2.1 INSIDE LDAP";
                        objServiceLogServices.AddEntity(serviceLog);

                        User objU = new User();
                        objU = (User)SearchForUser(objLoginDetails.UserName);
                        objUser = (User)FetchUserObject(objU, 0);

                        serviceLog.MethodName = "Step 2.3 INSIDE LDAP";
                        objServiceLogServices.AddEntity(serviceLog);
                    }
                    else
                    {
                        serviceLog.MethodName = "Step 2.2 INSIDE LDAP";
                        objServiceLogServices.AddEntity(serviceLog);

                        objRet.IsSuccess = false;
                        objRet.Message = errMsg;
                        objUser = null;
                        // return objUser;
                    }
                }
                else
                {
                    objUser = (User)validateUser(objLoginDetails.UserName, objLoginDetails.Password);
                }

                if (objUser != null)
                {
                    //Token = DateTime.Now.Ticks;

                    if (objUser.Is_Active == "Y")
                    {
                        if (IsLdapUser != "Y" && objUser.Password_Fail_Count >= GetPasswordThresholdValue())
                            objUser = CheckPasswordExpiryandUpdate(objUser.Users_Code.Value);

                        if (!IsUserLocked(objUser.Password_Fail_Count) || IsLdapUser == "Y")
                        {
                            //int loginDetailsCode = SaveLoginDetails_OnLogin(objUser.Users_Code.Value);
                            //var retObjUser = FetchUserObject(objUser, 0);

                            //if (IsLdapUser == "Y")
                            //{
                            //    objRet.IsSuccess = true;
                            //    objRet.Message = "Login Successful";
                            //    objRet.Token = Token.ToString();
                            //    return objRet;
                            //}
                            //objUser = AfterLoginPasswordUpdate(objUser.Users_Code.Value);

                            bool passwordValidDay = IsPasswordValid(objUser.Users_Code.Value);
                            if (!passwordValidDay)// || (objUser.Is_System_Password == "Y"))
                            {
                                objRet.IsSuccess = false;
                                objRet.Message = "Change Password";
                                objRet.Token = Token.ToString();
                                objRet.UserName = objUser.Login_Name;
                                objRet.SecurityGroupCode = objUser.Security_Group_Code.Value;
                                objRet.IsSystemPassword = objUser.Is_System_Password;
                                return objRet;
                            }
                            objRet.IsSuccess = true;
                            objRet.Message = "Login Successful";
                            objRet.Token = "";
                            objRet.UserName = objUser.Login_Name;
                            objRet.SecurityGroupCode = objUser.Security_Group_Code.Value;
                            objRet.IsSystemPassword = objUser.Is_System_Password;
                            return objRet;
                        }
                        objRet.IsSuccess = false;
                        var maxLockTimeMinutes = 0;

                        maxLockTimeMinutes = UserLockDuratin();

                        objRet.Message = "Your account is locked. Wait " + maxLockTimeMinutes + " mins to regain access";

                        objUser = null;
                        return objRet;
                    }
                    objRet.IsSuccess = false;
                    objRet.Message = "Your account is deactivated.";
                    objRet.Token = Token.ToString();
                    objRet.UserName = objUser.Login_Name;
                    objRet.SecurityGroupCode = objUser.Security_Group_Code.Value;
                    objUser = null;
                    return objRet;
                }
                objUser = (User)SearchForUser(objLoginDetails.UserName);

                if (objUser == null)
                {
                    objRet.IsSuccess = false;
                    objRet.Message = "User not exists in Music Hub";
                    objRet.Token = null;
                    objRet.UserName = "";
                    objRet.SecurityGroupCode = null;
                    return objRet;
                }

                if (IsLdapUser != "Y")
                {
                    if (objUser.Password_Fail_Count >= GetPasswordThresholdValue())
                        objUser = CheckPasswordExpiryandUpdate(objUser.Users_Code.Value);


                    if (!IsUserLocked(objUser.Password_Fail_Count) && IsLdapUser != "Y")
                    {
                        UpdatePasswordFailCount(objUser.Users_Code.Value);
                    }
                    int noOfRemainingAttempts = GetNoOfRemainingAttempts(objUser.Password_Fail_Count);

                    if (IsUserLocked(objUser.Password_Fail_Count) || noOfRemainingAttempts == 0)
                    {
                        int maxLockTimeMinutes = 0;

                        maxLockTimeMinutes = UserLockDuratin();

                        objRet.Message = "Your account is locked. Wait " + maxLockTimeMinutes + " mins to regain access";

                    }
                    else
                    {
                        if (noOfRemainingAttempts == GetPasswordThresholdValue() - 1)
                            objRet.Message = "Invalid password";
                        else
                        {
                            if (noOfRemainingAttempts < 4)
                            {
                                objRet.Message = "Invalid password, you have only " + noOfRemainingAttempts + " attempts remaining";
                            }
                            else
                            {
                                objRet.Message = "Invalid password";
                            }
                        }
                    }
                }
                else
                {
                    objRet.Message = "Invalid password";
                }

                // objUser = null;
                objRet.IsSuccess = false;
                objRet.Token = null;
                objRet.UserName = objUser.Login_Name;
                objRet.SecurityGroupCode = objUser.Security_Group_Code.Value;
                return objRet;
            }


            objRet.IsSuccess = false;
            objRet.Message = "Login Name / Password not Entered";
            objRet.Token = null;
            objRet.UserName = "";
            objRet.SecurityGroupCode = null;
            return objRet;
        }

        private bool IfSystemUser(LoginDetails user)
        {
            bool IsSystemUser = false;

            //ProEvalEntities _context = new ProEvalEntities();
            //GenericRepository<SystemParam> systemparamRepository = new GenericRepository<SystemParam>(_context);
            //GenericRepository<MSTUser> userRepository = new GenericRepository<MSTUser>(_context);

            // string userParamName = Convert.ToString(ConfigurationManager.AppSettings["SystemUsersParameterName"]).ToLower();

            ///
            //string CheckUserForsysadmin = "2"; // _unitOfWork.SystemConfigRepository.SearchFor(u => u.ConfigName.ToUpper() == "SYSTEMUSERS" && u.IsActive == "Y").FirstOrDefault().ConfigValue;
            //if (CheckUserForsysadmin != null && CheckUserForsysadmin != "")
            //{
            //    List<string> arrSplitUsersstr = CheckUserForsysadmin.Split(',').ToList();
            //    List<int> arrSplitUsers = arrSplitUsersstr.Select(s => int.Parse(s)).ToList();
            //    if (_unitOfWork.UserRepository.SearchFor(U => U.UserName.ToLower() == user.UserName.ToLower() && U.IsActive == "Y" && arrSplitUsers.Contains(U.UsersCode)).ToList().Count() > 0)
            //        IsSystemUser = true;
            //}
            return IsSystemUser;
        }

        private bool IfLoginNameExist(string loginName)
        {
            var Login_Name = SearchForUser(loginName);
            if (Login_Name != null)
                return true;
            else
                return false;
        }

        public object SearchForUser(string LoginName)
        {
            UserServices objService = new UserServices();
            var obj = new
            {
                Login_Name = LoginName,
                //Users_Code = 1219
            };
            //var objUser = objService.SearchForUser(obj).Where(x => x.IsProductionHouseUser == "Y").FirstOrDefault();
            var objUser = objService.SearchForUser(obj).FirstOrDefault();
            return objUser;
        }

        public bool LDAPValidation(string UserName, string Password, out string errMsg)
        {
            ServiceLog serviceLog = new ServiceLog();
            serviceLog.MethodName = "Step 3 INSIDE LDAPValidation()";
            objServiceLogServices.AddEntity(serviceLog);
            Error.WriteLog("LDAPValidation", includeTime: true, addSeperater: true);
            bool isSuccess = false;
            string dominName = string.Empty;
            string adPath = string.Empty;
            string userName = UserName;
            string strError = string.Empty;
            errMsg = strError;
            try
            {
                Error.WriteLog_Conditional("STEP 1 A: User Veryfying");


                dominName = Convert.ToString(ConfigurationManager.AppSettings["DirectoryDomain"]);  //key.Contains("DirectoryDomain") ? ConfigurationSettings.AppSettings[key] : dominName;
                adPath = Convert.ToString(ConfigurationManager.AppSettings["DirectoryPath"]);   //key.Contains("DirectoryPath") ? ConfigurationSettings.AppSettings[key] : adPath;

                Error.WriteLog_Conditional("STEP 2 A: User Veryfying" + dominName);
                Error.WriteLog_Conditional("STEP 2 B: User Veryfying" + adPath);

                if (!String.IsNullOrEmpty(dominName) && !String.IsNullOrEmpty(adPath))
                {
                    if (true == LDAPAuthentication(dominName, userName, Password, adPath, out strError))
                    {
                        isSuccess = true;

                        Error.WriteLog_Conditional("STEP 2 B: LDAP Success" + isSuccess);
                    }
                    dominName = string.Empty;
                    adPath = string.Empty;
                }
                if (!string.IsNullOrEmpty(strError))
                {
                    errMsg = strError;
                }
            }
            catch
            {
            }
            finally
            {
            }
            return isSuccess;
        }

        public bool LDAPAuthentication(string domain, string username, string password, string ldapPath, out string ErrMsg)
        {
            ServiceLog serviceLog = new ServiceLog();
            serviceLog.MethodName = "Step 3 INSIDE LDAPAuthentication()";
            objServiceLogServices.AddEntity(serviceLog);
            Error.WriteLog("LDAPAuthentication", includeTime: true, addSeperater: true);


            ErrMsg = "";
            string domainAndUsername = domain + @"\" + username;
            Error.WriteLog_Conditional("STEP 2 B: domain" + domain);
            Error.WriteLog_Conditional("STEP 2 B: username" + username);
            Error.WriteLog_Conditional("STEP 2 B: username" + password);
            DirectoryEntry entry = new DirectoryEntry(ldapPath, domainAndUsername, password);
            Error.WriteLog("ldapPath", includeTime: true, addSeperater: true);
            try
            {
                // Bind to the native AdsObject to force authentication.
                Object obj = entry.NativeObject;
                DirectorySearcher search = new DirectorySearcher(entry);
                search.Filter = "(SAMAccountName=" + username + ")";
                search.PropertiesToLoad.Add("cn");
                SearchResult result = search.FindOne();
                if (null == result)
                {
                    return false;
                }
                // Update the new path to the user in the directory
                ldapPath = result.Path;
                string _filterAttribute = (String)result.Properties["cn"][0];
            }
            catch (Exception ex)
            {
                ErrMsg = ex.Message;
                return false;
            }
            return true;
        }

        private object FetchUserObject(User objUser, int loginDetailsCode = 0)
        {
            User objNewUser = objUser;
            UserManagementService objUserManagementService = new UserManagementService();

            var objU = new
            {
                Users_Code = objNewUser.Users_Code ?? 0
            };

            objUser = objUserManagementService.SearchForUser(objU).FirstOrDefault();

            return objUser;
        }

        private object validateUser(string strUserName, string strPassword)
        {
            string encryptedPassword = Encryption.Encrypt(strPassword.Trim());//GetEncriptedStr(strPassword.Trim());  
            UserServices objService = new UserServices();
            var obj = new
            {
                Login_Name = strUserName,
                Password = encryptedPassword
            };
            //var objUser = objService.SearchForUser(obj).Where(x => x.IsProductionHouseUser == "Y").FirstOrDefault();
            var objUser = objService.SearchForUser(obj).FirstOrDefault();
            return objUser;
        }

        private int GetPasswordThresholdValue()
        {
            //MHSystemParameter obj = new MHSystemParameter();
            int passwordThresholdValue = 0;
            var obj = new
            {
                ParameterName = "PASSWORDFAILCOUNT",
                //Users_Code = 1219
            };

            var firstOrDefault = objSystemParameterServices.GetSystemParameterList().Where(x => x.Parameter_Name.ToUpper() == "MH_PASSWORDFAILCOUNT").FirstOrDefault();
            //objSystemParameterServices.GetSystemParameterList().Select(x => x.ParameterName == "PASSWORDFAILCOUNT").FirstOrDefault(); //"PASSWORDFAILCOUNT";
            if (firstOrDefault != null)
                passwordThresholdValue = Convert.ToInt32(firstOrDefault.Parameter_Value);// Convert.ToInt32(firstOrDefault.ConfigValue);
            return passwordThresholdValue;
        }

        public User CheckPasswordExpiryandUpdate(int userCode)
        {
            // bool isValid = false;
            UserServices objUserServices = new UserServices();
            User objUser;
            //  var objUsersBll = new UsersBll();
            //SystemConfigBLL ObjSystemConfigBLL = new SystemConfigBLL();
            objUser = GetUserByID(userCode);

            try
            {
                DateTime currenTime = DateTime.Now;
                DateTime lastLoginTime = DateTime.MinValue;

                if (!objUser.Last_Updated_Time.Equals(null))
                    lastLoginTime = Convert.ToDateTime(objUser.Last_Updated_Time);

                int time = Convert.ToInt32(currenTime.Subtract(lastLoginTime).TotalMinutes);
                int maxLockTimeMinutes = 0;
                //int MaxLockTimeMinutes = Convert.ToInt32(new System_Parameter_New_Service().SearchFor(x => x.Parameter_Name.ToUpper() == "MAXLOCKTIMEMINUTES").Select(s => s.Parameter_Value).FirstOrDefault());

                var firstOrDefault = objSystemParameterServices.GetSystemParameterList().Where(x => x.Parameter_Name.ToUpper() == "MH_USERLOCKDURATION").FirstOrDefault();// _unitOfWork.SystemConfigRepository.Get(s => s.ConfigName.ToUpper() == "USERLOCKDURATION");

                if (firstOrDefault != null)
                    maxLockTimeMinutes = Convert.ToInt32(firstOrDefault.Parameter_Value);

                if (time >= maxLockTimeMinutes)
                {
                    // Release Lock
                    objUser.Password_Fail_Count = 0;
                    objUser.Last_Updated_Time = DateTime.Now;
                    objUserServices.UpdateUser(objUser);
                    //_unitOfWork.UserRepository.Update(objUser);
                    //_unitOfWork.Save();
                }

                // isValid = true;
            }
            catch (Exception)
            {
                //  isValid = false;
            }


            return objUser;
        }

        public bool IsUserLocked(int? passwordFailCount)
        {
            bool isUserLocked = passwordFailCount >= GetPasswordThresholdValue();
            return isUserLocked;
        }

        public bool IsPasswordValid(int userCode)
        {
            var isValid = true;
            var currentDate = DateTime.Now;
            var lastPasswordChangeDate = DateTime.Now;
            //Users_Password_Detail objUserServices = new Users_Password_Detail();
            User objUserServices = new User();

            //   var objUserPasswordDetailBll = new UserPasswordDetailBLL();
            // var objSystemConfigBll = new SystemConfigBLL();
            var objUserUserPasswordDetailViewModel = GetUserByID(userCode); //_unitOfWork.UserPasswordDetailRepository.Get(u => u.UsersCode == userCode);
            if (objUserUserPasswordDetailViewModel != null)
                lastPasswordChangeDate = objUserUserPasswordDetailViewModel.Last_Updated_Time ?? DateTime.Now;

            var firstOrDefault = objSystemParameterServices.GetSystemParameterList().Where(x => x.Parameter_Name.ToUpper() == "MH_PASSWORDVALIDDAY").FirstOrDefault(); //"PASSWORDVALIDDAY";
            if (firstOrDefault != null)
            {
                var passwordValidDay = firstOrDefault.Parameter_Value;//Convert.ToInt32(firstOrDefault.ConfigValue);
                var diffDays = currentDate.Subtract(lastPasswordChangeDate).TotalDays;

                if (diffDays > Convert.ToDouble(passwordValidDay))
                    isValid = false;
            }

            return isValid;
        }

        public int UserLockDuratin()
        {
            int userLockDuration = 0;
            var firstOrDefault = objSystemParameterServices.GetSystemParameterList().Where(x => x.Parameter_Name.ToUpper() == "MH_USERLOCKDURATION").FirstOrDefault();
            if (firstOrDefault != null)
                userLockDuration = Convert.ToInt32(firstOrDefault.Parameter_Value);
            return userLockDuration;
        }

        public bool UpdatePasswordFailCount(int userCode)
        {
            var isValid = false;
            UserServices objUserServices = new UserServices();
            var objUser = objUserServices.GetUserByID(userCode);

            objUser.Password_Fail_Count = objUser.Password_Fail_Count + 1;
            
            try
            {
                objUserServices.UpdateUser(objUser);
                isValid = true;
            }
            catch (Exception)
            {
                isValid = false;
            }
            return isValid;
        }

        private int GetNoOfRemainingAttempts(int? passwordFailCount)
        {
            int noOfRemainingAttempts = 0;
            //  passwordFailCount = passwordFailCount + 1;
            noOfRemainingAttempts = GetPasswordThresholdValue() - Convert.ToInt32(passwordFailCount);
            return noOfRemainingAttempts;
        }

        public LoggedInUsers GetUserToken(User objUser)
        {
            LoggedInUsersServices objService = new LoggedInUsersServices();
            UserServices objUserService = new UserServices();

            User obj = (User)objUserService.GetUserByID(objUser.Users_Code ?? 0);
            LoggedInUsers objdetails = new LoggedInUsers();
            objdetails.LoginName = obj.Login_Name ?? "";
            var details = new { LoginName = obj.Login_Name ?? "" };
            LoggedInUsers objLogin_Details = objService.SearchFor(details).FirstOrDefault();
            return objLogin_Details;
        }
    }
}
