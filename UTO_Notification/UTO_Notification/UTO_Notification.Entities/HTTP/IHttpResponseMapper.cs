using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
//using Uto.DAS.DomainModel;

namespace UTO_Notification.Entities
{
    public interface IHttpResponseMapper
    {
        HttpResponses GetHttpSuccessResponse(object commonClass, string responseCode = "001");
        HttpResponses GetHttpFailureResponse(object commonClass, string responseCode = "000");
    }
}
