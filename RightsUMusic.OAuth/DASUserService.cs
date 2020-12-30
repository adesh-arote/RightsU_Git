using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using IdentityServer3.Core.Models;
using IdentityServer3.Core.Services;
using IdentityServer3.Core.Services.Default;
using RightsUMusic.Entity;
using RightsUMusic.BLL;
using RightsUMusic.BLL.Services;
//using Uto.DAS.DomainModel;
//using Uto.DAS.DTO;
//using Uto.DAS.Service;

namespace SocialNetwork.OAuth
{
    public class DASUserService : UserServiceBase
    {   

        public override async Task AuthenticateLocalAsync(LocalAuthenticationContext context)
        {

            try
            { 
            var task = Task.Run(() => GetUser(context.UserName, context.Password));
           
            var objLoginDetails = await task;
            if (objLoginDetails != null)
            {
                context.AuthenticateResult
                    = new AuthenticateResult(objLoginDetails);
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
        public string GetUser (string username, string password)
        {
            string errMessage;
            Return objReturn = new Return();
            LoginDetails objLoginDetails = new LoginDetails();
            try
            {
                objLoginDetails.UserName = username;
                objLoginDetails.Password = password;
                UserManagementService objUserManagementService = new UserManagementService();

                objReturn = objUserManagementService.GetLogin(objLoginDetails);
                if (!objReturn.IsSuccess)
                    errMessage = objReturn.Message.ToString();
                else
                    errMessage = null;
                return errMessage;
            }
            catch(Exception ex)
            {
                return ex.Message;
            }
        //validate user here
        }
    }
}