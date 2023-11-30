using RightsU.Audit.BLL.Services;
using RightsU.Audit.Entities.FrameworkClasses;
using RightsU.Audit.Entities.HTTP;
using RightsU.Audit.Entities.HttpModel;
using RightsU.Audit.Entities.InputEntities;
using RightsU.Audit.WebAPI.Filters;
using Swashbuckle.Swagger.Annotations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;

namespace RightsU.Audit.WebAPI.Controllers
{
    [SwaggerConsumes("application/json")]
    [SwaggerProduces("application/json")]
    [HideInDocs]
    //[AuthAttribute]
    public class AuditLogController : ApiController
    {
        public enum order
        {
            Ascending = 1,
            Descending = 2
        }
        public enum sort
        {
            IntCode = 1,
            Version = 2
        }

        private readonly USPService objUSPServices = new USPService();

        [SwaggerResponse(HttpStatusCode.OK, "Success")]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Invalid AuthKey")]
        [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / AuthKey Missing")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        //[LogFilter]
        [HttpPost]
        [Route("api/masterauditlog")]
        [EnableCors(origins: "*", headers: "*", methods: "*")]
        public HttpResponseMessage masterauditlog(MasterAuditLogInput Input)
        {
            HttpResponses httpResponses = new HttpResponses();
            IHttpResponseMapper httpResponseMapper = new HttpResponseMapper();
            HttpResponseMessage objresponse = new HttpResponseMessage();

            var response = new HttpResponseMessage();

            DateTime startTime;
            startTime = DateTime.Now;

            Return objReturn = objUSPServices.InsertAuditLog(Input);
            if (objReturn.StatusCode == HttpStatusCode.OK)
            {                
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.OK, objReturn, Configuration.Formatters.JsonFormatter);                
                return response;
            }
            else if (objReturn.StatusCode == HttpStatusCode.BadRequest)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.BadRequest, objReturn, Configuration.Formatters.JsonFormatter);
                return response;
            }
            else if (objReturn.StatusCode == HttpStatusCode.InternalServerError)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.InternalServerError, objReturn, Configuration.Formatters.JsonFormatter);
                return response;                
            }
            return objresponse;
        }

        [SwaggerResponse(HttpStatusCode.OK, "Success")]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Invalid AuthKey")]
        [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / AuthKey Missing")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [HttpGet]
        [Route("api/masterauditlist")]
        [EnableCors(origins: "*", headers: "*", methods: "*")]
        public HttpResponseMessage masterauditlist(order order, sort sort, Int32 requestFrom, Int32 requestTo, Int32 moduleCode, Int32 size = 0, Int32 page = 0, string searchValue = "", string user = "", string userAction = "", string includePrevAuditVesion = "")
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            Return objReturn = objUSPServices.GetAuditLogList(order.ToString(), sort.ToString(), size, page, requestFrom, requestTo, moduleCode, searchValue, user, userAction, includePrevAuditVesion);

            if (objReturn.StatusCode == HttpStatusCode.OK)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.OK, objReturn.LogObject, Configuration.Formatters.JsonFormatter);                
                return response;
            }
            else if (objReturn.StatusCode == HttpStatusCode.BadRequest)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.BadRequest, objReturn.LogObject, Configuration.Formatters.JsonFormatter);                
                return response;
            }
            else if (objReturn.StatusCode == HttpStatusCode.InternalServerError)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.InternalServerError, objReturn.LogObject, Configuration.Formatters.JsonFormatter);                
                return response;
            }
            return response;
        }
    }
}
