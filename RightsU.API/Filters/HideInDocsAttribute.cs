using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RightsU.API.Filters
{
    [AttributeUsage(AttributeTargets.Method | AttributeTargets.Class)]
    public class HideInDocsAttribute : Attribute
    {
    }
}