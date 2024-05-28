using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    public static class ExtensionMethods
    {
        public static bool StartsWithAny(this string source, string[] strings)
        {
            foreach (var valueToCheck in strings)
            {
                if (source.StartsWith(valueToCheck))
                {
                    return true;
                }
            }

            return false;
        }
    }
}
