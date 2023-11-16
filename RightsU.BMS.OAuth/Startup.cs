using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Owin;
using System.Security.Cryptography.X509Certificates;
using IdentityServer3.Core.Configuration;
using IdentityServer3.Core.Services;
using Microsoft.Owin;
using System.Configuration;

[assembly: OwinStartup(typeof(RightsU.BMS.OAuth.Startup))]
namespace RightsU.BMS.OAuth
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            var inMemoryManager = new AuthDataManager();
            var factory = new IdentityServerServiceFactory()
                .UseInMemoryScopes(inMemoryManager.GetScopes())
                .UseInMemoryClients(inMemoryManager.GetClients());
            factory.UserService = new Registration<IUserService>(
                typeof(UserService));

            var certificate = Convert.FromBase64String(ConfigurationManager.AppSettings["SigningCertificate"]);
            var options = new IdentityServerOptions
            {
                SigningCertificate = new X509Certificate2(certificate, ConfigurationManager.AppSettings["SigningCertificatePassword"]),
                RequireSsl = Convert.ToBoolean(ConfigurationManager.AppSettings["RequireSSL"]),
                Factory = factory
            };

            app.UseIdentityServer(options);
        }
    }
}