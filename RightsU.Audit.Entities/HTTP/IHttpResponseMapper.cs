using RightsU.Audit.Entities.HttpModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.Audit.Entities.HTTP
{
    public interface IHttpResponseMapper
    {
        HttpResponses GetHttpSuccessResponse(object commonClass, string responseCode = "001");
        HttpResponses GetHttpFailureResponse(object commonClass, string responseCode = "000");
    }
}
