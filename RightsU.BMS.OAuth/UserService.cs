using IdentityServer3.Core.Models;
using IdentityServer3.Core.Services.Default;
using RightsU.BMS.BLL.Services;
using RightsU.BMS.Entities;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace RightsU.BMS.OAuth
{
    public class UserService : UserServiceBase
    {
        public override async Task AuthenticateLocalAsync(LocalAuthenticationContext context)
        {
            try
            {
                var task = Task.Run(() => GetUser(context.UserName, context.Password));

                var user = await task;
                if (user != null)
                {
                    context.AuthenticateResult
                        = new AuthenticateResult(user);
                    return;
                }
                //if (user == null)
                //{
                //    context.AuthenticateResult
                //        = new AuthenticateResult("Invalid Credentials");
                //    return;
                //}

                context.AuthenticateResult = new AuthenticateResult(context.UserName, context.UserName);
                //new AuthenticateResult("/terms", context.UserName, context.UserName);
            }
            catch (Exception ex)
            {
                return;
            }
        }

        public string GetUser(string username, string password)
        {
            string errMessage;
            Return objReturn = new Return();
            LoginDetails objLoginDetails = new LoginDetails();
            string startDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff");

            try
            {
                objLoginDetails.UserName = username;
                objLoginDetails.Password = password;
                ServiceLog serviceLog = new ServiceLog()
                {
                    LogType = 0,
                    MethodName = "GetUser step 1",
                    Request = "",
                    Response = "",
                    RequestTime = DateTime.Now,
                    ResponseTime = DateTime.Now
                };

                UserManagementService objUserManagementService = new UserManagementService();

                serviceLog.Request = "GetUsers step 2";
                //objServiceLogServices.AddEntity(serviceLog);
                objReturn = objUserManagementService.GetLogin(objLoginDetails);

                if (!objReturn.IsSuccess)
                    errMessage = objReturn.Message.ToString();
                else
                    errMessage = null;
                return errMessage;
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
            //validate user here
        }
    }
}