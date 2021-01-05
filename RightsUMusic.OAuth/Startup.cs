using System;
using System.Configuration;
using System.Security.Cryptography.X509Certificates;
using System.Threading.Tasks;
using IdentityServer3.Core.Configuration;
using Microsoft.Owin;
using Owin;
using IdentityServer3.Core.Services;

[assembly: OwinStartup(typeof(SocialNetwork.OAuth.Startup))]

namespace SocialNetwork.OAuth
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
                typeof(DASUserService));

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
