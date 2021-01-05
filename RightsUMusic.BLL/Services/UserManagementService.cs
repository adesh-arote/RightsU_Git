using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RightsUMusic.Entity;
using System.Configuration;
using RightsUMusic.DAL.Repository;

namespace RightsUMusic.BLL.Services
{
    public class UserManagementService : UserServices
    {
        private readonly UserManagementService objUserManagementService;

        private readonly Login_DetailsServices objLogin_DetailsServices = new Login_DetailsServices();
        private readonly SystemParameterServices objSystemParameterServices = new SystemParameterServices();
        private readonly Users_Password_DetailRepositories objUsers_Password_DetailRepositories = new Users_Password_DetailRepositories();
        private readonly USPMHForgotPasswordRepositories objUSPMHForgotPasswordRepositories = new USPMHForgotPasswordRepositories();

        private bool _isSuccess;
        Return _objRet = new Return();

        public Return GetLogin(LoginDetails objLoginDetails)
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
                    return objRet;
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
                            if (!passwordValidDay || (objUser.Is_System_Password == "Y"))
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

        public Return LogOutAccount(int UsersCode,int Login_Details_Code)
        {
            User ObjUser = new User();
            UserManagementService objUserMgm = new UserManagementService();
            Login_Details objUsersLoginDetail = new Login_Details();
            _objRet = new Return();

            Login_DetailsServices objLogin_DetailsServices = new Login_DetailsServices();
        
            objUsersLoginDetail = objLogin_DetailsServices.GetUserByID(Login_Details_Code);

            LoggedInUsers objLoggedInUsers = new LoggedInUsers();
            LoggedInUsersServices objLoggedInUsersServices = new LoggedInUsersServices();
      
                //.GetLoggedInUserByID(UsersCode);

            try
            {
               ObjUser = objUserMgm.GetUserByID(UsersCode);
                var obj = new
                {
                    LoginName = ObjUser.Login_Name,
                    //Users_Code = 1219
                };
                objLoggedInUsers = objLoggedInUsersServices.SearchFor(obj).FirstOrDefault();

                if (ObjUser != null)
                {
                    ObjUser.Last_Updated_Time = DateTime.Now;
                    ObjUser.Last_Action_By = ObjUser.Users_Code;
                    //ObjUser.UpdatedOn = DateTime.Now;
                    objUserMgm.UpdateUser(ObjUser);

                    //Login_Details objLogin_Details = new Login_Details();
                    //objUsersLoginDetail.Login_Time = DateTime.Now;
                    if (objUsersLoginDetail != null)
                    {
                        objUsersLoginDetail.Logout_Time = DateTime.Now;
                        objUsersLoginDetail.Description = "Logout";
                        //objUsersLoginDetail.Users_Code = ObjUser.Users_Code ?? 0;
                        //objUsersLoginDetail.Security_Group_Code = 1;
                        objLogin_DetailsServices.UpdateUserLoginDetails(objUsersLoginDetail);
                    }

                    if(objLoggedInUsers != null)
                    {
                        objLoggedInUsersServices.DeleteLoggedInUsers(objLoggedInUsers);
                    }
                    
                    _objRet.IsSuccess = true;
                    _objRet.Message = "Logout Successfull";
                }
            }
            catch (Exception ex)
            {
                _objRet.IsSuccess = false;
                _objRet.Message = ex.Message;
            }

            return _objRet;

        }

        public Return ForgotPassword(string Email_Id)
        {
            User objUser = new User();
            Users_Password_Detail users_Password_Detail = new Users_Password_Detail();
            UserServices objService = new UserServices();
            var obj = new
            {
                Email_Id = Email_Id,
                //Users_Code = 1219
            };
             objUser = objService.SearchForUser(obj).Where(x => x.IsProductionHouseUser == "Y").FirstOrDefault();

            try
            {
                if (objUser != null)
                {
                    _objRet.IsSuccess = true;
                    _objRet.Message = "Password change request has been submitted successfully.";
                    string newPassword = getEncrptedPass(objUser.First_Name, objUser.Last_Name);
                    string encryptedPassword = Encryption.Encrypt(newPassword.Trim());

                    objUser.Password = encryptedPassword;
                    objUser.Is_System_Password = "Y";
                    objUser.Last_Updated_Time = DateTime.Now;
                    UpdateUser(objUser);

                    users_Password_Detail.Users_Code = Convert.ToInt32(objUser.Users_Code);
                    users_Password_Detail.Users_Passwords = encryptedPassword;
                    users_Password_Detail.Password_Change_Date = DateTime.Now;
                    AddPasswordDetails(users_Password_Detail);

                    SendNewPassword(objUser,newPassword);
                }
                else
                {
                    _objRet.IsSuccess = false;
                    _objRet.Message = "Please enter a valid Email Id";
                }
            }
            catch (Exception ex)
            {
                _objRet.IsSuccess = false;
                _objRet.Message = ex.Message;
            }

            return _objRet;

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
            var objUser = objService.SearchForUser(obj).Where(x => x.IsProductionHouseUser == "Y").FirstOrDefault();
            return objUser;
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

        private object FetchUserObject(User objUser, int loginDetailsCode = 0)
        {
            var retObjUser = new
            {
                objUser.Users_Code,
                objUser.Login_Name,
                objUser.Email_Id,
                Login_Details_Code = loginDetailsCode
            };
            return retObjUser;
        }

        public User AfterLoginPasswordUpdate(int userCode)
        {
            // bool isValid = false;
            //    var objUsersBll = new UsersBll();
            UserServices objUserServices = new UserServices();
            var objUser = GetUserByID(userCode);

            try
            {
                objUser.Password_Fail_Count = 0;
                objUser.Last_Updated_Time = DateTime.Now;
                objUserServices.UpdateUser(objUser);
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

        public IEnumerable<USPMHGetMenu> GetMenu(int SecurityGroupCode)
        {
            List<USPMHGetMenu> lstMenu = new List<USPMHGetMenu>();
            USPMHGetMenuRepositories obj = new USPMHGetMenuRepositories();
            lstMenu = (List<USPMHGetMenu>)obj.GetMenu(SecurityGroupCode);
            return lstMenu;
        }

        public string GetModulerights(int ModuleCode,int SecurtyGroupCode)
        {
            USPMHGetModuleRightsRepositories obj = new USPMHGetModuleRightsRepositories();
            string RequestID = obj.GetModuleRights(ModuleCode,SecurtyGroupCode);
            return RequestID;
        }

        public IEnumerable<Users_Password_Detail> GetPasswordDetails(string strSearch)
        {
            var lstPswdDetails = objUsers_Password_DetailRepositories.GetDataWithSQLStmt(strSearch).ToList();
            return lstPswdDetails;
        }

        public void AddPasswordDetails(Users_Password_Detail users_Password_Detail)
        {
            objUsers_Password_DetailRepositories.Add(users_Password_Detail);
        }

        private void SendNewPassword(User objUser,string newPassword)
        {
            objUSPMHForgotPasswordRepositories.SendNewPassword(objUser,newPassword);
        }

        private string getEncrptedPass(string FirstName, string LastName)
        {
            long currentTime = Convert.ToInt64(GetDateComparisionNumber(DateTime.Now.ToString("s")));
            string date = currentTime.ToString().Substring(8, 4);

            if (Convert.ToInt32(date) % 2 == 0)
            {
                date = ((date[0]) + date);
                date += date[2];
            }
            else
            {
                date = ((date[1]) + date);
                date += date[3];
            }

            if (FirstName.Length < 2)
                FirstName = FirstName + '#';
            if (LastName.Length < 2)
                LastName = LastName + '#';
            string str = FirstName.Substring(0, 2).Trim() + date + LastName.Substring(0, 2).Trim();

            return str;
        }
        private string GetDateComparisionNumber(string strDate)
        {
            string actualStr = strDate.Trim().Replace("T", "~").Replace(":", "~").Replace("-", "~");
            string[] arrDt = actualStr.Split('~');
            string tmpTimeInSec = arrDt[0].Trim() + arrDt[1].Trim() + arrDt[2].Trim() + Convert.ToString(Convert.ToInt64(Convert.ToInt64(arrDt[3].Trim()) * 60 * 60) + Convert.ToInt64(Convert.ToInt64(arrDt[4].Trim()) * 60) + Convert.ToInt64(arrDt[5].Trim()));
            return tmpTimeInSec;
        }

    }
}
