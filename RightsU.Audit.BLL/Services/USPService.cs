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
        
        public PostReturn InsertAuditLog(MasterAuditLogInput Input)
        {
            PostReturn _objRet = new PostReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation
            if (Input != null)
            {
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
            }
            else
            {
                _objRet.Message = "Input Paramater missing";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }
            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    var auditId = objProcedureRepositories.InsertAuditLog(Input.moduleCode, Input.intCode, Input.logData, Input.actionBy, Input.actionOn, Input.actionType,Input.requestId);
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

        public GenericReturn GetAuditLogList(string order, string sort, Int32 size, Int32 page, Int32 requestFrom, Int32 requestTo, Int32 moduleCode, string searchValue, string user, string userAction, string includePrevAuditVesion)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (string.IsNullOrEmpty(order))
            {
                order = ConfigurationManager.AppSettings["defaultOrder"];
            }
            else
            {
                if (order.ToUpper() != "ASC")
                {
                    if (order.ToUpper() != "DESC")
                    {
                        _objRet.Message = "Input Paramater 'order' is not in valid format";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                    }
                }
            }

            if (string.IsNullOrEmpty(sort))
            {
                sort = ConfigurationManager.AppSettings["defaultSort"];
            }
            else
            {
                if (sort.ToLower() == "IntCode".ToLower())
                {
                    sort = "IntCode";
                }
                else if (sort.ToLower() == "Version".ToLower())
                {
                    sort = "Version";
                }                
                else
                {
                    _objRet.Message = "Input Paramater 'sort' is not in valid format";
                    _objRet.IsSuccess = false;
                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                }
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
                if (_objRet.IsSuccess)
                {
                    _AuditLogReturn = objProcedureRepositories.GetAuditLogList(order, sort, size, page, requestFrom, requestTo, moduleCode, searchValue, user, userAction, includePrevAuditVesion);
                }
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message;
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.InternalServerError;
                _objRet.Response = _AuditLogReturn;
                return _objRet;
            }

            _AuditLogReturn.paging.page = page;
            _AuditLogReturn.paging.size = size;

            _objRet.Response = _AuditLogReturn;

            return _objRet;
        }
    }
}
