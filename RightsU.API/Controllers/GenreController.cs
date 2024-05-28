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
    [DisplayName("Genre")]
    [Route("api/genre")]
    public class genreController : BaseController
    {
        public enum SortColumn
        {
            CreatedDate = 1,
            UpdatedDate = 2,
            GenreName = 3
        }

        private readonly GenreServices objGenreServices = new GenreServices();
        private readonly System_Module_Service objSystemModuleServices = new System_Module_Service();

        /// <summary>
        /// Genre List 
        /// </summary>
        /// <remarks>Retrieves all available Genre</remarks>
        /// <param name="order">Defines how the results will be ordered</param>
        /// <param name="page">The page number that should be retrieved</param>
        /// <param name="searchValue">The value of the search across the title</param>
        /// <param name="size">The size (total records) of each page</param>
        /// <param name="sort">Defines on which attribute the results should be sorted</param>
        /// <param name="dateGt">Format - "dd-mmm-yyyy", filter basis on creation or modification date whichever falls into criteria</param>
        /// <param name="dateLt">Format - "dd-mmm-yyyy", filter basis on creation or modification date whichever falls into criteria</param>
        /// <returns></returns>        
        [HttpGet]
        public async Task<HttpResponseMessage> GetGenreList(Order order, Int32 page, Int32 size, SortColumn sort, string searchValue = "", string dateGt = "", string dateLt = "")
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objGenreServices.GetGenreList(order.ToString(), sort.ToString(), size, page, searchValue, dateGt, dateLt, 0);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, true);

            //if (objReturn.StatusCode == HttpStatusCode.OK)
            //{
            //    objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            //    response = Request.CreateResponse(HttpStatusCode.OK, objReturn.Response, Configuration.Formatters.JsonFormatter);
            //    response.Headers.Add("timetaken", Convert.ToString(objReturn.TimeTaken));
            //    response.Headers.Add("request_completion", Convert.ToString(objReturn.IsSuccess));
            //    response.Headers.Add("message", objReturn.Message);
            //    return response;
            //}
            //else if (objReturn.StatusCode == HttpStatusCode.BadRequest)
            //{
            //    objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            //    response = Request.CreateResponse(HttpStatusCode.BadRequest, objReturn, Configuration.Formatters.JsonFormatter);
            //    response.Headers.Add("timetaken", Convert.ToString(objReturn.TimeTaken));
            //    response.Headers.Add("request_completion", Convert.ToString(objReturn.IsSuccess));
            //    response.Headers.Add("message", objReturn.Message);
            //    return response;
            //}
            //else if (objReturn.StatusCode == HttpStatusCode.InternalServerError)
            //{
            //    objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            //    response = Request.CreateResponse(HttpStatusCode.InternalServerError, objReturn, Configuration.Formatters.JsonFormatter);
            //    response.Headers.Add("timetaken", Convert.ToString(objReturn.TimeTaken));
            //    response.Headers.Add("request_completion", Convert.ToString(objReturn.IsSuccess));
            //    response.Headers.Add("message", objReturn.Message);
            //    return response;
            //}

            return response;
        }

        /// <summary>
        /// Genre by id
        /// </summary>
        /// <remarks>Retrieves Genre by Id</remarks>
        /// <param name="id">get specific genre data using id.</param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/genre/{id}")]
        public async Task<HttpResponseMessage> GetGenreById(int? id)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objGenreServices.GetGenreById(id.Value);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, true);

            return response;
        }

        /// <summary>
        /// Save Genre Details
        /// </summary>
        /// <remarks>Create / Save New Genre</remarks>
        /// <param name="Input">Input data object for Create/Save New Genre</param>
        /// <returns></returns>        
        [HttpPost]
        public async Task<HttpResponseMessage> PostGenre(Genres Input)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objGenreServices.PostGenre(Input);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, false);
            return response;
        }

        /// <summary>
        /// Modify Genre details
        /// </summary>
        /// <remarks>Update / Modify Genre details by id</remarks>
        /// <param name="Input">Input data object for Modify existing Genre</param>
        /// <returns></returns>
        [HttpPut]        
        public async Task<HttpResponseMessage> PutGenre(Genres Input)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objGenreServices.PutGenre(Input);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, false);

            return response;
        }

        /// <summary>
        /// Active/Deactive Status 
        /// </summary>
        /// <remarks>Modify Active/Deactive Status of Existing Genre</remarks>
        /// <param name="Input">Input data object for Modify existing genre Active/Deactive Status</param>
        /// <returns></returns>
        [HttpPut]
        [Route("api/genre/ChangeActiveStatus")]
        public async Task<HttpResponseMessage> ChangeActiveStatus(Genres Input)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objGenreServices.ChangeActiveStatus(Input);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, false);

            return response;
        }
    }
}
