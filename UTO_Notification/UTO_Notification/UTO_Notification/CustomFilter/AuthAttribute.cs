using System;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Http.Filters;
using System.Configuration;
using System.Net;
using System.IO;
using System.Security.Cryptography;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Web.Http;
using UTO_Notification.API.CustomFilter;

namespace UTO_Notification.API.AuthFilter
{
    public class AuthAttribute : ActionFilterAttribute, IAuthenticationFilter
    {
        public Task AuthenticateAsync(HttpAuthenticationContext context, CancellationToken cancellationToken)
        {
            IEnumerable<string> requstAuthKey = context.Request.Headers.GetValues("AuthKey");
            var myListrequstAuthKey = requstAuthKey.ToList();
            IEnumerable<string> requstService = context.Request.Headers.GetValues("Service");
            var myListrequstService = requstService.ToList();
            string storedKeys = ConfigurationManager.AppSettings["storedKeys"].ToString();
            string[] sKeys;
            sKeys = storedKeys.Split(',');

            if (myListrequstAuthKey[0] == "")
            {
                var resp = new HttpResponseMessage(HttpStatusCode.Unauthorized)
                {
                    ReasonPhrase = "Not Authenticated"
                };
                throw new HttpResponseException(resp);
            }
            else
            {
                if (myListrequstService[0] == "false")
                {
                    if (sKeys.Contains(myListrequstAuthKey[0].ToString()))
                    {
                        return Task.FromResult<object>(null);

                    }
                    else
                    {
                        var resp = new HttpResponseMessage(HttpStatusCode.Unauthorized)
                        {
                            ReasonPhrase = "Not Authenticated"
                        };
                        throw new HttpResponseException(resp);
                    }
                }
                else
                {
                    //* write Log on collected server ip address *//
                    string ipAddress = System.Web.HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
                    if (string.IsNullOrEmpty(ipAddress))
                    {
                        ipAddress = System.Web.HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
                    }
                    WriteLog.Log(ipAddress, "AuthenticateAsync :IPAddress ", ipAddress);

                    //*  return ip; *//

                    //string strHostName = "";
                    //strHostName = Dns.GetHostName();
                    //IPHostEntry ipEntry = Dns.GetHostEntry(strHostName);
                    //IPAddress[] addr = ipEntry.AddressList;
                    //string ipAddress = addr[addr.Length - 1].ToString();

                    //* Encrypted *//

                    string salt = ConfigurationManager.AppSettings["salt"].ToString();

                    byte[] bytesToBeEncrypted = Encoding.UTF8.GetBytes(salt);
                    byte[] passwordBytes = Encoding.UTF8.GetBytes(ipAddress);

                    byte[] bytesEncrypted = AES_Encrypt(bytesToBeEncrypted, passwordBytes);

                    string result = Convert.ToBase64String(bytesEncrypted);

                    if (result == myListrequstAuthKey[0].ToString() && sKeys.Contains(myListrequstAuthKey[0].ToString()))
                    {
                        return Task.FromResult<object>(null);

                    }
                    else
                    {
                        var resp = new HttpResponseMessage(HttpStatusCode.Unauthorized)
                        {
                            ReasonPhrase = "Not Authenticated"
                        };
                        throw new HttpResponseException(resp);
                    }
                }
                
            }
        }

        private byte[] AES_Encrypt(byte[] bytesToBeEncrypted, byte[] passwordBytes)
        {
            byte[] encryptedBytes = null;
            byte[] saltBytes = new byte[] { 1, 2, 3, 4, 5, 6, 7, 8 };
            using (MemoryStream ms = new MemoryStream())
            {
                using (RijndaelManaged AES = new RijndaelManaged())
                {
                    AES.KeySize = 256;
                    AES.BlockSize = 128;

                    var key = new Rfc2898DeriveBytes(passwordBytes, saltBytes, 1000);
                    AES.Key = key.GetBytes(AES.KeySize / 8);
                    AES.IV = key.GetBytes(AES.BlockSize / 8);

                    AES.Mode = CipherMode.CBC;

                    using (var cs = new CryptoStream(ms, AES.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(bytesToBeEncrypted, 0, bytesToBeEncrypted.Length);
                        cs.Close();
                    }
                    encryptedBytes = ms.ToArray();
                }
            }

            return encryptedBytes;
        }

        public Task ChallengeAsync(HttpAuthenticationChallengeContext context, CancellationToken cancellationToken)
        {
            return Task.FromResult<object>(null);
        }
    }
}