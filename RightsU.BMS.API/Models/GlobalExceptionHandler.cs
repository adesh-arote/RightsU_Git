using Newtonsoft.Json;
using RightsU.BMS.Entities;
using System.Globalization;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.ExceptionHandling;

namespace RightsU.WebAPI.Models
{
    public class ExceptionHandler : IExceptionHandler
    {
        public virtual Task HandleAsync(ExceptionHandlerContext context,
                                        CancellationToken cancellationToken)
        {
            if (!ShouldHandle(context))
            {
                return Task.FromResult(0);
            }

            return HandleAsyncCore(context, cancellationToken);
        }

        public virtual Task HandleAsyncCore(ExceptionHandlerContext context,
                                           CancellationToken cancellationToken)
        {
            HandleCore(context);
            return Task.FromResult(0);
        }

        public virtual void HandleCore(ExceptionHandlerContext context)
        {
        }

        public virtual bool ShouldHandle(ExceptionHandlerContext context)
        {
            return context.CatchBlock.IsTopLevel;
        }
    }

    public class GlobalExceptionalHandler : ExceptionHandler
    {
        public override Task HandleAsync(ExceptionHandlerContext context, CancellationToken cancellationToken)
        {
            context.Result = new ErrorResult()
            {
                Request = context.ExceptionContext.Request,
                Content = string.Format(CultureInfo.InvariantCulture, "Bad Request.")
            };

            return base.HandleAsync(context, cancellationToken);
        }
    }

    public class ErrorResult : IHttpActionResult
    {
        public HttpRequestMessage Request { get; set; }

        public string Content { get; set; }

        public Task<HttpResponseMessage> ExecuteAsync(CancellationToken cancellationToken)
        {
            HttpResponseMessage response = null;

            response = new HttpResponseMessage(HttpStatusCode.OK);

            Return _objRet = new Return();
            _objRet.Message = "Technical Issue has occured. Kindly raise support request.";
            _objRet.IsSuccess = false;

            response.Content = new StringContent(JsonConvert.SerializeObject(_objRet));

            response.ReasonPhrase = Content;
            response.RequestMessage = Request;

            return Task.FromResult(response);
        }
    }
}
