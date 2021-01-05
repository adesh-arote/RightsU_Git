using RightsUMusic.BLL.Services;
using RightsUMusic.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Cors;
using System.Web.Http.Cors;
using System.Configuration;
using System.Web;
using System.Configuration;
using System.Web;
using System.Threading.Tasks;
using System.Security.Claims;
using System.IO;
using System.Web.Hosting;

namespace RightsUMusic.API.Controllers
{
    //[SessionFilter]
    public class LoginController : ApiController
    {
        private readonly UserServices objUserServices = new UserServices();
        private readonly Login_DetailsServices objLogin_DetailsServices = new Login_DetailsServices();
        private readonly SystemParameterServices objSystemParameterServices = new SystemParameterServices();
        private readonly UserManagementService objUserManagementService = new UserManagementService();
        private bool _isSuccess;
        Return _objRet = new Return();
        private string _retMsg;


        //    [AllowAnonymous]
        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public IHttpActionResult GetUserList()
        {
            UserServices objService = new UserServices();
            try
            {
                return Ok(objService.GetUserList());
            }
            catch (Exception ex)
            {
                return InternalServerError(ex);
            }

        }

        public User GetUserByID(int userCode)
        {
            UserServices objService = new UserServices();
            var User = objService.GetUserByID(userCode);
            return User;
        }

        public object SearchForUser(string LoginName)
        {
            UserServices objService = new UserServices();
            var obj = new
            {
                Login_Name = LoginName,
                //Users_Code = 1219
            };
            var objUser = objService.SearchForUser(obj).Where(x => x.IsProductionHouseUser == "Y").FirstOrDefault();
            return objUser;
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        [ActionName("GetUserLogin")]
        [EnableCors(origins: "*", headers: "*", methods: "*")]
        public HttpResponseMessage GetUserLogin(LoginDetails objLoginDetails)
        {
            UserManagementService objUserManagementService = new UserManagementService();
            User ObjUser = new User();
            _objRet = new Return();
            var objUserDetails = (dynamic)null;
            try
            {
                _objRet = objUserManagementService.GetLogin(objLoginDetails); //authenticationManagement.GetLogin(user);

                //if (_objRet.IsSuccess)
                //    objUserDetails = authenticationManagement.FetchUserObject(ObjUser, ObjUser.UsersLoginDetailsCode);

            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message;
                _objRet.IsSuccess = false;
            }
            finally
            {

            }

            //httpReturn.IsSuccess = _objRe.IsSuccess;
            //httpReturn.Message = _objRe.Message;
            return Request.CreateResponse(HttpStatusCode.Created, new { User = _objRet });
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        [ActionName("GetLogin")]
        [EnableCors(origins: "*", headers: "*", methods: "*")]
        public HttpResponseMessage GetLogin(LoginDetails objLoginDetails)
        {
            string errMsg = string.Empty;
            Return objRet = new Return();
            User objUser = null;
            long Token = DateTime.Now.Ticks;

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
                    return Request.CreateResponse(HttpStatusCode.OK, new { Return = objRet/*, User = objUser */}, Configuration.Formatters.JsonFormatter);
                }

                // objUser = (User)SearchForUser(objLoginDetails.UserName) ;

                //if (Convert.ToString(ConfigurationManager.AppSettings["IsLDAPAuthReq"]).Trim() == "Y" && IsSystemUser == false)//
                //{
                //    objUser.IsLdapUser = "Y";
                //    IsLdapUser = "Y";
                //}
                //else
                //{
                //    objUser.IsLdapUser = "N";
                //    IsLdapUser = "N";
                //}

                //if (IsLdapUser == "Y")
                //{
                //    if (LdapValidation(objLoginDetails.UserName, objLoginDetails.Password, out errMsg))
                //        objUser = (Users)FetchUser(objLoginDetails.UserName);
                //    else
                //        objUser = null;
                //}
                //else

                objUser = (User)validateUser(objLoginDetails.UserName, objLoginDetails.Password);

                if (objUser != null)
                {
                    //Token = DateTime.Now.Ticks;

                    if (objUser.Is_Active == "Y")
                    {
                        if (IsLdapUser != "Y" && objUser.Password_Fail_Count >= GetPasswordThresholdValue())
                            objUser = CheckPasswordExpiryandUpdate(objUser.Users_Code.Value);

                        if (!IsUserLocked(objUser.Password_Fail_Count) || IsLdapUser == "Y")
                        {
                            int loginDetailsCode = SaveLoginDetails_OnLogin(objUser.Users_Code.Value);
                            var retObjUser = FetchUserObject(objUser, 0);

                            if (IsLdapUser == "Y")
                            {
                                objRet.IsSuccess = true;
                                objRet.Message = "Login Successful";
                                objRet.Token = Token.ToString();
                                return Request.CreateResponse(HttpStatusCode.OK, new { Return = objRet/*, User = retObjUser*/ }, Configuration.Formatters.JsonFormatter);
                            }
                            objUser = AfterLoginPasswordUpdate(objUser.Users_Code.Value);

                            bool passwordValidDay = IsPasswordValid(objUser.Users_Code.Value);
                            if (!passwordValidDay || (objUser.Is_System_Password == "Y"))
                            {
                                objRet.IsSuccess = false;
                                objRet.Message = "Change Password";
                                objRet.Token = Token.ToString();
                                objRet.UserName = objUser.Login_Name;
                                objRet.SecurityGroupCode = objUser.Security_Group_Code.Value;
                                return Request.CreateResponse(HttpStatusCode.OK, new { Return = objRet/*, User = retObjUser */}, Configuration.Formatters.JsonFormatter);
                            }
                            objRet.IsSuccess = true;
                            objRet.Message = "Login Successful";
                            objRet.Token = Token.ToString();
                            objRet.UserName = objUser.Login_Name;
                            objRet.SecurityGroupCode = objUser.Security_Group_Code.Value;
                            return Request.CreateResponse(HttpStatusCode.OK, new { Return = objRet/*, User = objUser*/}, Configuration.Formatters.JsonFormatter);
                        }
                        objRet.IsSuccess = false;
                        var maxLockTimeMinutes = 0;

                        maxLockTimeMinutes = UserLockDuratin();

                        objRet.Message = "Your account is locked. Wait " + maxLockTimeMinutes + " mins to regain access";

                        objUser = null;
                        return Request.CreateResponse(HttpStatusCode.OK, new { Return = objRet/*, User = objUser*/ }, Configuration.Formatters.JsonFormatter);
                    }
                    objRet.IsSuccess = false;
                    objRet.Message = "Your account is deactivated.";
                    objRet.Token = Token.ToString();
                    objRet.UserName = objUser.Login_Name;
                    objRet.SecurityGroupCode = objUser.Security_Group_Code.Value;
                    objUser = null;
                    return Request.CreateResponse(HttpStatusCode.OK, new { Return = objRet/*, User = objUser */}, Configuration.Formatters.JsonFormatter);
                }
                objUser = (User)SearchForUser(objLoginDetails.UserName);

                if (objUser == null)
                {
                    objRet.IsSuccess = false;
                    objRet.Message = "User not exists in Music Hub";
                    objRet.Token = null;
                    objRet.UserName = "";
                    objRet.SecurityGroupCode = null;
                    return Request.CreateResponse(HttpStatusCode.OK, new { Return = objRet/*, User = objUser */}, Configuration.Formatters.JsonFormatter);
                }

                if (IsLdapUser != "Y")
                {
                    if (objUser.Password_Fail_Count >= GetPasswordThresholdValue())
                        objUser = CheckPasswordExpiryandUpdate(objUser.Users_Code.Value);


                    if (!IsUserLocked(objUser.Password_Fail_Count) && IsLdapUser != "Y")
                    {
                        // UpdatePasswordFailCount(objUser.Users_Code);
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
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = objRet/*, User = objUser */}, Configuration.Formatters.JsonFormatter);
            }


            objRet.IsSuccess = false;
            objRet.Message = "Login Name / Password not Entered";
            objRet.Token = null;
            objRet.UserName = "";
            objRet.SecurityGroupCode = null;
            return Request.CreateResponse(HttpStatusCode.OK, new { Return = objRet/*, User = objUser*/ }, Configuration.Formatters.JsonFormatter);
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

        private object validateUser(string strUserName, string strPassword)
        {
            string encryptedPassword = Encryption.Encrypt(strPassword.Trim());//GetEncriptedStr(strPassword.Trim());  
            UserServices objService = new UserServices();
            var obj = new
            {
                Login_Name = strUserName,
                Password = encryptedPassword
            };
            var objUser = objService.SearchForUser(obj).Where(x => x.IsProductionHouseUser == "Y").FirstOrDefault();
            return objUser;
        }


        public int SaveUserLoginDetails(User objUser)
        {
            //   bool isValid = false;
            User objNewUser = objUser;
            // UserService objNewUserService = new UserService();


            objNewUser.Password_Fail_Count = 0;
            objNewUser.Last_Updated_Time = DateTime.Now;


            //   objNewUser.EntityState = State.Modified;
            //  UsersLoginDetailsService objUsersLoginDetailsService = new UsersLoginDetailsService();

            Login_Details objUsersLoginDetail = new Login_Details();

            objUsersLoginDetail.Security_Group_Code = objNewUser.Security_Group_Code.Value;
            objUsersLoginDetail.Login_Time = DateTime.Now;
            objUsersLoginDetail.Description = "Login";
            objUsersLoginDetail.Users_Code = objNewUser.Users_Code ?? 0;

            //objNewUser.UsersLoginDetails.Add(objUsersLoginDetail);

            try
            {
                objLogin_DetailsServices.AddEntity(objUsersLoginDetail);
                objUserServices.UpdateUser(objNewUser);
                //objNewUserService.Save(objNewUser);
                // isValid = true;
            }
            catch (Exception)
            {
                // isValid = false;
            }
            return objUsersLoginDetail.Login_Details_Code ?? 0;
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

        private object FetchUserObject(User objUser, int loginDetailsCode = 0)
        {
            User objNewUser = objUser;
            UserManagementService objUserManagementService = new UserManagementService();

            MHUsersServices objMHUsersServices = new MHUsersServices();
            var objU = new
            {
                Users_Code = objNewUser.Users_Code ?? 0
            };
            MHUsers objMHUser = objMHUsersServices.SearchFor(objU).FirstOrDefault();

            VendorServices objVendorServices = new VendorServices();
            Vendor objVendor = objVendorServices.GetVendorByID(objMHUser.Vendor_Code);

            var lstMenu = objUserManagementService.GetMenu(objNewUser.Security_Group_Code.Value).ToArray();

            var retObjUser = new
            {
                objNewUser.Users_Code,
                objNewUser.Login_Name,
                objNewUser.Email_Id,
                SecurityGroupCode = objNewUser.Security_Group_Code,
                LoginDetailsCode = loginDetailsCode,
                ProductionHouse = objVendor.Vendor_Name,
                VendorShortName = objVendor.Short_Code ?? "",
                FullName = objNewUser.First_Name + " " + objNewUser.Last_Name,
                Menu = lstMenu
            };
            return retObjUser;
        }



        public User AfterLoginPasswordUpdate(int userCode)
        {
            // bool isValid = false;
            //    var objUsersBll = new UsersBll();
            var objUser = GetUserByID(userCode);

            try
            {
                objUser.Password_Fail_Count = 0;
                objUser.Last_Updated_Time = DateTime.Now;
                //_unitOfWork.UserRepository.Update(objUser);
                //_unitOfWork.Save();
            }
            catch (Exception)
            {
                // ignored
            }
            return objUser;
        }

        public bool IsPasswordValid(int userCode)
        {
            var isValid = true;
            var currentDate = DateTime.Now;
            var lastPasswordChangeDate = DateTime.Now;
            Users_Password_Detail objUsersPasswordDetail = new Users_Password_Detail();

            User objUserServices = new User();

            var objUserUserPasswordDetailViewModel = GetUserByID(userCode);

            string strSearch = "Select top 1 * from Users_Password_Detail where Users_Code  = "+userCode+" order by Password_Change_Date desc";

            List<Users_Password_Detail> lst = new List<Users_Password_Detail>();
            lst = objUserManagementService.GetPasswordDetails(strSearch).ToList();


            //if (objUserUserPasswordDetailViewModel != null)
            //    lastPasswordChangeDate = objUserUserPasswordDetailViewModel.Last_Updated_Time ?? DateTime.Now;

            if (objUsersPasswordDetail != null)
                lastPasswordChangeDate = lst.FirstOrDefault().Password_Change_Date ?? DateTime.Now;

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

        private int SaveLoginDetails_OnLogin(int userCode)
        {

            int loginDetailsCode = 0;
            try
            {
                Login_Details objLogin_Details = new Login_Details();
                objLogin_Details.Login_Time = DateTime.Now;
                objLogin_Details.Logout_Time = null;
                objLogin_Details.Description = "Login";
                objLogin_Details.Users_Code = userCode;
                objLogin_Details.Security_Group_Code = 1;
                objLogin_DetailsServices.AddEntity(objLogin_Details);

                // objUserLoginDetailsBll.Save(objUserLoginDetailsViewModel);

                loginDetailsCode = objLogin_Details.Login_Details_Code.Value;

            }
            catch (Exception e)
            {
                var a = e.InnerException;
            }
            return loginDetailsCode;
        }
        public int UserLockDuratin()
        {
            int userLockDuration = 0;
            var firstOrDefault = objSystemParameterServices.GetSystemParameterList().Where(x => x.Parameter_Name.ToUpper() == "MH_USERLOCKDURATION").FirstOrDefault();
            if (firstOrDefault != null)
                userLockDuration = Convert.ToInt32(firstOrDefault.Parameter_Value);
            return userLockDuration;
        }

        private int GetNoOfRemainingAttempts(int? passwordFailCount)
        {
            int noOfRemainingAttempts = 0;
            //  passwordFailCount = passwordFailCount + 1;
            noOfRemainingAttempts = GetPasswordThresholdValue() - Convert.ToInt32(passwordFailCount);
            return noOfRemainingAttempts;
        }


        [AcceptVerbs("GET", "POST")]
        //[ActionName("GetLoginDetails")]
        //[EnableCors(origins: "*", headers: "*", methods: "*")]
        [AllowAnonymous]
        [HttpPost]
        public HttpResponseMessage GetLoginDetails(User objUser)
        {

            //   var claimsPrincipal = User as ClaimsPrincipal;
            var username = objUser.Login_Name;// claimsPrincipal?.FindFirst("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier").Value;
            string AccessToken = "";
            string RefreshToken = "";
            var re = Request.Headers;

            try
            {

                if (re.GetValues("Authorization") != null)
                {
                    string[] arr = (string[])re.GetValues("Authorization");
                    AccessToken = arr[0];
                    AccessToken = AccessToken.Replace("Bearer ", "");
                }
                if (re.GetValues("token") != null)
                {
                    string[] arr1 = (string[])re.GetValues("token");
                    RefreshToken = arr1[0];
                    RefreshToken = RefreshToken.Replace("Bearer ", "");
                }


                if (CheckUserSession(username, AccessToken, RefreshToken, System.Web.HttpContext.Current))
                {
                    User objUsertocheck = (User)SearchForUser(username);
                    int UsersLoginDetailsCode = SaveUserLoginDetails(objUsertocheck);
                    //   User objUsertocheck = new User();
                    //objUsertocheck.Login_Name = username;
                    var retObjUser = FetchUserObject(objUsertocheck, UsersLoginDetailsCode);
                    //  objUser.IsSystemUser = IsSystemUser;
                    
                    bool passwordValidDay = IsPasswordValid(objUsertocheck.Users_Code.Value);
                    if (!passwordValidDay)
                    {
                        _objRet.IsSuccess = false;
                        _objRet.Message = "Change Password";
                        _objRet.IsSystemPassword = "Y";
                        return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet,User = retObjUser }, Configuration.Formatters.JsonFormatter);
                    }

                    //int UsersLoginDetailsCode = SaveUserLoginDetails(objUsertocheck);
                    ////   User objUsertocheck = new User();
                    ////objUsertocheck.Login_Name = username;
                    //var retObjUser = FetchUserObject(objUsertocheck, UsersLoginDetailsCode);

                    //bool passwordValidDay = IsPasswordValid(objUsertocheck.Users_Code.Value);
                    //if (!passwordValidDay)
                    //{
                    //    _objRet.IsSuccess = false;
                    //    _objRet.Message = "Change Password";
                    //    _objRet.IsSystemPassword = objUsertocheck.Is_System_Password;
                    //    return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, User = retObjUser }, Configuration.Formatters.JsonFormatter);
                    //}

                    _objRet.IsSuccess = true;
                    _objRet.Message = "Login Successful";
                    _objRet.IsSystemPassword = objUsertocheck.Is_System_Password;
                    return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, User = retObjUser }, Configuration.Formatters.JsonFormatter);
                }
                else
                {
                    _objRet.IsSuccess = false;
                    _objRet.Message = "Locked";
                    var newUser = (dynamic)null;
                    return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, User = newUser }, Configuration.Formatters.JsonFormatter);
                }
            }
            catch (Exception e)
            {
                _objRet.IsSuccess = false;
                _objRet.Message = e.Message;
                var newUser = (dynamic)null;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, User = newUser }, Configuration.Formatters.JsonFormatter);
            }

        }

        [HttpPost]
        [ActionName("LogOutAccount")]
        [EnableCors(origins: "*", headers: "*", methods: "*")]
        public HttpResponseMessage LogoutAccount(User_Info objUserInfo)
        {
            UserManagementService objUserManagementService = new UserManagementService();
            User ObjUser = new User();

            string UserCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UserCode = UserCode.Replace("Bearer ", "").Trim();
            _objRet = new Return();
            //var objUserDetails = (dynamic)null;
            try
            {
                _objRet = objUserManagementService.LogOutAccount(Convert.ToInt32(UserCode), objUserInfo.LoginDetailsCode); //authenticationManagement.GetLogin(user);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message;
                _objRet.IsSuccess = false;
            }
            finally
            {

            }
            return Request.CreateResponse(HttpStatusCode.Created, new { User = _objRet });
        }

        [HttpPost]
        [ActionName("LogOut")]
        [EnableCors(origins: "*", headers: "*", methods: "*")]
        [AllowAnonymous]
        public HttpResponseMessage Logout(User objUserInfo)
        {
            UserManagementService objUserManagementService = new UserManagementService();
            User ObjUser = new User();
            ObjUser = (User)SearchForUser(objUserInfo.Login_Name);

            //  string UserCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            //  int UserCode = 0;//UserCode.Replace("Bearer ", "").Trim();

            _objRet = new Return();
            //var objUserDetails = (dynamic)null;
            try
            {
                if (ObjUser != null)
                    _objRet = objUserManagementService.LogOutAccount(Convert.ToInt32(ObjUser.Users_Code), 0); //authenticationManagement.GetLogin(user);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message;
                _objRet.IsSuccess = false;
            }
            finally
            {

            }
            return Request.CreateResponse(HttpStatusCode.Created, new { User = _objRet });
        }

        [HttpPost]
        [ActionName("ForgotPassword")]
        [EnableCors(origins: "*", headers: "*", methods: "*")]
        [AllowAnonymous]
        public HttpResponseMessage ForgotPassword(EmailInfo objEmailInfo)
        {
            UserManagementService objUserManagementService = new UserManagementService();
            User ObjUser = new User();
            _objRet = new Return();
            //var objUserDetails = (dynamic)null;
            try
            {
                _objRet = objUserManagementService.ForgotPassword(objEmailInfo.Email_Id); //authenticationManagement.GetLogin(user);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message;
                _objRet.IsSuccess = false;
            }
            finally
            {

            }
            return Request.CreateResponse(HttpStatusCode.Created, new { User = _objRet });
        }


        [HttpPost]
        [ActionName("GetMenuRights")]
        [EnableCors(origins: "*", headers: "*", methods: "*")]
        public HttpResponseMessage GetMenuRights(Menu_Info objMenuInfo)
        {
            UserManagementService objUserManagementService = new UserManagementService();
            string UserCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UserCode = UserCode.Replace("Bearer ", "").Trim();
            string MenuRights = "";
            _objRet = new Return();

            try
            {
                MenuRights = objUserManagementService.GetModulerights(objMenuInfo.ModuleCode, objMenuInfo.SecurityGroupCode).ToString();
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message;
                _objRet.IsSuccess = false;
            }
            finally
            {

            }
            return Request.CreateResponse(HttpStatusCode.Created, new { MenuRights = MenuRights });
        }

        public bool CheckUserSession(string username, string AccessToken, string RefreshToken, HttpContext Current)
        {
            bool isValid = false;
            UserServices objUserServices = new UserServices();
            LoggedInUsersServices objLoggedInUsersServices = new LoggedInUsersServices();
            LoggedInUsers objLoggedInUsers = new LoggedInUsers();

            User objUser = objUser = (User)SearchForUser(username);
            HttpApplicationState Application = HttpContext.Current.Application;

            Application.Lock();
            var obj = new { LoginName = username, };
            int Count = objLoggedInUsersServices.SearchFor(obj).ToList().Count();

            objLoggedInUsers.LoginName = objUser.Login_Name;
            objLoggedInUsers.AccessToken = AccessToken;
            objLoggedInUsers.RefreshToken = RefreshToken;

            if (Count > 0)
            {
                int CountForCurrentUser = objLoggedInUsersServices.SearchFor(objLoggedInUsers).ToList().Count();
                if (CountForCurrentUser == 0)
                {
                    var objcheckuser = new { LoginName = username, };
                    LoggedInUsers objLoggedInUsersToCheck = objLoggedInUsersServices.SearchFor(objcheckuser).ToList().FirstOrDefault();

                    int maxTime = Convert.ToInt32(ConfigurationManager.AppSettings["SessionExpiration"]);
                    double maxTimeInSec = maxTime * 60;

                    DateTime loggedTime = objLoggedInUsersToCheck.LastUpdatedTime.Value;
                    DateTime currentTime = DateTime.Now;

                    TimeSpan totalTimeDiffInSec = currentTime.Subtract(loggedTime);

                    double currentTimeInSec = totalTimeDiffInSec.TotalSeconds;

                    if (maxTimeInSec <= currentTimeInSec)
                    {

                        objLoggedInUsers.LoginName = objUser.Login_Name;
                        objLoggedInUsers.HostIP = Current.Request.UserHostAddress;
                        objLoggedInUsers.LoggedinTime = DateTime.Now;
                        objLoggedInUsers.LastUpdatedTime = DateTime.Now;
                        objLoggedInUsers.BrowserDetails = string.IsNullOrEmpty(Current.Request.Browser.Browser) ? "" : Current.Request.Browser.Browser;
                        objLoggedInUsers.LoggedInUrl = string.IsNullOrEmpty(Current.Request.Url.OriginalString) ? "" : Current.Request.Url.OriginalString;
                        objLoggedInUsers.AccessToken = AccessToken;
                        objLoggedInUsers.RefreshToken = RefreshToken;
                        objLoggedInUsersServices.AddEntity(objLoggedInUsers);
                        try
                        {
                            objLoggedInUsersServices.DeleteLoggedInUsers(objLoggedInUsersToCheck);
                            objLoggedInUsersServices.AddEntity(objLoggedInUsers);
                            isValid = true;
                        }
                        catch (Exception)
                        {
                            isValid = false;
                        }
                    }
                    else
                    {
                        isValid = false;
                    }
                }
                else
                {
                    isValid = true;
                }
            }
            else
            {
                objLoggedInUsers.LoginName = objUser.Login_Name;
                objLoggedInUsers.HostIP = Current.Request.UserHostAddress;
                objLoggedInUsers.LoggedinTime = DateTime.Now;
                objLoggedInUsers.LastUpdatedTime = DateTime.Now;
                objLoggedInUsers.BrowserDetails = string.IsNullOrEmpty(Current.Request.Browser.Browser) ? "" : Current.Request.Browser.Browser;
                objLoggedInUsers.LoggedInUrl = string.IsNullOrEmpty(Current.Request.Url.OriginalString) ? "" : Current.Request.Url.OriginalString;
                objLoggedInUsers.AccessToken = AccessToken;
                objLoggedInUsers.RefreshToken = RefreshToken;

                try
                {
                    objLoggedInUsersServices.AddEntity(objLoggedInUsers);
                    isValid = true;
                }
                catch (Exception ex)
                {
                    var msg = ex.Message;
                    isValid = false;
                }

            }
            Application.UnLock();
            return isValid;
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage ChangePassword(ChangePasswordInput changePasswordInput)
        {
            Return _objRet = new Return();
            string UsersCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UsersCode = UsersCode.Replace("Bearer ", "");

            User userObject = new User();
            Users_Password_Detail users_Password_Detail = new Users_Password_Detail();
            userObject = GetUserByID(Convert.ToInt32(UsersCode));

            string oldPassword = Encryption.Encrypt(changePasswordInput.OldPassword);
            string newPassword = Encryption.Encrypt(changePasswordInput.NewPassword);

            string strSearch = "Select top 5 * from Users_Password_Detail where Users_Code = " + UsersCode + " AND Users_Passwords = '" + newPassword + "' order by 1 desc";

            List<Users_Password_Detail> lst = new List<Users_Password_Detail>();
            lst = objUserManagementService.GetPasswordDetails(strSearch).ToList();

            if (oldPassword != userObject.Password)
            {
                _objRet.Message = "Old password is incorrect.";
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
            else if (newPassword == userObject.Password)
            {
                _objRet.Message = "Please change your password, it should not be same as old Password";
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
            else if (lst.Count > 0)
            {
                _objRet.Message = "Please enter some other password, it matches your old password history";
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
            else
            {
                userObject.Password = newPassword;
                userObject.Is_System_Password = "N";
                userObject.Last_Updated_Time = DateTime.Now;
                objUserServices.UpdateUser(userObject);

                users_Password_Detail.Users_Code = Convert.ToInt32(UsersCode);
                users_Password_Detail.Users_Passwords = newPassword;
                users_Password_Detail.Password_Change_Date = DateTime.Now;
                objUserManagementService.AddPasswordDetails(users_Password_Detail);

            }

            try
            {
                _objRet.Message = "Password changed successfully.";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }

        [HttpPost]
        [ActionName("DecryptPassword")]
        [EnableCors(origins: "*", headers: "*", methods: "*")]
        public HttpResponseMessage DecryptPassword(User objUser)
        {
            UserManagementService objUserManagementService = new UserManagementService();
            string password = "";
            Return _objRet = new Return();

            try
            {
                password = Encryption.Decrypt(objUser.Password).ToString();
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message;
                _objRet.IsSuccess = false;
            }
            finally
            {

            }
            return Request.CreateResponse(HttpStatusCode.Created, new { Password = password });
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage UploadImage()
        {
            Return _objRet = new Return();
            try
            {
                var httpRequest = HttpContext.Current.Request;
                //var UsersCode = httpRequest.Form["UsersCode"];
                string UsersCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
                UsersCode = UsersCode.Replace("Bearer ", "");

                var fileWithTimeStamp = "";
                var fileWithOutTimeStamp = "";
                User objUser = new User();
                foreach (string file in httpRequest.Files)
                {
                    var postedFile = httpRequest.Files[file];
                    fileWithOutTimeStamp = Path.GetFileNameWithoutExtension(postedFile.FileName) + Path.GetExtension(postedFile.FileName);
                    fileWithTimeStamp = Path.GetFileNameWithoutExtension(postedFile.FileName) + "_" + DateTime.Now.ToFileTime() + Path.GetExtension(postedFile.FileName);
                    var fileName = Path.GetFileNameWithoutExtension(postedFile.FileName) + Path.GetExtension(postedFile.FileName);
                    var filePath = HttpContext.Current.Server.MapPath("~/Uploads/" + fileWithTimeStamp);
                    postedFile.SaveAs(filePath);

                    string sourcePath = HttpContext.Current.Server.MapPath(ConfigurationManager.AppSettings["SourcePath"]); 
                    //string sourcePath = @Convert.ToString(ConfigurationManager.AppSettings["SourcePath"]);
                    Error.WriteLog("Source Path: " + sourcePath, includeTime: true, addSeperater: true);
                    //string targetPathRU = HttpContext.Current.Server.MapPath(ConfigurationManager.AppSettings["DestPathMH"]);
                    string targetPathRU = @Convert.ToString(ConfigurationManager.AppSettings["DestPathMH"]);
                    Error.WriteLog("Target RU Path: " + targetPathRU, includeTime: true, addSeperater: true);

                    string sourceFile = Path.Combine(sourcePath, fileWithTimeStamp);
                    Error.WriteLog("Source File 1: " + sourceFile, includeTime: true, addSeperater: true);
                    string destFileRU = Path.Combine(targetPathRU, fileWithTimeStamp);
                    Error.WriteLog("destFile RU 1: " + destFileRU, includeTime: true, addSeperater: true);

                    File.Copy(sourceFile, destFileRU, true);

                    objUser = objUserServices.GetUserByID(Convert.ToInt32(UsersCode));
                    objUser.User_Image = fileWithTimeStamp;

                    objUserServices.UpdateUser(objUser);

                }
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, User = objUser }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                string msg = " Error at GetUsers : ";
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }
    }

    public class User_Info
    {
        //  public int UsersCode { get; set; }
        public int LoginDetailsCode { get; set; }
    }

    public class Menu_Info
    {
        public int ModuleCode { get; set; }
        public int SecurityGroupCode { get; set; }
    }

    public class EmailInfo
    {
        public string Email_Id { get; set; }
    }

    public class ChangePasswordInput
    {
        public string OldPassword { get; set; }
        public string NewPassword { get; set; }
    }
}