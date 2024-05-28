using RightsU.API.Filters;
using Swashbuckle.Swagger.Annotations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using RightsU.API.Entities;
using System.Threading.Tasks;
using RightsU.API.BLL.Services;
using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities.ReturnClasses;
using System.ComponentModel;

namespace RightsU.API.Controllers
{
    [DisplayName("Business Unit")]
    [Route("api/businessunit")]
    public class businessunitController : BaseController
    {

        public enum SortColumn
        {
            BusinessUnitName = 1,
            //IsActive = 2,
        }
        private readonly BusinessUnitService objBusinessUnitService = new BusinessUnitService();
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
        public async Task<HttpResponseMessage> GetBusinessUnit(Order order, Int32 page, Int32 size, SortColumn sort, string searchValue = "")
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objBusinessUnitService.GetBusinessUnit(order.ToString(), sort.ToString(), size, page, searchValue, 0);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, true);
            
            return response;
        }
    }
}
