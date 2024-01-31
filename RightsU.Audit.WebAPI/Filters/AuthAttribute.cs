using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Security.Cryptography;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Http.Filters;
using System.Web.Http.Results;

namespace RightsU.Audit.WebAPI.Filters
{
    public class AuthAttribute : ActionFilterAttribute, IAuthenticationFilter
    {
        public Task AuthenticateAsync(HttpAuthenticationContext context, CancellationToken cancellationToken)
        {
            IEnumerable<string> requstAuthKey;
            try
            {
                requstAuthKey = context.Request.Headers.GetValues("AuthKey");
            }
            catch (Exception)
            {
                var resp = new HttpResponseMessage(HttpStatusCode.ExpectationFailed)
                {
                    RequestMessage = context.Request,
                    ReasonPhrase = "AuthKey Missing"
                };
                throw new HttpResponseException(resp);
            }

            var myListrequstAuthKey = requstAuthKey.ToList();
            //IEnumerable<string> requstService = context.Request.Headers.GetValues("Service");
            //var myListrequstService = requstService.ToList();
            string storedKeys = ConfigurationManager.AppSettings["storedKeys"].ToString();
            string[] sKeys;
            sKeys = storedKeys.Split(',');

            if (myListrequstAuthKey[0] == "")
            {
                var resp = new HttpResponseMessage(HttpStatusCode.Unauthorized)
                {
                    ReasonPhrase = "Authentication Failed"
                };
                throw new HttpResponseException(resp);
            }
            else
            {
                if (sKeys.Contains(myListrequstAuthKey[0].ToString()))
                {
                    return Task.FromResult<object>(null);
                }
                else
                {
                    var resp = new HttpResponseMessage(HttpStatusCode.Unauthorized)
                    {
                        ReasonPhrase = "Authentication Failed"
                    };
                    throw new HttpResponseException(resp);
                }

            }
            throw new NotImplementedException();

        }

        public Task ChallengeAsync(HttpAuthenticationChallengeContext context, CancellationToken cancellationToken)
        {
            return Task.FromResult<object>(null);
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
    }
}