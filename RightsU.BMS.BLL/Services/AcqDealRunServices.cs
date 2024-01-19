using RightsU.BMS.BLL.Miscellaneous;
using RightsU.BMS.DAL;
using RightsU.BMS.DAL.Repository;
using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.BLL.Services
{
    public class AcqDealRunServices
    {
        private readonly AcqDealRunRepositories objAcq_Deal_Run_Repositories = new AcqDealRunRepositories();
        private readonly Acq_Deal_Run_Title_Repositories objAcq_Deal_Licensor_Repositories = new Acq_Deal_Run_Title_Repositories();
        private readonly Acq_Deal_Run_Channel_Repositories objAcq_Deal_Run_Channel_Repositories = new Acq_Deal_Run_Channel_Repositories();
        private readonly Acq_Deal_Run_Yearwise_Run_Repositories objAcq_Deal_Run_Yearwise_Run_Repositories = new Acq_Deal_Run_Yearwise_Run_Repositories();
        private readonly Acq_Deal_Run_Repeat_On_Day_Repositories objAcq_Deal_Run_Repeat_On_Day_Repositories = new Acq_Deal_Run_Repeat_On_Day_Repositories();

        public GenericReturn GetById(Int32 id)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (id == 0)
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR155");
            }

            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    Acq_Deal_Run objAcq_Deal_Run = new Acq_Deal_Run();

                    objAcq_Deal_Run = objAcq_Deal_Run_Repositories.Get(id);

                    if (objAcq_Deal_Run != null)
                    {
                        //objAcq_Deal_Run.Inserted_On = Convert.ToString(GlobalTool.DateToLinux(objAcq_Deal_Run.Inserted_On.Value));
                        //objAcq_Deal_Run.Last_updated_Time = Convert.ToString(GlobalTool.DateToLinux(objAcq_Deal_Run.Last_updated_Time.Value));
                        //objAcq_Deal_Run.Last_action_By = objAcq_Deal_Run.Inserted_By != null || objAcq_Deal_Run.Inserted_By.Value > 0 ? objAcq_Deal_Run.Inserted_By : objAcq_Deal_Run.Last_action_By;
                    }
                    else
                    {
                        _objRet.Message = "Error";
                        _objRet.Errors.Add("ERR183"); // ErrorCode to be added in table = 'deal_run_id' not found
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                    }
                    _objRet.Response = objAcq_Deal_Run;
                }

                if (!_objRet.IsSuccess)
                {
                    _objRet.Errors = GlobalTool.GetErrorList(_objRet.Errors);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return _objRet;
        }

        public GenericReturn Post(Acq_Deal_Run objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput == null)
            {
                _objRet.Message = "Error";
                _objRet.Errors.Add("ERR154");
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;

                //_objRet = GlobalTool.SetError("ERR154");
            }

            if (objInput.Acq_Deal_Code == null || objInput.Acq_Deal_Code <= 0)
            {
                _objRet.Message = "Error";
                _objRet.Errors.Add("ERR159"); // ErrorCode to be added in table = Input Paramater 'deal_id' is mandatory
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }

            if (string.IsNullOrWhiteSpace(objInput.Run_Type))
            {
                _objRet.Message = "Error";
                _objRet.Errors.Add("ERR158"); // ErrorCode to be added in table = Input Paramater 'run_type' is mandatory
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }

            if (objInput.Run_Type == "C" && (objInput.No_Of_Runs == null || objInput.No_Of_Runs <= 0))
            {
                _objRet.Message = "Error";
                _objRet.Errors.Add("ERR167"); // ErrorCode to be added in table = Input Paramater 'define_runs' is mandatory
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }

            if (string.IsNullOrWhiteSpace(objInput.Run_Definition_Type))
            {
                _objRet.Message = "Error";
                _objRet.Errors.Add("ERR158"); // ErrorCode to be added in table = Input Paramater 'run_definition_type' is mandatory
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }

            #region --- Acq_Deal_Run_Title ---
            if (objInput.Titles.Count() == 0)
            {
                _objRet.Message = "Error";
                _objRet.Errors.Add("ERR170"); // ErrorCode to be added in table = Input Paramater 'Titles' is mandatory
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }
            else
            {
                for (int i = 0; i < objInput.Titles.ToList().Count(); i++)
                {
                    if (objInput.Titles.ToList()[i].Acq_Deal_Run_Code == null || objInput.Titles.ToList()[i].Acq_Deal_Run_Code <= 0)
                    {
                        _objRet.Message = "Error";
                        _objRet.Errors.Add("ERR174"); // ErrorCode to be added in table = Input Paramater 'Titles.deal_run_id' is mandatory
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                    }

                    if (objInput.Titles.ToList()[i].Title_Code == null || objInput.Titles.ToList()[i].Title_Code <= 0)
                    {
                        _objRet.Message = "Error";
                        _objRet.Errors.Add("ERR173"); // ErrorCode to be added in table = Input Paramater 'Titles.title_id' is mandatory
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                    }

                    string strQuery = "SELECT Deal_Type_Code FROM Title where Title_Code =" + objInput.Titles.ToList()[i].Title_Code;

                    //var Extended_Columns_Value = .GetScalarDataWithSQLStmt(strQuery);

                    if (objInput.Titles.ToList()[i].Episode_From == null || objInput.Titles.ToList()[i].Episode_From <= 0)
                    {
                        _objRet.Message = "Error";
                        _objRet.Errors.Add("ERR174"); // ErrorCode to be added in table = Input Paramater 'Titles.episode_from' is mandatory
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                    }

                    if (objInput.Titles.ToList()[i].Episode_To == null || objInput.Titles.ToList()[i].Episode_To <= 0)
                    {
                        _objRet.Message = "Error";
                        _objRet.Errors.Add("ERR175"); // ErrorCode to be added in table = Input Paramater 'Titles.episode_to' is mandatory
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                    }
                }
            }
            #endregion


            #region --- Acq_Deal_Run_Channel ---

            if (objInput.Channels.Count() == 0)
            {
                _objRet.Message = "Error";
                _objRet.Errors.Add("ERR170"); // ErrorCode to be added in table = Input Paramater 'Channels' is mandatory
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }
            else
            {
                for (int i = 0; i < objInput.Titles.ToList().Count(); i++)
                {
                    if (objInput.Channels.ToList()[i].Acq_Deal_Run_Code == null || objInput.Channels.ToList()[i].Acq_Deal_Run_Code <= 0)
                    {
                        _objRet.Message = "Error";
                        _objRet.Errors.Add("ERR174"); // ErrorCode to be added in table = Input Paramater 'Channels.deal_run_id' is mandatory
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                    }

                    if (objInput.Channels.ToList()[i].Channel_Code == null || objInput.Channels.ToList()[i].Channel_Code <= 0)
                    {
                        _objRet.Message = "Error";
                        _objRet.Errors.Add("ERR173"); // ErrorCode to be added in table = Input Paramater 'Channels.channel_id' is mandatory
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                    }

                    if (objInput.Channels.ToList()[i].Min_Runs == null || objInput.Channels.ToList()[i].Min_Runs <= 0)
                    {
                        _objRet.Message = "Error";
                        _objRet.Errors.Add("ERR174"); // ErrorCode to be added in table = Input Paramater 'Channels.define_runs' is mandatory
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                    }
                }
            }

            #endregion

            #endregion

            if (_objRet.IsSuccess)
            {
                //objInput.Agreement_No = string.Empty;
                //objInput.Version = "0001";
                //objInput.Inserted_On = DateTime.Now;
                //objInput.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                //objInput.Last_Updated_Time = DateTime.Now;
                //objInput.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);


          

                _objRet.id = objInput.Acq_Deal_Code;
            }

            if (!_objRet.IsSuccess)
            {
                _objRet.Errors = GlobalTool.GetErrorList(_objRet.Errors);
            }

            return _objRet;
        }

    }
}
