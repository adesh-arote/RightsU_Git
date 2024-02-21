using Swashbuckle.Swagger;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Http.Description;

namespace RightsU.BMS.WebAPI.Filters
{
    public class HideInDocsFilter : IDocumentFilter
    {
        public void Apply(SwaggerDocument swaggerDoc, SchemaRegistry schemaRegistry, IApiExplorer apiExplorer)
        {
            foreach (var apiDescription in apiExplorer.ApiDescriptions)
            {
                if (!apiDescription.ActionDescriptor.ControllerDescriptor.GetCustomAttributes<HideInDocsAttribute>().Any() && !apiDescription.ActionDescriptor.GetCustomAttributes<HideInDocsAttribute>().Any()) continue;
                //var route = "/" + apiDescription.Route.RouteTemplate.TrimEnd('/');
                //var route = "/" + apiDescription.RelativePath.TrimEnd('/');
                var route = "/" + apiDescription.RelativePath.Trim('/').Split('?')[0].Trim('/');
                string[] strAllowedInSwagger = ConfigurationManager.AppSettings["AllowedInSwagger"].Split(',');

                if (!strAllowedInSwagger.Contains(apiDescription.ActionDescriptor.ControllerDescriptor.ControllerName))
                {
                    swaggerDoc.paths.Remove(route);
                    swaggerDoc.paths.Remove("/api/" + apiDescription.ActionDescriptor.ControllerDescriptor.ControllerName);
                }
                //else
                //{
                //    swaggerDoc.paths.Remove(route);
                //    swaggerDoc.paths.ToString();
                //}
            }
        }
    }
}