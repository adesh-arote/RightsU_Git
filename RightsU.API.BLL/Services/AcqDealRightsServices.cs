using RightsU.API.BLL.Miscellaneous;
using RightsU.API.DAL.Repository;
using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace RightsU.API.BLL.Services
{
    public class AcqDealRightsServices
    {
        private readonly AcqDealRightsRepositories objAcqDealRightsRepositories = new AcqDealRightsRepositories();
        private readonly Acq_Deal_Rights_PlatformRepositories objAcq_Deal_Rights_PlatformRepositories = new Acq_Deal_Rights_PlatformRepositories();
        private readonly Acq_Deal_Rights_TerritoryRepositories objAcq_Deal_Rights_TerritoryRepositories = new Acq_Deal_Rights_TerritoryRepositories();
        private readonly Acq_Deal_Rights_SubtitlingRepositories objAcq_Deal_Rights_SubtitlingRepositories = new Acq_Deal_Rights_SubtitlingRepositories();
        private readonly Acq_Deal_Rights_DubbingRepositories objAcq_Deal_Rights_DubbingRepositories = new Acq_Deal_Rights_DubbingRepositories();
        private readonly TitleRepositories objTitleRepositories = new TitleRepositories();
        private readonly DealRepositories objDealRepositories = new DealRepositories();
        public GenericReturn GetById(Int32 id)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation
            if (id == 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR155");
            }
            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    Acq_Deal_Rights objAcq_Deal_Rights = new Acq_Deal_Rights();

                    objAcq_Deal_Rights = objAcqDealRightsRepositories.GetById(id);

                    if (objAcq_Deal_Rights != null)
                    {
                        if (objAcq_Deal_Rights.Right_Start_Date.HasValue)
                            objAcq_Deal_Rights.right_start_date_str = Convert.ToString(GlobalTool.DateToLinux(objAcq_Deal_Rights.Right_Start_Date.Value));

                        if (objAcq_Deal_Rights.Right_End_Date.HasValue)
                            objAcq_Deal_Rights.right_end_date_str = Convert.ToString(GlobalTool.DateToLinux(objAcq_Deal_Rights.Right_End_Date.Value));

                        if (objAcq_Deal_Rights.ROFR_Date.HasValue)
                            objAcq_Deal_Rights.rofr_date_str = Convert.ToString(GlobalTool.DateToLinux(objAcq_Deal_Rights.ROFR_Date.Value));

                    }
                    else
                    {


                        _objRet = GlobalTool.SetError(_objRet, "ERR252");
                    }
                    _objRet.Response = objAcq_Deal_Rights;
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

        public GenericReturn Post(Acq_Deal_Rights objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput == null)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR262");
            }

            if (String.IsNullOrEmpty(objInput.Is_Title_Language_Right))
                objInput.Is_Title_Language_Right = "N";

            _objRet = ValidateInput(_objRet, objInput);

            #endregion

            if (_objRet.IsSuccess)
            {
                if (!String.IsNullOrEmpty(objInput.right_start_date_str))
                    objInput.Right_Start_Date = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.right_start_date_str));
                if (!String.IsNullOrEmpty(objInput.right_start_date_str))
                    objInput.Right_End_Date = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.right_end_date_str));

                if (objInput.Right_Type == "Y")
                {
                    string strCalculatTerm = "SELECT [dbo].[UFN_Calculate_Term]('" + objInput.Right_Start_Date.Value.ToString("dd/MMMM/yyyy") + "', '" + objInput.Right_End_Date.Value.ToString("dd/MMMM/yyyy") + "') AS Term";
                    objInput.Term = Convert.ToString(objAcqDealRightsRepositories.GetDataWithSQLStmt(strCalculatTerm).FirstOrDefault().Term);
                }
                else
                    objInput.Term = "";

                objInput.Actual_Right_Start_Date = objInput.Right_Start_Date;
                objInput.Effective_Start_Date = objInput.Right_Start_Date;
                objInput.Actual_Right_End_Date = objInput.Right_End_Date;
                if (!String.IsNullOrEmpty(objInput.rofr_date_str))
                {
                    objInput.ROFR_Date = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.rofr_date_str));
                    objInput.Is_ROFR = "Y";
                }
                else
                    objInput.Is_ROFR = "N";
                objInput.Original_Right_Type = objInput.Right_Type;
                objInput.Right_Status = "P";

                objInput.Inserted_On = DateTime.Now;
                objInput.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objInput.Last_Updated_Time = DateTime.Now;
                objInput.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);

                foreach (var item in objInput.Region)
                {
                    if (item.Territory_Type == "G")
                        item.Country_Code = null;
                    else
                        item.Territory_Code = null;
                }

                foreach (var item in objInput.Subtitling)
                {
                    if (item.Language_Type == "G")
                        item.Language_Code = null;
                    else
                        item.Language_Group_Code = null;
                }

                foreach (var item in objInput.Dubbing)
                {
                    if (item.Language_Type == "G")
                        item.Language_Code = null;
                    else
                        item.Language_Group_Code = null;
                }

                objAcqDealRightsRepositories.Add(objInput);
                _objRet.id = objInput.Acq_Deal_Rights_Code;

            }
            else
                _objRet.Errors = GlobalTool.GetErrorList(_objRet.Errors);
            return _objRet;
        }

        private GenericReturn ValidateInput(GenericReturn _objRet, Acq_Deal_Rights objInput)
        {
            if (objInput.Acq_Deal_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR263");
            }

            if (String.IsNullOrEmpty(objInput.Is_Exclusive))
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR264");
            }

            if (objInput.Is_Title_Language_Right == "N" && objInput.Subtitling.Count() <= 0 && objInput.Dubbing.Count <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR265");
            }

            if (String.IsNullOrEmpty(objInput.Is_Sub_License))
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR266");
            }

            if (!String.IsNullOrEmpty(objInput.Is_Sub_License))
            {
                if (objInput.Sub_License_Code <= 0)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR267");
                }
            }

            if (String.IsNullOrEmpty(objInput.Right_Type))
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR268");
            }

            if (objInput.Titles.Count <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR269");
            }
            else
            {
                for (int i = 0; i < objInput.Titles.ToList().Count(); i++)
                {
                    if (objInput.Titles.ToList()[i].Title_Code == null || objInput.Titles.ToList()[i].Title_Code <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR173");
                    }
                }
            }

            if (objInput.Region.Count <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR270");
            }
            else
            {
                for (int i = 0; i < objInput.Region.ToList().Count(); i++)
                {
                    if ((objInput.Region.ToList()[i].Country_Code == null || objInput.Region.ToList()[i].Country_Code <= 0)
                        && (objInput.Region.ToList()[i].Territory_Code == null || objInput.Region.ToList()[i].Territory_Code <= 0))
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR272");
                    }
                }
            }

            if (objInput.Platform.Count <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR271");
            }
            else
            {
                for (int i = 0; i < objInput.Platform.ToList().Count(); i++)
                {
                    if (objInput.Platform.ToList()[i].Platform_Code == null || objInput.Platform.ToList()[i].Platform_Code <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR274");
                    }
                }
            }

            if (objInput.Right_Type == "Y" && String.IsNullOrEmpty(objInput.right_start_date_str) && String.IsNullOrEmpty(objInput.right_end_date_str))
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR324");
            }
            if (objInput.Right_Type == "U" && String.IsNullOrEmpty(objInput.right_start_date_str))
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR325");
            }
            if (objInput.Right_Type == "M" && objInput.Milestone_No_Of_Unit.Value <= 0 && objInput.Milestone_Type_Code <= 0 && objInput.Milestone_Unit_Type.Value <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR326");
            }

            return _objRet;
        }

        public GenericReturn Delete(Int32 id)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (id == 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }

            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    Acq_Deal_Rights objDealRights = new Acq_Deal_Rights();

                    objDealRights = objAcqDealRightsRepositories.GetById(id);

                    objAcqDealRightsRepositories.Delete(objDealRights);

                    _objRet.Response = new { id = objDealRights.Acq_Deal_Rights_Code };
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return _objRet;
        }

        public GenericReturn Put(Acq_Deal_Rights objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validations

            if (objInput == null)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR262");
            }

            if (objInput.Acq_Deal_Rights_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR323");
            }

            if (String.IsNullOrEmpty(objInput.Is_Title_Language_Right))
                objInput.Is_Title_Language_Right = "N";

            _objRet = ValidateInput(_objRet, objInput);

            #endregion


            if (_objRet.IsSuccess)
            {
                var objDealRights = objAcqDealRightsRepositories.GetById(objInput.Acq_Deal_Rights_Code);

                if (objDealRights != null)
                {
                    objInput.Inserted_On = objDealRights.Inserted_On;
                    objInput.Inserted_By = objDealRights.Inserted_By;
                    objInput.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                    objInput.Last_Updated_Time = DateTime.Now;

                    //-----Pending Columns-----------

                    if (!String.IsNullOrEmpty(objInput.right_start_date_str))
                        objInput.Right_Start_Date = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.right_start_date_str));
                    else
                        objInput.Right_Start_Date = null;

                    if (!String.IsNullOrEmpty(objInput.right_start_date_str))
                        objInput.Right_End_Date = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.right_end_date_str));
                    else
                        objInput.Right_End_Date = null;

                    if (objInput.Right_Type == "Y")
                    {
                        string strCalculatTerm = "SELECT [dbo].[UFN_Calculate_Term]('" + objInput.Right_Start_Date.Value.ToString("dd/MMMM/yyyy") + "', '" + objInput.Right_End_Date.Value.ToString("dd/MMMM/yyyy") + "') AS Term";
                        objInput.Term = Convert.ToString(objAcqDealRightsRepositories.GetDataWithSQLStmt(strCalculatTerm).FirstOrDefault().Term);
                    }
                    else
                        objInput.Term = "";

                    objInput.Actual_Right_Start_Date = objInput.Right_Start_Date;
                    objInput.Effective_Start_Date = objInput.Right_Start_Date;
                    objInput.Actual_Right_End_Date = objInput.Right_End_Date;
                    if (!String.IsNullOrEmpty(objInput.rofr_date_str))
                    {
                        objInput.ROFR_Date = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.rofr_date_str));
                        objInput.Is_ROFR = "Y";
                    }
                    else
                    {
                        objInput.Is_ROFR = "N";
                        objInput.ROFR_Date = null;
                    }

                    objInput.Original_Right_Type = objInput.Right_Type;
                    objInput.Right_Status = "P";
                    objInput.Is_Verified = objDealRights.Is_Verified;
                    objInput.Promoter_Flag = objDealRights.Promoter_Flag;
                    objInput.Is_Under_Production = objInput.Is_Under_Production;
                    objInput.Buyback_Syn_Rights_Code = objInput.Buyback_Syn_Rights_Code;

                    //--------- Pending Columns

                    foreach (var item in objInput.Region)
                    {
                        if (item.Territory_Type == "G")
                            item.Country_Code = null;
                        else
                            item.Territory_Code = null;
                    }

                    foreach (var item in objInput.Subtitling)
                    {
                        if (item.Language_Type == "G")
                            item.Language_Code = null;
                        else
                            item.Language_Group_Code = null;
                    }

                    foreach (var item in objInput.Dubbing)
                    {
                        if (item.Language_Type == "G")
                            item.Language_Code = null;
                        else
                            item.Language_Group_Code = null;
                    }
                }

                objAcqDealRightsRepositories.Update(objInput);
            }


            if (!_objRet.IsSuccess)
            {
                _objRet.Errors = GlobalTool.GetErrorList(_objRet.Errors);
            }

            return _objRet;
        }
    }
}
