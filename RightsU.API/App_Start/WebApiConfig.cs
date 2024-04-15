﻿using RightsU.API.Filters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;

namespace RightsU.API
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Web API configuration and services
            config.Filters.Add(new SessionFilter());//-- UnComment at build time
            config.Filters.Add(new SysLogFilter());//-- UnComment at build time
            config.Filters.Add(new CustomExceptionFilter());//-- UnComment at build time

            // Web API routes
            config.MapHttpAttributeRoutes();

            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{Action}/{id}",
                defaults: new { id = RouteParameter.Optional }
            );
        }
    }
}