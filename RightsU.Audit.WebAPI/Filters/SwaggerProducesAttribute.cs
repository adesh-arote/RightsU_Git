using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RightsU.Audit.WebAPI.Filters
{
    [AttributeUsage(AttributeTargets.All)]
    public class SwaggerProducesAttribute : Attribute
    {
        public SwaggerProducesAttribute(params string[] contentTypes)
        {
            this.ContentTypes = contentTypes;
        }

        public IEnumerable<string> ContentTypes { get; }
    }
}