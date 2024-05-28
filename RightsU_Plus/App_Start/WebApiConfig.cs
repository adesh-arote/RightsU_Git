using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;


namespace RightsU_Plus
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{action}/{id}",
                defaults: new { id = RouteParameter.Optional }
            );

            //var xml = config.Formatters.XmlFormatter;
            //xml.Seriali.PreserveReferencesHandling = Newtonsoft.Json.PreserveReferencesHandling.None;
            //xml.UseXmlSerializer = true;
            //config.Formatters.Remove(config.Formatters.JsonFormatter);
            //xml.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore;
        }
    }
}
