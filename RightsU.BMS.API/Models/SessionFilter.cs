using RightsU.BMS.BLL.Services;
using RightsU.BMS.Entities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Claims;
using System.Web;
using System.Web.Http;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;

namespace RightsU.BMS.API
{
    public class SessionFilter : AuthorizationFilterAttribute
    {
        public bool IsAllowAnonymousEnabled { get; set; }
        public override void OnAuthorization(System.Web.Http.Controllers.HttpActionContext actionContext)
        {
            try
            {

                var actionDescriptor = actionContext.ActionDescriptor;

                var isAnonymousAllowed = actionDescriptor.GetCustomAttributes<AllowAnonymousAttribute>(true).Any() ||

                actionDescriptor.ControllerDescriptor.GetCustomAttributes<AllowAnonymousAttribute>(true).Any();

                if (isAnonymousAllowed)

                {
                    return;
                }
                else if (actionContext.Request.Headers.GetValues("Authorization") != null || actionContext.Request.Headers.GetValues("token") != null && actionContext.Request.Headers.GetValues("userCode") != null)
                {


                    // get value from header
                    string authenticationToken = Convert.ToString(actionContext.Request.Headers.GetValues("Authorization").FirstOrDefault());
                    string RefreshToken = Convert.ToString(actionContext.Request.Headers.GetValues("token").FirstOrDefault());

                    string UserCode = Convert.ToString(actionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
                    authenticationToken = authenticationToken.Replace("Bearer ", "");
                    RefreshToken = RefreshToken.Replace("Bearer ", "");
                    UserCode = UserCode.Replace("Bearer ", "");
                    //User user = new User();
                    //user.Users_Code = Convert.ToInt32(UserCode);

                    //UserManagementService objUserManagementService = new UserManagementService();

                    //LoggedInUsers objUserDetails = objUserManagementService.GetUserToken(user);
                    //authenticationManagement = new IAuthenticationService();

                    //   ---------------  need to add code authenticationManagement.GetUserToken(user);
                    //  IHttpResponseMapper httpResponseMapper = new HttpResponseMapper();
                    //var base64EncodedBytes = System.Convert.FromBase64String(authenticationToken);
                    //var decoded= System.Text.Encoding.UTF8.GetString(base64EncodedBytes);

                    //if (objUserDetails.AccessToken != authenticationToken || objUserDetails.RefreshToken != RefreshToken)
                    //{
                    //    HttpContext.Current.Response.AddHeader("AuthenticationStatus", "NotAuthorized");
                    //    actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Forbidden, "SessionExpired");
                    //    return;
                    //}

                    HttpContext.Current.Response.AddHeader("Authorization", authenticationToken);
                    HttpContext.Current.Response.AddHeader("AuthenticationStatus", "Authorized");
                    return;
                }
                actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.ExpectationFailed);
                actionContext.Response.ReasonPhrase = "Token missing";
            }
            catch (Exception ex)
            {
                actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.ExpectationFailed);
                actionContext.Response.ReasonPhrase = ex.Message;

            }
        }
    }
}