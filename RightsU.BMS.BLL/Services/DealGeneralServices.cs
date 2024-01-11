using RightsU.BMS.BLL.Miscellaneous;
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
    public class DealGeneralServices
    {
        private readonly DealGeneralRepositories objDealGeneralRepositories = new DealGeneralRepositories();

        public GenericReturn GetById(Int32 id)
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
                    Acq_Deal objDealGeneral = new Acq_Deal();

                    objDealGeneral = objDealGeneralRepositories.GetById(id);

                    objDealGeneral.Agreement_Date = Convert.ToString(GlobalTool.DateToLinux(DateTime.Parse(objDealGeneral.Agreement_Date)));
                    objDealGeneral.Inserted_On = Convert.ToString(GlobalTool.DateToLinux(DateTime.Parse(objDealGeneral.Inserted_On)));
                    objDealGeneral.Last_Updated_Time = Convert.ToString(GlobalTool.DateToLinux(DateTime.Parse(objDealGeneral.Last_Updated_Time)));

                    _objRet.Response = objDealGeneral;
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return _objRet;
        }

        public GenericReturn Post(Acq_Deal objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (string.IsNullOrEmpty(objInput.Agreement_Date))
            {
                _objRet.Message = "Input Paramater 'agreement_date' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            else
            {
                try
                {
                    objInput.Agreement_Date = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.Agreement_Date)).ToString("yyyy-MM-dd");
                }
                catch (Exception ex)
                {
                    _objRet.Message = "Input Paramater 'agreement_date' is invalid";
                    _objRet.IsSuccess = false;
                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                    return _objRet;
                }
            }

            if (string.IsNullOrEmpty(objInput.Deal_Desc))
            {
                _objRet.Message = "Input Paramater 'deal_description' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Deal_Tag_Code == null || objInput.Deal_Tag_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'deal_tag_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.Is_Master_Deal))
            {
                _objRet.Message = "Input Paramater 'master_sub_deal_type' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            else if (objInput.Is_Master_Deal.ToUpper() != "Y" && objInput.Is_Master_Deal.ToUpper() != "N")
            {
                _objRet.Message = "Input Paramater 'master_sub_deal_type' is invalid";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Role_Code == null || objInput.Role_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'role_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Deal_Type_Code == null || objInput.Deal_Type_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'deal_type_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Entity_Code == null || objInput.Entity_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'entity_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Vendor_Code == null || objInput.Vendor_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'primary_vendor_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Is_Master_Deal.ToUpper() == "N")
            {
                if (objInput.Parent_Deal_Code == null || objInput.Parent_Deal_Code <= 0)
                {
                    _objRet.Message = "Input Paramater 'master_deal_id' is mandatory";
                    _objRet.IsSuccess = false;
                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                    return _objRet;
                }
            }

            if (objInput.Is_Master_Deal.ToUpper() == "N")
            {
                if (objInput.Master_Deal_Movie_Code_ToLink == null || objInput.Master_Deal_Movie_Code_ToLink <= 0)
                {
                    _objRet.Message = "Input Paramater 'master_deal_link_title_id' is mandatory";
                    _objRet.IsSuccess = false;
                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                    return _objRet;
                }
            }

            if (string.IsNullOrEmpty(objInput.Year_Type))
            {
                _objRet.Message = "Input Paramater 'year_definition' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Currency_Code == null || objInput.Currency_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'currency_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Exchange_Rate == null || objInput.Exchange_Rate <= 0)
            {
                _objRet.Message = "Input Paramater 'exchange_rate' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Business_Unit_Code == null || objInput.Business_Unit_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'business_unit_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Category_Code == null || objInput.Category_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'category_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.Deal_Workflow_Status))
            {
                _objRet.Message = "Input Paramater 'workflow_status' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.Ref_BMS_Code))
            {
                _objRet.Message = "Input Paramater 'ref_system_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Licensors.Count() == 0)
            {
                _objRet.Message = "Input Paramater 'Licensors' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            else
            {
                for (int i = 0; i < objInput.Licensors.ToList().Count(); i++)
                {
                    if (objInput.Licensors.ToList()[i].Acq_Deal_Code == null || objInput.Licensors.ToList()[i].Acq_Deal_Code <= 0)
                    {
                        _objRet.Message = "Input Paramater 'Licensors.deal_id' is mandatory";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                        return _objRet;
                    }

                    if (objInput.Licensors.ToList()[i].Vendor_Code == null || objInput.Licensors.ToList()[i].Vendor_Code <= 0)
                    {
                        _objRet.Message = "Input Paramater 'Licensors.licensor_id' is mandatory";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                        return _objRet;
                    }
                }
            }

            if (objInput.DealTitles.Count() == 0)
            {
                _objRet.Message = "Input Paramater 'DealTitles' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            else
            {
                for (int i = 0; i < objInput.DealTitles.ToList().Count(); i++)
                {
                    if (objInput.DealTitles.ToList()[i].Acq_Deal_Code == null || objInput.DealTitles.ToList()[i].Acq_Deal_Code <= 0)
                    {
                        _objRet.Message = "Input Paramater 'DealTitles.deal_id' is mandatory";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                        return _objRet;
                    }

                    if (objInput.DealTitles.ToList()[i].Title_Code == null || objInput.DealTitles.ToList()[i].Title_Code <= 0)
                    {
                        _objRet.Message = "Input Paramater 'DealTitles.title_id' is mandatory";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                        return _objRet;
                    }

                    if (objInput.DealTitles.ToList()[i].Episode_Starts_From == null || objInput.DealTitles.ToList()[i].Episode_Starts_From <= 0)
                    {
                        _objRet.Message = "Input Paramater 'DealTitles.episode_from' is mandatory";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                        return _objRet;
                    }

                    if (objInput.DealTitles.ToList()[i].Episode_End_To == null || objInput.DealTitles.ToList()[i].Episode_End_To <= 0)
                    {
                        _objRet.Message = "Input Paramater 'DealTitles.episode_to' is mandatory";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                        return _objRet;
                    }

                    if (string.IsNullOrEmpty(objInput.DealTitles.ToList()[i].Title_Type))
                    {
                        _objRet.Message = "Input Paramater 'DealTitles.title_type' is mandatory";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                        return _objRet;
                    }

                    if (string.IsNullOrEmpty(objInput.DealTitles.ToList()[i].Due_Diligence))
                    {
                        _objRet.Message = "Input Paramater 'DealTitles.public_notice' is mandatory";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                        return _objRet;
                    }

                    if (string.IsNullOrEmpty(objInput.DealTitles.ToList()[i].Inserted_On))
                    {
                        _objRet.Message = "Input Paramater 'DealTitles.inserted_on' is mandatory";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                        return _objRet;
                    }
                    else
                    {
                        try
                        {
                            objInput.DealTitles.ToList()[i].Inserted_On = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.DealTitles.ToList()[i].Inserted_On)).ToString("yyyy-MM-dd");
                        }
                        catch (Exception ex)
                        {
                            _objRet.Message = "Input Paramater 'DealTitles.inserted_on' is invalid";
                            _objRet.IsSuccess = false;
                            _objRet.StatusCode = HttpStatusCode.BadRequest;
                            return _objRet;
                        }
                    }

                    if (objInput.DealTitles.ToList()[i].Inserted_By == null || objInput.DealTitles.ToList()[i].Inserted_By <= 0)
                    {
                        _objRet.Message = "Input Paramater 'DealTitles.inserted_by' is mandatory";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                        return _objRet;
                    }
                }
            }

            if (string.IsNullOrEmpty(objInput.Inserted_On))
            {
                _objRet.Message = "Input Paramater 'inserted_on' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            else
            {
                try
                {
                    objInput.Inserted_On = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.Inserted_On)).ToString("yyyy-MM-dd");
                }
                catch (Exception ex)
                {
                    _objRet.Message = "Input Paramater 'inserted_on' is invalid";
                    _objRet.IsSuccess = false;
                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                    return _objRet;
                }
            }

            if (objInput.Inserted_By == null || objInput.Inserted_By <= 0)
            {
                _objRet.Message = "Input Paramater 'inserted_by' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }


            #endregion

            if (_objRet.IsSuccess)
            {
                objInput.Version = "0001";

                List<Acq_Deal_Licensor> lstLicensors = new List<Acq_Deal_Licensor>();
                foreach (var item in objInput.Licensors)
                {
                    Acq_Deal_Licensor objLicensor = new Acq_Deal_Licensor();

                    objLicensor.Acq_Deal_Code = item.Acq_Deal_Code;
                    objLicensor.Vendor_Code = item.Vendor_Code;
                    lstLicensors.Add(objLicensor);
                }
                objInput.Licensors = lstLicensors;

                List<Acq_Deal_Movie> lstDealTitles = new List<Acq_Deal_Movie>();
                foreach (var item in objInput.DealTitles)
                {
                    Acq_Deal_Movie objDealTitle = new Acq_Deal_Movie();
                    objDealTitle.Acq_Deal_Code = item.Acq_Deal_Code;
                    objDealTitle.Title_Code = item.Title_Code;
                    objDealTitle.Episode_Starts_From = item.Episode_Starts_From;
                    objDealTitle.Episode_End_To = item.Episode_End_To;
                    objDealTitle.Notes = item.Notes;
                    objDealTitle.Title_Type = item.Title_Type;
                    objDealTitle.Due_Diligence = item.Due_Diligence;
                    objDealTitle.Inserted_On = item.Inserted_On;
                    objDealTitle.Inserted_By = item.Inserted_By;
                    objDealTitle.Last_UpDated_Time = item.Last_UpDated_Time;
                    objDealTitle.Last_Action_By = item.Last_Action_By;
                    lstDealTitles.Add(objDealTitle);
                }
                objInput.DealTitles = lstDealTitles;
                                
                objDealGeneralRepositories.Add(objInput);

                _objRet.Response = new { id = objInput.Acq_Deal_Code };                
            }

            return _objRet;
        }
    }
}
