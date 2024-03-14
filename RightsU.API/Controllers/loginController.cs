using RightsU.API.BLL.Services;
using RightsU.API.Entities;
using RightsU.API.Filters;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace RightsU.API.Controllers
{
    [HideInDocs]
    public class loginController : ApiController
    {
        [HttpPost]
        [ActionName("authorize")]
        [AllowAnonymous]
        public HttpResponseMessage authorize(AuthorizeViewModel authorizeViewModel)
        {
            LoggedInUsersServices objLoggedInUsersServices = new LoggedInUsersServices();

            BearerToken token = new BearerToken();
            TokenOutput outputToken = new TokenOutput();
            try
            {
                string clientId = "rightsumusichub";
                string clientSecret = "secret";
                string scope = "offline_access";

                string OpenApiURL = Convert.ToString(ConfigurationManager.AppSettings["Authority"]);
                string url = OpenApiURL + "/connect/token";
                string credentials = "client_id=" + clientId + "&client_secret=" + clientSecret + "&grant_type=password&scope=" + scope + "&username=" + authorizeViewModel.UserName + "&password=" + authorizeViewModel.Password;

                var httpWebRequest = (HttpWebRequest)WebRequest.Create(url);
                httpWebRequest.Method = "POST";
                httpWebRequest.KeepAlive = true;
                httpWebRequest.ContentType = "application/x-www-form-urlencoded";
                httpWebRequest.Accept = "application/json";

                using (var httpClient = new HttpClient())
                {
                    var tokenRequest =
                        new List<KeyValuePair<string, string>>
                            {
                              new KeyValuePair<string, string>("client_id", clientId),
                              new KeyValuePair<string, string>("client_secret", clientSecret),
                              new KeyValuePair<string, string>("grant_type", "password"),
                              new KeyValuePair<string, string>("scope", scope),
                              new KeyValuePair<string, string>("username", authorizeViewModel.UserName),
                              new KeyValuePair<string, string>("password", authorizeViewModel.Password)
                            };

                    HttpContent encodedRequest = new FormUrlEncodedContent(tokenRequest);
                    HttpResponseMessage response = httpClient.PostAsync(url, encodedRequest).Result;
                    token = response.Content.ReadAsAsync<BearerToken>().Result;

                    if (token.access_token != null && token.refresh_token != null && !string.IsNullOrEmpty(authorizeViewModel.UserName))
                    {
                        LoggedInUsers objLoggedInUsers = new LoggedInUsers();

                        objLoggedInUsers.LoginName = authorizeViewModel.UserName;
                        objLoggedInUsers.AccessToken = token.access_token;
                        objLoggedInUsers.RefreshToken = token.refresh_token;

                        var obj = new { LoginName = authorizeViewModel.UserName };
                        int Count = objLoggedInUsersServices.SearchFor(obj).ToList().Count();

                        if (Count > 0)
                        {
                            var obj1 = new { LoginName = authorizeViewModel.UserName, AccessToken= token.access_token, RefreshToken= token.refresh_token };
                            var CountForCurrentUser = objLoggedInUsersServices.SearchFor(obj1).ToList();

                            if (CountForCurrentUser.Count() == 0)
                            {
                                var objcheckuser = new { LoginName = authorizeViewModel.UserName };
                                LoggedInUsers objLoggedInUsersToCheck = objLoggedInUsersServices.SearchFor(objcheckuser).ToList().FirstOrDefault();

                                int maxTime = Convert.ToInt32(ConfigurationManager.AppSettings["SessionExpiration"]);
                                double maxTimeInSec = maxTime * 60;

                                DateTime loggedTime = objLoggedInUsersToCheck.LastUpdatedTime.Value;
                                DateTime currentTime = DateTime.Now;

                                TimeSpan totalTimeDiffInSec = currentTime.Subtract(loggedTime);

                                double currentTimeInSec = totalTimeDiffInSec.TotalSeconds;

                                if (maxTimeInSec <= currentTimeInSec)
                                {
                                    objLoggedInUsers.LoginName = authorizeViewModel.UserName;
                                    objLoggedInUsers.HostIP = HttpContext.Current.Request.UserHostAddress;
                                    objLoggedInUsers.LoggedinTime = DateTime.Now;
                                    objLoggedInUsers.LastUpdatedTime = DateTime.Now;
                                    objLoggedInUsers.BrowserDetails = string.IsNullOrEmpty(HttpContext.Current.Request.Browser.Browser) ? "" : HttpContext.Current.Request.Browser.Browser;
                                    objLoggedInUsers.LoggedInUrl = string.IsNullOrEmpty(HttpContext.Current.Request.Url.OriginalString) ? "" : HttpContext.Current.Request.Url.OriginalString;
                                    objLoggedInUsers.AccessToken = token.access_token;
                                    objLoggedInUsers.RefreshToken = token.refresh_token;
                                    objLoggedInUsersServices.AddEntity(objLoggedInUsers);

                                    objLoggedInUsersServices.DeleteLoggedInUsers(objLoggedInUsersToCheck);
                                    objLoggedInUsersServices.AddEntity(objLoggedInUsers);

                                    outputToken.AccessToken = "Bearer " + token.access_token;
                                    outputToken.RefreshToken = "Bearer " + token.refresh_token;
                                }
                                else
                                {
                                    outputToken.AccessToken = "Bearer " + objLoggedInUsersToCheck.AccessToken;
                                    outputToken.RefreshToken = "Bearer " + objLoggedInUsersToCheck.RefreshToken;
                                }
                            }
                            else
                            {
                                outputToken.AccessToken = "Bearer " + CountForCurrentUser.FirstOrDefault().AccessToken;
                                outputToken.RefreshToken = "Bearer " + CountForCurrentUser.FirstOrDefault().RefreshToken;
                            }
                        }
                        else
                        {
                            objLoggedInUsers.LoginName = authorizeViewModel.UserName;
                            objLoggedInUsers.HostIP = HttpContext.Current.Request.UserHostAddress;
                            objLoggedInUsers.LoggedinTime = DateTime.Now;
                            objLoggedInUsers.LastUpdatedTime = DateTime.Now;
                            objLoggedInUsers.BrowserDetails = string.IsNullOrEmpty(HttpContext.Current.Request.Browser.Browser) ? "" : HttpContext.Current.Request.Browser.Browser;
                            objLoggedInUsers.LoggedInUrl = string.IsNullOrEmpty(HttpContext.Current.Request.Url.OriginalString) ? "" : HttpContext.Current.Request.Url.OriginalString;
                            objLoggedInUsers.AccessToken = token.access_token;
                            objLoggedInUsers.RefreshToken = token.refresh_token;
                            objLoggedInUsersServices.AddEntity(objLoggedInUsers);

                            outputToken.AccessToken = "Bearer " + token.access_token;
                            outputToken.RefreshToken = "Bearer " + token.refresh_token;
                        }
                    }
                    else
                    {
                        HttpContext.Current.Response.AddHeader("AuthenticationStatus", "NotAuthorized");
                        return Request.CreateResponse(HttpStatusCode.Unauthorized, "Invalid Credentials");                        
                    }

                }
                
                return Request.CreateResponse(HttpStatusCode.Created, outputToken, Configuration.Formatters.JsonFormatter);
            }
            //catch (Exception ex)
            //{
            //    httpResponses = httpResponseMapper.GetHttpFailureResponse("Error");
            //    return Request.CreateResponse(HttpStatusCode.BadRequest, httpResponses);
            //}
            finally
            {

                //httpResponses = null;
                //httpResponseMapper = null;
            }
        }
    }

    public class AuthorizeViewModel
    {
        public string UserName { get; set; }
        public string Password { get; set; }
    }

    public class BearerToken
    {
        public string access_token { get; set; }
        public string refresh_token { get; set; }
        public Int32 expires_in { get; set; }
        public string token_type { get; set; }
    }

    public class TokenOutput
    {
        public string AccessToken { get; set; }
        public string RefreshToken { get; set; }
    }
}
