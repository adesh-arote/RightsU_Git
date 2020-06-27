using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace RightsU_Plus
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");
            routes.IgnoreRoute("bundles/Fonts/{resource}.ttf");
            routes.IgnoreRoute("bundles/Images/{resource}.gif");

            routes.MapRoute(
              name: "MusicTitleList",
              url: "Music_Title/",
              defaults: new { controller = "Music_Title", action = "List" }
          );


            routes.MapRoute(
            name: "MusicTitleListView",
            url: "Music_Title/View/{id}/{Page_No}",
            defaults: new { controller = "Music_Title", action = "View", id = UrlParameter.Optional, Page_No = 1 }
            );

            routes.MapRoute(
              name: "MusicTitle",
              url: "Music_Title/Index/{id}/{Page_No}",
              defaults: new { controller = "Music_Title", action = "Index", id = UrlParameter.Optional, Page_No = 1 }
          );
            
            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
                defaults: new { controller = "Login", action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}