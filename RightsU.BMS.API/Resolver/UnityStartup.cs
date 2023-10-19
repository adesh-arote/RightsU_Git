using System.Web.Http.Dependencies;
using Unity;
using Unity.Lifetime;
using UTO.Framework.Shared.Interfaces;
using UTO.Framework.SharedInfrastructure.Logging;

namespace RightsU.BMS.API.Resolver
{
    public static class UnityStartup
    {
        public static IDependencyResolver GetUnityContainer()
        {
            IUnityContainer container = new UnityContainer();
            // container.LoadConfiguration(); 

            container.RegisterType<ILogger, DBLogger>(new HierarchicalLifetimeManager());
            return new UnityResolver(container);
        }
    }
}