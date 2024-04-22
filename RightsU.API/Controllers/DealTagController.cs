using RightsU.API.BLL.Services;
using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using RightsU.API.Entities.ReturnClasses;
using RightsU.API.Filters;
using Swashbuckle.Swagger.Annotations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.ComponentModel;

namespace RightsU.API.Controllers
{
    [DisplayName("Dealtag")]
    [Route("api/dealtag")]
    public class dealtagController : BaseController
    {
        public enum Order
        {
            Asc = 1,
            Desc = 2
        }
        public enum SortColumn
        {
            Deal_Tag_Description = 1,
            Deal_Flag = 2,
        }

        private readonly DealTagService objDealTagService = new DealTagService();
        /// <summary>
        /// Asset List 
        /// </summary>
        /// <remarks>Retrieves all available Assets</remarks>
        /// <param name="order">Defines how the results will be ordered</param>
        /// <param name="page">The page number that should be retrieved</param>
        /// <param name="searchValue">The value of the search across the title</param>
        /// <param name="size">The size (total records) of each page</param>
        /// <param name="sort">Defines on which attribute the results should be sorted</param>
        /// <returns></returns>
        [HttpGet]
        public async Task<HttpResponseMessage> GetDealTag(Order order, Int32 page, Int32 size, SortColumn sort, string searchValue = "")
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objDealTagService.GetDealTag(order.ToString(), sort.ToString(), size, page, searchValue, 0);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, true);

            return response;
        }
    }
}
