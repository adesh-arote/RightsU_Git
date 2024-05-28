using RightsU.Audit.Entities.HttpModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.Audit.Entities.HTTP
{
    public class HttpResponseMapper : IHttpResponseMapper
    {
        public HttpResponses GetHttpSuccessResponse(object commonClass, string responseCode = "001")
        {
            HttpResponses HttpResponses = new HttpResponses();
            try
            {
                HttpResponses.ResponseCode = responseCode;
                HttpResponses.Status = true;
                HttpResponses.Response = commonClass;

                return HttpResponses;
            }
            catch (Exception ex)
            {
                throw;
            }
            finally
            {
                HttpResponses = null;
            }
        }

        public HttpResponses GetHttpFailureResponse(object commonClass, string responseCode = "000")
        {
            HttpResponses HttpResponses = new HttpResponses();
            try
            {
                HttpResponses.ResponseCode = responseCode;
                HttpResponses.Status = false;
                HttpResponses.Response = commonClass;
                return HttpResponses;
            }
            catch (Exception ex)
            {
                throw;
            }
            finally
            {
                HttpResponses = null;
            }
        }
    }
}
