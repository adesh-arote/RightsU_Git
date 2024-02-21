using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.WebAPI.Filters;
using Swashbuckle.Swagger.Annotations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;

namespace RightsU.BMS.WebAPI.Controllers
{
    [SwaggerConsumes("application/json")]
    [SwaggerProduces("application/json")]
    [HideInDocs]
    [SwaggerResponse(HttpStatusCode.OK, "Status ok / Success")]
    [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
    [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Token Expried / Invalid Token")]
    [SwaggerResponse(HttpStatusCode.Forbidden, "Access Forbidden")]
    [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / Token Missing")]
    [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
    public class BaseController : ApiController
    {
        [ApiExplorerSettings(IgnoreApi = true)]
        public HttpResponseMessage CreateResponse(GenericReturn objReturn, bool isGet)
        {
            var response = new HttpResponseMessage();

            if (objReturn.StatusCode == HttpStatusCode.OK && isGet)
                response = Request.CreateResponse(HttpStatusCode.OK, objReturn.Response, Configuration.Formatters.JsonFormatter);
            else if (objReturn.StatusCode == HttpStatusCode.OK && !isGet)
                response = Request.CreateResponse(HttpStatusCode.OK, objReturn, Configuration.Formatters.JsonFormatter);
            else if (objReturn.StatusCode == HttpStatusCode.BadRequest)
                response = Request.CreateResponse(HttpStatusCode.BadRequest, objReturn, Configuration.Formatters.JsonFormatter);
            else if (objReturn.StatusCode == HttpStatusCode.InternalServerError)
                response = Request.CreateResponse(HttpStatusCode.InternalServerError, objReturn, Configuration.Formatters.JsonFormatter);

            response.Headers.Add("timetaken", Convert.ToString(objReturn.TimeTaken));
            response.Headers.Add("request_completion", Convert.ToString(objReturn.IsSuccess));
            response.Headers.Add("message", objReturn.Message);

            return response;
        }

    }
}
