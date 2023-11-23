using RightsU.BMS.BLL.Services;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using System.Web.Http.Filters;

namespace RightsU.BMS.WebAPI.Filters
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
                else if (actionContext.Request.Headers.GetValues("Authorization") != null && actionContext.Request.Headers.GetValues("token") != null)
                {
                    // get value from header
                    string authenticationToken = Convert.ToString(actionContext.Request.Headers.GetValues("Authorization").FirstOrDefault());
                    string RefreshToken = Convert.ToString(actionContext.Request.Headers.GetValues("token").FirstOrDefault());

                    //string UserCode = Convert.ToString(actionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
                    authenticationToken = authenticationToken.Replace("Bearer ", "");
                    RefreshToken = RefreshToken.Replace("Bearer ", "");
                    //UserCode = UserCode.Replace("Bearer ", "");
                    //User user = new User();
                    //user.Users_Code = Convert.ToInt32(UserCode);
                                        
                    LoggedInUsersServices objLoggedInUsersServices = new LoggedInUsersServices();
                                        
                    LoggedInUsers objUserDetails = objLoggedInUsersServices.SearchFor(new { AccessToken= authenticationToken ,RefreshToken= RefreshToken }).ToList().FirstOrDefault();

                    if (objUserDetails != null)
                    {
                        int maxTime = Convert.ToInt32(ConfigurationManager.AppSettings["SessionExpiration"]);
                        double maxTimeInSec = maxTime * 60;

                        DateTime loggedTime = objUserDetails.LastUpdatedTime.Value;
                        DateTime currentTime = DateTime.Now;

                        TimeSpan totalTimeDiffInSec = currentTime.Subtract(loggedTime);

                        double currentTimeInSec = totalTimeDiffInSec.TotalSeconds;

                        if (maxTimeInSec <= currentTimeInSec)
                        {
                            HttpContext.Current.Response.AddHeader("AuthenticationStatus", "Unauthorized");
                            actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Unauthorized, "Token Expired");
                            return;
                        }
                    }
                    else
                    {
                        HttpContext.Current.Response.AddHeader("AuthenticationStatus", "Unauthorized");
                        actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Unauthorized, "Invalid Token");
                        return;
                    }

                    HttpContext.Current.Response.AddHeader("Authorization", authenticationToken);
                    HttpContext.Current.Response.AddHeader("AuthenticationStatus", "Authorized");
                    return;
                }
                actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.ExpectationFailed);
                actionContext.Response.ReasonPhrase = "Token missing";
            }
            catch (Exception ex)
            {
                actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.InternalServerError);
                actionContext.Response.ReasonPhrase = ex.Message;

            }
        }

    }
}