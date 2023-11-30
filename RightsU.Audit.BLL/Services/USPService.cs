using RightsU.Audit.DAL.Repository;
using RightsU.Audit.Entities.FrameworkClasses;
using RightsU.Audit.Entities.HTTP;
using RightsU.Audit.Entities.HttpModel;
using RightsU.Audit.Entities.InputEntities;
using RightsU.Audit.Entities.MasterEntities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace RightsU.Audit.BLL.Services
{
    public class USPService
    {
        private readonly ProcedureRepositories objProcedureRepositories = new ProcedureRepositories();
        //public USPInsertLog USPInsertLog(string ApplicationName, string RequestId, string User, string RequestUri, string RequestMethod, string Method, string IsSuccess, string TimeTaken, string RequestContent, string RequestLength, string RequestDateTime, string ResponseContent, string ResponseLength, string ResponseDateTime, string HttpStatusCode, string HttpStatusDescription, string AuthenticationKey, string UserAgent, string ServerName, string ClientIpAddress)
        //{
        //    USPInsertLog objUSPInsertNotification = objProcedureRepositories.USPInsertLog(ApplicationName, RequestId, User, RequestUri, RequestMethod, Method, IsSuccess, TimeTaken, RequestContent, RequestLength, RequestDateTime, ResponseContent, ResponseLength, ResponseDateTime, HttpStatusCode, HttpStatusDescription, AuthenticationKey, UserAgent, ServerName, ClientIpAddress).FirstOrDefault();
        //    return objUSPInsertNotification;
        //}

        //public List<USPLGGetLog> USPLGGetLog(string ApplicationId, string MethodName, string RequestFromDate, string RequestToDate, string ResponseFromDate, string ResponseToDate, string User, string size, string from)
        //{
        //    List<USPLGGetLog> objGetLog = objProcedureRepositories.USPLGGetLog(ApplicationId, MethodName, RequestFromDate, RequestToDate, ResponseFromDate, ResponseToDate, User, size, from).ToList();
        //    return objGetLog;
        //}

        //public List<USPGetMasters> USPGetMasters()
        //{
        //    List<USPGetMasters> lstUSPGetMasters = objProcedureRepositories.USPGetMasters().ToList();
        //    return lstUSPGetMasters;
        //}

        public Return InsertAuditLog(MasterAuditLogInput Input)
        {
            Return _objRet = new Return();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (Input.moduleCode == null || Input.moduleCode == 0)
            {
                _objRet.Message = "Input Paramater 'moduleCode' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                //objLog.Record_Status = "E";
                //objLog.Error_Description = _objRet.Message;
            }

            if (Input.intCode == null || Input.intCode == 0)
            {
                _objRet.Message = "Input Paramater 'intCode' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                //objLog.Record_Status = "E";
                //objLog.Error_Description = _objRet.Message;
            }

            if (string.IsNullOrEmpty(Input.logData))
            {
                _objRet.Message = "Input Paramater 'logData' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                //objLog.Record_Status = "E";
                //objLog.Error_Description = _objRet.Message;
            }

            if (string.IsNullOrEmpty(Input.actionBy))
            {
                _objRet.Message = "Input Paramater 'actionBy' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                //objLog.Record_Status = "E";
                //objLog.Error_Description = _objRet.Message;
            }

            if (Input.actionOn == null || Input.actionOn == 0)
            {
                _objRet.Message = "Input Paramater 'actionOn' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                //objLog.Record_Status = "E";
                //objLog.Error_Description = _objRet.Message;
            }

            if (string.IsNullOrEmpty(Input.actionType))
            {
                _objRet.Message = "Input Paramater 'actionType' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                //objLog.Record_Status = "E";
                //objLog.Error_Description = _objRet.Message;
            }
            else
            {
                string[] arrActionType = new string[] { "C", "X", "U", "A", "D" };
                if (!arrActionType.Contains(Input.actionType.ToUpper()))
                {
                    _objRet.Message = "Input Paramater 'actionType' is invalid";
                    _objRet.IsSuccess = false;
                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                }
            }

            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    var auditId = objProcedureRepositories.InsertAuditLog(Input.moduleCode, Input.intCode, Input.logData, Input.actionBy, Input.actionOn, Input.actionType);
                }
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message;
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.InternalServerError;
                return _objRet;
            }

            return _objRet;
        }

        public Return GetAuditLogList(string order, string sort, Int32 size, Int32 page, Int32 requestFrom, Int32 requestTo, Int32 moduleCode, string searchValue, string user, string userAction, string includePrevAuditVesion)
        {
            Return _objRet = new Return();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (string.IsNullOrEmpty(order))
            {
                order = ConfigurationManager.AppSettings["defaultOrder"];
            }
            if (string.IsNullOrEmpty(sort))
            {
                sort = ConfigurationManager.AppSettings["defaultSort"];
            }
            if (size == 0)
            {
                size = Convert.ToInt32(ConfigurationManager.AppSettings["defaultSize"]);
            }
            else
            {
                var maxSize = Convert.ToInt32(ConfigurationManager.AppSettings["maxSize"]);
                if (size > maxSize)
                {
                    _objRet.Message = "Input Paramater 'size' should not be greater than " + maxSize;
                    _objRet.IsSuccess = false;
                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                }
            }

            if (page == 0)
            {
                page = Convert.ToInt32(ConfigurationManager.AppSettings["defaultPage"]);
            }

            if (requestFrom == 0)
            {
                _objRet.Message = "Input Paramater 'requestFrom' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }

            if (requestTo == 0)
            {
                _objRet.Message = "Input Paramater 'requestTo' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }

            if (moduleCode == 0)
            {
                _objRet.Message = "Input Paramater 'moduleCode' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }

            if (string.IsNullOrEmpty(includePrevAuditVesion))
            {
                includePrevAuditVesion = ConfigurationManager.AppSettings["defaultPrevVersion"];
            }

            #endregion

            AuditLogReturn _AuditLogReturn = new AuditLogReturn();

            try
            {
                if (!_objRet.IsSuccess)
                {
                    _AuditLogReturn = objProcedureRepositories.GetAuditLogList(order, sort, size, page, requestFrom, requestTo, moduleCode, searchValue, user, userAction, includePrevAuditVesion);
                }
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message;
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.InternalServerError;
                _objRet.LogObject = _AuditLogReturn;
                return _objRet;
            }

            _AuditLogReturn.paging.page = page;
            _AuditLogReturn.paging.size = size;

            _objRet.LogObject = _AuditLogReturn;

            return _objRet;
        }
    }
}
