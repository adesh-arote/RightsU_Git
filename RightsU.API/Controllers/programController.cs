using RightsU.API.BLL.Services;
using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities.ReturnClasses;
using RightsU.API.Entities;
using RightsU.API.Filters;
using Swashbuckle.Swagger.Annotations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.ComponentModel;

namespace RightsU.API.Controllers
{
    [DisplayName("Program")]
    [Route("api/program")]
    public class programController : BaseController
    {
        public enum SortColumn
        {
            CreatedDate = 1,
            UpdatedDate = 2,
            ProgramName = 3
        }

        private readonly ProgramServices objProgramServices = new ProgramServices();
        private readonly System_Module_Service objSystemModuleServices = new System_Module_Service();

        /// <summary>
        /// Program List 
        /// </summary>
        /// <remarks>Retrieves all available Program</remarks>
        /// <param name="order">Defines how the results will be ordered</param>
        /// <param name="page">The page number that should be retrieved</param>
        /// <param name="searchValue">The value of the search across the title</param>
        /// <param name="size">The size (total records) of each page</param>
        /// <param name="sort">Defines on which attribute the results should be sorted</param>
        /// <param name="dateGt">Format - "dd-mmm-yyyy", filter basis on creation or modification date whichever falls into criteria</param>
        /// <param name="dateLt">Format - "dd-mmm-yyyy", filter basis on creation or modification date whichever falls into criteria</param>
        /// <returns></returns>
        [HttpGet]        
        public async Task<HttpResponseMessage> GetProgramList(Order order, Int32 page, Int32 size, SortColumn sort, string searchValue = "", string dateGt = "", string dateLt = "")
        {           
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objProgramServices.GetProgramList(order.ToString(), sort.ToString(), size, page, searchValue, dateGt, dateLt, 0);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, true);
                        
            return response;
        }

        /// <summary>
        /// Program by id
        /// </summary>
        /// <remarks>Retrieves Program by Id</remarks>
        /// <param name="id">get specific program data using id.</param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/program/{id}")]
        public async Task<HttpResponseMessage> GetProgramById(int? id)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objProgramServices.GetProgramById(id.Value);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, true);

            return response;
        }

        /// <summary>
        /// Save Program Details
        /// </summary>
        /// <remarks>Create / Save New Program</remarks>
        /// <param name="Input">Input data object for Create/Save New Program</param>
        /// <returns></returns>
        [HttpPost]        
        public async Task<HttpResponseMessage> PostProgram(Program Input)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;
            
            GenericReturn objReturn = objProgramServices.PostProgram(Input);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, false);

            return response;
        }

        /// <summary>
        /// Modify Program details
        /// </summary>
        /// <remarks>Update / Modify Program details by id</remarks>
        /// <param name="Input">Input data object for Modify existing Program</param>
        /// <returns></returns>
        [HttpPut]        
        public async Task<HttpResponseMessage> PutProgram(Program Input)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objProgramServices.PutProgram(Input);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, false);
                        
            return response;
        }

        /// <summary>
        /// Active/Deactive Status 
        /// </summary>
        /// <remarks>Modify Active/Deactive Status of Existing Program</remarks>
        /// <param name="Input">Input data object for Modify existing program Active/Deactive Status</param>
        /// <returns></returns>
        [HttpPut]
        [Route("api/program/ChangeActiveStatus")]
        public async Task<HttpResponseMessage> ChangeActiveStatus(Program Input)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objProgramServices.ChangeActiveStatus(Input);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, false);

            return response;
        }

    }
}
